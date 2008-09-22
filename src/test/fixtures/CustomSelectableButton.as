package fixtures {
	import laml.display.SelectableButton;
	

	public class CustomSelectableButton extends SelectableButton {
		[Embed(source="assets/Play1Normal.png")]
		public var CustomSelectableButtonUpState:Class;

		[Embed(source="assets/Play1Hot.png")]
		public var CustomSelectableButtonOverState:Class;

		[Embed(source="assets/Play1Pressed.png")]
		public var CustomSelectableButtonDownState:Class;
		
		[Embed(source="assets/PauseNormal.png")]
		public var CustomSelectableButtonUpSelectedState:Class;

		[Embed(source="assets/PauseHot.png")]
		public var CustomSelectableButtonOverSelectedState:Class;

		[Embed(source="assets/PausePressed.png")]
		public var CustomSelectableButtonDownSelectedState:Class;

//		[Embed(source="images/PauseDisabled.png")]

		override protected function initialize():void {
			super.initialize();
			width = 24;
			height = 24;
		}
	}
}