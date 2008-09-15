package laml.display {
	import laml.layout.FlowLayout;
	import laml.layout.LayoutableDelegate;
	
	public class VBox extends Component {
		
		override protected function initialize():void {
			layout = new FlowLayout(LayoutableDelegate.VERTICAL);
		}
	}
}
