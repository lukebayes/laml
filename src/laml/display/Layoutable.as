package laml.display {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import laml.layout.ILayout;

	public interface Layoutable extends IEventDispatcher {
		
		/* Findable */
		function set id(id:String):void;
		function get id():String;
		function set name(name:String):void;
		function get name():String;
		
		function set model(model:DynamicModel):void;
		function get model():DynamicModel;
		function set view(view:Sprite):void;
		function get view():Sprite;
		
		/* Positionable */
		function set x(x:int):void;
		function get x():int;
		function set y(y:int):void;
		function get y():int;
		
		/* Scaleable */
		function set width(width:Number):void;
		function get width():Number;
		function set height(height:Number):void;
		function get height():Number;
		function set actualWidth(width:Number):void;
		function get actualWidth():Number;
		function set actualHeight(height:Number):void;
		function get actualHeight():Number;
		function set percentWidth(width:Number):void;
		function get percentWidth():Number;
		function set percentHeight(height:Number):void;
		function get percentHeight():Number;
		function set preferredWidth(width:Number):void;
		function get preferredWidth():Number;
		function set preferredHeight(height:Number):void;
		function get preferredHeight():Number;
		
		function set maxWidth(max:Number):void;
		function get maxWidth():Number;
		function set maxHeight(max:Number):void;
		function get maxHeight():Number;
		function set minWidth(min:Number):void;
		function get minWidth():Number;
		function set minHeight(min:Number):void;
		function get minHeight():Number;
		
		/* Styleable */
		function set styleNames(names:String):void;
		function get styleNames():String;
		
		function set horizontalAlign(align:String):void;
		function get horizontalAlign():String;
		function set horizontalGutter(gutter:int):void;
		function get horizontalGutter():int;
		function set verticalAlign(align:String):void;
		function get verticalAlign():String;
		function set verticalGutter(gutter:int):void;
		function get verticalGutter():int;
		
		function set padding(padding:int):void;
		function get padding():int;
		function get horizontalPadding():int;
		function get verticalPadding():int;
		function set paddingTop(padding:int):void;
		function get paddingTop():int;
		function set paddingLeft(padding:int):void;
		function get paddingLeft():int;
		function set paddingRight(padding:int):void;
		function get paddingRight():int;
		function set paddingBottom(padding:int):void;
		function get paddingBottom():int;
		
		function set backgroundColor(color:uint):void;
		function get backgroundColor():uint;
		function set backgroundAlpha(alpha:Number):void;
		function get backgroundAlpha():Number;
		function set backgroundImage(image:Bitmap):void;
		function get backgroundImage():Bitmap;
		
		function set borderColor(color:uint):void;
		function get borderColor():uint;
		function set borderAlpha(alpha:Number):void;
		function get borderAlpha():Number;
		function set borderSize(size:uint):void;
		function get borderSize():uint;
		function set borderStyle(style:String):void;
		function get borderStyle():String;
		
		/* Utilities */
		function set layout(layout:ILayout):void;
		function get layout():ILayout;
		function toString():String;
		function invalidateDisplayList():void;
		function invalidateProperties():void;
		function validateDisplayList():void;
		function validateProperties():void;
		function render():void;
		
		/* Composable */
		function addChild(child:Layoutable):void;
		function getChildAt(index:int):Layoutable;
		function getChildById(id:String):Layoutable;
		function removeChild(child:Layoutable):void;
		function get numChildren():int;
		function set parent(parent:Layoutable):void;
		function get parent():Layoutable;
	}
}
