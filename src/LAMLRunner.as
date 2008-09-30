package {
	import asunit.textui.TestRunner;
	
	import laml.display.Component;
	import laml.display.HBox;
	import laml.display.SelectableButtonTest;
	import laml.display.VBox;
	
	public class LAMLRunner extends TestRunner {
		
		private var hboxRef:HBox;
		private var vboxRef:VBox;
		private var component:Component;
		
		public function LAMLRunner() {
			// start(clazz:Class, methodName:String, showTrace:Boolean)
			// NOTE: sending a particular class and method name will
			// execute setUp(), the method and NOT tearDown.
			// This allows you to get visual confirmation while developing
			// visual entities
			start(AllTests, null, TestRunner.SHOW_TRACE);
		}
	}
}
