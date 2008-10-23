package laml.tween {
	import gs.TweenLite;
	
	import laml.display.Layoutable;
	
	public class TweenLiteAdapter implements ITweenAdapter {

		public function animate(component:Layoutable, params:Object, milliseconds:Number=0, easing:String=null, callback:Function=null):void {
			var seconds:Number = milliseconds * .001;
			
			if(callback is Function && !params.onComplete) {
				params.onComplete = callback;
			} 
			TweenLite.to(component.view, seconds, params);
		}
	}
}