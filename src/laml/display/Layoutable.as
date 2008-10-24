package laml.display {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import laml.collections.ISelectableList;
	import laml.layout.ILayout;
	import laml.tween.ITweenAdapter;

	public interface Layoutable extends IEventDispatcher {
		
		/**
		 * Globally unique identifier for this instance. 
		 * The provided id must be unique for any tree that
		 * this instance is added to.
		 */
		function set id(id:String):void;
		function get id():String;
		function set name(name:String):void; // TODO: remove me
		function get name():String; // TODO: remove me
		
		function set model(model:DynamicModel):void;
		function get model():DynamicModel;
		function set view(view:Sprite):void;
		function get view():Sprite;
		function set dataProvider(dataProvider:ISelectableList):void;
		function get dataProvider():ISelectableList;
		function set data(data:*):void;
		function get data():*;
		
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
		function get fixedWidth():Number;
		function get fixedHeight():Number;
		function set actualWidth(width:Number):void;
		function get actualWidth():Number;
		function set actualHeight(height:Number):void;
		function get actualHeight():Number;
		function set excludeFromLayout(exclude:Boolean):void;
		function get excludeFromLayout():Boolean;
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
		function set backgroundColor(color:uint):void;
		function get backgroundColor():uint;
		function set backgroundAlpha(alpha:Number):void;
		function get backgroundAlpha():Number;
		function set backgroundImage(image:DisplayObject):void;
		function get backgroundImage():DisplayObject;
		function set cornerRadius(radius:uint):void;
		function get cornerRadius():uint;
		
		function set borderColor(color:uint):void;
		function get borderColor():uint;
		function set borderAlpha(alpha:Number):void;
		function get borderAlpha():Number;
		function set borderSize(size:uint):void;
		function get borderSize():uint;
		function set borderStyle(style:String):void;
		function get borderStyle():String;
		
		function set css(css:String):void;
		function get css():String;

		function set gutter(gutter:int):void;
		function get gutter():int;

		function set horizontalAlign(align:String):void;
		function get horizontalAlign():String;
		function set verticalAlign(align:String):void;
		function get verticalAlign():String;
		
		function get horizontalPadding():int;
		function get verticalPadding():int;

		function set padding(padding:int):void;
		function get padding():int;

		function set paddingTop(padding:int):void;
		function get paddingTop():int;
		function set paddingLeft(padding:int):void;
		function get paddingLeft():int;
		function set paddingRight(padding:int):void;
		function get paddingRight():int;
		function set paddingBottom(padding:int):void;
		function get paddingBottom():int;

		function set skin(skin:ISkin):void;
		function get skin():ISkin;

		// TODO: Should this change to 'styles' and get handled
		// in the parser?
		function set styleNames(names:String):void;
		function get styleNames():String;

		function set visible(visible:Boolean):void;
		function get visible():Boolean;
		
		/* Utilities */
		function set layout(layout:ILayout):void;
		function get layout():ILayout;
		function toString():String;
		function invalidateDisplayList():void;
		function invalidateProperties():void;
		function validateDisplayList():void;
		function validateProperties():void;
		function render():void;

		function set enabled(enabled:Boolean):void;
		function get enabled():Boolean;
		function set mask(mask:Layoutable):void;
		function get mask():Layoutable;
		function set mouseChildren(mouseChildren:Boolean):void;
		function get mouseChildren():Boolean;
		function set mouseEnabled(mouseEnabled:Boolean):void;
		function get mouseEnabled():Boolean;


		function getBitmapByName(name:String):DisplayObject;
		function getTextFormat():TextFormat;
		function buildStyleSheet(sheet:StyleSheet=null):StyleSheet;
		
		/* Tweening */
		function set tweenAdapter(tweenAdapter:ITweenAdapter):void;
		function get tweenAdapter():ITweenAdapter;

		function animate(params:Object, milliseconds:Number=0, easing:String=null, callback:Function=null):void;
		function hide(milliseconds:Number=0, callback:Function=null):void;
		function show(milliseconds:Number=0, callback:Function=null):void;
		function toggle():void;

		/* Composable */
		function get numChildren():int;
		function set parent(parent:Layoutable):void;
		function get parent():Layoutable;
		function get path():String;
		function get root():Layoutable;
		
		function addChild(child:Layoutable):void;
		function getChildAt(index:int):Layoutable;
		function getChildById(id:String):Layoutable;
		function removeAllChildren():void;
		function removeChild(child:Layoutable):void;
		function every(callback:Function, thisObject:* = null):Boolean;
		function filter(callback:Function, thisObject:* = null):Array;
		function forEach(callback:Function, thisObject:* = null):void;
		function map(callback:Function, thisObject:* = null):Array;
	}
}
