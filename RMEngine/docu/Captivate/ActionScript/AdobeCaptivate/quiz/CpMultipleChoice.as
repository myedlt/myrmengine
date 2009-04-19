//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.controls.RadioButton;
import mx.controls.CheckBox;
import AdobeCaptivate.quiz.CpQuizView;
import AdobeCaptivate.quiz.CpReviewArea;
import AdobeCaptivate.quiz.CpAnsRadioButton;
import AdobeCaptivate.quiz.CpAnsCheckBox;
import AdobeCaptivate.quiz.utils.CpItemParams;
import AdobeCaptivate.quiz.utils.CpMultiChoiceAnsParams;
import mx.core.UIComponent;
import mx.utils.Delegate;

[Event("clear")]
class AdobeCaptivate.quiz.CpMultipleChoice extends CpQuizView 
{
	// These are required for createClassObject()
	static var symbolName:String = "CpMultipleChoice";
	static var symbolOwner:Object = AdobeCaptivate.quiz.CpMultipleChoice;

	// Version string
//#include "../core/ComponentVersion.as"

	var className:String = "CpMultipleChoice";

	// reference to bounding box
	private var boundingBoxQ_mc:MovieClip;
	
	private var ans_array:Array;
	
	private var numAnswers:Number = 0;
	
	static var MULTIPLE:Number = 1;
	static var SINGLE:Number = 0;
	
	private var _answertype:Number = MULTIPLE; 
	
	function mytrace(str:String)	{
		//trace("CpMultipleChoice---" + str);
	}
	
	function CpMultipleChoice()	{
		ans_array = new Array();
		slideType = MULTIPLECHOICE; 
	}

	// initialize variables
	function init():Void
	{
		super.init();
		// Since we have a bounding box, we need to hide it and make sure 
		// that its width and height are set to 0. 
		boundingBoxQ_mc._visible = false;
		boundingBoxQ_mc._width = boundingBoxQ_mc._height = 0;
	}
	
	// create the mask and make it invisible
	function createChildren(Void):Void
	{
		super.createChildren();
	}

	// if we get invalidated just call super
	function invalidate(Void):Void
	{
		super.invalidate();
	}

	// redraw by re-laying out
	function draw(Void):Void
	{
		size();
	}

	// respond to size changes
	function size(Void):Void
	{
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
		super.initLayout();
	}
/**
* @private
* override this to layout the content
*/
	function doLayout():Void
	{
		super.doLayout();
		var p:CpMultiChoiceAnsParams;
			
		for(var i in ans_array)
		{
			p = ans_array[i];
			//trace(p._component);
			
			setItemParams(p._component, p);
		}
		
	}
	
	private function getItemParams(item:String):CpItemParams
	{
		for(var i:Number = 0; i < ans_array.length; i++)
		{
			if(item.toUpperCase() == ("ANS"+i))
				return ans_array[i];
		}
		return super.getItemParams(item);
	}
	
	function setType(nType:Number)
	{	//0: single answer, 1:multiple answer
		if(numAnswers == 0)
			_answertype = nType;
	}
	
	function getType():Number
	{
		return _answertype;
	}

	function createAnsField(newLabel:String, isCorrect:Boolean, answerID:String, x:Number, y:Number, width:Number, height:Number)
	{	
		var comp:UIComponent = createAnswerComp(newLabel, numAnswers);

		var p:CpMultiChoiceAnsParams = new CpMultiChoiceAnsParams();
		p._font.name = "Arial";		p._font.size = 12;
		p._name = "ANS"+numAnswers;
		if(_answertype == MULTIPLE)
			p._component = CpAnsCheckBox(comp);
		else
			p._component = CpAnsRadioButton(comp);
		p.isCorrect = isCorrect;
		p.answerID = answerID;
		ans_array[numAnswers] = p;
		setItemCoordinates("ANS"+numAnswers, x, y, width, height);
		numAnswers++;
		
		invalidate();
	}
	
	private function createAnswerComp(newText:String, ansNum:Number):UIComponent
	{
		var comp:MovieClip;
		if(_answertype == MULTIPLE)
			comp = createChild("CpAnsCheckBox", "Ans_ti_"+ansNum.toString(), {label:newText});
		else
			comp = createChild("CpAnsRadioButton", "Ans_ti_"+ansNum.toString(), {label:newText,groupName:"MCQ"});
		
		return UIComponent(comp);
	}
	
	private function clear(evt)
	{
		//dispatchEvent({type:"clear", name:evt.target, target:this});
		clearAll();
	}

	function clearAll()
	{
		for(var i:Number = 0; i < ans_array.length; i++)
			ans_array[i]._component.selected = false;
	}
	
/////////////////////
/***	
	function getUserAnswers():Array
	{
		var ans:Array = new Array;
		for(var i:Number = 0; i < ans_array.length; i++)
			ans[i] = (ans_array[i]._component.selected) ? 1 : 0;
		return ans;
	}

	function setUserAnswers(ans:Array)
	{
		for(var i:Number = 0; i < ans_array.length; i++)
			ans_array[i]._component.selected = (ans[i] == 1) ? true : false;
	}
	
	private function isCorrectAnswer(ansNum:Number, ansText:String):Boolean
	{
		var correct:Boolean = false;
		var p:CpMultiChoiceAnsParams;
		for(var i:Number = 0; i < ans_array.length; i++)
		{
			p = ans_array[i];
			if(p.isCorrect &&  !p._component.selected)
				return false;
			correct = true;
		}
		return correct;
	}
	
	private function isBlank():Boolean
	{
		for(var i:Number = 0; i < ans_array.length; i++)
		{
			if(ans_array[i]._component.selected)
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
			
		if(isCorrectAnswer)
			return CORRECT;
		
		return INCORRECT;
	}
	
	function enableUserInput(e:Boolean)
	{
		for(var i:Number = 0; i < ans_array.length; i++)
			ans_array[i]._component.enabled = e;
		
		enableClearButton(e);
		enableSubmitButton(e);
	}
	
	
	/*
	* displays the feedback as per the user input
	* if correct answer is given or the attempts 
	* are over then hitbutton is shown
	* /
	function submitAns()
	{
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
			var userAns:String = "";
			var correctAns:String = "";
			for(var i:Number = 0; i < ans_array.length; i++)
			{
				var nIndex:Number;
				if(ans_array[i]._component.selected)
				{
					nIndex = ans_array[i]._component.label.indexOf(")");
					if(nIndex != -1)
					{
						userAns += ans_array[i]._component.label.slice(0, nIndex);
						userAns += ",";
					}
				}
				if(ans_array[i].isCorrect)
				{
					nIndex = ans_array[i]._component.label.indexOf(")");
					if(nIndex != -1)
					{
						correctAns += ans_array[i]._component.label.slice(0, nIndex);
						correctAns += ",";
					}
				}
			}
			comp.showIncorrectMsg(userAns, correctAns);
		}
		setItemVisible(REVIEWAREA, true);
		comp.useHandCursor = true;
	}
****/
	public function get answerParams():Array
	{
		/**
		var ansParams:Array = new Array();
		for(var i in ans_array)
		{
			ansComps[i] = ans_array[i]._component;
		}
		return ansComps;
		**/
		//trace("ans_array.length" + ans_array.length);
		return ans_array;
	}
}