//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"
import MMQuizzingV3.MMQuizClasses.MultipleChoiceAnswer;

class MMQuizzingV3.MMQuizClasses.MultipleChoiceAnswerAccImpl extends RadioButtonAccImpl
{
	var master:Object;
	var ROLE:Number  = 0x2d;
	var owner:Object = MultipleChoiceAnswer;
	
	static function enableAccessibility()
	{
	}

	function MultipleChoiceAnswerAccImpl(master:Object)
	{
		super(master);
	}
	

	function createAccessibilityImplementation()
	{
		_accImpl = new MultipleChoiceAnswerAccImpl(this);
	}

	static function hookAccessibility():Boolean
	{
		// Flash player does not let us modify the prototype of the
		// class when we are loaded in an external swf, which we are
		// for Serrano (components.swf).  Workaround this by defining
		// the hookAccessibility method directly on
		// MultipleChoiceAnswer
		
		//MultipleChoiceAnswer.prototype.createAccessibilityImplementation = MMQuizzingV3.MMQuizClasses.MultipleChoiceAnswerAccImpl.prototype.createAccessibilityImplementation;
		return true;
	}

	static var accessibilityHooked:Boolean = hookAccessibility();
}
