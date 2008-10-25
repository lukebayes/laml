package {
	import flash.display.Sprite;
	
	import laml.display.Component;
	import laml.display.HBox;
	import laml.display.VBox;
	
	public class LAML extends Sprite {
		
		private var componentRef:Class = Component;
		private var hBoxRef:Class = HBox;
		private var vBoxRef:Class = VBox;

		public function LAML() {
			trace("LAML instantiated!");
		}
	}
}
