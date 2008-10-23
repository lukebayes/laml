package laml.tween {
	import laml.display.Layoutable;
	
	
	public class DefaultTweenAdapter implements ITweenAdapter {

		public function animate(component:Layoutable, params:Object, milliseconds:Number=0, easing:String=null, callback:Function=null):void {
			for(var key:String in params) {
				component[key] = params[key];
			}
			if(callback is Function) {
				callback();
			}
		}
	}
}