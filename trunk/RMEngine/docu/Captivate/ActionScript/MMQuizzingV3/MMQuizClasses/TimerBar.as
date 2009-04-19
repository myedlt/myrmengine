//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"

class MMQuizzingV3.MMQuizClasses.TimerBar extends UIComponent {	
	static var symbolName:String = "TimerBar";
	static var symbolOwner:Object = Object(TimerBar);
	var	className:String = "TimerBar";
	
	private var _label:Label;
	private var _bar:Object;
	
	private function formatTime(nNumber:Number)
	{
		var szRet = "00" + nNumber;
		return szRet.substr(-2);
	}

	
	function updateProgress(timeToDisplay:Date, fractionRemaining:Number)
	{
		var remSecs = timeToDisplay.getSeconds();
		var remMinutes = timeToDisplay.getMinutes();
		var remainingTimeStr = "";
		remainingTimeStr = remainingTimeStr.concat(formatTime(remMinutes), ":",formatTime(remSecs));
		_label.text = remainingTimeStr;
		_bar._x = -(fractionRemaining*_bar._width);
		
	}
	
	function TimerBar()
	{
	}

	
	private function init() {
		super.init();
	}
}
	
