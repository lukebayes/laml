package laml.display {

	import asunit.framework.TestCase;
	
	import fixtures.CustomButton;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class ButtonTest extends TestCase {
		private var button:Button;
		
		private var upColor:uint   = 0xFFCC00;
		private var overColor:uint = 0xCCFF00;
		private var downColor:uint = 0x00CCFF;
		private var size:uint      = 80;
    
		public function ButtonTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
		}

		override protected function tearDown():void {
			super.tearDown();
			removeChild(button.view);
			button = null;
		}
		
		public function testInstantiated():void {
			button = createButton();
			addChild(button.view);
			assertTrue("button is Button", button is Button);
		}
		
		public function testCustomButton():void {
			button = new CustomButton();
			addChild(button.view);
			addEventHandlers(button);
		}
		
		private function createButton():Button {
			var button:Button = new Button();
			button.width = 250;
			button.height = 100;
			button.backgroundColor = 0xCCCCCC;

			button.upState        = new ButtonDisplayState(upColor, size);
			button.overState      = new ButtonDisplayState(overColor, size);
			button.downState      = new ButtonDisplayState(downColor, size);
			button.hitTestState   = new ButtonDisplayState(upColor, size);
			
			addEventHandlers(button);
			
			return button;
		}
		
		private function addEventHandlers(button:Button):void {
			button.addEventListener(MouseEvent.CLICK, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
		}
		
		private function mouseEventHandler(event:MouseEvent):void {
			trace(">> mouseEventHandler :: " + event.type + " from " + event.target);
		}
	}
}

import flash.display.Shape;
	

class ButtonDisplayState extends Shape {
    private var bgColor:uint;
    private var size:uint;

    public function ButtonDisplayState(bgColor:uint, size:uint) {
        this.bgColor = bgColor;
        this.size    = size;
        draw();
    }

    private function draw():void {
        graphics.beginFill(bgColor);
        graphics.drawRect(0, 0, size, size);
        graphics.endFill();
    }
}