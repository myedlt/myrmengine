//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import AdobeCaptivate.quiz.utils.CpFont;
import mx.core.UIComponent;

class AdobeCaptivate.quiz.utils.CpCaptionParams extends AdobeCaptivate.quiz.utils.CpItemParams
{
	var audioID:String;
	var _failureLevel:Number;
	
	function CpCaptionParams()
	{
		audioID = "";
		_failureLevel = -1;
	}
}
