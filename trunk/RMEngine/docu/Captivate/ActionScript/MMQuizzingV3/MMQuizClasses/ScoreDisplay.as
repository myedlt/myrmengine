//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"

import MMQuizzingV3.MMQuizClasses.QuizController;

class MMQuizzingV3.MMQuizClasses.ScoreDisplay extends MovieClip {

	 private var _score:Number; 
	 private var _maxScore:Number;
	 private var _numQuestions:Number;
	 private var _numRetries:Number;
	 private var _numQuizAttempts:Number;
	 private var _percentCorrect:String;
	 private var _numQuestionsCorrect:Number
	 private var _feedback:String;
	 var passed:Boolean;
	 private var _scoreLbl:MovieClip;
	 private var _maxScoreLbl:MovieClip;
	 private var _numQuestionsLbl:MovieClip;
	 private var _numQuizAttemptsLbl:MovieClip;
	 private var _percentCorrectLbl:MovieClip;
	 private var _numQuestionsCorrectLbl:MovieClip;
	 private var _feedbackLbl:MovieClip;
	 private var _numRetriesLbl:MovieClip;

	 private var _quizController:QuizController;


	function ScoreDisplay()
	{
	}
	
	public function set quizController(theController:QuizController)
	{
		_quizController = theController;
	}

	public function get quizController():QuizController
	{
		return _quizController;
	}

	public function set score(newScore:Number)
	{
		_score = newScore;
		//trace("_scoreLbl = " + _scoreLbl + " _score = " + _score);
		if (_scoreLbl) {
			_scoreLbl.text = newScore;
		}
	}
	public function get score():Number
	{
		return _score;
	}

	public function set maxScore(newMaxScore:Number)
	{
		_maxScore = newMaxScore;
		if (_maxScoreLbl) {
			_maxScoreLbl.text = newMaxScore;
		}
	}
	public function get maxScore():Number
	{
		return _maxScore;
	}
	
	public function set numQuestions(newNumQuestions:Number)
	{
		_numQuestions = newNumQuestions;
		if (_numQuestionsLbl) {
			_numQuestionsLbl.text = newNumQuestions;
		}
	}
	public function get numQuestions():Number
	{
		return _numQuestions;
	}
	
	public function set numRetries(newNumRetries:Number)
	{
		_numRetries = newNumRetries;
		if (_numRetriesLbl) {
			_numRetriesLbl.text = newNumRetries;
		}
	}
	public function get numRetries():Number
	{
		return _numRetries;
	}
	
	public function set numQuizAttempts(newNumQuizAttempts:Number)
	{
		var me = this;
		_numQuizAttempts = newNumQuizAttempts;
		if (_numQuizAttemptsLbl) {
			_numQuizAttemptsLbl.text = newNumQuizAttempts;
		}
	}
	public function get numQuizAttempts():Number
	{
		return _numQuizAttempts;
	}
	
	public function set percentCorrect(newPercentCorrect:String)
	{
		var me = this;
		_percentCorrect = newPercentCorrect;
		if (_percentCorrectLbl) {
			_percentCorrectLbl.text = newPercentCorrect;
		}
	}
	public function get percentCorrect():String
	{
		return _percentCorrect;
	}

	public function set numQuestionsCorrect(newNumQuestionsCorrect:Number)
	{
		var me = this;
		_numQuestionsCorrect = newNumQuestionsCorrect;
		if (_numQuestionsCorrectLbl) {
			_numQuestionsCorrectLbl.text = newNumQuestionsCorrect;
		}
	}
									
	public function get numQuestionsCorrect():Number
	{
		return _numQuestionsCorrect;
	}

	public function set feedback(newFeedback:String)
	{
		var me = this;
		_feedback = newFeedback;
		if (_feedbackLbl) {
			_feedbackLbl.text = newFeedback;
		}

	}
	public function get feedback():String
	{
		return _feedback;
	}

	public function reviewAnswers()
	{
		quizController.playbackController.reviewAnswersForCurrentQuiz();
	}

	public function doContinue()
	{
		quizController.playbackController.gotoNextSlide();
	}

	function init()
	{
		super.init();
	}
}