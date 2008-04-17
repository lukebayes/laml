package laml {

	import asunit.framework.TestCase;

	public class AppTest extends TestCase {

		public function AppTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
		}
		
		override protected function tearDown():void {
			super.tearDown();
		}
		
		public function testSimpleApp():void {
			var app = new Shoes();
			with(app) {
				button( {label : "Hello", backgroundColor : 0xFFCC00} );
			}
		}
	}
}

class Shoes {
	
	public function Shoes() {
		trace("Shoes created");
	}
	
	public function button(config:Object) {
		trace("button: " + config);
	}
	
	public function alert(config:Object) {
	}
}
