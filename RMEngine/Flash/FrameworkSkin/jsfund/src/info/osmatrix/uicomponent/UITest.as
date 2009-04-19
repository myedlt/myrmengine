
package info.osmatrix.uicomponent{
	import flash.display.*;
	import flash.text.TextField;

	public class UITest extends MovieClip {
		public function addFirst(str:String) {
			var txt:TextField = new TextField();
			txt.text = str;
			addChild(txt);
		}
	}
}