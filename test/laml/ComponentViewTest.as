package laml {

	import asunit.framework.TestCase;

	public class ComponentViewTest extends TestCase {
		private var view;
		private var model;

		public function ComponentViewTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			model = {};
			view = new ComponentView(model);
			addChild(view);
		}

		override protected function tearDown():void {
			super.tearDown();
			removeChild(view);
			view = null;
		}

		public function testInstantiated():void {
			assertTrue("view is ComponentView", view is ComponentView);
		}

		public function testSetSize():void {
			model.x = 200;
			model.y = 20;
			model.width = 400;
			model.height = 300;
			view.draw();
		}
	}
}