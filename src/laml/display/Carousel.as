package laml.display {
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import laml.collections.ISelectableList;
	import laml.collections.SelectableList;
	import laml.events.PayloadEvent;
	import laml.xml.LAMLParser;
	
	public class Carousel extends Component {
		private static const CONTENT_CONTAINER:String 		= 'content-container';
		private static const CONTENT_MASK:String 			= 'content-mask';
		private static const DEFAULT_HORIZONTAL_GUTTER:int 	= 5;
		private static const DEFAULT_PADDING:int 			= 5;
		private static const DEFAULT_VISIBLE_ITEM_COUNT:int = 4;
		private static const LEFT_BUTTON:String 			= 'left-button';
		private static const RIGHT_BUTTON:String			= 'right-button';
		
		private var contentContainer:Layoutable;
		private var contentMask:Layoutable;
		private var defaultItemRenderer:String;
		private var leftButton:Layoutable;
		private var rightButton:Layoutable;
		
		override protected function initialize():void {
			super.initialize();
			dataProvider = new SelectableList();
			horizontalGutter = DEFAULT_HORIZONTAL_GUTTER;
			padding = DEFAULT_PADDING;
			itemRenderer = "<IconButton width='100%' height='100%' text='{title}' />";
			model.validate_dataProvider = validateDataProvider;
		}
		
		public function set visibleItemCount(count:int):void {
			model.visibleItemCount = count;
		}
		
		public function get visibleItemCount():int {
			return model.visibleItemCount || DEFAULT_VISIBLE_ITEM_COUNT;
		}

		public function set textFormat(textFormat:TextFormat):void {
			model.textFormat = textFormat;
		}
		
		public function get textFormat():TextFormat {
			return model.textFormat as TextFormat;
		}
		
		public function set itemRenderer(itemRenderer:*):void {
			if(itemRenderer is String) {
				model.itemRendererString = itemRenderer;
			}
			else if(itemRenderer is Class) {
				model.itemRendererClass = itemRenderer;
			}
			else {
				model.itemRenderer = itemRenderer;
			}
		}
		
		public function get itemRenderer():* {
			return model.itemRendererString || model.itemRendererClass || model.itemRenderer || defaultItemRenderer;
		}
		
		override public function set dataProvider(dataProvider:ISelectableList):void {
			if(dataProvider == null) {
				dataProvider = new SelectableList();
			}
			super.dataProvider = dataProvider;
		}

		protected function validateDataProvider(newItem:ISelectableList, oldItem:ISelectableList):void {
			if(oldItem) {
				// clear all old views...
				oldItem.removeEventListener(PayloadEvent.SELECTION_CHANGED, selectionChangedHandler);
				contentContainer.removeAllChildren();
			}
			
			var parser:LAMLParser = new LAMLParser();
			newItem.forEach(function(item:Object, index:int, items:Array):void {
				createItemView(item, parser);
			});
			
			newItem.addEventListener(PayloadEvent.SELECTION_CHANGED, selectionChangedHandler);
			
			if(newItem.selectedIndex == -1 && newItem.length > 0) {
				newItem.selectedIndex = 0;
			}
				
			updateSelection();
		}
		
		protected function createItemView(data:Object, parser:LAMLParser):void {
			var itemView:Layoutable;
			if(model.itemRendererClass) {
				itemView = new model.itemRendererClass();
				itemView.data = data;
			}
			else if(model.itemRendererString) {
				var itemXml:XML = new XML(model.itemRendererString);
				itemView = parser.parseLayoutable(itemXml, data);
			}
			else {
				trace(">> WARNING itemRenderer set with unknown type");
			}

			itemView.addEventListener(PayloadEvent.CHANGED, itemChangedHandler, false, 0, true);
			contentContainer.addChild(itemView);
		}
		
		protected function itemChangedHandler(event:PayloadEvent):void {
			dispatchEvent(event);
		}

		override protected function createChildren():void {
			super.createChildren();
			var parser:LAMLParser = new LAMLParser();
			var parsedXml:Component = parser.parseLayoutable(configXml, skin) as Component;
			addChild(parsedXml);
			textFormat = getTextFormat();
			
			leftButton = getChildById(LEFT_BUTTON);
			rightButton = getChildById(RIGHT_BUTTON);
			
			configureChildren();
		}
		
		protected function configureChildren():void {
			contentMask = getChildById(CONTENT_MASK);
			contentContainer = getChildById(CONTENT_CONTAINER);
			
			leftButton.addEventListener(MouseEvent.CLICK, leftButtonClickHandler);
			rightButton.addEventListener(MouseEvent.CLICK, rightButtonClickHandler);
		}
		
		private function leftButtonClickHandler(event:MouseEvent):void {
			dataProvider.selectPrevious();
		}
		
		private function rightButtonClickHandler(event:MouseEvent):void {
			dataProvider.selectNext();
		}
		
		private function selectionChangedHandler(event:PayloadEvent):void {
			updateSelection();
		}
		
		private function updateSelection():void {
			leftButton.enabled = leftButtonIsEnabled();
			rightButton.enabled = rightButtonIsEnabled();
			
			contentContainer.animate({x:getContainerPosition()}, 300, null);
		}
		
		private function leftButtonIsEnabled():Boolean {
			 return !(dataProvider.firstItem == dataProvider.selectedItem || dataProvider.selectedIndex == -1);
		}
		
		private function rightButtonIsEnabled():Boolean {
			if(dataProvider.length > visibleItemCount) {
				var limit:Number = dataProvider.length - visibleItemCount - 1;
				if(dataProvider.selectedIndex > limit) {
					return false;
				}
			}
			 return !(dataProvider.lastItem == dataProvider.selectedItem);
		}
		
		private function getContainerPosition():Number {
			var displayedIndex:int = dataProvider.selectedIndex;
			
			if(dataProvider.length > visibleItemCount) {
				displayedIndex = Math.min(displayedIndex, dataProvider.length - visibleItemCount);
			}

			return -((displayedIndex * getItemSize(contentMask.width)) + (horizontalGutter * dataProvider.selectedIndex));
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);
			var childSize:Number = getItemSize(contentMask.width);
			contentContainer.forEach(function(child:Layoutable, index:int, children:Array):void {
				child.width = childSize;
				child.height = h - (verticalPadding * 3);
			});

			contentContainer.x = getContainerPosition();
			contentContainer.invalidateDisplayList();
			contentContainer.render();

			if(!contentContainer.mask) {
				contentContainer.view.mask = contentMask.view;
				contentContainer.view.cacheAsBitmap = true;
			}
		}
		
		private function getItemSize(w:Number):Number {
			var negativeSpace:Number = paddingLeft + (contentContainer.horizontalGutter * visibleItemCount);
			var available:Number = w - negativeSpace;
			return available / Math.min(visibleItemCount, dataProvider.length);
		}
		
		protected function get configXml():XML {
			var xml:XML = <HBox width="100%" height="100%" horizontalGutter={horizontalGutter} padding={padding} xmlns="laml.display">
							<CarouselPreviousButton id={LEFT_BUTTON} width="15" height="65" />
							<Component width="100%" height="100%">
								<Row id={CONTENT_CONTAINER} excludeFromLayout="true" horizontalGutter={horizontalGutter} padding={padding} />
								<Component id={CONTENT_MASK} backgroundColor="#0000ff" width="100%" height="100%" />
							</Component>
							<CarouselNextButton id={RIGHT_BUTTON} width="15" height="65" />
						  </HBox>
			return xml;
		}
		
		override public function get root():Layoutable {
			return this;
		}
	}
}
