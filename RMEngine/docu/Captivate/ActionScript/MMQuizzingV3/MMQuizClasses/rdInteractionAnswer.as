//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"
import MMQuizzingV3.MMQuizClasses.AnswerScore;
import MMQuizzingV3.MMQuizClasses.Question;


class MMQuizzingV3.MMQuizClasses.rdInteractionAnswer extends UIComponent {
	static var symbolName:String = "rdInteractionAnswer";
	static var symbolOwner:Object = Object(rdInteractionAnswer);
	var	className:String = "rdInteractionAnswer";


	public var answerID:String = "";
	public var answered:Boolean = false;
	public var answeredCorrectly:Boolean = false;	
	public var correctAnswers:Array = null;
	//public var overrideAccessibility:Boolean = true;
	public var answerText:String;
	private var _answerScore:AnswerScore = null;
	private var _enabled:Boolean;
	
	public var prevChosenAnswer:String = "";
	
	public function get question():Question
	{
		return Question(_parent);
	}
	

	function get chosenAnswer():String
	{
		if (!answered) {
			return "";
		} else {
			return answerText;
		}
		return
	}
	
	function get correctAnswer():String
	{
		var retVal:String = "";
		if (correctAnswers.length > 0) {
			retVal = correctAnswers[0];
		}
		for (var i=1; i < correctAnswers.length; i++) {
			retVal = retVal.concat(",",  correctAnswers[i]);
		}
		return retVal;
	}

	public function get correctAnswersAsString():String
	{
		return this.correctAnswer;
	}

	public function init() 
	{
		correctAnswers = [];
		//_enabled = true;
		super.init();
		question.registerAnswer(this);
		initAnswerScore();

	}
	
		
	public function rdInteractionAnswer()
	{
	}

	public function clearAnswer():Void
	{
	}
		
	function submit(ansText:String, isCorrect:Boolean) 
	{
//		if (success) {
//			answerText = "1";
//			answeredCorrectly = true;
//		} else {
//			answerText = "0";
//			answeredCorrectly = false;
//		}
		//_root.debl("in rdInteractionAnswer.submit()");
		answerText = ansText;
		answeredCorrectly = isCorrect;
		answered = true;
		answerChosen();
	}
	
	/****
	function setEnabled(enabled:Boolean)
	{
		_enabled = enabled;
	}
	
	function isEnabed():Boolean
	{
		return _enabled;
	}
	****/
	
	public function answerChosen():Void
	{
		initAnswerScore(); // to catch the case where correctAnswer & answerID is set after init 
		_answerScore.chosenAnswer = this.chosenAnswer;
		prevChosenAnswer = this.chosenAnswer;
		this.dispatchEvent({type:"chooseAnswer", target:this});
		if (this.answeredCorrectly) {
			this.dispatchEvent({type:"chooseCorrectAnswer", target:this});
		} else {
			this.dispatchEvent({type:"chooseIncorrectAnswer", target:this});
		}
	}
	
		
		
	function get answerScore():AnswerScore
	{
		return _answerScore;
	}
	

	public function setFromAnswerScore(theAnswerScore:AnswerScore)
	{
		//trace("setFromAnswerScore theAnswerScore.chosenAnswer = " + theAnswerScore.chosenAnswer);
		prevChosenAnswer = theAnswerScore.chosenAnswer;
	}

	public function initAnswerScore()
	{
		if (!_answerScore) {
			_answerScore = new AnswerScore();
		}
		_answerScore.answerType = className;
		_answerScore.answerID = answerID;
		_answerScore.correctAnswer = correctAnswer;
		_answerScore.chosenAnswer = "";
		clearAnswer();
	}
}

/* To do:
- Initialize correctAnswers array (for button and click area, is just ["1"]
- Wire up rdInteractionAnswer.setEnabled() to enable the button/click area
- Call rdInteractionAnswer.submit() when answer is chosen (item is clicked on either inside or outside)
- Make interaction's numTries backing store be the Question.numTries
- When the number of retries is reached, or correct answer chosen, call Question.endQuestion(isScored)
- Need to do quizController's default action if no feedback-specific action provided
*/