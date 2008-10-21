package laml.display {
	import laml.layout.FlowLayout;
	import laml.layout.LayoutableDelegate;
	
	public class HBox extends Component {
		
		override protected function initialize():void {
			layout = new FlowLayout(LayoutableDelegate.HORIZONTAL);
		}
		
		override protected function get inferredMinWidth():Number {
			var result:Number = 0;
			children.forEach(function(child:Layoutable, index:int, items:Array):void {
				result += child.minWidth;
			});
			return result + horizontalPadding;
		}

		override public function get horizontalPadding():int {
			return super.horizontalPadding + (horizontalGutter * (numChildren - 1));
		}
	}
}
