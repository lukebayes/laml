package laml {
	
	public class Layout extends Delegate {
		protected var _availableWidth;
		protected var _availableHeight;

		public function draw() {
			clearCachedValues();
		}
		
		public function set component(component) {
			delegate = component;
		}
		
		public function get component() {
			return delegate;
		}
		
		protected function clearCachedValues() {
			_availableWidth = null;
			_availableHeight = null;
		}
				
		protected function get availableWidth() {
			if(_availableWidth) {
				return _availableWidth;
			}
			return _availableWidth = (this.width - (this.paddingLeft + this.paddingRight));
		}
		
		protected function get availableHeight() {
			if(_availableHeight) {
				return _availableHeight;
			}
			return _availableHeight = (this.height - (this.paddingTop + this.paddingBottom));
		}
	}
}
