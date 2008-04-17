package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
	import laml.BoxLayoutTest;
	import laml.ComponentTest;
	import laml.ComponentViewTest;
	import laml.ComponentVisualTest;
	import laml.DelegateTest;
	import laml.PayloadEventTest;
	import laml.surprises.ScopeTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new laml.BoxLayoutTest());
			addTest(new laml.ComponentTest());
			addTest(new laml.ComponentViewTest());
			addTest(new laml.ComponentVisualTest());
			addTest(new laml.DelegateTest());
			addTest(new laml.PayloadEventTest());
			addTest(new laml.surprises.ScopeTest());
		}
	}
}
