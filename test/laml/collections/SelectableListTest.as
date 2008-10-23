package laml.collections {

	import asunit.framework.TestCase;

	public class SelectableListTest extends TestCase {
		private var collection:SelectableList;

		public function SelectableListTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			collection = new SelectableList();
		}

		override protected function tearDown():void {
			super.tearDown();
			collection = null;
		}

		public function testInstantiated():void {
			assertTrue("collection is SelectableList", collection is SelectableList);
		}

		public function testAddItem():void {
			assertEquals(0, collection.length);
			collection.addItem({name:'a'});
			assertEquals(1, collection.length);
		}

		public function testGetItemAt():void {
			collection.addItem({name:'a'});
			assertEquals('a', collection.getItemAt(0).name);
		}
		
		public function testGetItemIndex():void {
			var a:Object = {name:'a'};
			var b:Object = {name:'b'};
			collection.addItem(a);
			collection.addItem(b);
			assertEquals(1, collection.getItemIndex(b));
		}
		
		public function testSetSelectedItem():void {
			var a:Object = {name:'a'};
			var b:Object = {name:'b'};
			collection.addItem(a);
			collection.addItem(b);
			collection.selectedItem = b;
			assertEquals('b', collection.selectedItem.name);
			assertEquals(1, collection.selectedIndex);
		}
		
		public function testRemoveItem():void {
			var a:Object = {name:'a'};
			var b:Object = {name:'b'};
			collection.addItem(a);
			collection.addItem(b);
			assertEquals(2, collection.length);
			collection.removeItem(b);
			assertEquals(1, collection.length);
		}
		
		public function testSelectNext():void {
			var a:Object = {name:'a'};
			var b:Object = {name:'b'};
			var c:Object = {name:'c'};
			collection.addItem(a);
			collection.addItem(b);
			collection.addItem(c);

			assertSame('first-1', a, collection.selectNext());
			assertSame('first-2', a, collection.selectedItem);
			
			assertSame('second-1', b, collection.selectNext());
			assertSame('second-2', b, collection.selectedItem);
			
			assertSame('third-1', c, collection.selectNext());
			assertSame('third-2', c, collection.selectedItem);
			
			assertNull('fourth-1', collection.selectNext());
			assertNull('fourth-2', collection.selectedItem);
			
			assertSame('fifth-1', a, collection.selectNext());
			assertSame('fifth-2', a, collection.selectedItem);
		}
		
		public function testSelectPrevious():void {
			var a:Object = {name:'a'};
			var b:Object = {name:'b'};
			var c:Object = {name:'c'};
			collection.addItem(a);
			collection.addItem(b);
			collection.addItem(c);
			
			collection.selectedItem = c;
			
			assertSame('first-1', b, collection.selectPrevious());
			assertSame('first-2', b, collection.selectedItem);

			assertSame('second-1', a, collection.selectPrevious());
			assertSame('second-2', a, collection.selectedItem);
			
			assertNull('third-1', collection.selectPrevious());
			assertNull('third-2', collection.selectedItem);
		}
		
		public function testGetFirstAndLast():void {
			var a:Object = {name:'a'};
			var b:Object = {name:'b'};
			var c:Object = {name:'c'};
			collection.addItem(a);
			collection.addItem(b);
			collection.addItem(c);
			
			assertSame(a, collection.firstItem);
			assertSame(c, collection.lastItem);
		}
	}
}