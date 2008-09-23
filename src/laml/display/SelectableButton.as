package laml.display {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SelectableButton extends Button {
		protected const UP_SELECTED_STATE:String = "UpSelectedState";
		protected const OVER_SELECTED_STATE:String = "OverSelectedState";
		protected const DOWN_SELECTED_STATE:String = "DownSelectedState";
		protected const HIT_TEST_SELECTED_STATE:String = "HitTestSelectedState";
		protected var unselectedButtonView:SimpleButton;
		protected var selectedButtonView:SimpleButton; 
		protected var _selected:Boolean;
		
		override protected function initialize():void { 
			super.initialize();
			model.validate_upSelectedState = validateUpSelectedState;
			model.validate_overSelectedState = validateOverSelectedState;
			model.validate_downSelectedState = validateDownSelectedState;
		}
		
		override protected function createView():void {
			selectedButtonView = new SimpleButton();
			decorateButtonViewEventListeners(selectedButtonView);

			unselectedButtonView = new SimpleButton();
			decorateButtonViewEventListeners(unselectedButtonView);
			buttonView = unselectedButtonView;

			_selected = false;
		}
		
		override protected function createStates():void {
			super.createStates();
			if(defaultUpSelectedState) {
				upSelectedState = defaultUpSelectedState;
			}
			
			if(defaultOverSelectedState) {
				overSelectedState = defaultOverSelectedState;
			}

			if(defaultDownSelectedState) {
				downSelectedState = defaultDownSelectedState;
			}
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

		public function get defaultUpSelectedState():DisplayObject {
			var alias:String = unQualifiedClassName + UP_SELECTED_STATE;
			return getBitmapByName(alias);
		}
		
		public function get defaultOverSelectedState():DisplayObject {
			var alias:String = unQualifiedClassName + OVER_SELECTED_STATE;
			return getBitmapByName(alias);
		}

		public function get defaultDownSelectedState():DisplayObject {
			var alias:String = unQualifiedClassName + DOWN_SELECTED_STATE;
			return getBitmapByName(alias);
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