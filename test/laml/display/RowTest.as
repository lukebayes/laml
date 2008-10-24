package laml.display {

	import laml.LAMLTestCase;
	import laml.xml.LAMLParser;

	public class RowTest extends LAMLTestCase {
		private var row:Row;

		public function RowTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			row = new Row();
			row.x = 200;
			row.y = 20;
			row.backgroundColor = 0x00ff00;
			row.padding = 5;
			row.gutter = 5;
		}

		override protected function tearDown():void {
			super.tearDown();
			removeChild(row.view);
			row = null;
		}

		public function testInstantiated():void {
			assertTrue("row is Row", row is Row);
		}

		public function testAddChildren():void {
			var parser:LAMLParser = new LAMLParser();
			var child:Layoutable;
			var xml:XML = <Component backgroundColor="#ffcc00" width="80" height="100" />
			for(var i:int; i < 5; i++) {
				child = parser.parse(xml);
				row.addChild(child);
			}
			row.render();
			assertRectangle(row, 200, 20, 430, 110);
		}
	}
}