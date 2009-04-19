//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"
import MMQuizzingV3.MMQuizClasses.Question;
import MMQuizzingV3.MMQuizClasses.Feedback;
import MMQuizzingV3.MMQuizClasses.AnswerScore;
//import MMQuizzingV3.MMQuizClasses.MultipleChoiceAnswerAccImpl;

import mx.utils.Delegate;

[Event("chooseAnswer")]
[Event("chooseCorrectAnswer")]
[Event("chooseIncorrectAnswer")]
[Tagname("MultipleChoiceAnswer")]
class MMQuizzingV3.MMQuizClasses.MultipleChoiceAnswer extends Object {
	var	className:String = "MultipleChoiceAnswer";
	
	public var isCorrect:Boolean = false;
	public var isTrueAnswer:Boolean = false;
	//public var useWholeButtonHilite:Boolean = false;
	//public var mouseOverHiliteColor:Number = 0x75AEEB;
	//public var mouseOverHiliteAlpha:Number = 50;
	public var answerID:String = "";
	public var _compMC:MovieClip = null;
	
	private var _feedback:Feedback = null;
	private var _retryFeedback:Feedback = null;
	private var _answerScore:AnswerScore;
	private var _question:Question;

	function get question():Question
	{
		/****
		var theParent:Object = _parent;
		while (theParent) {
			if (theParent.className == "Question") {
				return Question(theParent);
			} else if (theParent._question.className = "Question") {
				return Question(theParent._question);
			} else {
				theParent = theParent._parent;
			}
		}
		return null;
		****/
		return _question;
	}
	
	function set question(qs:Question)
	{
		_question = qs;
	}
	
	function get answered():Boolean
	{
		//trace(_compMC + "  " + _compMC.selected);
		return _compMC.selected;
	}
	
	function get answeredCorrectly():Boolean
	{
		return (_compMC.selected == isCorrect);
	}
	
	function get chosenAnswer():String
	{
		if (_compMC.selected) {
			return "1";
		} else {
			return "0";
		}
	}
	
	function get correctAnswer():String
	{
		if (isCorrect) {
			return "1";
		} else {
			return "0";
		}
	}
	
	function get answerScore():AnswerScore
	{
		return _answerScore;
	}
	
	function get feedback():Feedback
	{
		if (_feedback && ((Number(_feedback.audioClipID) != -1) || (_feedback.actionType != ""))) {
			return(_feedback);
		} else {
			return null;
		}
	}
	
	function set feedback(theFeedback:Feedback):Void
	{
		_feedback = theFeedback;
	}
	
	function get retryFeedback():Feedback
	{
		if (_retryFeedback) {
			return(_retryFeedback);
		} else {
			return null;
		}
	}
	
	function set retryFeedback(theFeedback:Feedback):Void
	{
		_retryFeedback = theFeedback;
	}

	public function setFromAnswerScore(answerScore:AnswerScore)
	{
		if (answerScore.chosenAnswer == "1") {
			_compMC.setSelected(true);
		} else {
			_compMC.setSelected(false);
		}
	}

	public function initAnswerScore()
	{
		if ((answerID != undefined) && (answerID.length > 0)) {
			_answerScore = new AnswerScore();
			_answerScore.answerType = className;
			_answerScore.answerID = answerID;
			_answerScore.isTrueAnswer = isTrueAnswer;
			if (isCorrect) {
				_answerScore.correctAnswer = "1";
			} else {
				_answerScore.correctAnswer = "0";
			}
			_answerScore.chosenAnswer = "0";
		}
	}

	function MultipleChoiceAnswer() 
	{
	}
	

	public function init() 
	{
		//super.init();
		//setGroupName("answerGroup");
		//trace("init  = " + _compMC);
		question.registerAnswer(this);
		_compMC.doLater(this, "initAnswerScore");
		_compMC.addEventListener("setState", Delegate.create(this,onSetState));
	}

	function onSetState(ev)
	{
		//trace("Caught state changed = " + ev.target + " _compMC = " + _compMC);
		if(ev.target == _compMC)
		{
			if (_compMC.selected) {
				_answerScore.chosenAnswer = "1";
			} else {
				_answerScore.chosenAnswer = "0";
			}
			//trace("_answerScore.chosenAnswer = "+ _answerScore.chosenAnswer);
		}
	}
	
	function setStateVar(state:Boolean):Void
	{
		_compMC.setStateVar(state);
		if (_compMC.selected) {
			_answerScore.chosenAnswer = "1";
		} else {
			_answerScore.chosenAnswer = "0";
		}
		
	}

	
	function answerChosen():Void
	{
		_compMC.dispatchEvent({type:"chooseAnswer", target:this});
		_answerScore.chosenAnswer = this.chosenAnswer;
		if (this.answeredCorrectly) {
			_compMC.dispatchEvent({type:"chooseCorrectAnswer", target:this});
		} else {
			_compMC.dispatchEvent({type:"chooseIncorrectAnswer", target:this});
		}
	}
	
	function setSelected (val:Boolean):Void
	{
		_compMC.setSelected(val);
		answerChosen();
	}
	
	
	function clearAnswer():Void
	{
		_compMC.setSelected(false);
	}
	
	function set enabled(e:Boolean):Void
	{
		_compMC.enabled = e;
	}
	
}
