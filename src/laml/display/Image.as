package laml.display {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	import laml.events.PayloadEvent;
	
	public class Image extends Component {
		private var attached:Bitmap;
		
		public function Image() {
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
		
		override protected function initialize():void {
			super.initialize();
			model.validate_source = validateSource;
		}
		
		private function validateSource(newValue:*, oldValue:*):void {
			if(attached) {
				view.removeChild(attached);
			}
			newValue = createImageFromValue(newValue);
			if(newValue) {
				view.addChild(newValue);
				attached = newValue;
				preferredWidth = attached.width;
				preferredHeight = attached.height;
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
			view.width = w;
			view.height = h;
		}
	}
}
