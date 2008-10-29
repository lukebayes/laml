package flash.display {
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	
	public class ConstrainedSprite extends Sprite {
		
		private var _width:Number;
		private var _height:Number;
		
		override public function set width(width:Number):void {
			_width = width;
			drawChildren();
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set height(height:Number):void {
			_height = height;
			drawChildren();
		}
		
		override public function get height():Number {
			return _height;
		}
		
		private function drawChildren():void {
			var rect:Rectangle;
			if(!isNaN(_width) && !isNaN(_height) && _width != 0 && _height != 0) {
				visibleChildren(function(child:DisplayObject, index:int):void {
					if(child.width > 0 && child.height > 0) {
						rect = constrainedSize(child.width, child.height, _width, _height);
						child.width = rect.width;
						child.height = rect.height;
						child.x = Math.round((_width/2) - (child.width/2));
						child.y = Math.round((_height/2) - (child.height/2));

					}
				})
			}
		}

		private function visibleChildren(handler:Function):void {
			var len:Number = numChildren;
			var child:DisplayObject;
			for(var i:int; i < len; i++) {
				child = getChildAt(i);
				if(child.visible) {
					handler.apply(handler, [child, i]);
				}
			}
		}

		private function constrainedSize(ow:int, oh:int, cw:int, ch:int):Rectangle {
			var w:int;
			var h:int;
			
			if (ow/oh > cw/ch) {
				w = cw;
				h = (w/ow) * oh;
			}
			else if (ow/oh < cw/ch) {
				h = ch;
				w = (h/oh) * ow;
			}
			else {
				if (ow > oh) {
					w = cw;
					h = (w/ow)*oh;
				}
				else {
					h = ch;
					w = (h/oh)*ow;
				}
			}
			return new Rectangle(0, 0, w, h);
		}
	}
}