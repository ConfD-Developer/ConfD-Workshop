// This class contains reusable parts
class UmlCommon {
    public static def user = 'User'
    public static def cli = 'cli'
    public static def confd = 'confd'
    public static def cdb = 'cdb'
    public static def libconfd = 'libconfd'
    public static def app = 'application'
    public static def system = 'system'
    public static def arrowReturn = '-->'

    private static def colorBoxConfD = '#FFEB99'
    private static def colorBoxUser = '#Gold'
    private static def colorBoxApp = '#E6F3F8'
    private static def colorBoxSystem = '#FFEB99'

    static def makeAppOtherInit(builder) {
        builder.delay("other application initialization")
        builder.note 'Application starts main ConfD loop (""poll"" connected sockets).', pos: "over $app"
        builder.delay("enter ConfD loop")
    }

    static def makeHeader(builder, text, params = null) {
        builder.plant('hide footbox')
        builder.autonumber()
        builder.title(text)
        UmlCommon.makeSkin(builder)
        UmlCommon.makeParticipants(builder, params)
    }

    static def makeSkin(builder) {
        // list of skinparams java -jar ~/.groovy/grapes/net.sourceforge.plantuml/plantuml/jars/plantuml-1.2017.18.jar -language
        builder.plant("skinparam BackgroundColor #FFFFFF-#EEEBDC")
        builder.plant("skinparam SequenceParticipantBackgroundColor #FFFFFF-#DDEBDC")
        builder.plant("skinparam DatabaseBackgroundColor #FFFFFF-#DDEBDC")

        //builder.plant("skinparam RectangleBackgroundColor #ffd200/#8cfcff")
        builder.plant("skinparam NoteFontSize 22")
        builder.plant("skinparam ArrowFontSize 24")
        builder.plant("skinparam SequenceParticipantFontSize 24")
        builder.plant("skinparam SequenceReferenceFontSize 20")
        builder.plant("skinparam ActorFontSize 24")
        builder.plant("skinparam SequenceGroupHeaderFontSize 20")
        builder.plant("skinparam SequenceGroupFontSize 16")
        builder.plant("skinparam SequenceDelayFontSize 16")
        builder.plant("skinparam SequenceDividerFontSize 20")
        builder.plant("skinparam HeaderFontSize  20")
        builder.plant("skinparam SequenceBoxFontSize   20")
        builder.plant("skinparam ComponentFontSize    20")
        //builder.plant("skinparam arrowFontStyle bold")
        builder.plant("skinparam SequenceBoxFontStyle plain")
        builder.plant("skinparam SequenceGroupFontStyle plain")
        builder.plant("skinparam SequenceDividerFontStyle plain")
        //builder.plant("skinparam sequenceParticipantFontStyle bold")
    }

    static def makeParticipants(builder, params = null) {
        def skipList = []
        def appThreads = 0

        if (params) {
            if (params?.skipList) {
                skipList = params.skipList
            }
            if (params?.appThreads) {
                appThreads = params.appThreads
            }
        }

        if (!skipList.contains(user)) {
            builder.box("              <size:40><&person></size> User                  ",
                    color: colorBoxUser) {
                actor(user)
            }
        }
        if (!(skipList.contains(cli) && skipList.contains(confd)
                && skipList.contains(cdb))) {
            builder.box("      ConfD      ", color: colorBoxConfD) {
                if (!skipList.contains(cli)) {
                    participant(cli, as: '" <size:40><&terminal></size> ConfD CLI "')
                }
                if (!skipList.contains(confd)) {
                    participant(confd, as: '" <size:40><&wrench></size> ConfD "')
                }
                if (!skipList.contains(cdb)) {
                    plant("database $cdb as \" ConfD CDB \" ")
                }
            }
        }
        if (!(skipList.contains(libconfd) && skipList.contains(app))) {
            builder.box("  Application  ", color: colorBoxApp) {
                participant(libconfd, as: '" <size:40><&list></size>  libconfd\\n(ConfD application client library) "')
                participant(app, as: '" <size:40><&layers></size> ConfD daemon\\n(application) "')
                if (appThreads > 0) {
                    for(i in appThreads) {
                        participant("$app${i+1}", as: "\" <size:40><&layers></size> ConfD daemon\\nthread ${i+1} \"")
                    }
                }
            }
        }
        if (!skipList.contains(system)) {
            builder.box("   System     ", color: colorBoxSystem) {
                participant(system, as: '" <size:40><&tablet></size> System\\nlayer "')
            }
        }
    }

}