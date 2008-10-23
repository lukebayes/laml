package laml.events {
	import flash.events.Event;

	public class PayloadEvent extends Event {
		public static const ADDED:String 				= 'added';
		public static const CHANGED:String 				= 'changed';
		public static const COMPLETED:String 			= 'completed';
		public static const ERROR:String 				= 'error';
		public static const LOADING_COMPLETED:String 	= 'loadingCompleted';
		public static const REMOVED:String 				= 'removed';
		public static const SELECTION_CHANGED:String	= 'selectionChanged';
		
		public var payload:Object;

		private var _target:Object;
		
		public function PayloadEvent(type:String=CHANGED, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		public function set target(target:*):void {
			_target = target;
		}
		
		override public function get target():Object {
			return (_target || super.target);
		}
		
		override public function toString():String {
			return "[PayloadEvent type='" + type + "' payload='" + payload + "']";
		}
		
		override public function clone():Event {
			var event:PayloadEvent = new PayloadEvent(type, bubbles, cancelable);
			event.payload = payload;
			return event;
		}
	}
}