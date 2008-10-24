package laml.layout {
	import laml.display.Layoutable;
	
	public class RowLayout implements ILayout {
		
		public function render(component:Layoutable):void {
			if(component.numChildren == 0) {
				return;
			}

			var position:Number = component.paddingLeft;
			var paddingTop:Number = component.paddingTop;

			component.forEach(function(child:Layoutable, index:int, children:Array):void {
				child.x = position;
				child.y = paddingTop;
				position += child.width + component.gutter;
				child.render();
			});
		}
	}
}