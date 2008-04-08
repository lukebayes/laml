package laml {

	import flash.errors.ReferenceError;
	import flash.errors.ArgumentError;
	import asunit.framework.TestCase;

	public class ComponentVisualTest extends TestCase {
		private var componentWidth = 300;
		private var componentHeight = 200;
		private var component;

		public function ComponentVisualTest(methodName=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			component = new Component();
			component.backgroundColor = 0xFF0000;
			component.width = componentWidth;
			component.height = componentHeight;
			component.x = 200;
			component.y = 20;
			component.padding = 5;
			addChild(component.view);
		}

		override protected function tearDown():void {
			super.tearDown();
			removeChild(component.view);
			component = null;
		}
		
		protected function createAndAddStubChild(w=50, h=50, strokeAlpha=0, padding=0) {
			var child 				= new Component();
			child.backgroundColor 	= 0xFFCC00;
			child.height 			= h;
			child.width 			= w;
			child.padding 			= padding;
			child.strokeAlpha 		= strokeAlpha;
			component.addChild(child);
			return child;
		}
		
		protected function createAndAddStubChildren(count) {
			var decrement = 30;
			var padding = 5;
			var strokeAlpha = 1;
			var w = componentWidth - decrement;
			var h = componentHeight - decrement;
			var children = new Array();
			var child;
			for(var i=0; i < count; i++) {
				children.push( createAndAddStubChild(w, h, strokeAlpha, padding) );
				w -= decrement;
				h -= decrement;
			}
			return children;
		}
		
		protected function createVerticalAlignmentStubChild(align) {
			var child = createAndAddStubChild();
			component.verticalAlign = align;
			component.draw();
			return child;
		}
		
		protected function createHorizontalAlignmentStubChild(align) {
			var child = createAndAddStubChild();
			component.horizontalAlign = align;
			component.draw();
			return child;
		}
		
		public function testAddedHandler():void {
			var triggered = false;
			var handler = function(event) {
				triggered = true;
			}
			
			var child = createAndAddStubChild();
			child.view.addEventListener(PayloadEvent.ADDED, handler);
			component.addChild(child);
			component.draw();
			assertTrue("Added event should be triggered", triggered);
		}
		
		public function testInvalidHorizontalAlign() {
			try {
				component.horizontalAlign = "middle";
				fail("Unexpected align value should throw an exception");
			}
			catch(e:ArgumentError) {
			}
		}

		public function testInvalidVerticalAlign() {
			try {
				component.verticalAlign = "middle";
				fail("Unexpected align value should throw an exception");
			}
			catch(e:ArgumentError) {
			}
		}
		
		public function testAlignVerticalBottom() {
			var child = createVerticalAlignmentStubChild(Layoutable.ALIGN_BOTTOM);
			assertEquals(145, child.y);
		}

		public function testAlignVerticalCenter() {
			var child = createVerticalAlignmentStubChild(Layoutable.ALIGN_CENTER);
			assertEquals(75, child.y);
		}

		public function testAlignHorizontalRight() {
			var child = createHorizontalAlignmentStubChild(Layoutable.ALIGN_RIGHT);
			assertEquals(245, child.x);
		}
		
		public function testAlignHorizontalCenter() {
			var child = createHorizontalAlignmentStubChild(Layoutable.ALIGN_CENTER);
			assertEquals(125, child.x);
		}
		
		public function testChildrenCenterBottom() {
			var children = createAndAddStubChildren(3);
			component.verticalAlign = Layoutable.ALIGN_BOTTOM;
			component.horizontalAlign = Layoutable.ALIGN_CENTER;
			component.draw();
			
			var child = children[0];
			assertEquals(15, child.x);
			assertEquals(25, child.y);

			child = children[1];
			assertEquals(30, child.x);
			assertEquals(55, child.y);

			child = children[2];
			assertEquals(45, child.x);
			assertEquals(85, child.y);
		}
		
		public function testChildrenBottomRight() {
			var children = createAndAddStubChildren(3);
			component.verticalAlign = Layoutable.ALIGN_BOTTOM;
			component.horizontalAlign = Layoutable.ALIGN_RIGHT;
			component.draw();

			var child = children[0];
			assertEquals(25, child.x);
			assertEquals(25, child.y);

			child = children[1];
			assertEquals(55, child.x);
			assertEquals(55, child.y);

			child = children[2];
			assertEquals(85, child.x);
			assertEquals(85, child.y);
		}

	}
}