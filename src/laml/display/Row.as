package laml.display {
	import laml.layout.RowLayout;
	
	public class Row extends HBox {

		override protected function initialize():void {
			super.initialize();
			layout = new RowLayout();
		}
	}
}
