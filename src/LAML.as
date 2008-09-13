package {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import laml.Component;
	import laml.LAMLParser;
	
	public class LAML extends Sprite {
		private var component;

		public function LAML() {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
			createChildren();
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		protected function createChildren() {
			var xml:XML = <Component xmlns="laml" backgroundColor="#FFCC00" padding="5">
								<Component backgroundColor="#FF0000" backgroundAlpha=".5" strokeAlpha="1" strokeSize="0" strokeColor="#0000FF" percentWidth="1" percentHeight="1" />
						  </Component>;

			var parser = new LAMLParser();
			component = parser.parse(xml);
			addChild(component.view);
			trace("LAML instantiated!");
			stageResizeHandler();
		}
		
		protected function stageResizeHandler(event=null) {
			component.x = 5;
			component.y = 5;
			component.width = stage.stageWidth - 10;
			component.height = stage.stageHeight - 10;
			component.draw();
		}
	}
}
