package laml.display {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	
	public class Button extends Component {
		private var _buttonView:SimpleButton;
		
		public function Button() {
		}
		
		override protected function initialize():void { 
			super.initialize();
			model.validate_upState = validateUpState;
			model.validate_overState = validateOverState;
			model.validate_downState = validateDownState;
			model.validate_hitTestState = validateHitTestState;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			buttonView = new SimpleButton();
			createButtonEventListeners(buttonView);
			buttonView.useHandCursor = true;
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			if(!hitTestState) {
				hitTestState = upState;
			}
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			buttonView.width = w;
			buttonView.height = h;
			super.updateDisplayList(w, h);
		}
		
		public function set upState(upState:DisplayObject):void {
			model.upState = upState;
		}
		
		public function get upState():DisplayObject {
			return model.upState;
		}
		
		protected function validateUpState(newValue:*, oldValue:*):void {
			buttonView.upState = newValue;
		}
		
		public function set overState(overState:DisplayObject):void {
			model.overState = overState;
		}
		
		public function get overState():DisplayObject {
			return model.overState;
		}
		
		protected function validateOverState(newValue:*, oldValue:*):void {
			buttonView.overState = newValue;
		}

		public function set downState(downState:DisplayObject):void {
			model.downState = downState;
		}
		
		public function get downState():DisplayObject {
			return model.downState;
		}
		
		protected function validateDownState(newValue:*, oldValue:*):void {
			buttonView.downState = newValue;
		}

		public function set hitTestState(hitTestState:DisplayObject):void {
			model.hitTestState = hitTestState;
		}
		
		public function get hitTestState():DisplayObject {
			return model.hitTestState;
		}
		
		protected function validateHitTestState(newValue:*, oldValue:*):void {
			buttonView.hitTestState = newValue;
		}

		public function set buttonView(simpleButton:SimpleButton):void {
			if(_buttonView) {
				view.removeChild(_buttonView);
			}
			_buttonView = view.addChild(simpleButton) as SimpleButton;
		}
		
		public function get buttonView():SimpleButton {
			return _buttonView;
		}
		
		protected function createButtonEventListeners(button:SimpleButton):void {
			button.addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}
		
		protected function mouseClickHandler(event:MouseEvent):void {
			trace(" CLICk ");
		}
			
	}
}
