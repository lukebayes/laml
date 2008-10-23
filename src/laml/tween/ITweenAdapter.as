package laml.tween {
	import laml.display.Layoutable;
	
	public interface ITweenAdapter {
		function animate(component:Layoutable, params:Object, milliseconds:Number=0, easing:String=null, callback:Function=null):void;
	}
}