//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"
import MMQuizzingV3.MMQuizClasses.Question;
//import MMQuizzingV3.MMQuizClasses.DragText;
//import MMQuizzingV3.MMQuizClasses.Feedback;
import MMQuizzingV3.MMQuizClasses.AnswerScore;


class MMQuizzingV3.MMQuizClasses.MatchAnswer extends Object {
	var	className:String = "MatchAnswer";

	public var answerID:String = "";

	private var _correctAnswer:String;
//	private var _prevChoice:String;
//	public var _choiceEntry:TextInput;
//	public var _dragText:DragText;
//	private var _retryFeedback:Feedback = null;
	private var _answerScore:AnswerScore;
	private var _question:Question;
	public var _compMC:MovieClip;

	function get question():Question
	{
		/****
			return Question(theParent._question);
		****/
		return _question;
	}
	
	function set question(qs:Question)
	{
		_question = qs;
	}
		
	function get chosenAnswer():String
	{
		return _compMC.text;
	}
	
	function get correctAnswer():String
	{
		return _correctAnswer;
	}

	
	function set correctAnswer(answer:String):Void
	{
		/*
		var n:Number = answer.length-1;
		while (answer.charAt(n) == " ") {
			n--;
		}
		_correctAnswer = answer.substr(0,n+1);
		*/
		_correctAnswer = answer;
	}
	
	function get answered():Boolean
	{
		return (_compMC.text.length > 0);
	}
	
	function get answeredCorrectly():Boolean
	{
		return (_compMC.text == correctAnswer);
	}
	
	function setEnabled(enabled:Boolean):Void
	{
		if (!enabled != _compMC.enabled) {
			_compMC.enabled = enabled;
			//_dragText.enabled = enabled;
		}
		//super.setEnabled(enabled);
	}
	
	/***
	public function get choiceEntry():TextInput
	{
		return _choiceEntry;
	}
	***/
	
	
	function MatchAnswer() 
	{
	}
	
	public function init() 
	{
		//_prevChoice = "";
		super.init();
		//doLater(this, "setupTextInput");
		question.registerAnswer(this);
		_compMC.addEventListener("changed", this);
		//_compMC.doLater(this, "initAnswerScore");
		initAnswerScore();
	}
	
	/***
	private function setupTextInput():Void
	{
		_choiceEntry.setStyle("fontFamily", textInputFontFamily);
		_choiceEntry.setStyle("fontSize", textInputFontSize);
		_choiceEntry.setStyle("backgroundColor", textInputBackgroundColor);
		_choiceEntry.setStyle("borderWidth", textInputBorderWidth);
		_choiceEntry.useHandCursor = false;
		_choiceEntry.tabEnabled = true;
		_choiceEntry.focusEnabled = true;
		_choiceEntry.restrict = "A-Z a-z 0-9";
		_choiceEntry.addEventListener("change", this);
		_choiceEntry.addEventListener("enter", this);
		_choiceEntry.maxChars = 1;
		_dragText.tabEnabled = false;
		_dragText.focusEnabled = false;
		
	}
	***/
	/***
	private function cleanupTextInput():Void
	{
		if (_choiceEntry.text.length > 1) {
			// Regardless of whether the insertion point was before
			// or after the previous text, we want to always get
			// the most-recently typed character.  Since the 
			// TextInput component doesn't give us the insertion
			// point,we look at the two characters.  Either the
			// previously-typed answer is at position 0 or 
			// position 1.  Whereever it is, we take the other
			// one.
			if (_choiceEntry.text.charAt(0) == _prevChoice) {
				_choiceEntry.text = _choiceEntry.text.charAt(1);
			} else {
				_choiceEntry.text = _choiceEntry.text.charAt(0);
			}
		}
		_choiceEntry.text = _choiceEntry.text.toUpperCase();
		answerChosen();
	}
	***/
	function changed(evObj:Object):Void
	{
		answerChosen();
	}
	
	function enter(evObj:Object):Void
	{
		answerChosen();
	}

	/****
	function dragRelease(dropTarget:DragText):Void
	{
		if (dropTarget) {
			var us = this;
			us._choiceEntry.text = dropTarget.choiceID;
			dropTarget.eraseHilite();
			dropTarget = null;
		}
		answerChosen();
	}
	***/
	
	public function clearAnswer():Void
	{
		_compMC.text = "";
		//_prevChoice = "";
		//clear();
	}

	/***
	public function setFocus():Void
	{
		_choiceEntry.setFocus();
	}
	
	private function findMatchingTarget(choiceID:String):DragText
	{
		if (choiceID.length != 1) return null;
		
		for (var elt in question) {
			if (question[elt].choiceID == choiceID) {
				return question[elt];
			}
		}
		return null;
	}
	
	private function connectRectsWithLine(sourceBounds:Object, destBounds:Object)
	{
		clear();
		lineStyle(lineWidth, lineColor, 100 );
		moveTo(sourceBounds.xMax, (sourceBounds.yMax+sourceBounds.yMin)/2);
		lineTo(destBounds.xMin-4, (destBounds.yMax+destBounds.yMin)/2);
	}
	
	
	private function drawTargetLink()
	{
		clear();
		var matchingTarget:DragText;
		matchingTarget = findMatchingTarget(_choiceEntry.text);

		if (matchingTarget) {
			var sourceBounds = getBounds(this);
			var destBounds = matchingTarget.getBounds(this);
			if (sourceBounds.xMin < destBounds.xMin) {
				connectRectsWithLine(sourceBounds, destBounds);
			} else {
				connectRectsWithLine(destBounds, sourceBounds);
			}
		}
	}
	***/

	public function answerChosen():Void
	{
		//_prevChoice = _choiceEntry.text;
		_answerScore.chosenAnswer = _compMC.text;
		//trace("_answerScore.chosenAnswer = " + _answerScore.chosenAnswer);
		//drawTargetLink();
		_compMC.dispatchEvent({type:"chooseAnswer", target:_compMC});
		if (this.answeredCorrectly) {
			_compMC.dispatchEvent({type:"chooseCorrectAnswer", target:_compMC});
		} else {
			_compMC.dispatchEvent({type:"chooseIncorrectAnswer", target:_compMC});
		}
	}
	
		
	function get answerScore():AnswerScore
	{
		return _answerScore;
	}
	
	/***

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
	***/

	public function setFromAnswerScore(answerScore:AnswerScore)
	{
		_compMC.text = answerScore.chosenAnswer;
		answerChosen();
	}

	public function initAnswerScore()
	{
		_answerScore = new AnswerScore();
		_answerScore.answerType = className;
		_answerScore.answerID = answerID;
		_answerScore.correctAnswer = _correctAnswer
		_answerScore.chosenAnswer = "";
	}
		
}
