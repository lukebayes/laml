package laml.display {
	import asunit.framework.TestCase;
	
	import fixtures.ComponentFake;
	import fixtures.ComponentStub;
	
	import laml.events.PayloadEvent;

	public class ComponentTest extends TestCase {
		private var component:Layoutable;

		public function ComponentTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			component = new ComponentStub();
			addChild(component.view);
		}

		override protected function tearDown():void {
			super.tearDown();
			removeChild(component.view);
			component = null;
		}

		public function testInstantiated():void {
			assertTrue("component is Component", component is Component);
		}

		public function testSimpleWidthSetter():void {
			component.width = 200;
			assertSame(200, component.width);
		}
		
		public function testId():void {
			assertTrue('Default id should not be null', component.id != null);
			assertTrue('Default id should include concrete data type: ' + component.id, (component.id.indexOf('ComponentStub') > -1));
			
			var second:Component = new Component();
			assertTrue('Second id should not be same as first', component.id != second.id);
			
			var third:Component = new Component();
			third.id = 'c';
			assertEquals('c', third.id);
		}
		
		public function testName():void {
			assertNotNull('Default name should not be null', component.name);
			assertEquals('Default name should be same as id', component.name, component.id);
			component.name = 'a';
			assertEquals('a', component.name);
		}
		
		public function testStyleSheet():void {
//			var styleSheet:StyleSheet = new StyleSheet();
//			styleSheet.setStyle("componentId", {color:"#FF0000"});
//			component.styleSheet = styleSheet;
			
 //			assertEquals(styleSheet, component.styleSheet);
		}
		
		public function testStyle():void {
			
		}
		
		public function testStyleNames():void {
			assertEquals('', component.styleNames);
			component.styleNames = 'a b c';
			assertEquals('a b c', component.styleNames);
		}
		
		public function testX():void {
			assertEquals(0, component.x);
			component.x = 10;
			assertEquals(10, component.x);
		}
		
		public function testY():void {
			assertEquals(0, component.y);
			component.y = 10;
			assertEquals(10, component.y);
			component.y = 20;
			assertEquals(20, component.y);
		}
		
		public function testCallbackOrder():void {
			var stub:ComponentStub = component as ComponentStub;
			// Force synchronous validation and track the callbacks
			// that were called and in what order...
			stub.render();
			
			var callbacks:Array = stub.callbacks;
			assertEquals('initialize', callbacks.shift());
			assertEquals('createChildren', callbacks.shift());
			assertEquals('commitProperties', callbacks.shift());
			assertEquals('updateDisplayList', callbacks.shift());
			assertEquals(0, callbacks.length);

			callbacks = stub.callbacks = [];
			
			// Modify a property on an existing, initialized instance
			// and force synchronous validation
			stub.foo = 'hello';
			stub.render();
			assertEquals(4, callbacks.length);

			assertEquals('set foo', callbacks.shift());
			assertEquals('fooChanged', callbacks.shift());
			assertEquals('commitProperties', callbacks.shift());
			assertEquals('updateDisplayList', callbacks.shift());
		}
		
		public function testCallbackOrderWithChanges():void {
			var stub:ComponentStub = component as ComponentStub;
			stub.foo = 'hello';
			// Force synchronous validation and track the callbacks
			// that were called and in what order...
			stub.render();
			
			var callbacks:Array = stub.callbacks;
			assertEquals(6, callbacks.length);
			
			assertEquals('initialize', callbacks.shift());
			assertEquals('createChildren', callbacks.shift());
			assertEquals('set foo', callbacks.shift());
			assertEquals('fooChanged', callbacks.shift());
			assertEquals('commitProperties', callbacks.shift());
			assertEquals('updateDisplayList', callbacks.shift());
		}
		
		public function testBackgroundColor():void {
			component.backgroundColor = 0xFFCC00;
			component.width = 200;
			component.height = 150;
			component.x = 200;
			component.render();
			
			assertEquals(200, component.view.width);
			assertEquals(150, component.view.height);
		}
		
		// Should the size of the drawn bg diminish
		// by 1/2 the size of the border? As it is
		// right now, drawn borders will be centered
		// on the item size.
		public function testBorderColor():void {
			component.borderColor = 0xFF0000;
			component.borderSize = 5;
			component.width = 200;
			component.height = 150;
			component.x = 200;
			component.render();
			
			assertEquals(205, component.view.width);
			assertEquals(155, component.view.height);
		}
		
		public function testAddChild():void {
			var handler:Function = function(event:PayloadEvent):void {
				assertSame(event.payload, child);
			}
			
			// Had to swap the component because children 
			// were being created prematurely on get view
			component = new ComponentStub();
			component.addEventListener(PayloadEvent.ADDED, handler);

			var child:Layoutable = new Component();
			component.addChild(child);
			
			component.render(); // Render must be called for children to be created

			assertEquals('View Children should be added', 1, component.view.numChildren);
			
			// Ensure validation doesn't get duplicated after child addition
			var stub:ComponentStub = component as ComponentStub;
			var callbacks:Array = stub.callbacks;
			assertEquals(4, callbacks.length);
			assertEquals('initialize', callbacks.shift());
			assertEquals('createChildren', callbacks.shift());
			assertEquals('commitProperties', callbacks.shift());
			assertEquals('updateDisplayList', callbacks.shift());
		}
		
		public function testGetChildById():void {
			var child:Layoutable = new Component();
			component.addChild(child);
			
			assertSame(child, component.getChildById(child.id));
		}
		
		public function testChildByIdDeep():void {
			var child1:Layoutable = new Component();
			var child2:Layoutable = new Component();
			component.addChild(child1);
			child1.addChild(child2);
			
			assertSame(child2, component.getChildById(child2.id));
		}
		
		public function testRemoveChild():void {
			var child:Layoutable = new Component();
			component.addChild(child);
			component.removeChild(child);
			
			assertEquals(0, component.numChildren);
			assertEquals(0, component.view.numChildren);
		}

		public function testGetItemByIdForRemovedChild():void {
			var handler:Function = function(event:PayloadEvent):void {
				assertNull(component.getChildById(event.payload.id));
			}
			
			component.addEventListener(PayloadEvent.REMOVED, handler);

			var child:Layoutable = new Component();
			component.addChild(child);
			component.removeChild(child);
		}

		public function testGetItemByIdForNestedRemovedChild():void {
			var child1:Layoutable = new Component();
			var child2:Layoutable = new Component();
			component.addChild(child1);
			child1.addChild(child2);
	
			assertSame(child2, component.getChildById(child2.id));
			
			child1.removeChild(child2);
			assertNull(component.getChildById(child2.id));
		}
		
		public function testPreferredWidth():void {
			component.preferredWidth = 50;
			assertEquals(50, component.width);
		}
		
		public function testPreferredHeight():void {
			component.preferredHeight = 50;
			assertEquals(50, component.height);
		}
		
		public function testPreferredLosesToWidth():void {
			component.preferredWidth = 50;
			component.width = 60;
			assertEquals(60, component.width);
		}

		public function testPreferredLosesToHeight():void {
			component.preferredHeight = 50;
			component.height = 60;
			assertEquals(60, component.height);
		}

		public function testPaddingToParts():void {
			component.padding = 10;
			assertEquals(10, component.paddingBottom);
			assertEquals(10, component.paddingLeft);
			assertEquals(10, component.paddingRight);
			assertEquals(10, component.paddingTop);
		}
		
		public function testWidthRounding():void {
			component.width = 3.2;
			assertEquals(3, component.width);
		}
		
		public function testHeightRounding():void {
			component.height = 3.9;
			assertEquals(4, component.height);
		}
		
		public function testMinWidthBoundary():void {
			component.minWidth = 5;
			component.width = 4;
			assertEquals(5, component.width);
		}
		
		public function testMaxWidthBoundary():void {
			component.maxWidth = 5;
			component.width = 6;
			assertEquals(5, component.width);
		}
		
		public function testMinHeightBoundary():void {
			component.minHeight = 5;
			component.height = 4;
			assertEquals(5, component.height);
		}
		
		public function testMaxheightBoundary():void {
			component.maxHeight = 5;
			component.height = 6;
			assertEquals(5, component.height);
		}
		
		public function testPaddingChangesMinSize():void {
			component.padding = 10;
			assertEquals(20, component.width);
			assertEquals(20, component.height);
		}
		
		public function testMXMLComponent():void {
			var fake:ComponentFake = new ComponentFake();
			assertEquals('foo', fake.customMember);
		}
		
		/** 
		 * If one parameter validator invalidates another
		 * parameter, the second validator will NOT be 
		 * triggered - if it did, it would be too easy
		 * to create infinite recursion within the component
		 * validation process.
		 * 
		 * If you are tempted to invalidate another propery
		 * try to do it in the setter of a given property
		 * rather than it's validator.
		 */
		public function testInvalidateWhileValidating():void {
			var stub:ComponentStub = new ComponentStub();
			stub.someProperty = 'foo';
			stub.render();
			assertEquals('foo', stub.someProperty);
			assertTrue('a', stub.somePropertyValidated);
			//assertFalse('stub.otherProperty should not validate!', stub.otherPropertyValidated);
		}
	}
}
