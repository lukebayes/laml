package laml.display {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import laml.collections.ISelectableList;
	import laml.layout.ILayout;
	import laml.tween.ITweenAdapter;

	public interface Identifiable {

		/**
		 * Globally unique identifier for this instance. 
		 * The provided id must be unique for any tree that
		 * this instance is added to.
		 */
		function set id(id:String):void;
		function get id():String;
	}
}

