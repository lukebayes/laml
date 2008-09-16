
package laml.layout {
	import laml.display.Component;
	import laml.display.Layoutable;
	
	public class LayoutableDelegate {
		public static const HORIZONTAL:String 	= 'horizontal';
		public static const VERTICAL:String 	= 'vertical';
		
		private var component:Layoutable;
		private var keys:Object;
		
		public function LayoutableDelegate(component:Layoutable, direction:String=HORIZONTAL) {
			this.component = component;
			keys = (direction == HORIZONTAL) ? createHorizontalKeys() : createVerticalKeys();
		}
		
		public function get direction():String {
			return keys.direction;
		}
		
		private function createHorizontalKeys():Object {
			return {
				actual: 		'actualWidth',
				align:			'horizontalAlign',
				direction: 		'horizontal',
				paddingFirst: 	'paddingLeft',
				gutter: 		'horizontalGutter',
				minSize:		'minWidth',
				paddingLast: 	'paddingRight',
				padding: 		'horizontalPadding',
				percent: 		'percentWidth',
				position:		'x',
				preferred:		'preferredWidth',
				size: 			'width'
			}
		}
		
		private function createVerticalKeys():Object {
			return {
				actual: 		'actualHeight',
				align:			'verticalAlign',
				direction: 		'vertical',
				paddingFirst: 	'paddingTop',
				gutter: 		'verticalGutter',
				minSize:		'minHeight',
				paddingLast: 	'paddingBottom',
				padding: 		'verticalPadding',
				percent: 		'percentHeight',
				position:		'y',
				preferred:		'preferredHeight',
				size: 			'height'
			}
		}
		
		public function get children():Array {
			var result:Array = [];
			var len:Number = component.numChildren;
			var child:Layoutable;
			for(var i:int; i < len; i++) {
				child = component.getChildAt(i);
				if(!child.excludeFromLayout) {
					result.push(new LayoutableDelegate(child, direction));
				}
			}
			return result;
		}
		
		public function get flexibleChildren():Array {
			var result:Array = [];
			var len:Number = children.length;
			var child:LayoutableDelegate;
			for(var i:int; i < len; i++) {
				child = children[i];
				//trace(">> checking child: " + child + " : "  + child.percentWidth + " h: " + child.percentHeight);
				if(!isNaN(child.percent)) {
					result.push(child);
				}
			}
			return result;
		}
		
		public function get staticChildren():Array {
			var result:Array = [];
			var len:Number = children.length;
			var child:LayoutableDelegate;
			for(var i:int; i < len; i++) {
				child = children[i];
				if(isNaN(child.percent)) {
					result.push(child);
				}
			}
			return result;
		}
		
		public function get minSize():Number {
			return component[keys.minSize];
		}
		
		public function get staticSize():Number {
			var sum:Number = 0;
			staticChildren.forEach(function(child:LayoutableDelegate, index:int, kids:Array):void {
				sum += child.size;
			});
			return sum;
		}
		
		public function set actual(size:Number):void {
			component[keys.actual] = size;
		}
		
		public function get actual():Number {
			return component[keys.actual];
		}
		
		public function get align():String {
			return component[keys.align];
		}
		
		public function get delegatedAlign():String {
			switch(align) {
				case Component.ALIGN_LEFT :
				case Component.ALIGN_TOP :
					return 'first';
				case Component.ALIGN_RIGHT:
				case Component.ALIGN_BOTTOM :
					return 'last';
				case Component.ALIGN_CENTER :
					return 'center';
			}
			return null;
		}
		
		public function get gutter():Number {
			return component[keys.gutter];
		}
		
		public function get gutterSum():Number {
			if(component.numChildren > 1) {
				return (component.numChildren - 1) * gutter;
			}
			return 0;
		}
		
		public function get padding():Number {
			return component[keys.padding];
		}
		
		public function get paddingFirst():Number {
			return component[keys.paddingFirst];
		}
		
		public function get paddingLast():Number {
			return component[keys.paddingLast];
		}
		
		public function set percent(percent:Number):void {
			component[keys.percent] = percent;
		}
		
		public function get percent():Number {
			return component[keys.percent];
		}
		
		public function set position(position:Number):void {
			component[keys.position] = position;
		}
		
		public function get position():Number {
			return component[keys.position];
		}
		
		public function get preferred():Number {
			return component[keys.preferred];
		}
	
		public function set size(size:Number):void {
			component[keys.size] = size;
		}
		
		public function get size():Number {
			return component[keys.size];
		}
	}
}
