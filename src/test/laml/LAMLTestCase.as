package laml {
	import asunit.framework.TestCase;
	
	import flash.events.Event;
	
	import laml.display.Layoutable;

	public class LAMLTestCase extends TestCase {
		
		public function LAMLTestCase(methodName:String=null) {
			super(methodName)
		}
		
		protected function listenToStage(subscriber:Layoutable):void {
			getContext().stage.addEventListener(Event.RESIZE, function(event:Event):void {
				subscriber.width = getContext().stage.stageWidth - 10;
				subscriber.height = getContext().stage.stageHeight - 15;
				subscriber.x = 5;
				subscriber.y = 5;
				subscriber.render();
			});
		}
		
		protected function assertRectangle(child:Layoutable, x:int, y:int, w:int, h:int):void {
			assertEquals(child.name + ' x', x, child.x);
			assertEquals(child.name + ' y', y, child.y);
			assertEquals(child.name + ' w', w, child.width);
			assertEquals(child.name + ' h', h, child.height);
		}
	}
}