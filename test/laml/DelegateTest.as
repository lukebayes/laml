package laml {

	import flash.errors.TypeError;
	import asunit.framework.TestCase;

	public class DelegateTest extends TestCase {
		
		public function DelegateTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
		}

		override protected function tearDown():void {
			super.tearDown();
		}

		public function testStubWidth() {
			var stub = new DelegateStub();
			stub.width = 200;
			assertEquals(200, stub.width);
		}
		
		public function testStubDefault() {
			var stub = new DelegateStub();
			assertEquals(0, stub.width);
		}
		
		public function testStubMethod() {
			var stub = new DelegateStub();
			var child = new Component();
			stub.addChild(child);
			assertEquals(1, stub.children.length);
		}
		
		public function testUnknownDelegate() {
			var stub = new DelegateStub();
			stub.clearDelegate();
			try {
				stub.width = 200;
				fail("Delegate should throw a ReferenceError when there is no defined delegate");
			}
			catch(e:TypeError) {
			}
		}
		
		public function testInternalChanges() {
			var stub = new DelegateStub();
			stub.updateWidth(120);
			assertEquals(120, stub.width);
		}
		
		public function testGetDelegatedProperty() {
			var stub = new DelegateStub();
			assertEquals(0, stub.getWidth());
		}
		
		public function testDirectDelegate() {
			var delegate = new Delegate(new Component());
			delegate.width = 110;
			assertEquals(110, delegate.width);
		}
		
		public function testHasProperty() {
			var delegate = new Delegate(new Component());
			assertTrue( delegate.hasOwnProperty("pendingAttributes") );
		}
	}
}

import laml.Delegate;
import laml.Component;
import flash.utils.flash_proxy;

class DelegateStub extends Delegate {
	
	public function DelegateStub() {
		delegate = new Component();
	}
	
	public function updateWidth(value) {
		this.width = value;
	}
	
	public function getWidth() {
		return this.width;
	}
	
	public function clearDelegate() {
		delegate = null;
	}
}
