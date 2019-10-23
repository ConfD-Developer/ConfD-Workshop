class DataProvider {
    //protected static def user = UmlCommon.user
    protected static def cli = UmlCommon.cli
    protected static def confd = UmlCommon.confd
    protected static def libconfd = UmlCommon.libconfd
    protected static def app = UmlCommon.app
    protected static def system = UmlCommon.system

    static def confd_fd_ready = { msgText, args, cl ->
        msgAd confd, to: app, text: "$msgText event on worker socket",
                returnText: "", {
            msgAd app, to: libconfd, text: '""confd_fd_ready(workersocket)"" //called in ConfD loop//',
                    returnText: "", {
                note "**libconfd** decodes \"\"$msgText\"\" message and calls callback", pos: "left of $libconfd"
                msgAd libconfd, to: app, text: "\"\"$msgText($args)\"\"",
                        returnText: '""CONFD_OK"" or ""CONFD_ERR""', {
                    delegate << cl
                }
                msg libconfd, to: confd, noReturn: true, text: '""CONFD_OK"" or ""CONFD_ERR""'
            }
        }
    }

    static def app_libconfd_confd_msg = { msgText ->
        msg app, to: libconfd, noReturn: true,
                text: "\"\"$msgText\"\"", {
            msg libconfd, to: confd, noReturn: true, text: "\"\"$msgText\"\""
        }
    }

    static def get_next = {
        delegate << confd_fd_ready.curry("get_next", "next") {
            alt '<size:20><&check></size> ""next==-1""', {
                //autonumber("stop")
                msg app, to: system, noReturn: true,
                        type: UmlCommon.arrowReturn,
                        text: "fetch first key value"
                'else' "<size:20><&x></size>"
                msg app, to: system, noReturn: true,
                        type: UmlCommon.arrowReturn,
                        text: "fetch next key value"
            }
            alt '<size:20><&check></size> key values found', {
                msgAd app, text: '""next=""//<new next>//'
                'else' "<size:20><&x></size>"
                msgAd app, text: '""next=-1"", ""key_values=NULL""'
            }
            //autonumber("resume")
            delegate << app_libconfd_confd_msg.curry('confd_data_reply_next_key""\\n""(key_values, next)')
        }
    }


    static def get_elem = {
        delegate << confd_fd_ready.curry("get_elem", "keypath") {
            //autonumber("stop")
            msgAd app, text: 'find element value', {
                msg app, to: system, noReturn: true,
                        type: UmlCommon.arrowReturn,
                        text: "fetch element value"
            }
            //autonumber("resume")
            alt "<size:20><&check></size> value  found", {
                delegate << app_libconfd_confd_msg.curry("confd_data_reply_value")
                'else' "<size:20><&x></size>"
                delegate << app_libconfd_confd_msg.curry("confd_data_reply_not_found")
            }
        }
    }

    static def get_object = {
        delegate << confd_fd_ready.curry("get_object", "keypath") {
            //autonumber("stop")
            msg app, to: system, noReturn: true,
                    type: UmlCommon.arrowReturn,
                    text: "fetch all values for the object"
            alt "<size:20><&check></size> values correctly found", {
                msgAd app, text: "create **confd_value_t** value array"
                //autonumber("resume")
                delegate << app_libconfd_confd_msg.curry("confd_data_reply_value_array")
                'else' "<size:20><&x></size>"
                delegate << app_libconfd_confd_msg.curry("confd_data_reply_not_found")
            }
        }
    }

    static def get_next_obj = {
        delegate << confd_fd_ready.curry("get_next_object", "keypath, next") {
            alt '<size:20><&check></size> next==-1', {
                //autonumber("stop")
                msg app, to: system, noReturn: true,
                        type: UmlCommon.arrowReturn,
                        text: "fetch first list element values"
                'else' "<size:20><&x></size>"
                msg app, to: system, noReturn: true,
                        type: UmlCommon.arrowReturn,
                        text: "fetch next list element values"
            }
            alt '<size:20><&check></size> values found', {
                msgAd app, text: "next=<new next>"
                msgAd app, text: "create **confd_value_t** value array\\nfrom element values"
                //autonumber("resume")
                delegate << app_libconfd_confd_msg.curry('confd_data_reply_next_object_array""\\n""(value_array, next)')
                'else' "<size:20><&x></size>"
                delegate << app_libconfd_confd_msg.curry('confd_data_reply_next_key""\\n""(NULL, -1, -1)')
            }
        }
    }

    static def get_next_obj_array = {
        delegate << confd_fd_ready.curry("get_next_object", "keypath, next") {
            alt '<size:20><&check></size> next==-1', {
                //autonumber("stop")
                msg app, to: system, noReturn: true,
                        type: UmlCommon.arrowReturn,
                        text: "fetch first N list elements (values)"
                'else' "<size:20><&x></size>"
                msg app, to: system, noReturn: true,
                        type: UmlCommon.arrowReturn,
                        text: "fetch next N list elements (values)"
            }
            alt '<size:20><&check></size> values found', {
                loop "each element to return", {
                    msgAd app, text: "for the current element\\nfill in **confd_next_object** structure"
                    //autonumber("resume")
                    note "**confd_next_object** - contains array of element values and\\n" +
                            "**next** value for the current element\\n" + "" +
                            "if **find_next** or **find_next_object** is implemented, the **next** " +
                            "value can be **-1**", pos: "over $app"
                }
                note "**objects** - array of confd_next_object.\\n**num** - number of returned objects", pos: "over $app"
                delegate << app_libconfd_confd_msg.curry('confd_data_reply_next_object_arrays""\\n""(objects, num, 0)')
                'else' "<size:20><&x></size>"
                delegate << app_libconfd_confd_msg.curry('confd_data_reply_next_key""\\n""(NULL, -1, -1)')
            }
        }
    }


    static def dp_header = { add_divider = false ->
        if (add_divider) {
            divider("Initialization part common to all data provider diagrams.")
        }
        note "Application performs initialization and connects to the ConfD",
                pos: "over $app"
        //msg app, to: confd, noReturn: true, type: UmlCommon.arrowReturn, text: "initialization"
        msgAd app, to: libconfd, text: '""confd_init_daemon""'
        msgAd app, to: libconfd, text: '""confd_connect(ctlsock)""', {
            msg libconfd, to: confd, noReturn: true, type: UmlCommon.arrowReturn, text: '""confd_connect""'
        }
        msgAd app, to: libconfd, text: '""confd_connect(workersock)""', {
            msg libconfd, to: confd, noReturn: true, type: UmlCommon.arrowReturn, text: '""confd_connect""'
        }
        note "Application registers callbacks", pos: "over $app"
        msgAd app, to: libconfd, text: '""confd_register_data_cb()""', {
            msg libconfd, to: confd, noReturn: true, type: UmlCommon.arrowReturn, text: '""confd_register_data_cb""'
        }
        msgAd app, to: libconfd, text: '""confd_register_done()""', {
            msg libconfd, to: confd, noReturn: true, type: UmlCommon.arrowReturn, text: '""confd_register_done""'
        }

        UmlCommon.makeAppOtherInit(delegate)

        note "System layer component provides operational data to the application.\\n\\n" +
                "The data can be read directly (e.g. from hardware) or they can" +
                "be returned by some layer of the component. It is responsibility of\\nthis component " +
                "to provide requested data.\\n\\n" +
                "The system component can be linked directly with the application or\\n" +
                "accessed via RPC mechanism (plain sockets, gRPC,  CORBA, REST, etc.)", pos: "left of $system"

        note 'Next, user types show command for a ""list"" element in ConfD CLI.\\nE.g. ""show ip route""\\n' +
                "(also applicable for other northbound interfaces, e.g. NETCONF)", pos: "right of $cli"

    }

    static def get_next_note = { elem_fun = "" ->
        def text = "Following loop shows ConfD iteration over the data model elements stored in a list."
        if (elem_fun != "") {
            text += " NOTE: ConfD may choose to call the\\n**get_next** and **${elem_fun}** callbacks " +
                    "anytime and application has to be prepared for this.\\n" +
                    "E.g. **get_next** is often called twice with next==-1 (existence check), " +
                    "**${elem_fun}** can be called without **get_next** when requsting specific leaf element."
        }
        note text, pos: "right of $cli"
    }

    static def get_next_loop = { cl ->
        msg confd, text: "next = -1", {
            loop "first call (next is -1) or some values were returned during previous iteration", {
                delegate << cl
            }
        }
    }

    static def process_get_next_get = { cl, split = false ->
        delegate << get_next
        if (split) {
            newpage()
        }
        opt("keys found?") {
            delegate << cl
        }
    }

    static def get_next_get_elem = {split = false ->
        delegate << get_next_note.curry("get_elem")
        divider('""get_next""')
        delegate << get_next_loop.curry({
            delegate << process_get_next_get.curry({
                divider('""get_elem""')
                loop "over non key elements of the list", {
                    delegate << get_elem
                }
            }, split)
        })
    }

    static def get_next_get_object = {split = false ->
        delegate << get_next_note.curry("get_object")
        divider('""get_next""')
        delegate << get_next_loop.curry({
            delegate << process_get_next_get.curry({
                divider('""get_object""')
                delegate << get_object
            }, split)
        })
    }

    static def get_next_object = {
        delegate << get_next_note
        delegate << get_next_loop.curry({
            delegate << get_next_obj
        })
    }

    static def get_next_object_array = {
        delegate << get_next_note
        delegate << get_next_loop.curry({
            delegate << get_next_obj_array
        })
    }

    static def show = { text, cl ->
        if (text) {
            divider(text)
        }
        msgAd "[", to: cli, text: '<size:24><&person></size> show\\ncommand', {
            msgAd cli, to: confd, text: "get show command\\noutput", {
                delegate << cl
            }
        }
    }


    static def makeDataProviderAllSeq(builder) {
        builder.plantuml {
            //plant("scale max 2500 width")
            UmlCommon.makeHeader(builder, 'Variants of ConfD Data Provider implementation',
                    [skipList: [UmlCommon.user, UmlCommon.cdb]])

            delegate << dp_header.curry(true)
            newpage()
            def variant = 1
            delegate << show.curry("Variant ${variant++}.: data provider implemented with **get_next** and **get_elem**", get_next_get_elem.curry(true))
            newpage()
            delegate << show.curry("Variant ${variant++}.: data provider implemented with **get_next** and **get_object**", get_next_get_object.curry(true))
            newpage()
            delegate << show.curry("Variant ${variant++}.: data provider implemented with **get_next_object** (returning one object)", get_next_object)
            newpage()
            delegate << show.curry("Variant ${variant++}.: data provider implemented with **get_next_object** (returning multiple objects)", get_next_object_array)
        }
    }

    static def makeDataProviderVar1Seq(builder) {
        builder.plantuml {
            UmlCommon.makeHeader(builder, 'ConfD data provider implementation with **get_next** and **get_elem**',
                    [skipList: [UmlCommon.user, UmlCommon.cdb]])
            delegate << dp_header
            delegate << show.curry(null, get_next_get_elem)
        }
    }

    static def makeDataProviderVar2Seq(builder) {
        builder.plantuml {
            UmlCommon.makeHeader(builder, 'ConfD data provider implementation with **get_next** and **get_object**',
                    [skipList: [UmlCommon.user, UmlCommon.cdb]])
            delegate << dp_header
            delegate << show.curry(null, get_next_get_object)
        }
    }

    static def makeDataProviderVar3Seq(builder) {
        builder.plantuml {
            UmlCommon.makeHeader(builder, 'ConfD data provider implementation with **get_next_object** (returning one object)',
                    [skipList: [UmlCommon.user, UmlCommon.cdb]])
            delegate << dp_header
            delegate << show.curry(null, get_next_object)
        }
    }

    static def makeDataProviderVar4Seq(builder) {
        builder.plantuml {
            UmlCommon.makeHeader(builder, 'ConfD data provider implementation with **get_next_object** (returning multiple objects)',
                    [skipList: [UmlCommon.user, UmlCommon.cdb]])
            delegate << dp_header
            delegate << show.curry(null, get_next_object_array)
        }
    }

}
