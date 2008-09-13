package laml.surprises {

	import asunit.framework.TestCase;

	public class ScopeTest extends TestCase {

		public function ScopeTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
		}

		override protected function tearDown():void {
			super.tearDown();
		}

		public function testVariableScope() {
			var stub = new ScopeStub();
			stub.setWidth(100);
			assertEquals(100, stub.width);
		}
	}
}

class ScopeStub {
	public var width;
	
	public function setWidth(value) {
		width = value;
		// The following will only throw in strict mode. 
		// The var prefix should be required.
		// This statement should not be valid even outside of strict mode
		// This should throw:
		// 1120	Access of undefined property _
		width3 = value;
	}
}

