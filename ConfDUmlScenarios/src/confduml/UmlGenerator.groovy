#!/usr/bin/env groovy
/*
  Install groovy and run this script `groovy UmlGenerator.groovy` to generate UML diagrams
 */
@Grab(group = 'net.sourceforge.plantuml', module = 'plantuml', version = '1.2019.3')
@Grab(group = 'org.bitbucket.novakmi', module = 'nodebuilder', version = '1.1.1')
@Grab(group = 'org.bitbucket.novakmi', module = 'plantumlbuilder', version = '1.0.0')
import net.sourceforge.plantuml.SourceStringReader
import org.bitbucket.novakmi.plantumlbuilder.PlantUmlBuilder
import org.bitbucket.novakmi.plantumlbuilder.PlantUmlBuilderCompPlugin
import org.bitbucket.novakmi.plantumlbuilder.PlantUmlBuilderSeqPlugin

class UmlGenerator {

    static def makeBuilder() {
        def builder = new PlantUmlBuilder()
        builder.registerPlugin(new PlantUmlBuilderSeqPlugin())
        // add extra support for Seq. diagrams
        builder.registerPlugin(new PlantUmlBuilderCompPlugin())
        // add extra support for component. diagrams
        return builder
    }

    static def makeComponentHeader(builder) {
        builder.plantuml {
            //plant("scale max 2500 width")
            UmlCommon.makeHeader(builder, 'ConfD interaction scenario - typical components',
                    [skipList: [UmlCommon.user]])
        }
    }

    static void main(String[] args) {
        System.setProperty('PLANTUML_LIMIT_SIZE', "${4096 * 2}")
        def builder = makeBuilder()
        [
                [fileName: 'subscriber_seq_one_phase', txt: true, fn: Subscriber.&makeSubscriberSeq],
                [fileName: 'subscriber_seq_two_phase', txt: true, fn: Subscriber.&makeSubscriberSeqTwoPhase],
                [fileName: 'subscriber_seq_sub_point_diff', txt: true, fn: Subscriber.&makeSubsPointDiffIterate],
                [fileName: 'subscriber_seq_sub_point_modifications', txt: true, fn: Subscriber.&makeSubsPointGetModifications],
                [fileName: 'subscriber_seq', txt: true, fn: Subscriber.&makeSubscriberSeqAll],
                [fileName: 'dataprovider_seq', txt: true, fn: DataProvider.&makeDataProviderAllSeq],
                [fileName: 'dataprovider_var1_seq', txt: true, fn: DataProvider.&makeDataProviderVar1Seq],
                [fileName: 'dataprovider_var2_seq', txt: true, fn: DataProvider.&makeDataProviderVar2Seq],
                [fileName: 'dataprovider_var3_seq', txt: true, fn: DataProvider.&makeDataProviderVar3Seq],
                [fileName: 'dataprovider_var4_seq', txt: true, fn: DataProvider.&makeDataProviderVar4Seq],
        ].each { it ->
            builder.reset()
            print "Processing  ${it.fileName}"
            it.fn(builder)
            def text = builder.getText()
            if (it.txt) {
                new File("./${it.fileName}.txt").write(text)
            }
            SourceStringReader s = new SourceStringReader(text)
//            FileOutputStream file = new FileOutputStream("./${it.fileName}.png")
//            FileFormatOption format = new FileFormatOption(FileFormat.PNG)
//            s.outputImage(file, format)
//            file.close()
            def cnt = s.getBlocks()[0].getDiagram().getNbImages() // count number of images (in first block) // TODO loop over all blocks?
            def ret = true
            for (int ix = 0; ix < cnt && ret != null; ix++) {
                FileOutputStream file = new FileOutputStream("./${it.fileName}${cnt > 1 ? "_${ix + 1}" : ''}.png")
                net.sourceforge.plantuml.FileFormatOption format = new net.sourceforge.plantuml.FileFormatOption(net.sourceforge.plantuml.FileFormat.PNG)
                if (cnt > 1) {
                    ret = s.outputImage(file, ix, format)
                } else {
                    ret = s.outputImage(file, format)
                }
                file.close()
            }
            println " ... done."

        }
    }
}
