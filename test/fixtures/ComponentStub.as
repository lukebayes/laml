package fixtures {

	import laml.display.Component;
	
	dynamic public class ComponentStub extends Component {
		
		public var callbacks:Array = [];
		public var fakeBoolean:Boolean;
		public var fooCallbackTriggered:Boolean;
		public var somePropertyValidated:Boolean;
		public var otherPropertyValidated:Boolean;
		
		override protected function initialize():void {
			callbacks.push('initialize');
			super.initialize();
			// Set up validations for custom params
			model.validate_foo = fooChanged;
			model.validate_someProperty = validateSomeProperty;
			model.validate_otherProperty = validateOtherProperty;
		}
		
		override protected function createChildren():void {
			callbacks.push('createChildren');
			super.createChildren();
		}

		override protected function commitProperties():void {
			callbacks.push('commitProperties');
			super.commitProperties();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			callbacks.push('updateDisplayList');
			super.updateDisplayList(w, h);
		}
		
		private function fooChanged(newValue:String, oldValue:String):void {
			callbacks.push('fooChanged');
			fooCallbackTriggered = true;
		}
		
		public function set someProperty(value:String):void {
			model.someProperty = value;	
		}
		
		public function get someProperty():String {
			return model.someProperty;
		}
		
		private function validateSomeProperty(newValue:String, oldValue:String):void {
			somePropertyValidated = true;
			model.otherProperty = newValue + 'Other';	
		}
		
		private function validateOtherProperty(newValue:String, oldValue:String):void {
			otherPropertyValidated = true;	
		}
		
		public function set otherProperty(value:String):void {
			model.otherProperty = value;
		}
		
		public function get otherProperty():String {
			return model.otherProperty;
		}
		
		public function set foo(foo:String):void {
			callbacks.push('set foo');
			model.foo = foo;
		}
		
		public function get foo():String {
			callbacks.push('get foo');
			return model.foo;
		}
	}
}