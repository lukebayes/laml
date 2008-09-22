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
		
	}
}