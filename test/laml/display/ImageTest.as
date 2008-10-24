package laml.display {

	import asunit.framework.TestCase;
	
	import flash.utils.setTimeout;
	
	import laml.events.PayloadEvent;

	public class ImageTest extends TestCase {
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
				assertEquals(205, image.width);
				assertEquals(104, image.height);
			}
			
			var updateSource:Function = function():void {
				image.source = imageUrl;
			}
			
			image.addEventListener(PayloadEvent.LOADING_COMPLETED, addAsync(completed));
			setTimeout(updateSource, 100);
		}
		
		public function testUrl():void {
			var completed:Function = function(event:PayloadEvent):void {
				assertEquals(205, image.width);
				assertEquals(104, image.height);
			}
			image.addEventListener(PayloadEvent.LOADING_COMPLETED, addAsync(completed));
			image.source = imageUrl;
		}
	}
}