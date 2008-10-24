package laml.display {
	import flash.display.Shape;

	public class ShapeBackground extends BasicBackground {
	    public static var TRIANGLE:String = "TRIANGLE";
	    
	    protected var shape:String;
	    protected var direction:String;
	    protected var shapeColor:uint;

		public function ShapeBackground(bgColor:uint, radius:uint=0, corners:String="ALL", bgAlpha:Number=1.0, shape:String="TRIANGLE", direction:String="BOTTOM", shapeColor:uint=0xFFFFFF) {
			super(bgColor, radius, corners, bgAlpha);

			this.shape = shape;
			this.direction = direction;
			this.shapeColor = shapeColor;
		}
		
		override public function draw(w:Number, h:Number):void {
			super.draw(w, h);
			
			switch(shape) {
				case TRIANGLE:
					drawTriangle(w, h);
					break;
			}
		}
		
		protected function drawTriangle(w:Number, h:Number):void {
			var size:Number = Math.min(w, h) / 2;
			var halfSize:Number = size / 2;
			var vCenter:Number = h/2;
			var hCenter:Number = w/2;
			var top:Number = vCenter - halfSize;
			var bottom:Number = vCenter + halfSize;
			var left:Number = hCenter - halfSize;
			var right:Number = hCenter + halfSize;
			
			graphics.beginFill(shapeColor);
			graphics.moveTo(vCenter, hCenter);
			
			if(direction == BOTTOM) {
				graphics.moveTo(hCenter, bottom);
				graphics.lineTo(right, top);
				graphics.lineTo(left, top);
				graphics.lineTo(hCenter, bottom);
			}
			else if(direction == RIGHT) {
				graphics.moveTo(right, vCenter);
				graphics.lineTo(left, top);
				graphics.lineTo(left, bottom);
				graphics.lineTo(right, vCenter);
			}
			else if(direction == LEFT) {
				graphics.moveTo(left, vCenter);
				graphics.lineTo(right, top);
				graphics.lineTo(right, bottom);
				graphics.lineTo(left, vCenter);
			}
			else if(direction == TOP) {
				graphics.moveTo(hCenter, top);
				graphics.lineTo(right, bottom);
				graphics.lineTo(left, bottom);
				graphics.lineTo(hCenter, top);
			}

			graphics.endFill();
		}
	}
}
