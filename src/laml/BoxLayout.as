package laml {
	
	public class BoxLayout extends Layout {		
		
		override public function draw() {
			super.draw();
			drawChildren();
		}
		
		protected function drawChildren() {
			for each(child in this.children) {
				drawChild(child);
			}
		}

		protected function drawChild(child) {
			var hStrategy = getHorizontalPositionStrategy(this.horizontalAlign);
			var vStrategy = getVerticalPositionStrategy(this.verticalAlign);

			scaleChild(child);
			hStrategy.apply(this, [child]);
			vStrategy.apply(this, [child]);
			child.draw();
		}
		
		protected function scaleChild(child) {
			scaleHorizontally(child);
			scaleVertically(child);
		}

		protected function scaleHorizontally(child) {
			if(child.percentWidth) {
				child.actualWidth = availableWidth * child.percentWidth;
			}
		}
		
		protected function scaleVertically(child) {
			if(child.percentHeight) {
				child.actualHeight = availableHeight * child.percentHeight;
			}
		}
		
		protected function getHorizontalPositionStrategy(align) {
			switch(align) {
				case Layoutable.ALIGN_LEFT :
					return function(child) {
						child.x = this.paddingLeft;
					}
				case Layoutable.ALIGN_CENTER :
					return function(child) {
						child.x = this.paddingLeft + ((this.availableWidth / 2) - (child.width / 2));
					}
				case Layoutable.ALIGN_RIGHT :
					return function(child) {
						child.x = this.width - (this.paddingRight + child.width);
					}
					break;
			}
		}
		
		protected function getVerticalPositionStrategy(align) {
			switch(align) {
				case Layoutable.ALIGN_TOP :
					return function(child) {
						child.y = this.paddingTop;
					}
				case Layoutable.ALIGN_CENTER :
					return function(child) {
						child.y = this.paddingTop + ((this.availableHeight / 2) - (child.height / 2));
					}
				case Layoutable.ALIGN_BOTTOM :
					return function(child) {
						child.y = this.height - (this.paddingBottom + child.height);
					}
			}
		}
	}
}
