package laml.layout {
	import laml.display.Layoutable;
	
	dynamic public class StackLayout implements ILayout {
		protected var component:Layoutable;
		
		private var cache:Object;
		
		public function render(component:Layoutable):void {
			if(component.numChildren == 0) {
				return;
			}
			
			this.component = component;

			var horizontalDelegate:LayoutableDelegate = new LayoutableDelegate(component, LayoutableDelegate.HORIZONTAL);
			var verticalDelegate:LayoutableDelegate = new LayoutableDelegate(component, LayoutableDelegate.VERTICAL);

			horizontallyScaleChildren(horizontalDelegate);
			verticallyScaleChildren(verticalDelegate);
			
			horizontallyPositionChildren(horizontalDelegate);
			verticallyPositionChildren(verticalDelegate);
			
			renderChildren();
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
			//trace(">> scale children: " + delegate.flexibleChildren.length);
			//trace(">> delegate w: " + delegate.size);
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
