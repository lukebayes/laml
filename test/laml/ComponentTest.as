package laml {

	import flash.errors.ReferenceError;
	import flash.errors.ArgumentError;
	import asunit.framework.TestCase;

	public class ComponentTest extends TestCase {
		private var component;

		public function ComponentTest(methodName=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			component = new Component();
		}

		override protected function tearDown():void {
			super.tearDown();
			component = null;
		}
		
		protected function setUpChildren(count=5) {
			var children = [];
			
			var child;
			var i = 0;
			while (i++ < count) {
				child = new Component();
				component.addChild(child);
				children.push(child);
			}

			return children;
		}

		public function testInstantiated() {
			assertTrue("component is Component", component is Component);
		}

		public function testX() {
			component.x = 100;
			assertEquals(100, component.x);
		}
		
		public function testY() {
			component.y = 200;
			assertEquals(200, component.y);
		}
		
		public function testWidth() {
			component.width = 300;
			assertEquals(300, component.width);
		}
		
		public function testHeight() {
			component.height = 400;
			assertEquals(400, component.height);
		}
		
		public function testPercentWidth() {
			component.percentWidth = 90;
			assertEquals(90, component.percentWidth);
		}
		
		public function testPercentHeight() {
			component.percentHeight = 80;
			assertEquals(80, component.percentHeight);
		}
		
		public function testChildren() {
			assertEquals(0, component.children.length);
		}
		
		public function testAddChild() {
			var child = new Component();
			component.addChild(child);
			assertSame(child, component.children[0]);
		}
		
		public function testGetChildAt() {
			var children = setUpChildren(3);
			assertSame(children[1], component.getChildAt(1));
		}
		
		public function testUnknownParam() {
			component.someParam = "foo";
			assertEquals("foo", component.someParam);
		}
		
		public function testParent() {
			assertNull(component.parent);
			var child = new Component();
			component.addChild(child);
			assertSame(component, child.parent);
		}
		
		public function testRemoveChild() {
			var kids = setUpChildren(5);
			var child = kids[0];
			var removed = component.removeChild(child);
			
			assertEquals(4, component.children.length);
			assertSame(removed, child);
		}
		
		public function testRemoveUnknownChild() {
			var kids = setUpChildren(5);
			var child = new Component();
			try {
				component.removeChild(child);
				fail("Removing a child that hasn't been added should throw an arugment error");
			}
			catch(e:ArgumentError) {
			}
		}
		
		public function testPadding() {
			component.padding = 10;
			assertEquals(10, component.paddingBottom);
			assertEquals(10, component.paddingLeft);
			assertEquals(10, component.paddingRight);
			assertEquals(10, component.paddingTop);
		}
		
		public function testToString() {
			var parent = new Component();
			var child1 = new Component();
			var child2 = new Component();
			var child3 = new Component();
			
			parent.id = "parent";
			child1.id = "child1";
			child2.id = "child2";
			child3.id = "child3";

			parent.addChild(child1);
			child1.addChild(child2);
			child2.addChild(child3);
			
			assertEquals("/parent", parent.toString());
			assertEquals("/parent/child1", child1.toString());
			assertEquals("/parent/child1/child2", child2.toString());
			assertEquals("/parent/child1/child2/child3", child3.toString());
		}
		
		public function testMinWidth() {
			var component = new Component();
			component.minWidth = 100;
			assertEquals(100, component.width);
		}
		
		public function testMinHeight() {
			var component = new Component();
			component.minHeight = 100;
			assertEquals(100, component.height);
		}
		
		public function testMaxWidth() {
			var component = new Component();
			component.maxWidth = 100;
			assertEquals(0, component.width);
			component.width = 200;
			assertEquals(100, component.width);
		}

		public function testMaxHeight() {
			var component = new Component();
			component.maxHeight = 100;
			assertEquals(0, component.height);
			component.height = 200;
			assertEquals(100, component.height);
		}
	}
}