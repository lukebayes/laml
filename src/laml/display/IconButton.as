package laml.display {
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import laml.xml.LAMLParser;
	
	public class IconButton extends Button {
		private var ICON:String = "icon_button_icon";		
		private var LABEL:String = "icon_button_label";		
		
		private var iconComponent:Component;
		private var label:Label;
		
		public function IconButton() {
			super();
		}
		
		override protected function initialize():void {
			super.initialize();
			model.validate_icon = validateIcon;
			model.validate_text = validateText;
			model.validate_textFormat = validateTextFormat;
			model.validate_selectable = validateSelectable;
			model.validate_embedFonts = validateEmbedFonts;
			text = "";
		}

		override protected function createChildren():void {
			super.createChildren();
			var parser:LAMLParser = new LAMLParser();
			var parsedXml:Component = parser.parseLayoutable(configXml, skin) as Component;
			addChild(parsedXml);
			configureChildren();
		}
		
		protected function configureChildren():void {
			iconComponent = getChildById(ICON) as Component;

			label = getChildById(LABEL) as Label;
			label.border = true;
		}

		override protected function mouseClickHandler(event:MouseEvent):void {
			super.mouseClickHandler(event);
		}

		override protected function mouseEventHandler(event:MouseEvent):void {
			super.mouseEventHandler(event);
		}
		
		public function set icon(icon:String):void {
			model.icon = icon;
		}
		
		public function get icon():String {
			return model.icon;
		}
		
		protected function validateIcon(newValue:*, oldValue:*):void {
			trace(">> IconButton.validatIcon :: " + newValue + ", " + oldValue);
//			iconComponent.backgroundImage = getBitmapByName(newValue);
		}
		
		public function set text(text:String):void {
			model.text = text;
		}
		
		public function get text():String {
			return label.text;
		}
		
		protected function validateText(newValue:*, oldValue:*):void {
			label.text = newValue;
		}
		
		public function set textFormat(textFormat:TextFormat):void {
			model.textFormat = textFormat;
		}
		
		public function get textFormat():TextFormat {
			return label.textFormat;
		}
		
		protected function validateTextFormat(newValue:*, oldValue:*):void {
			label.textFormat = newValue;
		}

		public function set selectable(selectable:Boolean):void {
			model.selectable = selectable;
		}

		public function get selectable():Boolean {
			return label.selectable;
		}
		
		protected function validateSelectable(newValue:*, oldValue:*):void {
			label.selectable = newValue;
		}
		
		
		public function set embedFonts(embedFonts:Boolean):void {
			model.embedFonts = embedFonts;
		}
		
		public function get embedFonts():Boolean {
			return label.embedFonts;
		}
		
		protected function validateEmbedFonts(newValue:*, oldValue:*):void {
			label.embedFonts = newValue;
		}			

		protected function get configXml():XML {
			var xml:XML = <HBox width="100%" height="100%" xmlns="laml.display">
							<VBox width="24" height="100%" verticalAlign="center">
								<Component id={ICON} width="24" height="24" backgroundColor="#CCCCCC"></Component>
							</VBox>
							<Label id={LABEL} width="100%" height="100%"></Label>
						</HBox>;
			return xml;
		}
	}
}