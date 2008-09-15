package laml.layout {
	
	dynamic public class FlowLayout extends StackLayout {
		
		private var direction:String;
		
		public function FlowLayout(direction:String) {
			this.direction = direction;	
		}

		override protected function scaleChildren(delegate:LayoutableDelegate, axis:String):void {
			if(shouldScaleChildren(delegate, axis)) {
				scaleChildrenOnAxis(delegate, axis);
			}
			else {
				super.scaleChildren(delegate, axis);
			}
		}
		
		protected function shouldScaleChildren(delegate:LayoutableDelegate, axis:String):Boolean {
			return (axis == direction);
		}

		override protected function getMinSize(delegate:LayoutableDelegate):int {
			if(delegate.direction == direction) {
				var kids:Array = delegate.children;
				var result:int;
				var len:int = kids.length;
				for(var i:int; i < len; i++) {
					result += kids[i].size;
				}
				return result + delegate.gutterSum + delegate.padding;
			}
			else {
				return super.getMinSize(delegate);
			}
		}

		override protected function horizontallyPositionChildren(delegate:LayoutableDelegate):void {
			if(direction == LayoutableDelegate.HORIZONTAL) {
				var method:Function = positionChildrenMethodOnAxis(delegate);
				method(delegate, LayoutableDelegate.HORIZONTAL);
			}
			else {
				super.horizontallyPositionChildren(delegate);
			}
		}

		override protected function verticallyPositionChildren(delegate:LayoutableDelegate):void {
			if(direction == LayoutableDelegate.VERTICAL) {
				var method:Function = positionChildrenMethodOnAxis(delegate);
				method(delegate, LayoutableDelegate.HORIZONTAL);
			}
			else {
				super.verticallyPositionChildren(delegate);
			}
		}

		protected function positionChildrenMethodOnAxis(delegate:LayoutableDelegate):Function {
			return this['positionChildrenOnAxis_' + delegate.delegatedAlign];
		}
		
		protected function scaleChildrenOnAxis(delegate:LayoutableDelegate, axis:String):void {
			var kids:Array = delegate.flexibleChildren;
			var len:int = kids.length;
			var child:LayoutableDelegate;
			var unitSize:Number = getUnitSizeOnAxis(delegate, axis);
			for(var i:int; i < len; i++) {
				child = kids[i] as LayoutableDelegate;
				child.actual = Math.floor(child.percent * unitSize);
			}
		}
		
		protected function positionChildrenOnAxis_first(delegate:LayoutableDelegate, axis:String):void {
			var kids:Array = delegate.children;
			var first:int = delegate.paddingFirst;
			var gutter:int = delegate.gutter;
			var child:LayoutableDelegate;
			var len:int = kids.length;
			for(var i:int; i < len; i++) {
				child = kids[i] as LayoutableDelegate;
				child.position = first;
				first = first + child.actual + gutter;
			}
		}
		
		protected function positionChildrenOnAxis_center(delegate:LayoutableDelegate, axis:String):void {
			positionChildrenOnAxis_first(delegate, axis);
		}
		
		protected function positionChildrenOnAxis_last(delegate:LayoutableDelegate, axis:String):void {
			var kids:Array = delegate.children;
			var last:int = delegate.size - delegate.paddingLast;
			var gutter:int = delegate.gutter;
			var child:LayoutableDelegate;
			var len:int = kids.length - 1;
			for(var i:int = len; i >= 0; i--) {
				child = kids[i] as LayoutableDelegate;
				child.position = last - child.size;
				last = last - gutter - child.size;
			}
		}

		protected function getUnitSizeOnAxis(delegate:LayoutableDelegate, axis:String):Number {
			var available:Number = 	getAvailablePixelsOnAxis(delegate, axis);
			var percentSum:Number = getPercentSum(delegate, axis);
			return available / percentSum;	
		}
		
		protected function getPercentSum(delegate:LayoutableDelegate, axis:String):Number {
			var kids:Array = delegate.flexibleChildren;
			var len:int = kids.length;
			var sum:Number = 0;
			for(var i:int; i < len; i++) {
				sum += kids[i].percent;
			}
			return sum;
		}

		protected function getAvailablePixelsOnAxis(delegate:LayoutableDelegate, axis:String):Number {
			return (delegate.size - delegate.padding) - (delegate.gutterSum + delegate.staticSize);
		}
		
		protected function getFlexibleRatioOnAxis(delegate:LayoutableDelegate, axis:String):Number {
			var ratio:Number = getFlexibleRatio(delegate, axis);
			ratio = ratio / delegate.flexibleChildren.length;
			return ratio;
		}
	}
}
