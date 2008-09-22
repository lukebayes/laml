package laml.display {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class Skin extends Sprite {

		public function getBitmapByName(alias:String):DisplayObject {
			if(hasOwnProperty(alias)) {
				return new this[alias]() as DisplayObject;
			}
			
			return null;
		}
	}
}