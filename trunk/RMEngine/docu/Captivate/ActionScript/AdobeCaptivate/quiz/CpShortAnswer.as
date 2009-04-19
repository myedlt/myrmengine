//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import AdobeCaptivate.quiz.CpQuizView;
import AdobeCaptivate.quiz.CpReviewArea;
import AdobeCaptivate.quiz.utils.CpItemParams;
import mx.utils.Delegate;
import AdobeCaptivate.quiz.utils.CpFillBlanksAnsParams;


class AdobeCaptivate.quiz.CpShortAnswer extends CpQuizView
{
	// These are required for createClassObject()
	static var symbolName:String = "CpShortAnswer";
	static var symbolOwner:Object = AdobeCaptivate.quiz.CpShortAnswer;

	// Version string
//#include "../core/ComponentVersion.as"

	var className:String = "CpShortAnswer";

	static var ANSFIELD:String = "ANS";
	private var _ans_param:CpFillBlanksAnsParams = undefined;
	private var _correctWords_arr:Array;
	private var _caseSensitive:Boolean = false;
	private var ans_array:Array;
	
	// reference to bounding box
	private var boundingBoxQ_mc:MovieClip;
	
	function CpShortAnswer() 
	{
		_correctWords_arr = new Array();
		ans_array = new Array();
		slideType = SHORTANSWER;
	}

	// initialize variables
	function init():Void {
		super.init();
		// Since we have a bounding box, we need to hide it and make sure 
		// that its width and height are set to 0.  Notice that we are not using 
		// "this" as we used to in AS1.  In AS2 the compiler automatically
		// references the class members.
		boundingBoxQ_mc._visible = false;
		boundingBoxQ_mc._width = boundingBoxQ_mc._height = 0;
	}
	
	// create the mask and make it invisible
	function createChildren(Void):Void	{
		super.createChildren();
	}

	// if we get invalidated just call super
	function invalidate(Void):Void	{
		super.invalidate();
	}

	// redraw by re-laying out
	function draw(Void):Void	{
		size();
	}

	// respond to size changes
	function size(Void):Void	{
		super.size();
	}

/**
* @private
* override this to find out when a new object is added that needs to be layed out
* @param object the layout object
*/
	function addLayoutObject(object:Object):Void	{
	}

	function initLayout():Void	{
		super.initLayout();
	}
/**
* @private
* override this to layout the content
*/
	function doLayout():Void	{
		super.doLayout();
		if(_ans_param != undefined)
			setItemParams(_ans_param._component, _ans_param);
	}

	private function getItemParams(item:String):CpItemParams
	{
		if(item.toUpperCase() == ANSFIELD)
			return _ans_param;
		else
			return super.getItemParams(item);
	}

	function createAnsField(x:Number, y:Number, width:Number, height:Number)
	{
		_ans_param = new CpFillBlanksAnsParams();
		ans_array[0] = _ans_param;
		_ans_param._font.name = "Arial";		_ans_param._font.size = 14;
		//trace("createAnsField _d = %d" + getNextHighestDepth());
		_ans_param._component = createChild("TextArea", ANSFIELD);
		_ans_param._name = ANSFIELD;
		setItemCoordinates(ANSFIELD, x, y, width, height)
	}

/***	
	function createClearButton(newText:String, x:Number, y:Number, width:Number, height:Number):Void
	{
		super.createClearButton(newText, x, y, width, height);
		getQuizItem(CLEAR).addEventListener("click", Delegate.create(this,onClear));
	}
****/
	function addAnswers(correctWords:Array, caseSensitive:Boolean)
	{
		_ans_param.correctWords_arr = correctWords;
		_ans_param.caseSensitive = caseSensitive;
		//_correctWords_arr = correctWords;
		//_caseSensitive = caseSensitive;
	}

/********	
	function getUserAnswers():Array
	{
		var ans:Array = new Array;
		ans[0] = _ans_param._component.text;
		return ans;
	}

	function setUserAnswers(ans:Array)
	{
		_ans_param._component.text = ans[0];
	}
	
	private function isCorrectAnswer(ansText:String):Boolean
	{
		for(var i:Number = 0; i < _correctWords_arr.length; i++)
		{
			var word:String = _correctWords_arr[i];
			if(_caseSensitive)
			{
				if(ansText == word)
					return true;
			}
			else if(ansText.toUpperCase() == word.toUpperCase())
				return true;
		}
		return false;
	}
	
	private function isBlank():Boolean
	{
		if(_ans_param._component.text == "")
			return true;
		return false;
	}

	//returns the status on pressing submit
	//0 -- no answer entered
	//1 -- incompete
	//2 -- incorrect
	//3 -- correct
	function getStatus():Number
	{
		var quesStatus:Number = BLANK;
		var noAns:Boolean = isBlank();
		
		if(noAns == true)
			return quesStatus;
		
		if(isCorrectAnswer(_ans_param._component.text) == false)
			quesStatus = INCORRECT;
		else
			quesStatus = CORRECT;
		
		return quesStatus;
	}
	
	function enableUserInput(e:Boolean)
	{
		_ans_param._component.enabled = e;
		enableClearButton(e);
		enableSubmitButton(e);
	}
****/
	private function clear(evt)
	{
		clearAll();
	}

	function clearAll()
	{
		_ans_param._component.text = "";
	}
	
	
	/*
	* displays the feedback as per the user input
	* if correct answer is given or the attempts 
	* are over then hitbutton is shown
	*
	function submitAns()
	{
		//trace("inside fill in the blank -  submitAns");
		var status:Number = getStatus();
		showFeedbackOnSubmit(status);
		if((status == CORRECT) || (attempts >= maxAttempts))
		{
			enableUserInput(false);
			showHitButton();
		}
	}
	
	function showReview()
	{
		var comp:CpReviewArea = CpReviewArea(getQuizItem(REVIEWAREA));
		if(lastStatus == CORRECT)
			comp.showCorrectMsg();
		else if(lastStatus == INCOMPLETE || lastStatus == BLANK)
			comp.showIncompleteMsg();
		else
			comp.showIncorrectMsg(_ans_param._component.text, _correctWords_arr.toString());
		setItemVisible(REVIEWAREA, true);
		comp.useHandCursor = true;
	}
********/

	public function get answerParams():Array
	{
		return ans_array;
	}

}