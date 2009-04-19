package info.osmatrix {
	import flash.display.*;
	import flash.text.TextField;
	
	import info.osmatrix.uicomponent.*;

	public class CWFW extends MovieClip {

		public function ExamApp() {
			
		}
		
		public function init() {			
			//chapter01.title.text = "ffff";
			//dtTest.text = "abc";
			
			var ch02:MovieClip = new UIChapter();
			ch02.x = 100; ch02.y = 100;
			ch02.setTitle("第一章 绪论");
			addChild(ch02);
		}
	}
}