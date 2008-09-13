package laml {
	import flash.errors.ArgumentError;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	// TODO: Implement enumeration with nextProperty, etc.
	/**
	 * Any class that extends Delegate, must use 'this' in order
	 * to access values that are defined on the delegated object
	 */
	public class Delegate extends Proxy {
		protected var delegate;
		
		public function Delegate(refersTo=null) {
			delegate = refersTo;
		}
		
		override flash_proxy function callProperty(methodName:*, ...args):* {
			return delegate[methodName].apply(delegate, args);
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			delegate[name] = value;
		}
		
		override flash_proxy function getProperty(name:*):* {
			return delegate[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return delegate.hasOwnProperty(name);
		}
	}
}
