//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"
import MMQuizzingV3.MMQuizClasses.Feedback;

[TagName("Hint")]
class MMQuizzingV3.MMQuizClasses.Hint extends Feedback {
	static var symbolName:String = "Hint";
	static var symbolOwner:Object = Object(Hint);
	var	className:String = "Hint";


	function Hint() 
	{
	}
	
	private function init() {
		useHandCursor = false;
		isModal = false;
		super.init();
	}
	
	function size(Void):Void {
		super.size();
	}
	

}