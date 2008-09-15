package laml.layout {

	import laml.LAMLTestCase;
	import laml.display.Component;
	import laml.display.Layoutable;
	import laml.xml.LAMLParser;

	public class StackLayoutTest extends LAMLTestCase {
		private var box:Layoutable;
		private var parser:LAMLParser;

		public function StackLayoutTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			parser = new LAMLParser();
		}
		
		override protected function tearDown():void {
			super.tearDown();
			parser = null;
			if(box && box.view.parent) {
				removeChild(box.view);
			}
			box = null;
		}
		
		protected function getStaticHBox(hAlign:String):XML {
			var xml:XML = <HBox id="root" xmlns="laml.display" padding="5" horizontalAlign={hAlign} horizontalGutter="5" backgroundColor="#FF00FF" width="600" height="300">
				<Component id="child1" width="200" percentHeight="1" backgroundColor="#FF0000" />
				<Component id="child2" width="150" percentHeight="1" backgroundColor="#FFFF00" />
				<Component id="child3" width="100" percentHeight="1" backgroundColor="#0000FF" />
			</HBox>;
			return xml;
		}

		protected function getFlexibleHBox():XML {
			var xml:XML = <HBox id="root" xmlns="laml.display" padding="5" horizontalGutter="5" backgroundColor="#FF00FF" width="600" height="300">
				<Component id="child1" percentWidth="100" percentHeight="1" backgroundColor="#FF0000" />
				<Component id="child2" width="200" height="180" backgroundColor="#FFFF00" />
				<Component id="child3" percentWidth="100" height="100%" backgroundColor="#0000FF" />
			</HBox>;
			return xml;
		}
		
		protected function getStaticChildrenVBox(hAlign:String):XML {
			var xml:XML = <VBox id="root" xmlns="laml.display" padding="5" verticalAlign={hAlign} verticalGutter="5" backgroundColor="#FF00FF" width="600" height="300">
				<Component id="child1" percentWidth="1" height="100" backgroundColor="#FF0000" />
				<Component id="child2" width="150" height="90" backgroundColor="#FFFF00" />
				<Component id="child3" width="100" height="60" backgroundColor="#0000FF" />
			</VBox>;
			return xml;
		}

		protected function getFlexibleChildrenVBox():XML {
			var xml:XML = <VBox id="root" width="600" height="300" xmlns="laml.display" padding="5" verticalGutter="5" backgroundColor="#FF00FF">
				<Component id="child1" width="100%" height="100%" backgroundColor="#FF0000" />
				<Component id="child2" width="200" height="140" backgroundColor="#FFFF00" />
				<Component id="child3" width="100%" height="50%" backgroundColor="#0000FF" />
			</VBox>;
			return xml;
		}
		
		public function testStaticChildrenAlignLeftHorizontal():void {
			box = parser.parseLayoutable(getStaticHBox(Component.ALIGN_LEFT));
			//addChild(box.view);
			box.render();
			//listenToStage(box);
			
			var child:Layoutable = box.getChildAt(0);
			assertRectangle(child, 5, 5, 200, 290);
			child = box.getChildAt(1);
			assertRectangle(child, 210, 5, 150, 290);
			child = box.getChildAt(2);
			assertRectangle(child, 365, 5, 100, 290);
		}
		
		public function testStaticChildrenAlignRightHorizontal():void {
			box = parser.parseLayoutable(getStaticHBox(Component.ALIGN_RIGHT));
			//addChild(box.view);
			box.render();
			//listenToStage(box);
			
			var child:Layoutable = box.getChildAt(0);
			assertRectangle(child, 135, 5, 200, 290);
			child = box.getChildAt(1);
			assertRectangle(child, 340, 5, 150, 290);
			child = box.getChildAt(2);
			assertRectangle(child, 495, 5, 100, 290);
		}
		
		public function testFlexibleChildrenHorizontal():void {
			box = parser.parseLayoutable(getFlexibleHBox());
			//addChild(box.view);
			box.render();
			//listenToStage(box);
			
			var child:Layoutable = box.getChildAt(0);
			assertRectangle(child, 5, 5, 190, 290);
			child = box.getChildAt(1);
			assertRectangle(child, 200, 5, 200, 180);
			child = box.getChildAt(2);
			assertRectangle(child, 405, 5, 190, 290);
			
		}
		
		public function testStaticChildrenAlignTopVertical():void {
			box = parser.parseLayoutable(getStaticChildrenVBox(Component.ALIGN_TOP));
			//addChild(box.view);
			box.render();
			//listenToStage(box);
			
			var child:Layoutable = box.getChildAt(0);
			assertRectangle(child, 5, 5, 590, 100);
			child = box.getChildAt(1);
			assertRectangle(child, 5, 110, 150, 90);
			child = box.getChildAt(2);
			assertRectangle(child, 5, 205, 100, 60);
		}

		public function testStaticChildrenAlignBottomVertical():void {
			box = parser.parseLayoutable(getStaticChildrenVBox(Component.ALIGN_BOTTOM));
			//addChild(box.view);
			box.render();
			//listenToStage(box);
			
			var child:Layoutable = box.getChildAt(0);
			assertRectangle(child, 5, 35, 590, 100);
			child = box.getChildAt(1);
			assertRectangle(child, 5, 140, 150, 90);
			child = box.getChildAt(2);
			assertRectangle(child, 5, 235, 100, 60);
		}

		public function testFlexibleChildrenVertical():void {
			box = parser.parseLayoutable(getFlexibleChildrenVBox());
			//addChild(box.view);
			box.render();
			//listenToStage(box);
			
			var child:Layoutable = box.getChildAt(0);
			assertRectangle(child, 5, 5, 590, 93);
			child = box.getChildAt(1);
			assertRectangle(child, 5, 103, 200, 140);
			child = box.getChildAt(2);
			assertRectangle(child, 5, 248, 590, 46);
		}

		public function testNestedLayout():void {
			var container:Component;
			var xml:XML = <VBox id="player" verticalAlign="bottom" x="200" width="640" verticalGutter="10" height="480" padding="10" backgroundColor="#FFFFFF" xmlns="laml.display">
							<Component id="video_container" width="100%" height="100%" backgroundColor="#FFCC00" />
							<VBox width="100%" height="57" backgroundColor="#333333" />
						  </VBox>;

			box = parser.parseLayoutable(xml);
			//addChild(box.view);
			box.render();
			//listenToStage(box);

			var child:Layoutable = box.getChildAt(0);
			assertRectangle(child, 10, 10, 620, 393);
			child = box.getChildAt(1);
			assertRectangle(child, 10, 413, 620, 57);
		}

		public function testNestedComplexLayout():void {
			var container:Component;
			var xml:XML = <Component id="player" verticalAlign="bottom" x="200" width="640" verticalGutter="10" height="480" padding="10" backgroundColor="#FFFFFF" xmlns="laml.display">
							<Component id="video_container" width="100%" height="100%" backgroundColor="#33333" />
							<VBox width="100%" height="57">
								<HBox width="100%" height="57" padding="4" backgroundColor="#333333" backgroundAlpha=".5" horizontalGutter="4" verticalAlign="center">
									<Component id="play_pause_button" width="50" height="100%" backgroundColor="#FF0000" />
									<VBox width="100%" height="100%" paddingTop="18">
										<Component id="progress_handle" width="100%" height="10" backgroundColor="#00FF00" />
										<Component id="title" width="99.9%" height="100%" borderSize="0" borderColor="#FF0000" />
									</VBox>
								</HBox>
							</VBox>
						  </Component>;

			box = parser.parseLayoutable(xml);
			//addChild(box.view);
			box.render();
			//listenToStage(box);

			var child:Layoutable = box.getChildAt(0);
			assertRectangle(child, 10, 10, 620, 460);
			child = box.getChildAt(1);
			assertRectangle(child, 10, 413, 620, 57);
		}
	}
}