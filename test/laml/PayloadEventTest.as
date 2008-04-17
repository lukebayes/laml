package laml {

	import asunit.framework.TestCase;

	public class PayloadEventTest extends TestCase {
		private var instance;

		public function PayloadEventTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new PayloadEvent(PayloadEvent.PAYLOAD);
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is PayloadEvent", instance is PayloadEvent);
		}
		
		public function testClone():void {
			instance.payload = 'hello';
			var copy = instance.clone();
			assertEquals('hello', copy.payload);
			assertFalse(copy.bubbles);
		}
	}
}