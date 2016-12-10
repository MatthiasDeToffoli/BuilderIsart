package {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	public class TextSprite extends Sprite {
		public function TextSprite() {
			super();
			for (var i:int = numChildren - 1; i >= 0; i--) {
				if (getQualifiedClassName(getChildAt(i)) == "flash.text::TextField") removeChildAt(i);
			}
			if (numChildren==0) {
				graphics.lineTo(1, 1);
				graphics.lineStyle(1, 0, 0);
			}
		}
	}
}