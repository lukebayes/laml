package laml.display {
	import laml.layout.FlowLayout;
	import laml.layout.LayoutableDelegate;
	
	public class HBox extends Component {
		
		// TODO: Shouldn't this call super.initialize() ?
		override protected function initialize():void {
			layout = new FlowLayout(LayoutableDelegate.HORIZONTAL);
		}
	}
}
