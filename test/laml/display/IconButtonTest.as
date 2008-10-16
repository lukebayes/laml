package laml.display {

	import asunit.framework.TestCase;
	
	import fixtures.CustomIconButton;
	
	import flash.events.MouseEvent;

	public class IconButtonTest extends TestCase {
		private var button:IconButton;
		
		private var upColor:uint   = 0xFFCC00;
		private var overColor:uint = 0xCCFF00;
		private var downColor:uint = 0x00CCFF;
		private var size:uint      = 80;
    
		public function IconButtonTest(methodName:String=null) {
			super(methodName)
		}

		override protected function tearDown():void {
			super.tearDown();
			removeChild(button.view);
			button = null;
		}
		
		public function testInstantiated():void {
			button = createButton();
			addChild(button.view);
			assertTrue("button is Button", button is IconButton);
		}

		public function testIconButton():void {
			button = createButton();
			button.text = "Share";
			button.x = 200;
			button.y = 100;
			addChild(button.view);
			addEventHandlers(button);
		}
				
		public function testCustomIconButton():void {
			button = new CustomIconButton();
			button.width = 80;
			button.height = 24;
			button.upState        = new ButtonDisplayState(upColor, size);
			button.overState      = new ButtonDisplayState(overColor, size);
			button.downState      = new ButtonDisplayState(downColor, size);
			button.hitTestState   = new ButtonDisplayState(upColor, size);
			button.text = "MySpace";
			button.icon = "CustomIconButtonIcon";
			button.url = "http://www.myspace.com";
			addChild(button.view);
			addEventHandlers(button);
		}

		private function createButton():IconButton {
			var button:IconButton = new IconButton();
			button.width = 80;
			button.height = 20;
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