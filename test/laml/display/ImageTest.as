package laml.display {

	import asunit.framework.TestCase;
	
	import flash.display.DisplayObject;
	import flash.utils.setTimeout;
	
	import laml.events.PayloadEvent;

	public class ImageTest extends TestCase {
		
		private var logoWidth:Number = 202;
		private var logoHeight:Number = 102;

		private var largeImageSource:String = '../test/fixtures/assets/LargeSquare.png';

		// Relative url from this SOURCE file:
		[Embed(source="../../fixtures/assets/ProjectSprouts.png")]
		private var sproutsLogo:Class;

		// Relative url from SWF:
		private var imageUrl:String = '../test/fixtures/assets/ProjectSprouts.png';

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
		
		public function testSourceChanged():void {
			image.preferredWidth = 300;
			image.preferredHeight = 200;
			image.x = 300;
			image.y = 20;
			image.backgroundColor = 0xFFCC00;
			
			var completed:Function = function(event:PayloadEvent):void {
				assertEquals(logoWidth, image.width);
				assertEquals(logoHeight, image.height);
			}
			
			var updateSource:Function = function():void {
				image.source = imageUrl;
			}
			
			image.addEventListener(PayloadEvent.LOADING_COMPLETED, addAsync(completed));
			setTimeout(updateSource, 100);
		}
		
		public function testUrl():void {
			var completed:Function = function(event:PayloadEvent):void {
				assertEquals(logoWidth, image.width);
				assertEquals(logoHeight, image.height);
			}
			image.addEventListener(PayloadEvent.LOADING_COMPLETED, addAsync(completed));
			image.source = imageUrl;
		}
		
		public function testMaintainAspectRatio():void {
			image.preferredWidth = 300;
			image.preferredHeight = 200;
			image.x = 300;
			image.y = 20;
			image.width = 500;
			image.height = 450;
			image.padding = 5;
			image.backgroundColor = 0xFFCC00;
			image.source = sproutsLogo;
			image.maintainAspectRatio = true;
			image.render();
			
			var loaded:DisplayObject = image.view.getChildAt(0);
			assertEquals(490, loaded.width);
			assertEquals(247, loaded.height);
		}
		
		public function testLargeImage():void {
			image.backgroundColor = 0xffcc00;
			image.maintainAspectRatio = true;
			image.padding = 10;
			image.width = 450;
			image.height = 280;
			image.render();
			
			var complete:Function = function(event:PayloadEvent):void {
				var child:DisplayObject = image.view.getChildAt(0);
				// Image maintained it's aspect ratio - even after a load operation:
				assertEquals(272, child.width);
				assertEquals(260, child.height);
			}
			
			image.addEventListener(PayloadEvent.LOADING_COMPLETED, addAsync(complete));
			image.source = largeImageSource;
		}
	}
}