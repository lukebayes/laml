package laml.layout {

	import laml.LAMLTestCase;
	import laml.display.Component;
	import laml.display.Layoutable;

	public class FlowLayoutTest extends LAMLTestCase {
		private var component:Layoutable;

		public function FlowLayoutTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			component = new Component();
			component.backgroundColor = 0xFFCC00;
			component.preferredWidth = 640;
			component.preferredHeight = 480;
			component.padding = 10;
			component.paddingTop = 10;
			component.x = 300;
			addChild(component.view);
		}

		override protected function tearDown():void {
			super.tearDown();
			removeChild(component.view);
			component = null;
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
			var child:Layoutable = createChild();
			component.addChild(child);
			component.render();
			assertEquals(200, child.width);
			assertEquals(10, child.x);
			assertEquals(10, child.y);
		}
		
		public function testSingleFixedWidthBottomRight():void {
			component.horizontalAlign = Component.ALIGN_RIGHT;
			component.verticalAlign = Component.ALIGN_BOTTOM;
			
			var child:Layoutable = createChild();
			component.addChild(child);
			component.render();
			assertEquals(430, child.x);
			assertEquals(220, child.y);
		}
		
		public function testSingleFixedWidthCenter():void {
			component.horizontalAlign = Component.ALIGN_CENTER;
			component.verticalAlign = Component.ALIGN_CENTER;
			
			var child:Layoutable = createChild();
			component.addChild(child);
			component.render();
			assertEquals(220, child.x);
			assertEquals(115, child.y);
		}
		
		public function testSingleFlexibleChild():void {
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
	}
}