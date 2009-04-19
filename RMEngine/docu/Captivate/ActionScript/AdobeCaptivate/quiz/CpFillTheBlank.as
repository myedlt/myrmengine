//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.core.View;
import mx.controls.Button;
import AdobeCaptivate.quiz.CpQuizView;
import AdobeCaptivate.quiz.CpLabel;
import AdobeCaptivate.quiz.CpReviewArea;
import AdobeCaptivate.quiz.CpAnsTextInput;
import AdobeCaptivate.quiz.CpAnsComboBox;
import AdobeCaptivate.quiz.utils.CpItemParams;
import AdobeCaptivate.quiz.utils.CpFillBlanksAnsParams;
import mx.utils.Delegate;

class AdobeCaptivate.quiz.CpFillTheBlank extends CpQuizView
{
	// These are required for createClassObject()
	static var symbolName:String = "CpFillTheBlank";
	static var symbolOwner:Object = AdobeCaptivate.quiz.CpFillTheBlank;

	// Version string
//#include "../core/ComponentVersion.as"

	var className:String = "CpFillTheBlank";

	// reference to bounding box
	private var boundingBoxQ_mc:MovieClip;
	
	static var QUESTIONPHRASE:String = "QUESTIONPHRASE";
	private var _QuestionPhrase_params:CpItemParams;

	private var ans_array:Array;
	private var numAnswers:Number = 0;
	
	//constants for type of user input
	static var TEXTINPUT:Number = 0;
	static var COMBOBOX:Number = 1;
	
	
	function mytrace(str:String)
	{
		//trace("CpFillTheBlank---" + str);
	}
	
	function CpFillTheBlank()
	{
		slideType = FILLTHEBLANK;
		ans_array = new Array();
	}

	// initialize variables
	function init():Void
	{
		//mytrace("init");
		super.init();
		// Since we have a bounding box, we need to hide it and make sure 
		// that its width and height are set to 0.  Notice that we are not using 
		// "this" as we used to in AS1.  In AS2 the compiler automatically
		// references the class members.
		boundingBoxQ_mc._visible = false;
		boundingBoxQ_mc._width = boundingBoxQ_mc._height = 0;
	}
	
	// create the mask and make it invisible
	function createChildren(Void):Void
	{
		super.createChildren();
	}

/**
* @public
* create the question item
* if linkageID is given then label is ignored, 
* and it tries to load the MC referred by linageID
*/
	public function createQuestionPhrase(label:String, linkageID:String, x:Number, y:Number, width:Number, height:Number):Void
	{
		if(_QuestionPhrase_params != undefined)
			return;

		_QuestionPhrase_params = new CpItemParams();

		var param:CpItemParams = _QuestionPhrase_params;
		param._name = QUESTIONPHRASE;
		if(linkageID != null && linkageID.length > 0)
		{
			param._movie = true;
			param._component = createChild( linkageID, "questionPhrase_mc");
		}
		else
		{
			param._font.name = "Arial";		param._font.size = 20;		param._font.bBold = true;
			param._component = createChild( "CpLabel", "questionPhrase_lbl", {text: label, hAlign: "center", vAlign: "center"});
		}
		setItemCoordinates(QUESTIONPHRASE, x, y, width, height);
	}

	// if we get invalidated just call super
	function invalidate(Void):Void
	{
		//mytrace("invalidate");
		super.invalidate();
	}

	// redraw by re-laying out
	function draw(Void):Void
	{
		//mytrace("draw");
		size();
	}

	// respond to size changes
	function size(Void):Void
	{
		//mytrace("size");
		super.size();
	}

/**
* @private
* override this to find out when a new object is added that needs to be layed out
* @param object the layout object
*/
	function addLayoutObject(object:Object):Void
	{
		
	}

	function initLayout():Void
	{
		//mytrace("initlayout");
		super.initLayout();
	}
/**
* @private
* override this to layout the content
*/
	function doLayout():Void
	{
		//mytrace("inside dolayout");
		super.doLayout();
		var p:CpItemParams = _QuestionPhrase_params;
		if(p != undefined)
			setItemParams(p._component, p);
				
		for(var i:Number = 0; true; i++)
		{
			if(ans_array[i] == undefined)
				break;
			//trace("FIB -- " + i);
			p = ans_array[i];
			setItemParams(p._component, p);
		}
		
	}
	
	private function getItemParams(item:String):CpItemParams
	{
		for(var i:Number = 0; true; i++)
		{
			if(ans_array[i] == undefined)
				break;
			if(item.toUpperCase() == ("ANS"+i))
				return ans_array[i];
		}
		if(item.toUpperCase() == QUESTIONPHRASE)
			return _QuestionPhrase_params;
		else
			return super.getItemParams(item);
	}

	function createTextAnsField(newLabel:String, x:Number, y:Number, width:Number, height:Number)
	{
		createInputFields(numAnswers, newLabel, TEXTINPUT);
		setItemCoordinates(("ANS"+numAnswers), x, y, width, height)
		numAnswers++;
	}

	function createListAnsField(newLabel:String, x:Number, y:Number, width:Number, height:Number)
	{	
		createInputFields(numAnswers, newLabel, COMBOBOX);
		setItemCoordinates(("ANS"+numAnswers), x, y, width, height)
		numAnswers++;
	}
	
