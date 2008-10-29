package flash.display {

	import asunit.framework.TestCase;

	public class ConstrainedSpriteTest extends TestCase {
		private var instance:ConstrainedSprite;

		[Embed(source="../../fixtures/assets/ProjectSprouts.png")]
		private var SproutsLogo:Class;

		public function ConstrainedSpriteTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ConstrainedSprite();
			instance.x = 300;
			instance.y = 20;
			addChild(instance);
		}

		override protected function tearDown():void {
			super.tearDown();
			removeChild(instance);
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ConstrainedSprite", instance is ConstrainedSprite);
		}

		public function testUseChildrenSize():void {
			var bitmap:DisplayObject = new SproutsLogo() as DisplayObject;
			instance.addChild(bitmap);
			assertEquals(202, instance.width);
			assertEquals(102, instance.height);
		}

		public function testModifyChildSizeAfterAdding():void {
			var bitmap:DisplayObject = new SproutsLogo() as DisplayObject;
			instance.addChild(bitmap);

			instance.width = 300;
			assertEquals(300, instance.width);
			assertEquals(151, instance.height);
		}
		
		public function testModifyChildSizeWhenAdding():void {
			instance.width = 300;
			instance.height = 300;
			assertEquals(0, instance.width);
			assertEquals(0, instance.height);
			
			var bitmap:DisplayObject = new SproutsLogo() as DisplayObject;
			instance.addChild(bitmap);
			
			assertEquals(300, instance.width);
			assertEquals(151, instance.height);
		}
		
		public function testShowChild():void {
			var bitmap:DisplayObject = new SproutsLogo() as DisplayObject;
			bitmap.visible = false;
			instance.addChild(bitmap);

			instance.width = 300;
			instance.height = 300;
			
			assertEquals(300, instance.width);
			assertEquals(151, instance.height);
			
			bitmap.visible = true;
			instance.draw();
			assertEquals(300, instance.width);
			assertEquals(151, instance.height);
		}
		
		public function testTwoChildren():void {
			var child1:DisplayObject = new SproutsLogo() as DisplayObject;
			var child2:DisplayObject = new SproutsLogo() as DisplayObject;
			child2.rotation = 90;
			
			instance.addChild(child1);
			instance.addChild(child2);
			
			instance.width = 300;
			instance.height = 300;
			
			assertEquals(300, instance.width);
			assertEquals(300, instance.height);
		}
	}
}