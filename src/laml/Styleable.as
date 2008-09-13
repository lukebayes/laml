package laml {
	import flash.display.Bitmap;
	
	public class Styleable extends Layoutable {
		/* Constants */
		public static const FONT_BOLD				= "Bold";
		public static const FONT_ITALIC				= "Italic";
		public static const FONT_NORMAL				= "Normal";
		public static const FAMILY_SANS				= "_sans";
		public static const FAMILY_TYPEWRITER		= "_typewriter";

		/* Style Parameters */
		public var backgroundColor:uint				= 0x333333;
		public var backgroundAlpha:Number			= 1;
		public var backgroundImage:Bitmap			= null;
		public var strokeColor:uint					= 0x666666;
		public var fontFace							= FAMILY_SANS;
		public var fontSize							= 12;
		public var fontWeight						= FONT_NORMAL;
		public var strokeAlpha						= 0;
		public var strokeSize						= 0;
		public var strokeStyle						= 'Solid';

	}
}
