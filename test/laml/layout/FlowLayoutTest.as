package laml.layout {

	import laml.LAMLTestCase;
	import laml.display.Component;
	import laml.display.ComponentMock;
	import laml.display.Layoutable;
	import laml.xml.LAMLParser;

	public class FlowLayoutTest extends LAMLTestCase {
		private var component:Layoutable;
		private var parser:LAMLParser
		private var box:Layoutable;

		public function FlowLayoutTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			parser = new LAMLParser();
		}

		override protected function tearDown():void {
			super.tearDown();
			if(box && box.view.parent) {
				removeChild(box.view);
			}

			if(component && component.view.parent) {
				removeChild(component.view);
			}
			component = null;
		}
		
		private function createComponent():void {
			component = new Component();
			component.backgroundColor = 0x666666;
			component.width = 640;
			component.height = 480;
			component.padding = 10;
			component.paddingTop = 10;
			component.x = 300;
			addChild(component.view);
		}
		
		private function createChild(color:uint=0xFF000, percentWidth:Number=NaN, percentHeight:Number=NaN, maxWidth:Number=NaN, maxHeight:Number=NaN):Layoutable {
			var child:Layoutable = new Component();
			child.backgroundColor = color;
			if(isNaN(percentWidth)) {
				child.width = 200;
			}
			else {
				child.percentWidth = percentWidth;
			}
			if(isNaN(percentHeight)) {
				child.height = 250;
			}
			else {
				child.percentHeight = percentHeight;
			}
			if(!isNaN(maxWidth)) {
				child.maxWidth = maxWidth;
			}
			if(!isNaN(maxHeight)) {
				child.maxHeight = maxHeight;
			}
			return child;
		}
		
		public function testSingleFixedWidthChildTopLeft():void {
			createComponent();

			var child:Layoutable = createChild();
			component.addChild(child);
			component.render();
			assertEquals(200, child.width);
			assertEquals(10, child.x);
			assertEquals(10, child.y);
		}
		
		public function testSingleFixedWidthBottomRight():void {
			createComponent();

			component.horizontalAlign = Component.ALIGN_RIGHT;
			component.verticalAlign = Component.ALIGN_BOTTOM;
			
			var child:Layoutable = createChild();
			component.addChild(child);
			component.render();
			assertEquals(430, child.x);
			assertEquals(220, child.y);
		}
		
		public function testSingleFixedWidthCenter():void {
			createComponent();

			component.horizontalAlign = Component.ALIGN_CENTER;
			component.verticalAlign = Component.ALIGN_CENTER;
			
			var child:Layoutable = createChild();
			component.addChild(child);
			component.render();
			assertEquals(220, child.x);
			assertEquals(115, child.y);
		}
		
		public function testSingleFlexibleChild():void {
			createComponent();

			var child:Layoutable = createChild();
			child.percentWidth = 1;
			child.percentHeight = 1;
			component.addChild(child);
			component.render();

			assertEquals(620, child.width);
			assertEquals(460, child.height);
			assertEquals(10, child.x);
			assertEquals(10, child.y);
		}
		
		public function testThreeFlexibleChildren():void {
			createComponent();

			var child1:Layoutable = createChild(0xFF0000, 1, 1);
			var child2:Layoutable = createChild(0x00FF00, 1, 1, 200, 220);
			var child3:Layoutable = createChild(0x0000FF, 1, 1, 180, 160);
			
			component.addChild(child1);
			component.addChild(child2);
			component.addChild(child3);
			
			addChild(component.view);
			component.render();
			
			assertRectangle(child1, 10, 10, 620, 460);
			assertRectangle(child2, 10, 10, 200, 220);
			assertRectangle(child3, 10, 10, 180, 160);
		}
		
		public function testExcludeFromLayout():void {
			var xml:XML = <VBox id="root" xmlns="laml.display" x="200" width="640" height="480" padding="10" backgroundColor="#FF0000">
				<Component id="child1" height="100%" width="200" backgroundColor="#CCCCCC"/>
				<Component id="child2" height="200" width="300" excludeFromLayout="true" backgroundColor="#0FFFF0" />
			</VBox>;
			
			box = parser.parseLayoutable(xml);
			addChild(box.view);
			box.render();
			listenToStage(box);
			
			var child:Layoutable;
			
			child = box;
			assertRectangle(child, 200, 0, 640, 480);
			child = box.getChildAt(0);
			assertRectangle(child, 10, 10, 200, 460);
			child = box.getChildAt(1);
			assertRectangle(child, 0, 0, 300, 200);
		}

		public function testContainerExpandsForChildren():void {
			var xml:XML = <VBox id="root" xmlns="laml.display" x="200" y="10" padding="5" backgroundColor="#FFCC00">
				<Component id="child1" width="200" height="80" backgroundColor="#FF0000" />
				<Component id="child2" width="120" height="80" backgroundColor="#00FF00" />
				<Component id="child3" width="200" height="105" backgroundColor="#0000FF" />
			</VBox>;
			
			box = parser.parseLayoutable(xml);
			addChild(box.view);
			box.render();
			//listenToStage(box);
			
			var child:Layoutable = box;
			assertRectangle(child, 200, 10, 210, 275);
			child = box.getChildAt(0);
			assertRectangle(child, 5, 5, 200, 80);
			child = box.getChildAt(1);
			assertRectangle(child, 5, 85, 120, 80);
			child = box.getChildAt(2);
			assertRectangle(child, 5, 165, 200, 105);

			// Change the size of a child
			child.width = 300;
			child.height = 200;
			box.render();
			
			// The Box should always draw up to it's children size
			// unless it has been given a percent, or fixed size
			assertRectangle(box, 200, 10, 310, 370);
		}

		public function testContainerRespectsChildrenMinSize():void {
			var xml:XML = <VBox id="root" xmlns="laml.display" x="200" y="10" padding="5" backgroundColor="#FFCC00">
				<Component id="child1" width="200" height="80" backgroundColor="#FF0000" />
				<Component id="child2" width="120" height="80" backgroundColor="#00FF00" />
				<Component id="child3" minWidth="20" minHeight="25" width="100%" height="50%" backgroundColor="#0000FF" />
			</VBox>;
			
			box = parser.parseLayoutable(xml);
			addChild(box.view);
			box.width = 100; // Set invalid (too small) width
			box.height = 100; // Set invalid (too small) height
			box.render();
			listenToStage(box);
			
			var child:Layoutable = box;
			assertRectangle(child, 200, 10, 210, 195);
			child = box.getChildAt(0);
			assertRectangle(child, 5, 5, 200, 80);
			child = box.getChildAt(1);
			assertRectangle(child, 5, 85, 120, 80);
			child = box.getChildAt(2);
			assertRectangle(child, 5, 165, 200, 25);
		}

		public function testNestedChildrenCallCount():void {
			var xml:XML = <VBox id="root" xmlns="laml.display" x="200" y="10" padding="5" backgroundColor="#FFCC00">
				<ComponentMock id="child1" width="100%" height="80" backgroundColor="#FF0000" />
				<Label id="child2" width="100" height="100" text="what" backgroundColor="#00FF00" />
				<Component id="child3" width="100%" height="105" backgroundColor="#0000FF" />
			</VBox>;
			
			box = parser.parseLayoutable(xml);
			
			box.width = 400;
			box.height = 330;
			
			addChild(box.view);
			
			var child:ComponentMock = box.getChildById('child1') as ComponentMock;
			assertNotNull(child);
			assertEquals(2, child.widths.length);
			assertEquals(1, child.heights.length);
		}

		public function testDistributeMissingFinalPixel():void {
			var xml:XML = <HBox id="parent" width="401" height="100" x="300" y="20" xmlns="laml.display" backgroundColor="#0000ff">
							<Component id="child1" width="100%" height="100%" backgroundColor="#ff0000" />
							<Component id="child2" width="100%" height="100%" backgroundColor="#ff0000" />
						  </HBox>;
			box = parser.parseLayoutable(xml);
			addChild(box.view);
			box.render();
			
			var child1:Layoutable = box.getChildById('child1');
			var child2:Layoutable = box.getChildById('child2');
			assertEquals('Remainder pixel should go to last child', 201, child2.width);
		}

		public function testDistributeMissingFinalFourPixels():void {
			var xml:XML = <HBox id="parent" width="101" height="100" x="300" y="20" gutter="1" padding="1" xmlns="laml.display" backgroundColor="#0000ff">
							<Component id="child1" width="100%" height="100%" backgroundColor="#ff0000" />
							<Component id="child2" width="100%" height="100%" backgroundColor="#ff0000" />
							<Component id="child3" width="50%" height="50%" backgroundColor="#ff0000" />
							<Component id="child4" width="100%" height="100%" backgroundColor="#ff0000" />
							<Component id="child5" width="50%" height="50%" backgroundColor="#ff0000" />
							<Component id="child6" width="100%" height="100%" backgroundColor="#ff0000" />
							<Component id="child7" width="100%" height="100%" backgroundColor="#ff0000" />
						  </HBox>;
			box = parser.parseLayoutable(xml);
			addChild(box.view);
			listenToStage(box);
			box.render();
			
			var child:Layoutable;
			
			child = box.getChildById('child1');
			assertEquals('1', 15, child.width);
			
			child = box.getChildById('child2');
			assertEquals('2', 15, child.width);
			
			child = box.getChildById('child3');
			assertEquals('3', 7, child.width);
			
			child = box.getChildById('child4');
			assertEquals('4 added', 16, child.width);
			
			child = box.getChildById('child5');
			assertEquals('5 added', 8, child.width);
			
			child = box.getChildById('child6');
			assertEquals('6 added', 16, child.width);
			
			child = box.getChildById('child7');
			assertEquals('7 added', 16, child.width);
		}
	}
}