package laml.display {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SelectableButton extends Button {
		protected var _selected:Boolean;
		protected var selectedButtonView:SimpleButton; 
		protected var unselectedButtonView:SimpleButton;
		
		override protected function initialize():void { 
			super.initialize();
			model.validate_upSelectedState = validateUpSelectedState;
			model.validate_overSelectedState = validateOverSelectedState;
			model.validate_downSelectedState = validateDownSelectedState;
		}
		
		override protected function createChildren():void {
			view = new Sprite();

			selectedButtonView = new SimpleButton();
			decorateButtonViewEventListeners(selectedButtonView);

			unselectedButtonView = new SimpleButton();
			decorateButtonViewEventListeners(unselectedButtonView);
			buttonView = unselectedButtonView;

			_selected = false;
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			if(!overSelectedState) {
				overSelectedState = upSelectedState;
			} 
			if(!downSelectedState) {
				downSelectedState = overSelectedState || upSelectedState;
			}
		}

		override protected function updateSize(w:Number, h:Number):void {
			selectedButtonView.width = w;
			selectedButtonView.height = h;
			unselectedButtonView.width = w;
			unselectedButtonView.height = h;
		}

		public function set upSelectedState(upSelectedState:DisplayObject):void {
			model.upSelectedState = upSelectedState;
		}
		
		public function get upSelectedState():DisplayObject {
			return model.upSelectedState;
		}
		
		public function set overSelectedState(overSelectedState:DisplayObject):void {
			model.overSelectedState = overSelectedState;
		}
		
		public function get overSelectedState():DisplayObject {
			return model.overSelectedState;
		}
		
		public function set downSelectedState(downSelectedState:DisplayObject):void {
			model.downSelectedState = downSelectedState;
		}
		
		public function get downSelectedState():DisplayObject {
			return model.downSelectedState;
		}
		
		protected function validateUpSelectedState(newValue:*, oldValue:*):void {
			selectedButtonView.upState = newValue;
		}
		
		protected function validateOverSelectedState(newValue:*, oldValue:*):void {
			selectedButtonView.overState = newValue;
		}

		protected function validateDownSelectedState(newValue:*, oldValue:*):void {
			selectedButtonView.downState = newValue;
		}

		override protected function validateHitTestState(newValue:*, oldValue:*):void {
			super.validateHitTestState(newValue, oldValue);
			selectedButtonView.hitTestState = newValue;
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		protected function toggleState():void {
			buttonView = (buttonView === unselectedButtonView) ? selectedButtonView : unselectedButtonView;
			_selected = !_selected;
		}
		
		override protected function clickHandler(mouseEvent:MouseEvent):void {
			toggleState();
			mouseEventHandler(mouseEvent);
		}
	}
}