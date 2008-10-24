package laml.display {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import mx.core.BitmapAsset;
	import mx.core.FontAsset;
	import mx.core.IFlexAsset;
	import mx.core.IFlexDisplayObject;
	import mx.core.SpriteAsset;
	
	public class Skin extends Sprite implements ISkin {
 		private var bitmapAsset:BitmapAsset;
		private var fontAsset:FontAsset;
		private var iFlexAsset:IFlexAsset;
		private var iFlexDisplayObject:IFlexDisplayObject;
		private var spriteAsset:SpriteAsset;

		public function getBitmapByName(alias:String):DisplayObject {
			if(hasOwnProperty(alias)) {
				return new this[alias]() as DisplayObject;
			}
			
			return new Sprite();
		}
	}
}