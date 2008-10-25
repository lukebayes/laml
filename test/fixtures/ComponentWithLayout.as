package fixtures {
	import laml.display.Component;
	
	import mx.core.ByteArrayAsset;
	
	public class ComponentWithLayout extends Component {

		[Embed("ComponentWithLayout.laml", mimeType="application/octet-stream")]
		public var Config:Class;
	}
}