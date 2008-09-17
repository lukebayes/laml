package episodic.core {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class SkinStub extends Sprite {
		[Embed(source="assets/Play1Normal.png")]
		public var CustomButtonUpState:Class;

		[Embed(source="assets/Play1Hot.png")]
		public var CustomButtonOverState:Class;

		[Embed(source="assets/Play1Pressed.png")]
		public var CustomButtonDownState:Class;
		
		[Embed(source="assets/Play1Normal.png")]
		public var CustomSelectableButtonUpState:Class;

		[Embed(source="assets/Play1Hot.png")]
		public var CustomSelectableButtonOverState:Class;

		[Embed(source="assets/Play1Pressed.png")]
		public var CustomSelectableButtonDownState:Class;
		
		[Embed(source="assets/PauseNormal.png")]
		public var CustomSelectableButtonUpSelectedState:Class;

		[Embed(source="assets/PauseHot.png")]
		public var CustomSelectableButtonOverSelectedState:Class;

		[Embed(source="assets/PausePressed.png")]
		public var CustomSelectableButtonDownSelectedState:Class;

		public function getBitmap(alias:String):DisplayObject {
			if(hasOwnProperty(alias)) {
				return new this[alias]() as DisplayObject;
			}
			else {
				var bitmapData:BitmapData = new BitmapData(1, 1);
				return new Bitmap(bitmapData);
			}
		}
	}
}