	private function createInputFields(ansNum:Number, newLabel:String, type:Number)
	{
		var p:CpFillBlanksAnsParams = new CpFillBlanksAnsParams();
		ans_array[ansNum] = p;
		p._font.name = "Arial";
		p._font.size = 14;
		if(type == TEXTINPUT)
		{
			p._type = TEXTINPUT;
			p._component = createChild("CpAnsTextInput", "Ans_"+ansNum.toString());
			var comp:CpAnsTextInput = CpAnsTextInput(p._component);
			comp.label = newLabel;
		}
		else
		{
			p._type = COMBOBOX;
			p._component = createChild("CpAnsComboBox", "Ans_"+ansNum.toString());
			var comp:CpAnsComboBox = CpAnsComboBox(p._component);
			comp.label = newLabel;
		}
		p._name = "ANS"+ansNum;
	}
	

	function addAnswers(ansNum:Number, words:Array, correctWords:Array, caseSensitive:Boolean)
	{
		var p:CpFillBlanksAnsParams = CpFillBlanksAnsParams(ans_array[ansNum - 1]);
		//trace("ansNum = " + ansNum + " p = " + p);
		p.words_arr = words;
		if(p._type == COMBOBOX)
		{
			var comp:CpAnsComboBox = CpAnsComboBox(p._component);
			comp.addItems(words);
		}
		p.correctWords_arr = correctWords;
		p.caseSensitive = caseSensitive;
	}
	
/*****
	function getUserAnswers():Array
	{
		var ans:Array = new Array;
		var p:CpFillBlanksAnsParams;
		for(var i:Number = 0; true; i++)
		{
			if(ans_array[i] == undefined)
				break;
			p = CpFillBlanksAnsParams(ans_array[i]);
			if(p._type == TEXTINPUT)
			{
				var comp:CpAnsTextInput = CpAnsTextInput(p._component);
				ans[i] = comp.text;
			}
		}
		return ans;
	}

	function setUserAnswers(ans:Array)
	{
		var p:CpFillBlanksAnsParams;
		for(var i:Number = 0; true; i++)
		{
			if(ans_array[i] == undefined)
				break;
			p = CpFillBlanksAnsParams(ans_array[i]);
			if(p._type == TEXTINPUT)
			{
				var comp:CpAnsTextInput = CpAnsTextInput(p._component);
				comp.text = ans[i];
			}
		}
	}
	
	private function isCorrectAnswer(ansNum:Number, ansText:String):Boolean
	{
		var p:CpFillBlanksAnsParams = CpFillBlanksAnsParams(ans_array[ansNum]);
		if(p._type == TEXTINPUT)
		{
			for(var i:Number = 0; i < p.words_arr.length; i++)
			{
				var word:String = p.words_arr[i];
				if(p.caseSensitive)
				{
					if(ansText == word)
						return true;
				}
				else if(ansText.toUpperCase() == word.toUpperCase())
					return true;
			}
			return false;
		}
		return false;
	}
	
	private function isBlank():Boolean
	{
		var p:CpFillBlanksAnsParams;
		for(var i:Number = 0; true; i++)
		{
			if(ans_array[i] == undefined)
				break;
			p = CpFillBlanksAnsParams(ans_array[i]);
			var comp:CpAnsTextInput = CpAnsTextInput(p._component);
			if(comp.text != "")
				return false;
		}
		return true;
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
			
		var p:CpFillBlanksAnsParams;
		for(var i:Number = 0; true; i++)
		{
			if(ans_array[i] == undefined)
				break;
			p = CpFillBlanksAnsParams(ans_array[i]);
			var comp:CpAnsTextInput = CpAnsTextInput(p._component);
			if(comp.text == "")
			{
				quesStatus = INCOMPLETE;
				break;
			}
			else if(isCorrectAnswer(i, comp.text) == false)
			{
				quesStatus = INCORRECT;
				break;
			}
			else
				quesStatus = CORRECT;
		}
		
		return quesStatus;
	}
	
	function enableUserInput(e:Boolean)
	{
		for(var i:Number = 0; true; i++)
		{
			if(ans_array[i] == undefined)
				break;
			ans_array[i]._component.enabled = e;
		}
		
		enableClearButton(e);
		enableSubmitButton(e);
	}
*****/	
	private function clear(evt)
	{
		clearAll();
	}

	function clearAll()
	{
		for(var i:Number = 0; true; i++)
		{
			if(ans_array[i] == undefined)
				break;
			ans_array[i]._component.text = "";
		}
	}
	
	
	/*
	* disables all user inputs and enable the hit button 
	* /
	private function showHitButton()
	{
		enableUserInput(false);
		enableNextButton(false);
		enableBackButton(false);
		super.showHitButton();
	}
	*/
	
	/*
	* displays the feedback as per the user input
	* if correct answer is given or the attempts 
	* are over then hitbutton is shown
	* /
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
		{
			var userAns:Array = getUserAnswers();
			var correctAns:Array = Array();
			
			var p:CpFillBlanksAnsParams; 
			for(var i:Number = 0; true; i++)
			{
				if(ans_array[i] == undefined)
					break;
				p = CpFillBlanksAnsParams(ans_array[i]);
				if(p._type == TEXTINPUT)
				{
					//trace("before concat correctAns = " + correctAns + " p.words_arr = " + p.words_arr);
					correctAns = correctAns.concat(p.words_arr);
					//trace("after concat correctAns = " + correctAns + " p.words_arr = " + p.words_arr);
				}
			}
			comp.showIncorrectMsg(userAns.toString(), correctAns.toString());
		}
		setItemVisible(REVIEWAREA, true);
		comp.useHandCursor = true;
	}
	********/
	
	function get answerParams():Array { 
		return ans_array; 
	}
	
}