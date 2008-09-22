package {
	import flash.display.Sprite;
	
	import laml.display.Component;
	import laml.display.HBox;
	import laml.display.VBox;
	import laml.xml.LAMLParser;
	
	public class LAML extends Sprite {
		
		private var componentRef:Class = Component;
		private var parserRef:Class = LAMLParser;		
		private var hBoxRef:Class = HBox;
		private var vBoxRef:Class = VBox;

		public function LAML() {
			trace("LAML instantiated!");
		}
	}
}
