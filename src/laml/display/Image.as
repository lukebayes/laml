package laml.display {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import laml.events.PayloadEvent;
	
	public class Image extends Component {
		private var bitmap:Bitmap;
		private var originalWidth:Number;
		private var originalHeight:Number;
		
		override protected function initialize():void {
			super.initialize();
			horizontalAlign = Component.ALIGN_CENTER;
			verticalAlign = Component.ALIGN_CENTER;

			model.validate_source = validateSource;
		}
		
		/**
		 * @source can be a string URL that the Image should load,
		 * a Class definition (by reference) that it Image should
		 * instantiate, or a subclass (or instance) of Bitmap.
		 * 
		 * The Image will figure out what type of source it just
		 * received and respond accordingly. 
		 * 
		 * Of course images that need loaded will not be available
		 * immediately, but attached Bitmaps and classes will update
		 * preferredHeight and preferredWidth right away.
		 */
		public function set source(source:*):void {
			model.source = source;
		}
		
		public function get source():* {
			return model.source;
		}
		
		public function set maintainAspectRatio(maintain:Boolean):void {
			model.maintainAspectRatio = maintain;
		}
		
		public function get maintainAspectRatio():Boolean {
			return model.maintainAspectRatio;
		}
		
		private function validateSource(newValue:*, oldValue:*):void {
			if(bitmap) {
				view.removeChild(bitmap);
			}
			newValue = createImageFromValue(newValue);
			if(newValue) {
				bitmap = newValue;
				bitmap.smoothing = true;
				view.addChild(bitmap);
				preferredWidth = originalWidth = bitmap.width;
				preferredHeight = originalHeight = bitmap.height;
			}
		}
		
		private function createImageFromValue(value:*):Bitmap {
			if(value is Bitmap) {
				return value;
			}
			else if(value is Class) {
				return new value();
			}
			else {
				loadImage(value);
			}
			return null;
		}
		
		private function loadImage(url:String):void {
			//var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.load(new URLRequest(url));
		}
		
		private function loadCompleteHandler(event:Event):void {
			source = event.target.content;
			render();
			dispatchPayloadEvent(PayloadEvent.LOADING_COMPLETED);
		}
		
		private function loadErrorHandler(event:Event):void {
			dispatchPayloadEvent(PayloadEvent.ERROR, event);
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);
			var availableWidth:Number = w - (paddingLeft + paddingRight);
			var availableHeight:Number = h - (paddingTop + paddingBottom);

			if(maintainAspectRatio) {
				if(bitmap) {
					var rect:Rectangle = constrainSize(originalWidth, originalHeight, availableWidth, availableHeight);
					var bw:Number = Math.floor(rect.width);
					var bh:Number = Math.floor(rect.height);
					bitmap.width = bw;
					bitmap.height = bh;
					
					switch(horizontalAlign) {
						case Component.ALIGN_LEFT :
							bitmap.x = paddingLeft;
							break;
						case Component.ALIGN_RIGHT :
							bitmap.x = w - (bw + paddingLeft);
							break;
						case Component.ALIGN_CENTER :
							bitmap.x = w/2 - bw/2;
							break;
					}

					switch(verticalAlign) {
						case Component.ALIGN_TOP :
							bitmap.y = paddingTop;
							break;
						case Component.ALIGN_BOTTOM :
							bitmap.y = h - (bh + paddingBottom);
							break;
						case Component.ALIGN_CENTER :
							bitmap.y = h/2 - bh/2;
							break;
					}
				}
			}
			else if(bitmap) {
				bitmap.width = w;
				bitmap.height = h;
			}
		}

		private function constrainSize(ow:int, oh:int, cw:int, ch:int):Rectangle {
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
