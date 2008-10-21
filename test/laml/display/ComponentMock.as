package laml.display {
	
	public class ComponentMock extends Component {
		public var widths:Array;
		public var heights:Array;
		
		public function ComponentMock() {
			widths = new Array();
			heights = new Array();
			super();
		}
		
		override public function set width(w:Number):void {
			super.width = w;
			widths.push(w);
		}
		
		override public function set height(h:Number):void {
			super.height = h;
			heights.push(h);
		}
	}
}