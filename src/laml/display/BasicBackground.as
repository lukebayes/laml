package laml.display {
	import flash.display.Shape;

	public class BasicBackground extends Shape {
	    private var bgColor:uint;
	    private var radius:uint;

		public function BasicBackground(bgColor:uint, radius:uint) {
			this.bgColor = bgColor;
			this.radius = radius;
		}
		
		public function draw(w:Number, h:Number):void {
			graphics.beginFill(bgColor);
			if(radius > 0) {
				graphics.drawRoundRect(0, 0, w, h, radius);
			}
			else {
				graphics.drawRect(0, 0, w, h);
			}
			graphics.endFill();
		}
	}
}
