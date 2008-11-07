package laml.layout {
	import laml.display.Layoutable;
	
	dynamic public class StackLayout implements ILayout {
		protected var component:Layoutable;
		
		private var cache:Object;
		private var horizontalDelegate:LayoutableDelegate;
		private var verticalDelegate:LayoutableDelegate;
		
		public function render(component:Layoutable):void {
			if(component.numChildren == 0) {
				return;
			}
			
			if(!horizontalDelegate) {
				horizontalDelegate = new LayoutableDelegate(component, LayoutableDelegate.HORIZONTAL);
			}

			if(!verticalDelegate) {
				verticalDelegate = new LayoutableDelegate(component, LayoutableDelegate.VERTICAL);
			}

			this.component = component;

			if(isNaN(horizontalDelegate.fixed) && isNaN(horizontalDelegate.percent)) {
				horizontalDelegate.actual = getChildrenWidth(horizontalDelegate);
			}
			
			if(isNaN(verticalDelegate.fixed) && isNaN(verticalDelegate.percent)) {
				verticalDelegate.actual = getChildrenHeight(verticalDelegate);
			}

			horizontallyScaleChildren(horizontalDelegate);
			verticallyScaleChildren(verticalDelegate);
			
			horizontallyPositionChildren(horizontalDelegate);
			verticallyPositionChildren(verticalDelegate);
			
			renderChildren();
		}
		
		protected function getChildrenWidth(delegate:LayoutableDelegate):Number {
			return getDelegateSize(delegate);
		}
		
		protected function getChildrenHeight(delegate:LayoutableDelegate):Number {
			return getDelegateSize(delegate);
		}
		
		protected function getDelegateSize(delegate:LayoutableDelegate):Number {
			var result:Number = delegate.actual;
			delegate.children.forEach(function(child:LayoutableDelegate, index:int, children:Array):void {
				result = Math.max(result, child.actual + delegate.padding);
			});
			return result;
		}
		
		protected function horizontallyScaleChildren(delegate:LayoutableDelegate):void {
			scaleChildren(delegate, LayoutableDelegate.HORIZONTAL);
		}
		
		protected function verticallyScaleChildren(delegate:LayoutableDelegate):void {
			scaleChildren(delegate, LayoutableDelegate.VERTICAL);
		}
		
		protected function horizontallyPositionChildren(delegate:LayoutableDelegate):void {
			var method:Function = positionChildrenMethod(delegate);
			method(delegate, LayoutableDelegate.HORIZONTAL);
		}
		
		protected function verticallyPositionChildren(delegate:LayoutableDelegate):void {
			var method:Function = positionChildrenMethod(delegate);
			method(delegate, LayoutableDelegate.VERTICAL);
		}
		
		protected function positionChildrenMethod(delegate:LayoutableDelegate):Function {
			return this['positionChildren_' + delegate.delegatedAlign];
		}
		
		protected function scaleChildren(delegate:LayoutableDelegate, axis:String):void {
			var kids:Array = delegate.flexibleChildren;
			var len:int = kids.length;
			var child:LayoutableDelegate;
			for(var i:int; i < len; i++) {
				child = kids[i] as LayoutableDelegate;
				child.actual = child.percent * getUnitSize(delegate, axis);
			}
		}
		
		protected function positionChildren_first(delegate:LayoutableDelegate, axis:String):void {
			var kids:Array = delegate.children;
			var first:int = delegate.paddingFirst;
			var child:LayoutableDelegate;
			var len:int = kids.length;
			for(var i:int; i < len; i++) {
				child = kids[i] as LayoutableDelegate;
				child.position = first;
			}
		}
		
		protected function positionChildren_center(delegate:LayoutableDelegate, axis:String):void {
			var kids:Array = delegate.children;
			var space:int = getAvailablePixels(delegate, axis);
			var paddingFirst:int = delegate.paddingFirst;
			var child:LayoutableDelegate;
			var len:int = kids.length;
			for(var i:int; i < len; i++) {
				child = kids[i] as LayoutableDelegate;
				child.position = ((space - child.size) / 2) + paddingFirst;
			}
		}
		
		protected function positionChildren_last(delegate:LayoutableDelegate, axis:String):void {
			var kids:Array = delegate.children;
			var last:int = delegate.size - delegate.paddingLast;
			var child:LayoutableDelegate;
			var len:int = kids.length;
			for(var i:int; i < len; i++) {
				child = kids[i] as LayoutableDelegate;
				child.position = last - child.size;
			}
		}
		
		protected function getAvailablePixels(delegate:LayoutableDelegate, axis:String):Number {
			return delegate.size - delegate.padding;
		}
		
		protected function getUnitSize(delegate:LayoutableDelegate, axis:String):Number {
			return getAvailablePixels(delegate, axis) * getFlexibleRatio(delegate, axis);
		}
		
		protected function getFlexibleRatio(delegate:LayoutableDelegate, axis:String):Number {
			var kids:Array = delegate.flexibleChildren;
			var len:int = kids.length;
			var sum:Number = 0;
			var child:LayoutableDelegate;
			for(var i:int; i < len; i++) {
				child = kids[i] as LayoutableDelegate;
				sum += child.percent;
			}
			return sum / len;
		}
		
		protected function renderChildren():void {
			// Do not use the LayoutableDelegate.children
			// or 'excludeFromLayout' items will not be rendered
			var len:int = component.numChildren;
			for(var i:int; i < len; i++) {
				component.getChildAt(i).render();
			}
		}
	}
}
