package laml {

	import asunit.framework.TestCase;

	public class BoxLayoutTest extends TestCase {
		private var layout;
		private var component;
		private var child;

		public function BoxLayoutTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			component = new Component();
			component.backgroundColor = 0xFF0000;
			component.width = 300;
			component.height = 200;
			component.padding = 10;
			addChild(component.view);

			child = new Component();
			child.backgroundColor = 0xFFCC00;
			child.percentWidth = 1;
			child.percentHeight = 1;
			component.addChild(child);

			component.draw();
		}

		override protected function tearDown():void {
			super.tearDown();
			removeChild(component.view);
		}

		public function testBoxLayout():void {
			assertEquals(10, child.x);
			assertEquals(10, child.y);
			assertEquals(280, child.width);
			assertEquals(180, child.height);
		}
	}
}