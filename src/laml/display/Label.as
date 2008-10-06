package laml.display{
	import flash.display.BlendMode;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
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
			model.validate_textFormat = validateTextFormat;
			model.validate_selectable = validateSelectable;
			text = "";
		}
		
		override protected function createChildren():void {
			super.createChildren();
			createTextView();
			createTextFormat();
		}
		
		protected function createTextView():void {
			var tf:TextField = new TextField();
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.gridFitType = GridFitType.PIXEL;
			tf.type = TextFieldType.DYNAMIC;
			tf.wordWrap = true;
			tf.sharpness = 200;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.blendMode = BlendMode.LAYER;
			textView = tf;
		}

		protected function createTextFormat():void {
			var tf:TextFormat = getTextFormat();
			if(!tf.align) {
				tf.align = TextFormatAlign.CENTER;
			}
			textFormat = tf;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);
			textView.text = text;

			var yPosition:Number = Math.round(Math.max((h - textView.textHeight)/2, 0));
			textView.width = w;
			textView.height = h - yPosition;
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
