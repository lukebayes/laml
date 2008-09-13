package laml {
	import flash.events.EventDispatcher;
	
	public class Layoutable {
		public static const ALIGN_BOTTOM			= "bottom";
		public static const ALIGN_CENTER			= "center";
		public static const ALIGN_LEFT				= "left";
		public static const ALIGN_RIGHT				= "right";
		public static const ALIGN_TOP				= "top";

		public var id;
		public var maxWidth;
		public var maxHeight;
		public var measuredHeight:int;
		public var measuredWidth:int;
		public var percentHeight;
		public var percentWidth;
		public var paddingBottom:int;
		public var paddingLeft:int;
		public var paddingRight:int;
		public var paddingTop:int;
		public var parent;
		public var x:int;
		public var y:int;

		protected var _actualHeight:int;
		protected var _actualWidth:int;
		protected var _horizontalAlign = ALIGN_LEFT;
		protected var _height:int;
		protected var _layout;
		protected var _minWidth:int;
		protected var _minHeight:int;
		protected var _verticalAlign = ALIGN_TOP;
		protected var _width:int;
		protected var _view;
		
		public function Layoutable() {
			initialize();
		}
		
		protected function initialize() {
			layout = new BoxLayout();
			dispatcher = new EventDispatcher();
			_view = createView();
		}
		
		public function draw() {
			if(!view.parent) {
				parent.view.addChild(view);
			}
			layout.draw();
			view.draw();
		}

		public function get view() {
			return _view;
		}
		
		protected function createView() {
			return new ComponentView(this);
		}

		public function addEventListener(type, listener, useCapture=false, priority=0, useWeakReference=false) {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type, listener, useCapture=false) {
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event) {
			return dispatcher.dispatchEvent(event);
		}

		public function set actualWidth(width) {
			_actualWidth = Math.max(minWidth, width);
			if(maxWidth) {
				_actualWidth = Math.min(maxWidth, width);
			}
		}
		
		public function get actualWidth() {
			return _actualWidth;
		}
		
		public function set actualHeight(height) {
			_actualHeight = Math.max(minHeight, height);
			if(maxHeight) {
				_actualHeight = Math.min(maxHeight, height);
			}
		}
		
		public function get actualHeight() {
			return _actualHeight;
		}
		
		public function set minWidth(min) {
			_minWidth = min;
			if(actualWidth < min) {
				actualWidth = min;
			}
		}
		
		public function get minWidth() {
			return _minWidth;
		}
		
		public function set minHeight(min) {
			_minHeight = min;
			if(actualHeight < min) {
				actualHeight = min;
			}
		}
		
		public function get minHeight() {
			return _minHeight;
		}
		
		public function set width(width) {
			percentWidth = NaN;
			actualWidth = width;
		}
		
		public function get width() {
			return actualWidth;
		}
		
		public function set height(height) {
			percentHeight = NaN;
			actualHeight = height;
		}
		
		public function get height() {
			return actualHeight;
		}
		
		public function set horizontalAlign(align) {
			if(align != ALIGN_LEFT && align != ALIGN_CENTER && align != ALIGN_RIGHT) {
				throw new ArgumentError("Component.horizontalAlign received unexpected value: " + align);
			}
			_horizontalAlign = align;
		}
		
		public function get horizontalAlign() {
			return _horizontalAlign;
		}
		
		public function set verticalAlign(align) {
			if(align != ALIGN_TOP && align != ALIGN_CENTER && align != ALIGN_BOTTOM) {
				throw new ArgumentError("Component.verticalAlign received unexpected value: " + align);
			}
			_verticalAlign = align;
		}
		
		public function get verticalAlign() {
			return _verticalAlign;
		}
		
		public function set layout(layout) {
			_layout = layout;
			_layout.component = this;
		}
		
		public function get layout() {
			return _layout;
		}

		public function set padding(padding) {
			paddingBottom 	= padding;
			paddingLeft 	= padding;
			paddingRight 	= padding;
			paddingTop 		= padding;
		}
		
		public function set horizontalPadding(padding) {
			paddingLeft 	= padding;
			paddingRight 	= padding;
		}
		
		public function get horizontalPadding() {
			return paddingLeft + paddingRight;
		}
		
		public function set verticalPadding(padding) {
			paddingBottom 	= padding;
			paddingTop 		= padding;
		}
		
		public function get verticalPadding() {
			return paddingBottom + paddingTop;
		}
		
		public function get padding() {
			return (paddingBottom || paddingLeft || paddingRight || paddingTop);
		}
	}
}