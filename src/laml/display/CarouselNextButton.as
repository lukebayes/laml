package laml.display {
	
	public class CarouselNextButton extends Button {
		override protected function initialize():void {
			super.initialize();
			preferredWidth = 30;
			preferredHeight = 100;
		}
		
		override public function set enabled(enabled:Boolean):void {
			super.enabled = enabled;
			visible = (enabled) ? true : false;
		}
	}
}