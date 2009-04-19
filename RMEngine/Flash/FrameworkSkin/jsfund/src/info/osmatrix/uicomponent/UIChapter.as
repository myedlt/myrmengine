
package info.osmatrix.uicomponent{

	import flash.display.*;
	import flash.text.TextField;

	public class UIChapter extends MovieClip {
		public function setTitle(str:String) {
			var txt:TextField = new TextField();
			txt.text = str;
			txt.x = 30; txt.y = 5;
			addChild(txt);
		}
	}
}