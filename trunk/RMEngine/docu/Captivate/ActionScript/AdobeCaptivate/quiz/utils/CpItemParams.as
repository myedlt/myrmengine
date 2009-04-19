//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import AdobeCaptivate.quiz.utils.CpFont;
import mx.core.UIComponent;

class AdobeCaptivate.quiz.utils.CpItemParams
{
	var _x:Number = 0;
	var _y:Number = 0;
	var _width:Number = 0;
	var _height:Number = 0;
	var _font:CpFont;
	var _component:MovieClip;
	var _name:String = "undefined";
	var _movie:Boolean = false;
	
	function CpItemParams()
	{
		_font = new CpFont();
	}
}
