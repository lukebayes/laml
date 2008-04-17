package laml {
	import flash.errors.ArgumentError;
	import flash.events.Event;
	import flash.utils.Proxy;
	
	public class Component extends Styleable {
		public static var LAST_ID 					= 0;

		public var id;
		public var parent;
		
		protected var _children;
	
		override protected function initialize() {
			super.initialize();
			id = "Component" + (LAST_ID++);
			_children = new Array();
		}
		
		override public function draw() {
			if(!view.parent) {
				parent.view.addChild(view);
			}
			super.draw();
		}

		public function get children() {
			return _children;
		}
		
		public function addChild(child) {
			children.push(child);
			child.parent = this;
			return children.length - 1;
		}

		public function getChildAt(index) {
			return children[index];
		}
		
		public function removeChild(childToRemove) {
			var len = children.length;
			for (var i = 0; i < len; i++) {
				if(children[i] === childToRemove) {
					return children.splice(i, 1)[0];
				}
			}
			
			throw new ArgumentError("Child not found " + childToRemove + ", could not remove");
			return null;
		}
		
		public function toString() {
			if(parent) {
				return parent.toString() + "/" + id;
			}
			else {
				return "/" + id;
			}
		}

/*		
		// Considering a way to automatically translate gestures to events?
		protected function wireGestureToEvent(gestureName, eventName) {
			var handler = function(event) {
				var payloadEvent = new PayloadEvent(eventName);
				payloadEvent.payload = event.target;
				dispatchEvent(payloadEvent);
			}
			view.addEventListener(gestureName, handler);
		}
*/
	}
}
