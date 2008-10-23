package laml.collections {

	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	import laml.events.PayloadEvent;
	
	public class SelectableList extends EventDispatcher implements ISelectableList {

		protected var _selectedIndex:int = -1;
		protected var _selectedItem:Object;

		protected var items:Array;
		
		public function SelectableList() {
			items = new Array();
		}
		
		public function get firstItem():* {
			return (length == 0) ? null : items[0];
		}
		
		public function get lastItem():* {
			return (length == 0) ? null : items[length-1];
		}

		public function get length():int {
			return items.length;
		}

		public function set selectedIndex(index:int):void {
			_selectedIndex = index;
			selectedItem = getItemAt(index);
		}
		
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		
		public function set selectedItem(item:Object):void {
			var index:int = getItemIndex(item);
			_selectedIndex = index;
			_selectedItem = getItemAt(index);
			var event:PayloadEvent = new PayloadEvent(PayloadEvent.SELECTION_CHANGED);
			event.payload = _selectedItem;
			dispatchEvent(event);
		}
		
		public function get selectedItem():Object {
			return _selectedItem;
		}
		
		public function addItem(item:Object):void {
			items.push(item);
		}
		
		public function getItemAt(index:int):Object {
			if(index == -1) {
				return null;
			}
			if(length == 0) {
				throw new IllegalOperationError("There are no items in the collection");
			}
			return items[index];
		}
		
		public function getItemIndex(item:Object):int {
			var len:int = items.length;
			for(var i:Number = 0; i < len; i++) {
				if(items[i] === item) {
					return i;
				}
			}
			return -1;
		}
				
		public function removeItem(item:Object):Object {
			var index:int = getItemIndex(item);
			if(index > -1) {
				return removeItemAt(index);
			}
			return null;
		}
		
		public function removeItemAt(index:int):Object {
			var result:Object = items.splice(index, 1).shift();
			if (selectedIndex == index)
			{
				if (length == 0)
				{
					selectedIndex = -1;
				}
				else
				{
					selectedIndex = index == length ? 0 : selectedIndex;
				}
			}
			return result;
		}
		
		public function selectNext():Object {
			if(length > 0) {
				if(selectedIndex == -1) {
					selectedIndex = 0;
					return selectedItem;
				}
				else if(selectedIndex < length - 1) {
					selectedIndex++;
					return selectedItem;
				}
				else {
					selectedIndex = -1;
				}
			}
			return null;	
		}
		
		public function selectPrevious():Object {
			if(length > 0) {
				if(selectedIndex > 0) {
					selectedIndex--;
					return selectedItem;
				}
				else {
					selectedIndex = -1;
				}
			}
			return null;	
		}
		
		public function every(callback:Function, thisObject:* = null):Boolean {
			return items.every(callback, thisObject);
		}
		
		public function filter(callback:Function, thisObject:* = null):Array {
			return items.filter(callback, thisObject);
		}
		
		public function forEach(callback:Function, thisObject:* = null):void {
			items.forEach(callback, thisObject);
		}
		
		public function map(callback:Function, thisObject:* = null):Array {
			return items.map(callback, thisObject);
		}
	}
}