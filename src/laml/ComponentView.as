package laml {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ComponentView extends Sprite {
		
		public var model;
		
		public function ComponentView(_model=null) {
			model = _model;
		}
		
		public function draw() {
			x = model.x;
			y = model.y;
			graphics.clear();
//			if(model.backgroundAlpha > 0) {
				graphics.beginFill(model.backgroundColor, model.backgroundAlpha);
//			}
			if(model.strokeAlpha > 0) {
				graphics.lineStyle(model.strokeSize, model.strokeColor, model.strokeAlpha);
			}
			graphics.drawRect(0, 0, model.width, model.height);
			graphics.endFill();
		}
	}
}
