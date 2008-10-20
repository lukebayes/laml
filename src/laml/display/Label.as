package laml.display{
	import flash.display.BlendMode;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Label extends Component {
		private var _textView:TextField;

		public function Label() {
		}
		
		override protected function initialize():void {
			super.initialize();
			model.validate_border = validateBorder;
			model.validate_embedFonts = validateEmbedFonts;
			model.validate_selectable = validateSelectable;
//			model.validate_selectionColor = validateSelectionColor;
			model.validate_textFormat = validateTextFormat;
			verticalAlign = ALIGN_CENTER;
			text = "";
		}
		
		override protected function createChildren():void {
			super.createChildren();
			textView = createTextView();
			textFormat = createTextFormat();
		}
		
		protected function createTextView():TextField {
			var tf:TextField = new TextField();
			tf.type = TextFieldType.DYNAMIC;
			tf.wordWrap = true;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.blendMode = BlendMode.LAYER;
			
			return tf;
		}

		protected function createTextFormat():TextFormat {
			var tf:TextFormat = getTextFormat();
			if(!tf.align) {
				tf.align = TextFormatAlign.CENTER;
			}
			
			return tf;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);
			textView.text = text;
			textView.width = w;
			
			var magic:Number = 1;
			var yPosition:Number = Math.round(Math.max((h - textView.textHeight)/2, 0)) - magic;

			if(verticalAlign == ALIGN_TOP) {
				yPosition = magic;
			}
			else if(verticalAlign == ALIGN_BOTTOM) {
				yPosition = h - textView.textHeight - magic;
			}
			
			textView.height = h - yPosition + magic;
			textView.y = yPosition;
		}
		
		public function set text(text:String):void {
			model.text = text;
		}
		
		public function get text():String {
			return model.text;
		}
		
		public function set textFormat(textFormat:TextFormat):void {
			model.textFormat = textFormat;
		}
		
		public function get textFormat():TextFormat {
			return model.textFormat;
		}
		
		protected function validateTextFormat(newValue:*, oldValue:*):void {
			textView.defaultTextFormat = newValue;
		}
		
		public function set selectable(selectable:Boolean):void {
			model.selectable = selectable;
		}

		public function get selectable():Boolean {
			return model.selectable;
		}

		protected function validateSelectable(newValue:*, oldValue:*):void {
			textView.selectable = newValue;
			textView.mouseEnabled = newValue;
		}

		public function setSelection(beginningIndex:Number, endIndex:Number):void {
			if(selectable) {
				textView.setSelection(beginningIndex, endIndex);
			}
		}		
		
		
//		public function set selectionColor(color:Number):void {
//			model.selectionColor = color;
//		}
//		
//		public function get selectionColor():Number {
//			return model.selectionColor;
//		}
//		
//		protected function validateSelectionColor(newValue:*, oldValue:*):void {
//			trace(">> validate selection color");
//		}
		
		public function set embedFonts(embedFonts:Boolean):void {
			model.embedFonts = embedFonts;
		}
		
		public function get embedFonts():Boolean {
			return model.embedFonts;
		}
		
		protected function validateEmbedFonts(newValue:*, oldValue:*):void {
			textView.embedFonts = newValue;
		}
		
		public function set border(border:Boolean):void {
			model.border = border;
		}
		
		public function get border():Boolean {
			return model.border;
		}
		
		protected function validateBorder(newValue:*, oldValue:*):void {
			textView.border = border;
		}
		
		public function set textView(textField:TextField):void {
			if(_textView && view.contains(_textView)) {
				view.removeChild(_textView);
			}
			_textView = view.addChild(textField) as TextField;
		}
		
		public function get textView():TextField {
			return _textView;
		}
	}
}
