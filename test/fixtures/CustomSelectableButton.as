package fixtures {
	import laml.display.SelectableButton;
	

	public class CustomSelectableButton extends SelectableButton {
		[Embed(source="assets/Play1Normal.png")]
		public var CustomSelectableButtonUp:Class;

		[Embed(source="assets/Play1Hot.png")]
		public var CustomSelectableButtonOver:Class;

		[Embed(source="assets/Play1Pressed.png")]
		public var CustomSelectableButtonDown:Class;
		
		[Embed(source="assets/PauseNormal.png")]
		public var CustomSelectableButtonSelectedUp:Class;

		[Embed(source="assets/PauseHot.png")]
		public var CustomSelectableButtonSelectedOver:Class;

		[Embed(source="assets/PausePressed.png")]
		public var CustomSelectableButtonSelectedDown:Class;

//		[Embed(source="images/PauseDisabled.png")]

		override protected function initialize():void {
			super.initialize();
			width = 24;
			height = 24;
		}
	}
}