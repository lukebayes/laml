package laml.display {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import laml.collections.ISelectableList;
	import laml.layout.ILayout;
	import laml.tween.ITweenAdapter;

	public interface Composable {

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
