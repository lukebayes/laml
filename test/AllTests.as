package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
	import laml.collections.SelectableListTest;
	import laml.display.ComponentTest;
	import laml.display.ImageTest;
	import laml.layout.FlowLayoutTest;
	import laml.layout.StackLayoutTest;
	import laml.xml.LAMLParserTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new laml.collections.SelectableListTest());
			addTest(new laml.display.ComponentTest());
			addTest(new laml.display.ImageTest());
			addTest(new laml.layout.FlowLayoutTest());
			addTest(new laml.layout.StackLayoutTest());
			addTest(new laml.xml.LAMLParserTest());
		}
	}
}
