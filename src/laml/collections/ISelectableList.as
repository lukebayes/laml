package laml.collections {
	import flash.events.IEventDispatcher;
	
	public interface ISelectableList extends IEventDispatcher {
		
		function get firstItem():*;
		function get lastItem():*;
		function get length():int;
		function set selectedIndex(index:int):void;
		function get selectedIndex():int;
		function set selectedItem(item:Object):void;
		function get selectedItem():Object;

		function addItem(item:Object):void;
		function getItemAt(index:int):Object;
		function getItemIndex(item:Object):int;
		function removeItem(item:Object):Object;
		function removeItemAt(index:int):Object;
		function selectNext():Object;
		function selectPrevious():Object;

		function every(callback:Function, thisObject:* = null):Boolean;
		function filter(callback:Function, thisObject:* = null):Array;
		function forEach(callback:Function, thisObject:* = null):void;
		function map(callback:Function, thisObject:* = null):Array;
	}
}