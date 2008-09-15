package laml.display {

	import asunit.framework.TestCase;
	
	import laml.events.PayloadEvent;

	public class ImageTest extends TestCase {
		[Embed(source="../../fixtures/assets/ProjectSprouts.png")]
		private var sproutsLogo:Class;
		
		private var image:Image;

		public function ImageTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			image = new Image();
			addChild(image.view);
		}

		override protected function tearDown():void {
			super.tearDown();
			removeChild(image.view);
			image = null;
		}

		public function testEmbeddedBitmapAsset():void {
			var clazz:Class = sproutsLogo;
			image.source = new clazz();
		}
		
		public function testClassName():void {
			image.source = sproutsLogo;
		}
		
		public function testUrl():void {
			var handler:Function = function(event:PayloadEvent):void {
				assertEquals(205, image.width);
				assertEquals(104, image.height);
			}
			image.addEventListener(PayloadEvent.LOADING_COMPLETED, addAsync(handler));
			image.source = 'images/ProjectSprouts.png';
		}
	}
}