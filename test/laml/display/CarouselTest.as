package laml.display {

	import laml.LAMLTestCase;
	import laml.collections.ISelectableList;
	import laml.collections.SelectableList;
	import laml.tween.TweenLiteAdapter;

	public class CarouselTest extends LAMLTestCase {
		private var carousel:Carousel;

		public function CarouselTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			carousel = new Carousel();
			carousel.width = 400;
			carousel.height = 200;
			carousel.x = 300;
			carousel.y = 20;
			addChild(carousel.view);
			listenToStage(carousel);
		}

		override protected function tearDown():void {
			super.tearDown();
			removeChild(carousel.view);
			carousel = null;
		}

		public function testInstantiated():void {
			assertTrue("carousel is Carousel", carousel is Carousel);
		}
		
		private function getDataProviderItem(name:String):Object {
			return {
				name: name
			}
		}

		public function testSetDataProvider():void {
			var collection:ISelectableList = new SelectableList();
			collection.addItem(getDataProviderItem('one'));
			collection.addItem(getDataProviderItem('two'));
			collection.addItem(getDataProviderItem('three'));
			collection.addItem(getDataProviderItem('four'));
			collection.addItem(getDataProviderItem('five'));
			collection.addItem(getDataProviderItem('six'));
	
			carousel.dataProvider = collection;
			carousel.tweenAdapter = new TweenLiteAdapter();
		}
	}
}