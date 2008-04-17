package laml {
	import flash.events.Event;
	
	public class PayloadEvent extends Event {
		public static const PAYLOAD = "payloadEvent";
		
		/* Begin General Purpose Events */
		public static const CHANGED 			= "changed";
		public static const ADDED				= "added";
		public static const REMOVED				= "removed";
		
		/* Begin User Gestures (Pending) */
		public static const PRESS 				= "press";
		public static const RELEASE				= "release";
		public static const RELEASE_OUTSIDE		= "releaseOutside";
		public static const CLICK				= "click";
		public static const DOUBLE_CLICK		= "doubleClick";
		public static const DRAG_BEGIN			= "dragBegin";
		public static const DRAG_END			= "dragEnd";
		public static const DRAG_OVER			= "draggOver";
		public static const DRAG_OUT			= "draggOut";
		public static const DRAG_RELEASE		= "dragRelease";
		public static const FOCUS				= "focus";
		public static const BLUR				= "blur";
		
		public var payload;
		
		public function PayloadEvent(type:String=PAYLOAD, bubbles=false, cancelable=false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			var event = new PayloadEvent(type, bubbles, cancelable);
			event.payload = payload;
			return event;
		}
	}
}
