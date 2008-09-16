package laml.layout {
	import laml.display.Layoutable;
	
	public interface ILayout {
		
		function render(component:Layoutable):void;
	}
}