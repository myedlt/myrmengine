//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.controls.RadioButton;

[Event("setState")]
class AdobeCaptivate.quiz.CpAnsRadioButton extends RadioButton
{
	// These are required for createClassObject()
	static var symbolName:String = "CpAnsRadioButton";
	static var symbolOwner:Object = Object(AdobeCaptivate.quiz.CpAnsRadioButton);
	var className:String = "CpAnsRadioButton";
	
	function CpAnsRadioButton()
	{
		
	}
		
	function init()
	{
		super.init();
	}
	
	function size()
	{
		super.size();
	}
		
	function setStateVar(state:Boolean):Void
	{
		super.setStateVar(state);
		dispatchEvent({type:"setState", target:this});
		//trace("state changed");
	}

}