package laml.display {
	import asunit.framework.TestCase;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class LabelTest extends TestCase {
		private var label:Label;

		public function LabelTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			label = new Label();
			label.backgroundColor = 0xCCCCCC;
			label.width = 100;
			label.height = 40;
			label.x = 40;
			label.y = 40;
			addChild(label.view);
		}
		
		override protected function tearDown():void {
			super.tearDown();
			removeChild(label.view);
			label = null;
		}

		public function testLabel():void {
			label.text = "Hello World";
			label.textFormat = getTextFormat();
			label.render();
//			assertEquals('Episode display object was attached', 1, video.view.numChildren);
		}

		public function testSelectableLabel():void {
			label.text = "Selectable";
			label.selectable = true;
			label.textFormat = getTextFormat();
			label.render();
//			assertEquals('Episode display object was attached', 1, video.view.numChildren);
		}
		
		protected function getTextFormat():TextFormat {
			var tf:TextFormat = new TextFormat();
			tf.align = TextFormatAlign.RIGHT;
			tf.color = 0xFF0000;
			tf.size = 24;
			return tf;
		}
	}
}
