package laml.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.Security;
	
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
		
		public function Skin() {
			Security.allowDomain("*");
		}

		public function getBitmapByName(alias:String):DisplayObject {
			if(hasOwnProperty(alias)) {
				return new this[alias]() as DisplayObject;
			}
			// Uncomment to see skin elements that cannot be found:
			//trace(">> skin unable to find: " + alias);
			var bitmapData:BitmapData = new BitmapData(1, 1, true, 0x00FFCC00);
			return new Bitmap(bitmapData);
		}
	}
}