package laml.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	[Event(name='click', type='MouseEvent')]
	[Event(name='mouseDown', type='MouseEvent')]
	[Event(name='mouseMove', type='MouseEvent')]
	[Event(name='mouseOut', type='MouseEvent')]
	[Event(name='mouseOver', type='MouseEvent')]
	[Event(name='mouseUp', type='MouseEvent')]
	public class Button extends Component {
		protected const UP_STATE:String = "UpState";
		protected const OVER_STATE:String = "OverState";
		protected const DOWN_STATE:String = "DownState";
		protected const HIT_TEST_STATE:String = "HitTestState";

		protected var _buttonView:SimpleButton;
		
		override protected function initialize():void { 
			super.initialize();
			model.validate_upState = validateUpState;
			model.validate_overState = validateOverState;
			model.validate_downState = validateDownState;
			model.validate_hitTestState = validateHitTestState;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			createView();
			createStates();
		}
		
		protected function createView():void {
			buttonView = new SimpleButton();
			decorateButtonViewEventListeners(buttonView);
		}
		
		protected function createStates():void {
			if(defaultUpState) {
				upState = defaultUpState;
			}
			
			if(defaultOverState) {
				overState = defaultOverState;
			}

			if(defaultDownState) {
				downState = defaultDownState;
			}
			
			if(defaultHitTestState) {
				hitTestState = defaultHitTestState;
			}
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			if(!hitTestState) {
				hitTestState = upState;
			}
			if(!overState) {
				overState = upState;
			} 
			if(!downState) {
				downState = overState || upState;
			}
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			updateSize(w, h);
			super.updateDisplayList(w, h);
		}
		
		protected function updateSize(w:Number, h:Number):void {
			buttonView.width = w;
			buttonView.height = h;
		}
		
		public function set upState(upState:DisplayObject):void {
			model.upState = upState;
		}
		
		public function get upState():DisplayObject {
			return model.upState;
		}
		
		public function set overState(overState:DisplayObject):void {
			model.overState = overState;
		}
		
		public function get overState():DisplayObject {
			return model.overState;
		}
		
		public function set downState(downState:DisplayObject):void {
			model.downState = downState;
		}
		
		public function get downState():DisplayObject {
			return model.downState;
		}
		
		public function set hitTestState(hitTestState:DisplayObject):void {
			model.hitTestState = hitTestState;
		}
		
		public function get hitTestState():DisplayObject {
			return model.hitTestState;
		}
		
		protected function validateUpState(newValue:*, oldValue:*):void {
			buttonView.upState = newValue;
		}
		
		protected function validateOverState(newValue:*, oldValue:*):void {
			buttonView.overState = newValue;
		}

		protected function validateDownState(newValue:*, oldValue:*):void {
			buttonView.downState = newValue;
		}

		protected function validateHitTestState(newValue:*, oldValue:*):void {
			buttonView.hitTestState = newValue;
		}

		public function get defaultUpState():DisplayObject {
			var alias:String = unQualifiedClassName + UP_STATE;
			return getBitmapByName(alias);
		}
		
		public function get defaultOverState():DisplayObject {
			var alias:String = unQualifiedClassName + OVER_STATE;
			return getBitmapByName(alias);
		}

		public function get defaultDownState():DisplayObject {
			var alias:String = unQualifiedClassName + DOWN_STATE;
			return getBitmapByName(alias);
		}

		public function get defaultHitTestState():DisplayObject {
			if(width > 0 && height > 0) {
				var bitmapData:BitmapData = new BitmapData(width, height);
				return new Bitmap(bitmapData);
			}
			
			return null;
		}

		public function set buttonView(simpleButton:SimpleButton):void {
			if(_buttonView) {
				view.removeChild(_buttonView);
			}
			_buttonView = view.addChild(simpleButton) as SimpleButton;
			_buttonView.useHandCursor = true;
		}
		
		public function get buttonView():SimpleButton {
			return _buttonView;
		}
		
		protected function decorateButtonViewEventListeners(button:SimpleButton):void {
			button.addEventListener(MouseEvent.CLICK, clickHandler);
			button.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
		}
		
		protected function clickHandler(mouseEvent:MouseEvent):void {
			mouseEventHandler(mouseEvent);
		}

		protected function mouseEventHandler(mouseEvent:MouseEvent):void {
			var event:MouseEvent = new MouseEvent(mouseEvent.type);
			dispatchEvent(event);
		}
	}
}
