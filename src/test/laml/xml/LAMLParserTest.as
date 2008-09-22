package laml.xml {

	import asunit.framework.TestCase;
	
	import fixtures.ComponentStub;
	
	import flash.errors.IllegalOperationError;
	
	import laml.display.Component;
	import laml.display.HBox;
	import laml.display.Layoutable;
	import laml.display.VBox;

	public class LAMLParserTest extends TestCase {
		private var parser:LAMLParser;
		private var stub:ComponentStub;

		public function LAMLParserTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			parser = new LAMLParser();
		}

		override protected function tearDown():void {
			super.tearDown();
			parser = null;
		}
		
		private function getCustomTypeXML(type:String):XML {
			var str:String = "<" + type + " />";
			return new XML(str);
		}

		public function testInstantiated():void {
			assertTrue("parser is LAMLParser", parser is LAMLParser);
		}

		public function testParseSimple():void {
			var xml:XML = <u:Dictionary xmlns:u="flash.utils" name="foobar" />;
			var result:Object = parser.parse(xml);
			assertNotNull("Object returned", result);
			assertEquals("foobar", result.name);
		}
		
		public function testParseCustomType():void {
			var xml:XML = <Component xmlns="laml.display" />;
			var result:Object = parser.parse(xml);
			assertTrue("result is a Component", result is Layoutable);
		}

		public function testStringNode():void {
			var xml:XML = <String>Luke</String>
			var result:Object = parser.parse(xml);
			assertEquals("Luke", result);
		}
		
		public function testNumberNode():void {
			var xml:XML = <Number>10</Number>
			var result:Object = parser.parse(xml);
			assertEquals(10, result);
		}
		
		public function testBooleanTrueAttribute():void {
			var xml:XML = <ComponentStub fakeBoolean="true" xmlns="fixtures" />;
			var result:Object = parser.parseLayoutable(xml);
			result.render();
			
			assertTrue(result.fakeBoolean is Boolean);
			assertTrue(result.fakeBoolean);
		}
		
		public function testBooleanFalseAttribute():void {
			var xml:XML = <ComponentStub fakeBoolean="false" xmlns="fixtures" />;
			var result:Object = parser.parseLayoutable(xml);
			result.render();

			assertTrue(result.fakeBoolean is Boolean);
			assertFalse(result.fakeBoolean);
		}
		
		public function testAttributeNumber():void {
			var xml:XML = <Component width="100" xmlns="laml.display" />;
			var result:Layoutable = parser.parseLayoutable(xml);
			result.render();

			assertTrue(result.width is Number);
			assertEquals(100, result.width);
		}
		
		public function testNestedVisualNode():void {
			var xml:XML = <Component xmlns="laml.display" id="root">
							<Component id="child1" />
					  	  </Component>;
			var result:Layoutable = parser.parseLayoutable(xml);
			result.render();

			assertEquals("root", result.id);
			
			var child:Layoutable = result.getChildAt(0);
			assertTrue("child is component", child is Layoutable);			
			assertTrue(child is Layoutable);
			assertEquals('child1', child.id);
		}
		
		public function testNestedChildrenWithIds():void {
			var xml:XML = <Component xmlns="laml.display">
						<Component id="child1" />
						<Component id="child2">
							<Component id="child3" />
						</Component>
					  </Component>;
			var result:Layoutable = parser.parseLayoutable(xml);
			result.render();

			var child1:Layoutable = result.getChildById('child1');
			var child2:Layoutable = result.getChildById('child2');
			var child3:Layoutable = result.getChildById('child3');
			assertNotNull(child1);
			assertNotNull(child2);
			assertNotNull(child3);
			
			assertSame(result, child1.parent);
			assertSame(result, child2.parent);
			assertSame(child2, child3.parent);
		}

		public function testChildWithSameAsParentId():void {
			var xml:XML = <Component xmlns="laml.display" id="foo">
						<Component id="foo" />
					  </Component>;
			try {
				var result:Layoutable = parser.parseLayoutable(xml);
				fail("Duplicate id should have thrown an error");
			}
			catch(e:IllegalOperationError) {
			}
		}
		
		public function testHexValues():void {
			var xml:XML = <Component id="bob" backgroundColor="#FFCC00" xmlns="laml.display" />;
			var result:Layoutable = parser.parseLayoutable(xml);
			result.render();
			assertEquals(0xFFCC00, result.backgroundColor);
		}
		
		/*
		public function testNestedChildrenWithDuplicateIds():void {
			var xml:XML = <Component xmlns="laml.display">
						<Component id="child1" />
						<Component id="child2">
							<Component id="child3" />
							<Component id="child1" />
						</Component>
					  </Component>;
			try {
				var result:Layoutable = parser.parseLayoutable(xml);
				fail("Duplicate id should have thrown an error");
			}
			catch(e:IllegalOperationError) {
			}
		}
		
		public function testReferenceAttribute():void {
			var xml:XML = <Component id="bob" xmlns="laml.display">
						<Component id="child1" owner="{bob}" />
					  </Component>;
			var result:Layoutable = parser.parseLayoutable(xml);
			assertSame(result.child1.owner, result);
		}
		*/
	}
}