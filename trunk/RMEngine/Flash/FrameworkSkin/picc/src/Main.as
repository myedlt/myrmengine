package {

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	import flash.text.TextField;
	
	import info.osmatrix.rmframework.app.view.FlashViewHelper;
	
	public class Main extends MovieClip {

		public var viewHelper:FlashViewHelper;
		
		public function Main() {
			initApp();
		}
		
		private function initApp():void {
			viewHelper = new FlashViewHelper(this);
		}
	}
}