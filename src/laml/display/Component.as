package laml.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import laml.collections.ISelectableList;
	import laml.collections.SelectableList;
	import laml.events.PayloadEvent;
	import laml.layout.ILayout;
	import laml.layout.StackLayout;
	import laml.tween.DefaultTweenAdapter;
	import laml.tween.ITweenAdapter;
	
	/**
	 * Component is the primary base class for the visual composite structure.
	 * 
	 * Like the Flex IUIComponent, this class has a template method lifecycle.
	 * 
	 * Whenever a subcass of component is instantiated, the following template
	 * methods will be called in the following order.
	 * 
	 * // synchronous - before subclass constructor:
	 * initialize();
	 * createChildren();
	 * // asynchronous, unless render() is manually called:
	 * commitProperties();
	 * updateDisplayList(width:Number, height:Number);
	 * 
	 * Before commitProperties() is called, an attempt will be made to validate
	 * each property that was modified by calling a method on the model named:
	 * 
	 * validate_[name](newValue, oldValue);
	 * 
	 * For example, if the paddingLeft parameter was changed from 20 to 10,
	 * the method called will be:
	 *  
	 * model.validate_paddingLeft(10, 20);
	 * 
	 * You can create that method callback on the DynamicModel from within the
	 * initialize method of your component subclass.
	 * 
	 */
	[Event(name='change', type='PayloadEvent')]
	public class Component implements Layoutable {
		public static const ALIGN_TOP:String 		= 'top';
		public static const ALIGN_CENTER:String 	= 'center';
		public static const ALIGN_BOTTOM:String 	= 'bottom';
		public static const ALIGN_LEFT:String 		= 'left';
		public static const ALIGN_RIGHT:String 		= 'right';
		
		// Global counter to avoid 
		// efault instance id collisions.
		private static var INCR:int;
		
		private var _className:String;
		private var _layout:ILayout;
		private var _model:DynamicModel;
		private var _parent:Layoutable;
		private var _qualifiedClassName:String;
		private var _view:Sprite;
		private var _enabled:Boolean;
		
		private var childrenHash:Dictionary;
		private var childrenCreated:Boolean;

		protected var children:SelectableList;
		
		public function Component() {
			initializeComponent();
			initialize();
		}
		
		private function initializeComponent():void {
			model = new DynamicModel(this);
			model.validate_mouseChildren = validateMouseChildren;
			model.validate_mouseEnabled = validateMouseEnabled;
			model.validate_mask = validateMask;

			children = new SelectableList();
			childrenHash = new Dictionary();
			layout = new StackLayout();

			// initialize component properties
			backgroundAlpha = 1;
			borderAlpha = 1;
			css = '';
			styleNames = '';
			visible = true;
			horizontalAlign = ALIGN_LEFT;
			verticalAlign = ALIGN_TOP;
		}
		
		protected function initialize():void {
		}
		
		protected function createChildren():void {
			view = new Sprite();
			if(backgroundImage) {
				backgroundImage.name = 'background';
				view.addChild(backgroundImage);
			}
		}
		
		protected function addChildViewsToView():void {
			var len:int = numChildren;
			children.forEach(function(child:Layoutable, index:int, children:Array):void {
				if(child.view !== view) {
					view.addChild(child.view);
				}
			});
		}
		
		// Ensure that width and height are not 
		// smaller than the minimums
		private function updateSizeIfNeeded():void {
			if(model.width < inferredMinWidth) {
				width = inferredMinWidth;
			}
			
			if(model.height < inferredMinHeight) {
				height = inferredMinHeight;
			}
		}
		
		protected function createChildrenIfNeeded():void {
			if(!childrenCreated) {
				createChildren();
				addChildViewsToView();
				updateSizeIfNeeded();
				childrenCreated = true;
			}
		}
		
		public function invalidateProperties():void {
			model.invalidateProperties();
			invalidateDisplayList();
		}
		
		/**
		 * Force validation and prevent pending asynchronous update
		 */
		public function validateProperties():void {
			createChildrenIfNeeded();
			if(model.validateProperties()) {
//				model.disabled = true;
				commitProperties();
//				model.disabled = false;
			}
		}
		
		protected function commitProperties():void {
		}
		
		public function invalidateDisplayList():void {
			// invalidate root too!
			if(root !== this) {
				root.invalidateDisplayList();
			}
			// invalidate this control's model
			model.invalidateDisplayList();
		}
		
		public function validateDisplayList():void {
			validateProperties();
			if(model.validateDisplayList()) {
				model.disabled = true;
				layout.render(this);
				updateDisplayList(width, height);

				// TODO: This needs investigated...
				if(parent && !view.parent) {
					parent.view.addChild(view);
				}
				model.disabled = false;
			}
		}
		
		public function render():void {
			validateProperties();
			validateDisplayList();
		}
		
		protected function updateDisplayList(w:Number, h:Number):void {
			if(visible) {
				view.x = x;
				view.y = y;
				drawBackground(w, h);
			}
			view.visible = visible;
		}
		
		protected function drawBackground(w:Number, h:Number):void {
			if(model.backgroundColor != null || model.borderColor != null) {
				view.graphics.clear();
				if(model.backgroundColor != null && backgroundAlpha > 0) {
					view.graphics.beginFill(backgroundColor, backgroundAlpha);
				}
				if(model.borderColor != null) {
					view.graphics.lineStyle(borderSize, borderColor, borderAlpha);
				}
				if(model.cornerRadius != null) {
					view.graphics.drawRoundRect(0, 0, w, h, cornerRadius);
				}
				else {
					view.graphics.drawRect(0, 0, w, h);
				}
				view.graphics.endFill();
			}
			
			if(backgroundImage) {
				backgroundImage.alpha = backgroundAlpha;
				backgroundImage.width = w;
				backgroundImage.height = h;
				backgroundImage.cacheAsBitmap = true;
			}
		}

		public function set layout(layout:ILayout):void {
			_layout = layout;
		}
		
		public function get layout():ILayout {
			return _layout;
		}
		
		public function get length():int {
			throw new IllegalOperationError("get length isn't supported on Component, try numChildren instead");
		}

		public function set model(model:DynamicModel):void {
			_model = model;
		}
		
		public function get model():DynamicModel {
			return _model;
		}
		
		public function set view(view:Sprite):void {
			_view = view;
		}
		
		public function get view():Sprite {
			if(!_view) {
				createChildrenIfNeeded();
			}
			return _view;
		}

		public function set id(id:String):void {
			if(model.id != undefined) {
				throw new IllegalOperationError("Component.id is immutable once it has been set (or requested)");
			}
			model.id = id;
		}
		
		public function get id():String {
			return model.id ||= generateId();
		}
		
		public function set name(name:String):void {
			model.name = name;
		}
		
		public function get name():String {
			return model.name || id;
		}

		public function set dataProvider(dataProvider:ISelectableList):void {
			model.dataProvider = dataProvider;
		}
		
		public function get dataProvider():ISelectableList {
			return model.dataProvider;
		}
		
		public function set data(data:*):void {
			model.data = data;
		}
		
		public function get data():* {
			return model.data;
		}
		
		public function set css(css:String):void {
			model.css = css;
		}
		
		public function get css():String {
			return model.css;
		}
		
		public function bringToTop(child:DisplayObject):void {
			view.setChildIndex(child, view.numChildren - 1);
		}
		
		public function swapChildren(childOne:DisplayObject, childTwo:DisplayObject):void {
			view.swapChildren(childOne, childTwo);
		}

		public function getTextFormat():TextFormat {
			var sheet:StyleSheet = buildStyleSheet();

			var styles:Array = new Array();
			styles.push(getStyleByType(sheet));
			styles = styles.concat(getStylesByStyleNames(sheet));
			styles.push(getStyleById(sheet));
			
			var style:Object = new Object();
			var len:Number = styles.length;
			for(var i:Number = 0; i < len; i++) {
				for(var j:String in styles[i]) {
					style[j] = styles[i][j];
				}
			}

			return sheet.transform(style);
		}

		protected function getStyleByType(sheet:StyleSheet):Object {
			var style:Object = sheet.getStyle(unQualifiedClassName); 
			return style;
		}

		protected function getStylesByStyleNames(sheet:StyleSheet):Array {
			var names:Array = styleNames.split(" ");
			var styles:Array = new Array();
			var len:Number = names.length;
			
			for(var i:Number = 0; i < len; i++) {
				styles.push(sheet.getStyle("." + names[i]));
			}
			
			return styles;
		}
		
		protected function getStyleById(sheet:StyleSheet):Object {
			var style:Object = sheet.getStyle("#" + id); 
			return style;
		}

		public function set styleNames(names:String):void {
			model.styleNames = names;
		}
		
		public function get styleNames():String {
			return model.styleNames;
		}
		
		public function buildStyleSheet(sheet:StyleSheet=null):StyleSheet {
			if(!sheet) {
				var sheet:StyleSheet = new StyleSheet();
			}
			sheet.parseCSS(css);
			
			if(parent) {
				return parent.buildStyleSheet(sheet);
			} 
			else {
				return sheet;
			}
		}

		public function set visible(visible:Boolean):void {
			model.visible = visible;
		}
		
		public function get visible():Boolean {
			return model.visible;
		}
		
		public function set mask(mask:Layoutable):void {
			model.mask = mask;	
		}
		
		public function get mask():Layoutable {
			return model.mask;
		}
		
		public function set mouseChildren(mouseChildren:Boolean):void {
			model.mouseChildren = mouseChildren;
		}
		
		public function get mouseChildren():Boolean {
			return model.mouseChildren;
		}
		
		protected function validateMask(newValue:*, oldValue:*):void {
			if(newValue) {
				view.mask = newValue.view;
			}
			else if(oldValue) {
				view.mask = null;
			}
		}
		
		private function viewPath(v:DisplayObject=null):String {
			v = (v) ? v : view;
			var path:String = v.name;
			while(v && v.parent) {
				path = v.parent.name + '/' + path;
				v = v.parent;
			}
			return '/' + path;
		}
		
		protected function validateMouseChildren(newValue:*, oldValue:*):void {
			view.mouseChildren = newValue;
		}
		
		public function set mouseEnabled(mouseEnabled:Boolean):void {
			model.mouseEnabled = mouseEnabled;
		}
		
		public function get mouseEnabled():Boolean {
			return model.mouseEnabled;
		}

		protected function validateMouseEnabled(newValue:*, oldValue:*):void {
			view.mouseEnabled = newValue;
		}

		public function set horizontalAlign(align:String):void {
			if(align != ALIGN_LEFT && align != ALIGN_CENTER && align != ALIGN_RIGHT) {
				throw new IllegalOperationError("horizontalAlign must be left, center or right");
			}
			model.horizontalAlign = align;
		}

		public function get horizontalAlign():String {
			return model.horizontalAlign;
		}
		
		public function set horizontalGutter(gutter:int):void {
			model.horizontalGutter = gutter;
		}
		
		public function get horizontalGutter():int {
			return model.horizontalGutter;
		}
		
		public function set verticalAlign(align:String):void {
			if(align != ALIGN_TOP && align != ALIGN_CENTER && align != ALIGN_BOTTOM) {
				throw new IllegalOperationError("verticallAlign must be top, center or bottom");
			}
			model.verticalAlign = align;			
		}

		public function get verticalAlign():String {
			return model.verticalAlign;
		}
		
		public function set verticalGutter(gutter:int):void {
			model.verticalGutter = gutter;
		}
		
		public function get verticalGutter():int {
			return model.verticalGutter;
		}
		
		public function set x(x:int):void {
			model.x = x;
		}
		
		public function get x():int {
			return model.x;
		}
		
		public function set y(y:int):void {
			model.y = y;
		}
		
		public function get y():int {
			return model.y;
		}
		
		public function set width(width:Number):void {
			if(model.width != width) {
				model.width = actualWidth = width;
			}
		}
		
		public function get width():Number {
			if(isNaN(model.actualWidth)) {
				return preferredWidth || minWidth;
			}
			return model.actualWidth;
		}
		
		public function set height(height:Number):void {
			if(model.height != height) {
				model.height = actualHeight = height;
			}
		}
		
		public function get height():Number {
			if(isNaN(model.actualHeight)) {
				return preferredHeight || minHeight;
			}
			return model.actualHeight;
		}
		
		public function get fixedWidth():Number {
			return model.width;
		}

		public function get fixedHeight():Number {
			return model.height;
		}
		
		public function set actualWidth(width:Number):void {
			var min:Number = minWidth;
			var max:Number = maxWidth;
			width = Math.round(width);
			width = (min) ? Math.max(min, width) : width;
			width = (max) ? Math.min(max, width) : width;
			model.actualWidth = width;
		}
		
		public function get actualWidth():Number {
			return model.width || model.actualWidth || preferredWidth || minWidth;
		}
		
		public function set actualHeight(height:Number):void {
			var min:Number = minHeight;
			var max:Number = maxHeight;
			height = Math.round(height);
			height = (min) ? Math.max(min, height) : height;
			height = (max) ? Math.min(max, height) : height;
			model.actualHeight = height;
		}
		
		public function get actualHeight():Number {
			return model.height || model.actualHeight || preferredHeight || minHeight;
		}
		
		public function set excludeFromLayout(exclude:Boolean):void {
			model.excludeFromLayout = exclude;
		}
		
		public function get excludeFromLayout():Boolean {
			return model.excludeFromLayout;
		}

		public function set percentWidth(percent:Number):void {
			percent = (percent > 1) ? percent * .01 : percent;
			width = NaN;
			model.percentWidth = percent;
		}
		
		public function get percentWidth():Number {
			return model.percentWidth;
		}
		
		public function set percentHeight(percent:Number):void {
			percent = (percent > 1) ? percent * .01 : percent;
			height = NaN;
			model.percentHeight = percent;
		}
		
		public function get percentHeight():Number {
			return model.percentHeight;
		}
		
		public function set preferredWidth(width:Number):void {
			model.preferredWidth = width;
		}
		
		public function get preferredWidth():Number {
			return model.preferredWidth;
		}
		
		public function set preferredHeight(height:Number):void {
			model.preferredHeight = height;
		}
		
		public function get preferredHeight():Number {
			return model.preferredHeight;
		}

		public function set maxWidth(max:Number):void {
			model.maxWidth = max;
		}
		
		public function get maxWidth():Number {
			return model.maxWidth;
		}
		
		public function set maxHeight(max:Number):void {
			model.maxHeight = max;
		}
		
		public function get maxHeight():Number {
			return model.maxHeight;
		}
		
		public function set minWidth(min:Number):void {
			model.minWidth = min;
			if(actualWidth < min) {
				actualWidth = min;
			}
		}
		
		public function get minWidth():Number {
			return model.width || model.minWidth || inferredMinWidth;
		}
		
		protected function get inferredMinWidth():Number {
			var result:Number = 0;
			children.forEach(function(child:Layoutable, index:int, items:Array):void {
				if(!child.excludeFromLayout) {
					result = Math.max(result, child.minWidth);
				}
			});
			return result + horizontalPadding;
		}
		
		public function set minHeight(min:Number):void {
			model.minHeight = min;
			if(actualHeight < min) {
				actualHeight = min;
			}
		}

		public function get minHeight():Number {
			return model.height || model.minHeight || inferredMinHeight;
		}

		protected function get inferredMinHeight():Number {
			var result:Number = 0;
			children.forEach(function(child:Layoutable, index:int, items:Array):void {
				if(!child.excludeFromLayout) {
					result = Math.max(result, child.minHeight);
				}
			});
			return result + verticalPadding;
		}

		public function set padding(padding:int):void {
			paddingBottom 	= padding;
			paddingLeft 	= padding;
			paddingRight	= padding;
			paddingTop		= padding;
			model.padding 	= padding;
		}
		
		public function get padding():int {
			return model.padding;
		}
		
		public function get horizontalPadding():int {
			return paddingLeft + paddingRight;
		}
		
		public function get verticalPadding():int {
			return paddingTop + paddingBottom;
		}

		public function set paddingBottom(padding:int):void {
			model.paddingBottom = padding;
		}
		
		public function get paddingBottom():int {
			return model.paddingBottom;
		}
		
		public function set paddingLeft(padding:int):void {
			model.paddingLeft = padding;
		}
		
		public function get paddingLeft():int {
			return model.paddingLeft;
		}
		
		public function set paddingRight(padding:int):void {
			model.paddingRight = padding;
		}
		
		public function get paddingRight():int {
			return model.paddingRight;
		}
		
		public function set paddingTop(padding:int):void {
			model.paddingTop = padding;
		}
		
		public function get paddingTop():int {
			return model.paddingTop;
		}
		
		public function set backgroundColor(color:uint):void {
			model.backgroundColor = color;
		}
		
		public function get backgroundColor():uint {
			return model.backgroundColor;
		}
		
		public function set cornerRadius(radius:uint):void {
			model.cornerRadius = radius;
		}
		
		public function get cornerRadius():uint {
			return model.cornerRadius;
		}
		
		public function set backgroundAlpha(alpha:Number):void {
			model.backgroundAlpha = alpha;
		}
		
		public function get backgroundAlpha():Number {
			return model.backgroundAlpha;
		}
		
		public function set backgroundImage(image:DisplayObject):void {
			model.backgroundImage = image;
		}
		
		public function get backgroundImage():DisplayObject {
			return model.backgroundImage;
		}
		
		public function set borderColor(color:uint):void {
			model.borderColor = color;
		}
		
		public function get borderColor():uint {
			return model.borderColor;
		}
		
		public function set borderAlpha(alpha:Number):void {
			model.borderAlpha = alpha;
		}
		
		public function get borderAlpha():Number {
			return model.borderAlpha;
		}
		
		public function set borderSize(size:uint):void {
			model.borderSize = size;
		}
		
		public function get borderSize():uint {
			return model.borderSize;
		}
		
		public function set borderStyle(style:String):void {
			model.borderStyle = style;
		}
		
		public function get borderStyle():String {
			return model.borderStyle;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			model.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			model.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return model.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			return model.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean {
			return model.willTrigger(type);
		}

		protected function dispatchPayloadEvent(type:String, payload:Object=null):void {
			var event:PayloadEvent = new PayloadEvent(type);
			event.payload = payload;
			dispatchEvent(event);
		}
		
		/***************************
		 * Composable Implementation
		 */
		public function addChild(child:Layoutable):void {
			childrenCreated = false;
			child.addEventListener(PayloadEvent.ADDED, childAddedHandler);
			child.addEventListener(PayloadEvent.REMOVED, childRemovedHandler);
			children.addItem(child);
			child.parent = this;
			dispatchPayloadEvent(PayloadEvent.ADDED, child);
			invalidateProperties();
		}
		
		public function removeAllChildren():void {
			while(numChildren > 0) {
				// TODO: implement removeChildAt();
				removeChild(getChildAt(0));
			}
		}
		
		public function removeChild(child:Layoutable):void {
			if(children.removeItem(child)) {
				child.parent = null;
				if(childrenCreated && view.contains(child.view)) {
					view.removeChild(child.view);
				}
				removeChildFromHash(child);
				dispatchPayloadEvent(PayloadEvent.REMOVED, child);
				invalidateProperties();
			}
		}
		
		public function getChildAt(index:int):Layoutable {
			return children.getItemAt(index) as Layoutable;	
		}
		
		public function getChildById(id:String):Layoutable {
			var len:int = numChildren;
			var child:Layoutable;
			for(var i:int; i < len; i++) {
				child = getChildAt(i);
				if(child.id == id) {
					return child;
				}
				child = child.getChildById(id);
				if(child) {
					return child;
				}
			}
			return null;
		}

		public function every(callback:Function, thisObject:* = null):Boolean {
			return children.every(callback, thisObject);
		}
		
		public function filter(callback:Function, thisObject:* = null):Array {
			return children.filter(callback, thisObject);
		}
		
		public function forEach(callback:Function, thisObject:* = null):void {
			children.forEach(callback, thisObject);
		}
		
		public function map(callback:Function, thisObject:* = null):Array {
			return children.map(callback, thisObject);
		}
				
		public function get numChildren():int {
			return children.length;
		}
		
		public function set parent(parent:Layoutable):void {
			_parent = parent;
		}
		
		public function get root():Layoutable {
			if(parent) {
				return parent.root;
			}
			return this;
		}
		
		public function get parent():Layoutable {
			return _parent;
		}
		
		public function get path():String {
			var result:String = '';
			if(parent) {
				result = parent.path;
			}
			return result + '/' + name;
		}
		
		public function toString():String {
			return "[" + getQualifiedClassName(this).split("::").pop() +  " path='" + path + "' x='" + x + "' y='" + y + "' width='" + width + "' height='" + height + "']";
		}
		
		/***************************
		 * Helper Methods
		 */
		
		private function addChildToHash(child:Layoutable):void {
			if(id == child.id || childrenHash[child.id]) {
				throw new IllegalOperationError("Child already exists with provided id " + child.id + " at: " + this);
			}
			childrenHash[child.id] = child;
		}
		
		private function removeChildFromHash(child:Layoutable):void {
			delete childrenHash[child.id];
		}
		
		private function childAddedHandler(event:PayloadEvent):void {
			addChildToHash(event.payload as Layoutable);
			dispatchEvent(event);
		}
		
		private function childRemovedHandler(event:PayloadEvent):void {
			removeChildFromHash(event.payload as Layoutable);
			dispatchEvent(event);
		}
		
		protected function get unQualifiedClassName():String {
			return _className ||= qualifiedClassName.split('::').pop();
		}
		
		protected function get qualifiedClassName():String {
			return _qualifiedClassName ||= getQualifiedClassName(this);
		}

		public function set skin(skin:ISkin):void {
			model.skin = skin;
		}
		
		// TODO: why do we have to do this?
		public function get skin():ISkin {
			if (model.skin) {
				return model.skin;
			}
			else if (parent) {
				return parent.skin;
			}
			return null;
		}
		
		public function set tweenAdapter(tweenAdapter:ITweenAdapter):void {
			model.tweenAdapter = tweenAdapter;
		}
		
		public function get tweenAdapter():ITweenAdapter {
			if(model.tweenAdapter) {
				return model.tweenAdapter;
			}
			else if(parent) {
				return parent.tweenAdapter;
			} 
			else {
				return new DefaultTweenAdapter();
			}
		}
		
		public function animate(params:Object, milliseconds:Number=0, easing:String=null, callback:Function=null):void {
			tweenAdapter.animate(this, params, milliseconds, easing, callback);
		}
		
		public function show(milliseconds:Number=0, callback:Function=null):void {
			visible = true;
			animate({alpha:1}, milliseconds, null, callback);
		}
		
		public function hide(milliseconds:Number=0, callback:Function=null):void {
			var wrappedCallback:Function = function(...params):void {
				visible = false;
				if(callback is Function) {
					callback.apply(null, params);
				}
			};		
			animate({alpha:0}, milliseconds, null, wrappedCallback);
		}
		
		public function toggle():void {
			(visible) ? hide() : show();
		}
		
		public function set enabled(enabled:Boolean):void {
			_enabled = enabled;
			
			if(_enabled) {
				clearGrayScale();
				mouseEnabled = true;
				mouseChildren = true;
			}
			else {
				applyGrayScale();
				mouseEnabled = false;
				mouseChildren = false;
			}
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public function clearGrayScale():void {
			view.filters = [];
		}
		
		public function applyGrayScale():void {
			var cm:ColorMatrixFilter = new ColorMatrixFilter();
			
			cm.matrix = new Array(
			0.3086, 0.609, 0.282, 0, 0,
			0.3086, 0.609, 0.282, 0, 0,
			0.3086, 0.609, 0.282, 0, 0,
			0, 0, 0, 1, 0);
			
			view.filters = [cm];	
		}

		public function getBitmapByName(alias:String):DisplayObject {
			var result:DisplayObject;
			if(hasOwnProperty(alias)) {
				return new this[alias]() as DisplayObject;
			}
			
			if(skin) {
				result = skin.getBitmapByName(alias);
				if(result) {
					return result;
				} 
			}
			
			if(parent) {
				result = parent.getBitmapByName(alias);
				if(result) {
					return result;
				}
			}

			var bitmapData:BitmapData = new BitmapData(1, 1, true, 0x00FFCC00);
			return new Bitmap(bitmapData);
		}

		protected function generateId():String {
			return unQualifiedClassName + (++INCR);
		}
	}
}
