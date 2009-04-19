//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"
import MMQuizzingV3.MMQuizClasses.MultipleChoiceMultipleAnswer;

class MMQuizzingV3.MMQuizClasses.MultipleChoiceMultipleAnswerAccImpl extends CheckBoxAccImpl
{
	var master:Object;
	var ROLE:Number = 0x2c
	var STATE_SYSTEM_CHECKED:Number = 0x10;
	var owner:Object = MultipleChoiceMultipleAnswer;
	
	static function enableAccessibility()
	{
	}

	function MultipleChoiceMultipleAnswerAccImpl(master:Object)
	{
		super(master);
	}
	

	function createAccessibilityImplementation()
	{
		_accImpl = new MultipleChoiceMultipleAnswerAccImpl(this);
	}

	static function hookAccessibility():Boolean
	{
		// Flash player does not let us modify the prototype of the
		// class when we are loaded in an external swf, which we are
		// for Serrano (components.swf).  Workaround this by defining
		// the hookAccessibility method directly on
		// MultipleChoiceMultipleAnswer

		//MultipleChoiceMultipleAnswer.prototype.createAccessibilityImplementation = MMQuizzingV3.MMQuizClasses.MultipleChoiceMultipleAnswerAccImpl.prototype.createAccessibilityImplementation;
		return true;
	}

	static var accessibilityHooked:Boolean = hookAccessibility();
}
