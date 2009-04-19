//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import AdobeCaptivate.quiz.utils.CpItemParams;

class AdobeCaptivate.quiz.utils.CpFillBlanksAnsParams extends CpItemParams
{
	var caseSensitive:Boolean = false;
	
	var words_arr:Array;
	var correctWords_arr:Array;
	
	var _type:Number = 0; //0 -- text input, 1 -- combobox
	
	function CpFillBlanksAnsParams()
	{
		words_arr = new Array;
		correctWords_arr = new Array;
	}
}
