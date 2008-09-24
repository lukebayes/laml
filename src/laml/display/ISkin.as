package laml.display {
	import flash.display.DisplayObject;
	
	public interface ISkin {
		function getBitmapByName(alias:String):DisplayObject;
	}
}