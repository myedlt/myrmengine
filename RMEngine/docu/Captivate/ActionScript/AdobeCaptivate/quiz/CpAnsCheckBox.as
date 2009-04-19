//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.controls.CheckBox;

[Event("setState")]
class AdobeCaptivate.quiz.CpAnsCheckBox extends CheckBox
{
	// These are required for createClassObject()
	static var symbolName:String = "CpAnsCheckBox";
	static var symbolOwner:Object = Object(AdobeCaptivate.quiz.CpAnsCheckBox);
	var className:String = "CpAnsCheckBox";
	
	function CpAnsCheckBox()
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