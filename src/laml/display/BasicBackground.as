package laml.display {
	import flash.display.Shape;

	public class BasicBackground extends Shape {
	    protected var bgColor:uint;
	    protected var radius:uint;
	    protected var corners:String;
		protected var bgAlpha:Number;
	    
	    public static var ALL:String = "ALL";
	    public static var TOP:String = "TOP";
	    public static var RIGHT:String = "RIGHT";
	    public static var BOTTOM:String = "BOTTOM";
	    public static var LEFT:String = "LEFT";

		public function BasicBackground(bgColor:uint, radius:uint=0, corners:String="ALL", bgAlpha:Number=1.0) {
			this.bgColor = bgColor;
			this.radius = radius;
			this.corners = corners;
			this.bgAlpha = bgAlpha;
		}
		
		public function draw(w:Number, h:Number):void {
			graphics.clear();
			graphics.beginFill(bgColor, bgAlpha);
			if(radius > 0) {
				if(corners == ALL) {
					graphics.drawRoundRect(0, 0, w, h, radius);
				}
				else if(corners == TOP) {
					graphics.moveTo(0, radius);
					graphics.curveTo(0, 0, radius, 0);
					graphics.lineTo(w - radius, 0);
					graphics.curveTo(w, 0, w, radius);
					graphics.lineTo(w, h);
					graphics.lineTo(0, h);
					graphics.lineTo(0, radius);
				}
				else if(corners == RIGHT) {
					graphics.moveTo(0, 0);
					graphics.lineTo(w - radius, 0);
					graphics.curveTo(w, 0, w, radius);
					graphics.lineTo(w, h - radius);
					graphics.curveTo(w, h, w - radius, h);
					graphics.lineTo(0, h);
					graphics.lineTo(0, 0);
				}
				else if(corners == BOTTOM) {
					graphics.moveTo(0, 0);
					graphics.lineTo(w, h);
					graphics.lineTo(w, h - radius);
					graphics.curveTo(w, h, w - radius, h);
					graphics.lineTo(radius, h);
					graphics.curveTo(0, h, 0, h - radius);
					graphics.lineTo(0, 0);
				}
				else if(corners == LEFT) {
					graphics.moveTo(0, radius);
					graphics.curveTo(0, 0, radius, 0);
					graphics.lineTo(w, 0);
					graphics.lineTo(w, h);
					graphics.lineTo(w - radius, h);
					graphics.curveTo(0, h, 0, h - radius);
					graphics.lineTo(0, radius);
				}
			}
			else {
				graphics.drawRect(0, 0, w, h);
			}
			graphics.endFill();
		}
	}
}
