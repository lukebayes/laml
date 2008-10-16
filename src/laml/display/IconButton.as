package laml.display {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;
	
	import laml.xml.LAMLParser;
	
	public class IconButton extends Button {
		private var classId:String = generateId();
		private var ICON:String = classId + "_icon_button_icon";
		private var LABEL:String = classId + "_icon_button_label";		
		private var ICON_CONTAINER:String = classId + "icon_container";
		private var UP_BG_COLOR:Number = 0x2F2F2F;
		private var OVER_BG_COLOR:Number = 0x444444;
		
		private var iconComponent:Image;
		private var iconContainer:Component;
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
			textFormat = getTextFormat();
		}
		
		override protected function createStates():void {
			var size:Point = new Point(width, height);
			upState = new IconButtonDisplayState(UP_BG_COLOR, size, cornerRadius);
			downState = new IconButtonDisplayState(OVER_BG_COLOR, size, cornerRadius);
		}
		
		protected function configureChildren():void {
			iconComponent = getChildById(ICON) as Image;
			label = getChildById(LABEL) as Label;

			iconContainer = getChildById(ICON_CONTAINER) as Component;
			// TODO: not accessing the view directly results in not taking the
			// children's size into consideration - maybe a missed invalidate call?
			iconContainer.view.mouseEnabled = false;
			iconContainer.view.mouseChildren = false;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);
			iconComponent.x = iconContainer.paddingLeft;			
			iconComponent.y = (h - iconComponent.height) / 2;

			var labelOffset:Number = (iconComponent.x * 2) + iconComponent.width; 
			label.x = labelOffset;
			label.width = w - labelOffset;
		}
		
		override protected function updateSize(w:Number, h:Number):void {
			var size:Point = new Point(w, h);
			buttonView.upState = new IconButtonDisplayState(UP_BG_COLOR, size, cornerRadius);
			buttonView.overState = new IconButtonDisplayState(OVER_BG_COLOR, size, cornerRadius);
			buttonView.downState = new IconButtonDisplayState(OVER_BG_COLOR, size, cornerRadius);
			buttonView.hitTestState = new IconButtonDisplayState(UP_BG_COLOR, size, cornerRadius);
		}

		override protected function mouseClickHandler(event:MouseEvent):void {
			if(url) {
				navigateToURL(new URLRequest(url));
			} 
			super.mouseClickHandler(event);
		}
		
		public function set icon(icon:String):void {
			model.icon = icon;
		}
		
		public function get icon():String {
			return model.icon;
		}
		
		public function set url(url:String):void {
			model.url = url;
		}
		
		public function get url():String {
			return model.url;
		}
		
		protected function validateIcon(newValue:*, oldValue:*):void {
			iconComponent.source = getBitmapByName(newValue) as Bitmap;
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
			var xml:XML = <HBox id={ICON_CONTAINER} width="100%" height="100%" padding="3" xmlns="laml.display">
							<Image id={ICON} preferredWidth="1" preferredHeight="1" backgroundColor="#CCCCCC"></Image>
							<Label id={LABEL} width="100%" height="100%"></Label>
						</HBox>;
			return xml;
		}
	}
}

import flash.display.Shape;
import flash.geom.Point;	

class IconButtonDisplayState extends Shape {
    private var bgColor:uint;
    private var size:Point;
    private var radius:Number;

    public function IconButtonDisplayState(bgColor:uint, size:Point, radius:uint) {
        this.bgColor = bgColor;
        this.size    = size;
        this.radius  = radius;
        draw();
    }

    private function draw():void {
        graphics.beginFill(bgColor);
 		graphics.drawRoundRect(0, 0, size.x, size.y, radius);
        graphics.endFill();
    }
}