package {
	import flash.display.Sprite;
	
	import laml.display.CarouselNextButton;
	import laml.display.CarouselPreviousButton;
	import laml.display.Component;
	import laml.display.HBox;
	import laml.display.IconButton;
	import laml.display.Label;
	import laml.display.Row;
	import laml.display.VBox;
	
	public class LAML extends Sprite {
		
		private var hboxRef:HBox;
		private var vboxRef:VBox;
		private var carouselPreviousButton:CarouselPreviousButton;
		private var carouselNextButton:CarouselNextButton;
		private var componentRef:Component;
		private var iconButtonRef:IconButton;
		private var labelRef:Label;
		private var rowRef:Row;
		private var hBoxRef:HBox;
		private var vBoxRef:VBox;

		public function LAML() {
			trace("LAML instantiated!");
		}
	}
}
