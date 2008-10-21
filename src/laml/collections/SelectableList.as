package laml.collections {

	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	public class SelectableList extends EventDispatcher {
		protected var _selectedIndex:int = -1;
		protected var _selectedItem:Object;

		protected var items:Array;
		
		public function SelectableList() {
			items = new Array();
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
		}
		
		public function get selectedItem():Object {
			return _selectedItem;
		}
		
		public function addItem(item:Object):void {
			items.push(item);
		}
		
		public function removeItem(item:Object):Object {
			var index:int = getItemIndex(item);
			if(index > -1) {
				return items.splice(index, 1)[0];
			}
			return null;
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
		
		public function forEach(callback:Function, thisObject:* = null):void {
			items.forEach(callback, thisObject);
		}
		
		public function every(callback:Function, thisObject:* = null):Boolean {
			return items.every(callback, thisObject);
		}
		
		public function filter(callback:Function, thisObject:* = null):Array {
			return items.filter(callback, thisObject);
		}
		
		public function get length():int {
			return items.length;
		}	
	}
}