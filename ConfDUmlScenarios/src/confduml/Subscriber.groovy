class Subscriber {
    //protected static def user = UmlCommon.user
    protected static def cli = UmlCommon.cli
    protected static def confd = UmlCommon.confd
    protected static def libconfd = UmlCommon.libconfd
    protected static def app = UmlCommon.app
    protected static def cdb = UmlCommon.cdb
    protected static def system = UmlCommon.system

    static def sub_header = { twoPhase = false -> //add_divider = false ->
        //if (add_divider) {
        divider "Application initialization"
        note "Application performs initialization and connects to the ConfD",
                pos: "over $app"
        //msg app, to: confd, noReturn: true, type: UmlCommon.arrowReturn, text: "initialization"
        msgAd app, to: libconfd,  text: '""confd_init_daemon""'
        msgAd app, to: libconfd, text: '""cdb_connect(subsock)""', {
            msg libconfd, to: confd, noReturn: true, type: UmlCommon.arrowReturn, text: '""cdb_connect""'
        }

        loop "for each part of the data model to make subscription (point)", {
            def subFun = '""cdb_subscribe""'
            if (twoPhase) {
                subFun = '""cdb_subscribe2(CDB_SUB_RUNNING_TWOPHASE)""'
            }
            msgAd app, to: libconfd, text: "\"\"${subFun}\"\"", returnText: "subscription point", {
                msgAd libconfd, to: confd, text: "\"\"${subFun}\"\"", returnText: "subscription point"
            }
        }
        msgAd app, to: libconfd, text: '""cdb_subscribe_done""', {
            msgAd libconfd, to: confd, text: '""cdb_subscribe_done""'
        }
        UmlCommon.makeAppOtherInit(delegate)

        divider "Configuration"
        note "User creates configuration.\\n" +
                "(also applicable for other northbound interfaces, e.g. NETCONF)", pos: "right of $cli"
        msgAd "[", to: cli, text: '<size:24><&person></size> config commands', {
            msgAd cli, to: confd, text: "configure"
        }
    }

    static def invoke_sub = { twoPhaseType = null ->
        //loop "for each subscription point", {
        def funRead = "cdb_read_subscription_socket"
        if (twoPhaseType != null) {
            funRead = "cdb_read_subscription_socket(&flags)"
        }
        def refCl = {
            ref "See diagram (several variants) process subscription point", over: [confd, system]
        }
        def syncCl = {
            msgAd app, to: libconfd, text: '""cdb_sync_subscription_socket""', {
                msgAd libconfd, to: confd, text: '""cdb_sync_subscription_socket""'
            }
        }
        def rollCl = {
            note "Rollback (optionally) in the system what was performed by this subscription (point).",
                    pos: "over $app"
            autonumber("stop")
            msg app, to: system, noReturn: true, type: UmlCommon.arrowReturn,
                    text: "Process subscription point failure (rollback)"
            autonumber("resume")
        }

        def rollAllCl = {
            opt "failure during processing of subscription point", {
                loop "each already processed subscription point", {
                    delegate << rollCl
                }
            }
        }

        msgAd confd, to: app, text: "invoke subscription event${twoPhaseType ? " $twoPhaseType" : ""}", {
            msgAd app, to: libconfd, text: "\"\"${funRead}\"\"", returnText: "list of subs. points", {
                msgAd libconfd, to: confd, text: "\"\"${funRead}\"\"", returnText: "list of subs. points"
            }
            loop "for each subscription point (and no failure detected)", {
                if (twoPhaseType == null) {
                    delegate << refCl
                    delegate << rollAllCl
                } else {
                    if (twoPhaseType.contains("PREPARE")) {
                        delegate << refCl
                        note "If something goes wrong, the application can react and abort the transaction.",
                                pos: "right of $confd"
                        delegate << rollAllCl
                    }
                    if (twoPhaseType.contains("COMMIT")) {
                        note "Confirm (optionally) in the system what was performed by this subscription (point).",
                                pos: "over $app"
                        autonumber("stop")
                        msg app, to: system, noReturn: true, type: UmlCommon.arrowReturn,
                                text: "Confirm changes done in pre-commit (CDB_SUB_PREPARE)"
                        autonumber("resume")
                    }
                    if (twoPhaseType.contains("ABORT")) {
                        delegate << rollCl
                    }
                }
            }
            if (!twoPhaseType?.contains("PREPARE")) {
                delegate << syncCl
            } else {
                alt "<size:20><&check></size> processing without failure", {
                    //note "Transaction processing can continue.", pos: "left of $app"
                    delegate << syncCl
                    'else' "<size:20><&x></size> failure"
                    msgAd app, to: libconfd, text: '""cdb_sub_abort_trans""', {
                        note "Transaction will be aborted", pos: "left of $app"
                        msgAd libconfd, to: confd, text: '""cdb_sub_abort_trans""'
                    }
                }
            }

        }
    }

    static def subHead = { twoPhase = false ->
        UmlCommon.makeHeader(delegate, "ConfD ${twoPhase ? "Two Phase " : ""}Subscriber",
                [skipList: [UmlCommon.user]])
        delegate << sub_header.curry(twoPhase)
    }

    static def subscrCl = { twoPhase = false, split = false ->
        divider "Committing transaction and Processing of subscriptions"
        msgAd "[", to: cli, text: '<size:24><&person></size> commit', {
            note "Configuration is being committed. Transaction processing is in progress.",
                    pos: "right of $cli"
            msgAd cli, to: confd, text: "commit", {
                delay("Transaction processing")
                msg(confd, to: cdb, noReturn: true, type: UmlCommon.arrowReturn, text: "add/update config")
                if (!twoPhase) {
                    delay("Transaction fully processed")
                }
            }
        }
        if (!twoPhase) {
            note "Subscriptions (one phase) are started, when transaction is fully processed and cannot be aborted.",
                    pos: "right of $confd"
            delegate << invoke_sub
        } else {
            note "Subscriptions (CDB_SUB_PREPARE) are started, when transaction is still not processed and can be aborted.",
                    pos: "right of $confd"
            delegate << invoke_sub.curry("CDB_SUB_PREPARE")
            if (split) {
                newpage()
            }
            alt "<size:20><&check></size> transaction processed", {
                delay "Transaction fully processed"
                delegate << invoke_sub.curry("CDB_SUB_COMMIT")
                'else' "<size:20><&x></size> transaction aborted"
                delay "Transaction being aborted"
                delegate << invoke_sub.curry("CDB_SUB_ABORT")

            }
        }
    }

    static def makeSubscriberSeq(builder, twoPhase = false, split = false) {
        builder.plantuml {
            delegate << subHead.curry(twoPhase)
            delegate << subscrCl.curry(twoPhase)
        }
    }

    static def makeSubscriberSeqTwoPhase(builder) {
        makeSubscriberSeq(builder, true)
    }

    static def subPointHeader = { variant ->
        UmlCommon.makeHeader(delegate, "Process subscription point - variant \"\"${variant}\"\"",
                [skipList: [UmlCommon.user, UmlCommon.cli]])
    }

    static def sysUpdate = {
        msg app, to: system, text: 'update (if needed)', noReturn: true, type: UmlCommon.arrowReturn
    }

    static def processSubPointAlt = {

        alt("operation == MOP_CREATED") {
            msg app, text: 'Process creation of ""list"" entry,\\n""presence container"" or ""empty leaf"".'
            "else"("operation == MOP_DELETED")
            msg app, text: 'Process deletion of ""presence container""\\nor optional ""leaf"".'
            "else"("operation == MOP_MODIFIED")
            msg app, text: 'Process modification of descendant\\nof ""list"" entry.'
            "else"("operation == MOP_VALUE_SET")
            msg app, text: 'Process ""newv"" value of ""leaf"".'
            "else"("operation == MOP_MOVED_AFTER")
            msg app, text: 'Process moved order of ""list"" entry\\n(""orderd-by user"" list).'
        }
        delegate << sysUpdate
    }

    static def makeSubsPointDiffIterate(builder) {
        builder.plantuml {
            delegate << subPointHeader.curry("cdb_diff_iterate")
            msgAd app, to: libconfd, text: '""cdb_diff_iterate(spoint, iter_function)""', {
                loop("until changes for spoint available or iteration no stopped") {
                    msgAd libconfd, to: confd, text: 'request next change for spoint'
                    msgAd libconfd, to: app, text: '""iter_function""\\n""(kp, op, oldv, newv, state)""',
                            returnText:'""CONFD_OK"" or ""ITER_STOP"" or\\n""ITER_RECURSE"" or ""ITER_CONTINUE""\\nor ""ITER_UP"" or ""ITER_SUSPEND""',{
                        delegate << processSubPointAlt
                    }
                }
            }
        }
    }

    static def makeSubsPointGetModifications(builder) {
        builder.plantuml {
            delegate << subPointHeader.curry("cdb_get_modifications")
            msgAd app, to: libconfd, text: '""cdb_get_modifications(spoint, &values)""', {
                msgAd libconfd, to: confd, text: 'request modifications'
                msgAd libconfd,  text: 'allocate memory and\\nstore modifications into ""values""'
            }
            loop('iterate over ""values""') {
                alt("val.v.type is not C_NOEXISTS, C_XMLTAG,\\nC_XMLBEGIN, C_XMLEND or C_XMLBEGINDEL") {
                    msg app, text: 'Process creation of a ""leaf"" or a ""leaf-list.'
                    "else"("val.v.type == C_XMLTAG")
                    msg app, text: 'Process creation of a ""leaf"".'
                    "else"("val.v.type == C_XMLBEGIN")
                    msg app, text: 'Start processing of creation of a ""list"".'
                    "else"("val.v.type == C_XMLBEGINDEL")
                    msg app, text: 'Start processing of deletion of the a ""list"".'
                    "else"("val.v.type == C_XMLEND")
                    msg app, text: 'Finish processing of creation/deletion of a ""list"".'
                    "else"("val.v.type == C_NOEXISTS")
                    msg app, text: 'Process deletion of an ""empty leaf"",\\na ""presence container"", an optional ""leaf""\\nor an optional ""leaf-list"".'
                }
                delegate << sysUpdate
                msgAd app, text: '""confd_free_value(CONFD_GET_TAG_VALUE(val))""'
            }
            msgAd app, text: '""free(values)""'
        }
    }

    static def makeSubscriberSeqAll(builder) {
        builder.plantuml {
            delegate << subHead
            newpage()
            delegate << subscrCl
            newpage()
            delegate << subscrCl.curry(true, true)
        }
    }
}
