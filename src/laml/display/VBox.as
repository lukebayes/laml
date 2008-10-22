package laml.display {
	import laml.layout.FlowLayout;
	import laml.layout.LayoutableDelegate;
	
	public class VBox extends Component {
		
		override protected function initialize():void {
			layout = new FlowLayout(LayoutableDelegate.VERTICAL);
		}

		override protected function get inferredMinHeight():Number {
			var result:Number = 0;
			children.forEach(function(child:Layoutable, index:int, items:Array):void {
				result += child.minHeight;
			});
			return result + verticalPadding;
		}

		override public function get verticalPadding():int {
			return super.verticalPadding + (verticalGutter * (numChildren - 1));
		}
	}
}
