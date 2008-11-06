package laml.display {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import laml.collections.ISelectableList;
	import laml.layout.ILayout;
	import laml.tween.ITweenAdapter;

	public interface Layoutable extends Identifiable, Composable, Styleable, IEventDispatcher {
		
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

	}
}
