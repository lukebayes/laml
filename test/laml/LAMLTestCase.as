package laml {
	import asunit.errors.AssertionFailedError;
	import asunit.framework.TestCase;
	
	import flash.events.Event;
	
	import laml.display.Layoutable;

	public class LAMLTestCase extends TestCase {
		
		public function LAMLTestCase(methodName:String=null) {
			super(methodName)
		}
		
		protected function assertRectangle(layoutable:Layoutable, x:Number=NaN, y:Number=NaN, width:Number=NaN, height:Number=NaN):void {
			assertPosition(layoutable, x, y);
			assertDimensions(layoutable, width, height);
		}
		
		protected function assertPosition(layoutable:Layoutable, x:Number=NaN, y:Number=NaN):void {
			if(isNaN(x) && isNaN(y)) {
				throw new AssertionFailedError('assertPosition called with no expected values');
			}
			if(!isNaN(x)) {
				assertEquals('Unexpected x for ' + layoutable, x, layoutable.x);
			}
			if(!isNaN(y)) {
				assertEquals('Unexpected y for ' + layoutable, y, layoutable.y);
			}
		}

		protected function assertDimensions(layoutable:Layoutable, width:Number=NaN, height:Number=NaN):void {
			if(isNaN(width) && isNaN(height)) {
				throw new AssertionFailedError('assertDimensions called with no expected values');
			}
			if(!isNaN(width)) {
				assertEquals('Unexpected width for ' + layoutable, width, layoutable.width);
			}
			if(!isNaN(height)) {
				assertEquals('Unexpected height for ' + layoutable, height, layoutable.height);
			}
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
	}
}