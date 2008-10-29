package flash.display {
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class ConstrainedSprite extends Sprite {
		
		private var _width:Number;
		private var _height:Number;
		
		public function ConstrainedSprite() {
			addEventListener(Event.ADDED, addedHandler);
		}
		
		private function addedHandler(event:Event):void {
			var child:DisplayObject = event.target as DisplayObject;
			if(child.parent == this) {
				trace(">> insdie");
				drawChild(child);
			}
		}
		
		public function draw():void {
			drawChildren();
		}
		
		override public function set width(width:Number):void {
			_width = width;
			drawChildren();
		}
		
		override public function set height(height:Number):void {
			_height = height;
			drawChildren();
		}
		
		private function drawChildren():void {
			forEach(function(child:DisplayObject, index:int):void {
				drawChild(child);
			});
		}
		
		private function shouldDrawChild(child:DisplayObject):Boolean {
			trace("_width: ", _width, "_height", _height, "visible", child.visible, "child width", child.width, "child.height", child.height);
			return (!isNaN(_width) && 
					!isNaN(_height) &&
					_width != 0 && 
					_height != 0 && 
					child.width > 0 && 
					child.height > 0);
		}
		
		private function drawChild(child:DisplayObject):void {
			if(shouldDrawChild(child)) {
				trace(">>a ");
				var rect:Rectangle;
				rect = constrainedSize(child.width, child.height, _width, _height);
				child.width = rect.width;
				child.height = rect.height;
				child.x = Math.round((_width/2) - (child.width/2));
				child.y = Math.round((_height/2) - (child.height/2));
			}
		}

		private function forEach(handler:Function):void {
			var len:Number = numChildren;
			var child:DisplayObject;
			for(var i:int; i < len; i++) {
				handler.apply(handler, [getChildAt(i), i]);
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