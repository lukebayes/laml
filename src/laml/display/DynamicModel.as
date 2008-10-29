package laml.display {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.clearTimeout;
	import flash.utils.flash_proxy;
	import flash.utils.setTimeout;
	
	import laml.events.PayloadEvent;

	dynamic public class DynamicModel extends Proxy implements IEventDispatcher {
		public var disabled:Boolean;
		
		private var invalidProperties:Dictionary;
		private var component:Layoutable;
		private var dispatcher:IEventDispatcher;
		private var displayListIsInvalid:Boolean;
		private var displayListTimeoutId:Number;
		private var propertiesAreInvalid:Boolean;
		private var propertyTimeoutId:Number;
		private var validationTimeout:Number;
		private var valueContainer:Object;
		private var callbacks:Object;
		
		public function DynamicModel(component:Component) {
			validationTimeout = 24;
			invalidProperties = new Dictionary();
			dispatcher = new EventDispatcher(component);
			valueContainer = new Object();
			this.component = component;
			callbacks = {};
		}
		
		public function invalidateProperties():void {
			propertiesAreInvalid = true;
			// Validate asynchronously, unless the modifying
			// entity manually validates when it's done working...
			clearTimeout(propertyTimeoutId);
			propertyTimeoutId = setTimeout(component.validateProperties, validationTimeout);
		}
		
		public function validateProperties():Boolean {
			clearTimeout(propertyTimeoutId);
			var result:Boolean = propertiesAreInvalid;
			if(result) {
				propertiesAreInvalid = false;
				var prop:Object;
				for(var i:String in invalidProperties) {
					prop = invalidProperties[i];
					validateProperty(prop.name, prop.newValue, prop.oldValue);
				}
				var props:Dictionary = invalidProperties;
				invalidProperties = new Dictionary();
				var event:PayloadEvent = new PayloadEvent(PayloadEvent.CHANGED);
				event.payload = props;
				dispatchEvent(event);
			}
			return result;
		}
		
		public function invalidateDisplayList():void {
			if(!disabled) {
				displayListIsInvalid = true;
				clearTimeout(displayListTimeoutId);
				displayListTimeoutId = setTimeout(component.validateDisplayList, validationTimeout);
			}
		}
		
		public function validateDisplayList():Boolean {
			clearTimeout(displayListTimeoutId);
			var result:Boolean = displayListIsInvalid;
			if(result) {
				displayListIsInvalid = false;
			}
			return result;
		}
		
		protected function validateProperty(name:String, newValue:*, oldValue:*):void {
			var callbackName:String = 'validate_' + name;
			if(callbacks.hasOwnProperty(callbackName)) {
				callbacks[callbackName](newValue, oldValue);
			}
		}
		
		protected function invalidateProperty(name:*, oldValue:*, newValue:*):void {
			invalidProperties[name] = {name: name, oldValue: oldValue, newValue:newValue};
			if(!propertiesAreInvalid) {
				component.invalidateProperties();
			}
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return (this[name] != undefined);
		}

		override flash_proxy function setProperty(name:*, value:*):void {
			if(value is Function) {
				// TODO: Need to support a collection of callbacks instead
				// of clobbering with the most recent....
				if(callbacks[name]) {
					throw new IllegalOperationError("DynamicModel does not yet support multiple callbacks on: " + name);
				}
				callbacks[name] = value;
			}
			else if(value != valueContainer[name]) {
				if(!disabled) {
					invalidateProperty(name, valueContainer[name], value);
				}
				valueContainer[name] = value;
			}
		}
		
		override flash_proxy function getProperty(name:*):* {
			return valueContainer[name];
		}
		
		override flash_proxy function callProperty(name:*, ...rest):* {
			throw new TypeError(name + ' is not a function.');
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			return dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			return dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}
	}
}
