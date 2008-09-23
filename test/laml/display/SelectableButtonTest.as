package laml.display {

	import asunit.framework.TestCase;
	
	import fixtures.CustomSelectableButton;
	
	import flash.events.MouseEvent;

	public class SelectableButtonTest extends TestCase {
		private var button:SelectableButton;
		
		private var upColor:uint			= 0xFFCC00;
		private var overColor:uint			= 0xCCFF00;
		private var downColor:uint			= 0x00CCFF;
		
		private var upSelectedColor:uint	= 0xFF0000;
		private var overSelectedColor:uint	= 0x00FF00;
		private var downSelectedColor:uint	= 0x0000FF;
		private var size:uint				= 80;
    
		public function SelectableButtonTest(methodName:String=null) {
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
			assertTrue("button is Button", button is SelectableButton);
		}
		
		public function testCustomButton():void {
			button = new CustomSelectableButton();
			addChild(button.view);
			addEventHandlers(button);
		}
		
		public function testCustomButtonGrayScale():void {
			button = new CustomSelectableButton();
			button.enabled = false;
			addChild(button.view);
			addEventHandlers(button);
		}

		private function createButton():SelectableButton {
			var button:SelectableButton = new SelectableButton();
			button.width = 250;
			button.height = 100;
			button.backgroundColor 		= 0xCCCCCC;

			button.upState				= new ButtonDisplayState(upColor, size);
			button.overState			= new ButtonDisplayState(overColor, size);
			button.downState			= new ButtonDisplayState(downColor, size);
			
			button.upSelectedState		= new ButtonDisplayState(upSelectedColor, size);
			button.overSelectedState	= new ButtonDisplayState(overSelectedColor, size);
			button.downSelectedState	= new ButtonDisplayState(downSelectedColor, size);
			
			button.hitTestState			= new ButtonDisplayState(upSelectedColor, size);
			
			addEventHandlers(button);

			return button;
		}
		
		protected function addEventHandlers(button:SelectableButton):void {
			button.addEventListener(MouseEvent.CLICK, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);

		}
		
		private function mouseEventHandler(event:MouseEvent):void {
			trace(">> mouseEventHandler :: " + event.type + " from " + event.target + " where selected is " + event.target.selected);
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