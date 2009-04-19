package {

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	import flash.text.TextField;
	
	import info.osmatrix.rmframework.app.view.PBankFlashViewHelper;
	
	public class PBank extends MovieClip {

		public var viewHelper:PBankFlashViewHelper;
		
		public function PBank() {
			initApp();
		}
		
		private function initApp():void {
			viewHelper = new PBankFlashViewHelper(this);
		}
	}
}