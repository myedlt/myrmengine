//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"
import MMQuizzingV3.MMQuizClasses.Feedback;
import MMQuizzingV3.MMQuizClasses.AnswerScore;
import MMQuizzingV3.MMQuizClasses.Question;
import MMQuizzingV3.MMQuizClasses.QuestionScore;


class MMQuizzingV3.MMQuizClasses.LikertAnswer extends Object {
	var	className:String = "LikertAnswer";

	public var answerID:String = "";
	public var correctAnswerID:Number;	// Index into allAnswers array.
	public var allAnswers:Array;
	public var interactionType:String = "likert";
	public var interactionID:String = "";
	public var objectiveID:String = "";
	public var weighting:Number = 0;
	public var _responseCount:Number = 0;

	private var _retryFeedback:Feedback = null;
	private var _answerScore:AnswerScore;
	public var radioGroup:RadioButtonGroup;
	private var _inited = false;
	private var _dataExt:String;
	
	private var _question:Question;

/**
	public function get responseCount():Number
	{
		return _responseCount;
	}


	public function set responseCount(theCount:Number)
	{
		_responseCount = theCount;
		var i:Number;
		var mc;
		for (i = 8; i > 0; i--)
		{
			mc = this["radioButton_mc"+i];
			// Remove unnecessary radio buttons
			if (i > theCount) {
				mc.removeMovieClip();
			} else {
				mc.setGroupName("radioGroup");
				mc.setGroupName("radioGroup");	// Not sure why, but have to do this twice, or else last radioButton isn't part of radioGroup
			}

		}
	}

	public function get dataExt():String
	{
		return _dataExt;
	}

	public function set dataExt(data:String):Void
	{
		_dataExt = data;
		var myXML:XML = null;
		var anAnswer:XMLNode;
		var answerProp:XMLNode;

		this.allAnswers = [];
		myXML = new XML(data);
		for (anAnswer = myXML.firstChild.firstChild; anAnswer != null; anAnswer=anAnswer.nextSibling) {
			for (answerProp = anAnswer.firstChild; answerProp != null; answerProp=answerProp.nextSibling) {
				if (answerProp.attributes.id=="10064") {	// PROPERTY_RESPONSE_VALUE
					var theAnswer = answerProp.attributes.value;
					allAnswers.push(theAnswer);
				}
			}
		}

	}
**/

	function get question():Question
	{
		return _question;
	}
	
	function set question(qs:Question)
	{
		_question = qs;
	}
	
	function get chosenAnswerID():Number
	{
		var selectedRB:RadioButton = RadioButton(radioGroup.selectedRadio);
		if (selectedRB == null) {
			return -1;
		}
		var buttonName:String = selectedRB._name;
		if (buttonName == null) {
			return -1;
		}
		var i:Number;
		var s:String;
		s = "radioButton_mc";
		i = buttonName.lastIndexOf(s);
		i += s.length;
		buttonName = buttonName.substring(i, buttonName.length);
		return Number(buttonName);
	}

	function get chosenAnswer():String
	{
		var id = this.chosenAnswerID-1;
		//trace("id = " + id);
		if (id >= 0) {
			//trace("allAnswers[id] = " + allAnswers[id]);
			return allAnswers[id];
			
		} else {
			return "";
		}
	}
	
	function get correctAnswer():String
	{
		return chosenAnswer();
	}

	

	function get answered():Boolean
	{
		//trace(" answered ?= radioGroup = " + radioGroup + " radioGroup.selectedRadio = " + radioGroup.selectedRadio);
		return ((radioGroup.selectedRadio != null) && (radioGroup.selectedRadio != undefined));
	}
	
	function get answeredCorrectly():Boolean
	{
		return true;
	}
	
	function set enabled(enabled:Boolean):Void
	{
		//trace("enabled = " + enabled);
		radioGroup.setEnabled(enabled);
	}


	
	function LikertAnswer()
	{
		//init();
	}
	
	
	public function init() 
	{
		if (!_inited) {
			super.init();
			question.registerAnswer(this);
			//tabChildren = true;
			//tabEnabled = false;
			//focusEnabled = false;
			//doLater(this, "initAnswerScore");
			initAnswerScore();
			_inited = true;
		}

	}

	
	public function clearAnswer():Void
	{
		for (var i in radioGroup.radioList) {
			radioGroup.radioList[i].setSelected(false);
		}
	}
	

	public function answerChosen():Void
	{
		_answerScore.chosenAnswer = this.chosenAnswer;
		_answerScore.correctAnswer = this.chosenAnswer;
		//trace("_answerScore.chosenAnswer = " + _answerScore.chosenAnswer);
		/**
		this.dispatchEvent({type:"chooseAnswer", target:this});
		if (this.answeredCorrectly) {
			this.dispatchEvent({type:"chooseCorrectAnswer", target:this});
		} else {
			this.dispatchEvent({type:"chooseIncorrectAnswer", target:this});
		}
		**/
	}
	
		
	function click(evObj:Object):Void
	{
		answerChosen();
	}

		
	function get answerScore():AnswerScore
	{
		return _answerScore;
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
		var theChosenAnswerID:Number = -1;
		for (theChosenAnswerID in allAnswers) {
			if (allAnswers[theChosenAnswerID] == answerScore.chosenAnswer) {
				for (var radioID in radioGroup.radioList) {
					var buttonName:String = radioGroup.radioList[radioID]._name;
					var s:String = "radioButton_mc";
					var j:Number = buttonName.lastIndexOf(s)+s.length;
					buttonName = buttonName.substring(j, buttonName.length);
					if ((Number(buttonName)-1) == theChosenAnswerID) {
						radioGroup.radioList[radioID].setSelected(true);
						answerChosen();
						return;
					}
				}
			}
		}
	}

	public function getQuestionScore():QuestionScore
	{
		
		var qs:QuestionScore = new QuestionScore();
		
		qs.slideNum = question.questionScore.slideNum;
		qs.startTime = question.questionScore.startTime;
		qs.endTime = question.questionScore.endTime;
		qs.interactionType = this.interactionType;
		qs.objectiveID = this.objectiveID;
		qs.interactionID = this.interactionID;
		qs.weighting = this.weighting;
		qs.answerScores = [];
		qs.answerScores.push(answerScore.copy());
		qs.numTries = question.questionScore.numTries;
		qs.answersIncomplete = !this.answered;
		qs.pausedMsecs = question.questionScore.pausedMsecs;
		qs.questionNumInQuiz = question.questionScore.questionNumInQuiz;
		qs.wasJudged = question.questionScore.wasJudged;
		qs.answeredCorrectly = true;

		return qs;
	}

	public function initAnswerScore()
	{
		_answerScore = new AnswerScore();
		_answerScore.answerType = className;
		_answerScore.answerID = answerID;
		_answerScore.correctAnswer = correctAnswer;
		_answerScore.chosenAnswer = "";
		for (var i in radioGroup.radioList) {
			var rb:RadioButton = RadioButton(radioGroup.radioList[i]);
			rb.useHandCursor = true;
			rb.addEventListener("click",this);
			radioGroup.radioList[i].useHandCursor = true;
			
		}
		
		clearAnswer();
		
	}
		

	
}
