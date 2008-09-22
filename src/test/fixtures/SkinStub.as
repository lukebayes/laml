package episodic.core {
	import laml.display.Skin;
	
	public class SkinStub extends Skin {
		[Embed(source="assets/Play1Normal.png")]
		public var CustomButtonUpState:Class;

		[Embed(source="assets/Play1Hot.png")]
		public var CustomButtonOverState:Class;

		[Embed(source="assets/Play1Pressed.png")]
		public var CustomButtonDownState:Class;
		
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
	}
}