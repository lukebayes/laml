package laml {

	import flash.errors.IllegalOperationError;
	import asunit.framework.TestCase;
	import laml.*;

	public class LAMLParserTest extends TestCase {
		private var parser:LAMLParser;

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
		
		private function getSimpleXML(name) {
			var xml = <u:Dictionary xmlns:u="flash.utils" name={name} />;
			return xml;
		}
		
		private function getCustomTypeXML(type) {
			var str = "<" + type + " />";
			return new XML(str);
		}

		public function testInstantiated():void {
			assertTrue("parser is LAMLParser", parser is LAMLParser);
		}

		public function testParseSimple():void {
			var name = "FooBar";
			var xml = getSimpleXML(name);
			var result = parser.parse(xml);
			assertNotNull("Object returned", result);
			assertEquals(name, result.name);
		}
		
		public function testParseCustomType():void {
			var xml = <Component xmlns="laml" />;
			var result = parser.parse(xml);
			assertTrue("result is a Component", result is Component);
		}
		
		public function testParseCustomType2():void {
			var xml = <Styleable xmlns="laml" />;
			var result = parser.parse(xml);
			assertTrue("result is a Styleable", result is Styleable);
		}

		public function testStringNode():void {
			var xml = <String>Luke</String>
			var result = parser.parse(xml);
			assertEquals("Luke", result);
		}
		
		public function testNumberNode():void {
			var xml = <Number>10</Number>
			var result = parser.parse(xml);
			assertEquals(10, result);
		}
		
		public function testBooleanTrueAttribute():void {
			var xml = <Component isValid="true" xmlns="laml" />;
			var result = parser.parse(xml);
			assertTrue(result.isValid is Boolean);
			assertTrue(result.isValid);
		}
		
		public function testBooleanFalseAttribute():void {
			var xml = <Component isValid="false" xmlns="laml" />;
			var result = parser.parse(xml);
			assertTrue(result.isValid is Boolean);
			assertFalse(result.isValid);
		}
		
		public function testAttributeNumber():void {
			var xml = <Component count="100" xmlns="laml" />;
			var result = parser.parse(xml);
			assertTrue(result.count is Number);
			assertEquals(100, result.count);
		}
		
		public function testNestedVisualNode():void {
			var xml = <Component xmlns="laml" id="root">
						<Component id="child1" />
					  </Component>;
			var result = parser.parse(xml);
			assertTrue("result is component", result is Component);
			assertEquals("root", result.id);
			
			var child = result.getChildAt(0);
			assertTrue("child is component", child is Component);			
			assertTrue(child is Component);
			
			assertNotNull(result.child1);
		}
		
		public function testNestedChildrenWithIds():void {
			var xml = <Component xmlns="laml">
						<Component id="child1" />
						<Component id="child2">
							<Component id="child3" />
						</Component>
					  </Component>;
			var result = parser.parse(xml);
			
			assertNotNull(result.child1);
			assertNotNull(result.child2);
			assertNotNull(result.child3);
		}

		public function testChildWithExistingId():void {
			var xml = <Component xmlns="laml" id="parent">
						<Component id="layout" />
					  </Component>;
			try {
				var result = parser.parse(xml);
				fail("Duplicate id should have thrown an error");
			}
			catch(e:IllegalOperationError) {
			}
		}
		
		public function testNestedChildrenWithDuplicateIds():void {
			var xml = <Component xmlns="laml">
						<Component id="child1" />
						<Component id="child2">
							<Component id="child3" />
							<Component id="child1" />
						</Component>
					  </Component>;
			try {
				var result = parser.parse(xml);
				fail("Duplicate id should have thrown an error");
			}
			catch(e:IllegalOperationError) {
			}
		}
		
		public function testHexValues():void {
			var xml = <Component id="bob" backgroundColor="#FFCC00" xmlns="laml" />;
			var result = parser.parse(xml);
			assertEquals(0xFFCC00, result.backgroundColor);
		}
		
		public function testReferenceAttribute():void {
			var xml = <Component id="bob" xmlns="laml">
						<Component id="child1" owner="{bob}" />
					  </Component>;
			var result = parser.parse(xml);
			assertSame(result.child1.owner, result);
		}
	}
}