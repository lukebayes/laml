package laml {
	import flash.errors.ArgumentError;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Proxy;
	
	dynamic public class Component extends Styleable {
		public static var LAST_ID = 0;

		public var pendingAttributes;
		
		protected var _children;
		protected var childIdHash;
	
		override protected function initialize() {
			super.initialize();
			id = "Component" + (++LAST_ID);
			pendingAttributes = {};
			childIdHash = {};
		}

		public function get children() {
			return _children ||= [];
		}
		
		public function get length() {
			return children.length;
		}
		
		public function addChild(child) {
			children.push(child);
			child.parent = this;
			addElementId(child);
			return children.length - 1;
		}
		
		public function addElementId(child) {
			if(parent) {
				return parent.addElementId(child);
			}
			if(childIdHash[child.id]) {
				throw new IllegalOperationError('Element added to Composite with existing id (' + child.id + ')');
			}
			childIdHash[child.id] = child;
		}
		
		public function removeElementId(child) {
			if(parent) {
				return parent.removeElementId(child);
			}
			delete childIdHash[child.id];
		}
		
		public function getElementById(id) {
			if(parent) {
				return parent.getElementById(id);
			}
			else {
				return childIdHash[id];
			}
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
