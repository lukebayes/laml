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
		protected const UP_STATE:String = "Up";
		protected const OVER_STATE:String = "Over";
		protected const DOWN_STATE:String = "Down";
		protected const HIT_TEST_STATE:String = "HitTest";
		
		protected var _defaultUpState:DisplayObject;
		protected var _defaultOverState:DisplayObject;
		protected var _defaultDownState:DisplayObject;
		protected var _defaultHitTestState:DisplayObject;

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
		}
		
		protected function createStates():void {
			if(!upState && defaultUpState) {
				upState = defaultUpState;
			}
			
			if(!overState && defaultOverState) {
				overState = defaultOverState;
			}

			if(!downState && defaultDownState) {
				downState = defaultDownState;
			}
			
			// This hitTestState isn't getting
			// sized appropriately...
			//if(defaultHitTestState) {
			//	hitTestState = defaultHitTestState;
			//}
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			//preferredWidth = upState.width;
			//preferredHeight = upState.height;
			
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
			if(buttonView.upState is BasicBackground) {
				BasicBackground(buttonView.upState).draw(w, h);
				BasicBackground(buttonView.overState).draw(w, h);
				BasicBackground(buttonView.downState).draw(w, h);
				BasicBackground(buttonView.hitTestState).draw(w, h);
			}
			else {
				buttonView.width = w;
				buttonView.height = h;
			}
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
			if(_defaultUpState) {
				return _defaultUpState;
			}
			var alias:String = unQualifiedClassName + UP_STATE;
			return _defaultUpState = getBitmapByName(alias);
		}
		
		public function get defaultOverState():DisplayObject {
			if(_defaultOverState) {
				return _defaultOverState;
			}
			var alias:String = unQualifiedClassName + OVER_STATE;
			return _defaultOverState = getBitmapByName(alias);
		}

		public function get defaultDownState():DisplayObject {
			if(_defaultDownState) {
				return _defaultDownState;
			}
			var alias:String = unQualifiedClassName + DOWN_STATE;
			return _defaultDownState = getBitmapByName(alias);
		}

		public function get defaultHitTestState():DisplayObject {
			if(_defaultHitTestState) {
				return _defaultHitTestState;
			}

			if(width > 0 && height > 0) {
				var bitmapData:BitmapData = new BitmapData(width, height);
				return _defaultHitTestState = new Bitmap(bitmapData);
			}
			
			return null;
		}

		public function set buttonView(simpleButton:SimpleButton):void {
			if(_buttonView) {
				removeButtonViewEventListeners(_buttonView);
				if(view.contains(_buttonView)) {
					view.removeChild(_buttonView);
				}
			}
			_buttonView = view.addChild(simpleButton) as SimpleButton;
			_buttonView.useHandCursor = true;
			
			decorateButtonViewEventListeners(_buttonView);
		}
		
		public function get buttonView():SimpleButton {
			return _buttonView;
		}
		
		protected function removeButtonViewEventListeners(button:SimpleButton):void {
			button.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
			button.removeEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			button.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
			button.removeEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			button.removeEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			button.removeEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
		}

		protected function decorateButtonViewEventListeners(button:SimpleButton):void {
			button.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			button.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			button.addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
		}

		protected function mouseClickHandler(mouseEvent:MouseEvent):void {
			mouseEventHandler(mouseEvent);
		}
		
		protected function mouseEventHandler(mouseEvent:MouseEvent):void {
			dispatchEvent(mouseEvent);
		}
	}
}