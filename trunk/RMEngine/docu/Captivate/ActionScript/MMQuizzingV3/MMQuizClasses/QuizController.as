//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"
import MMQuizzingV3.MMQuizClasses.QuizParams;
import MMQuizzingV3.MMQuizClasses.PlaybackController;
import MMQuizzingV3.MMQuizClasses.Question;
import MMQuizzingV3.MMQuizClasses.QuestionScore;
import MMQuizzingV3.MMQuizClasses.SlideInfo;
import MMQuizzingV3.MMQuizClasses.ScoreDisplay;
//import MMQuizzingV3.MMQuizClasses.ReviewFeedback;
//import MMQuizzingV3.MMQuizClasses.QuizProgress;
import MMQuizzingV3.MMQuizClasses.QuizState;



[Event("enterReviewMode")]
[Event("leaveReviewMode")]
class MMQuizzingV3.MMQuizClasses.QuizController extends UIObject {	

	private var _quizParams:QuizParams;
	private var _playbackController:PlaybackController;
	private var _quizInProgress:Boolean = false;
	private var _inReviewMode:Boolean = false;
	private var _questionScores:Array;
	private var _sawPassScoreSlide:Boolean = false;
	private var _sawFailScoreSlide:Boolean = false;
	private var _sawAnyScoreSlide:Boolean = false;
	private var _numStarts:Number = 0;
	private var _numFinishes:Number = 0;
	private var _restoringState:Boolean = false;
	
	function QuizController()	{	_questionScores = [];	}
	
	function init()	{	super.init();	}

	public function get sawPassScoreSlide():Boolean	{	return _sawPassScoreSlide;	}
	public function set sawPassScoreSlide(sawIt:Boolean)	{	_sawPassScoreSlide = sawIt;	}

	public function get sawFailScoreSlide():Boolean	{	return _sawFailScoreSlide;	}
	public function set sawFailScoreSlide(sawIt:Boolean)	{	_sawFailScoreSlide = sawIt;	}

	public function get sawAnyScoreSlide():Boolean	{	return _sawAnyScoreSlide;	}
	public function set sawAnyScoreSlide(sawIt:Boolean)	{	_sawAnyScoreSlide = sawIt;	}

	public function get quizParams():QuizParams	{	return _quizParams;	}
	public function set quizParams(newParams:QuizParams)	{	_quizParams = newParams;	}

	public function get playbackController():PlaybackController	{	return _playbackController;	}
	public function set playbackController(newController:PlaybackController)	{	_playbackController = newController;	}
	
	public function get inReviewMode():Boolean	{	return _inReviewMode;	}
	public function set inReviewMode(inMode:Boolean)
	{
		/***/
		if (inMode && !_inReviewMode) {
			dispatchEvent({type:"enterReviewMode", target:this});
		} else if (!inMode && _inReviewMode) {
			dispatchEvent({type:"leaveReviewMode", target:this});
		}
		/***/
		_inReviewMode = inMode;
	}
	
	public function get questionScores():Array	{	return _questionScores;	}
	public function set questionScores(scores:Array)	{	_questionScores = scores;	}
	
	public function getQuestionScore(questionNum:Number):QuestionScore
	{
		for (var i in questionScores) {
			var qs:QuestionScore = _questionScores[i];
			gtrace("questionNum = " + questionNum + " qs.questionNumInQuiz = " + qs.questionNumInQuiz);
			if (qs.questionNumInQuiz == questionNum) {
				return qs;
			}
		}
		return null;
	}
	
	public function get score():Number
	{
		var total:Number = 0;
		
		for (var i in questionScores) {
			var qs:QuestionScore = questionScores[i];
			if (!isNaN(qs.score)) {
				total += qs.score;
			}
		}
		return total;
	}
	
	public function saveQuestionScore(question:Question) 
	{
		if (!inReviewMode && !restoringState) {
			addQuestionScore(question.questionScore);
			question._questionScore = null;
		}
	}
	
	
		
	public function addQuestionScore(qs:QuestionScore)
	{
		for (var i in questionScores) {
			if (questionScores[i].questionNumInQuiz == qs.questionNumInQuiz) {
				questionScores[i] = qs;
				return;
			}
		}
		// not found
		questionScores.push(qs);
	}
	
	public function enterCurrentSlide()
	{
		var slide:SlideInfo = playbackController.currentSlide;

		if (this != playbackController.quizControllerForSlide(slide)) {
			return;	// Not our slide...we don't care
		}

		var slideType:String = quizParams.getSlideType(slide);
		var slideIsScoreSlide:Boolean = false;
		gtrace("enterCurrentSlide slideType = " + slideType);
		switch (slideType) {
			case "question":
				if (!quizInProgress && !inReviewMode) {
					// startQuiz
					quizInProgress = true;
				}
				break;
			case "passScoreSlide":
				slideIsScoreSlide = true;
				sawPassScoreSlide = true;
				break;
			case "failScoreSlide":
				slideIsScoreSlide = true;
				sawFailScoreSlide = true;
				break;
			case "anyScoreSlide":
				slideIsScoreSlide = true;
				sawAnyScoreSlide = true;
				break;
			default:
				break;
		}
		/****/
		var currentQuestions:Array = getQuestionsForCurrentSlide();
		//gtrace(" currentQuestions = " + currentQuestions);
		if (currentQuestions.length > 0) {
			for (var i in currentQuestions) {
				var currentQuestion:Question = Question(currentQuestions[i]);
				currentQuestion.quizController = this;
				this.startQuestion(currentQuestion);

			}
		} else 
		/****/
		if (slideIsScoreSlide) {
			gtrace("Enter score slide");
			gtrace("score = " + score);
			gtrace("scoreDisplay = " + scoreDisplay);
			gtrace("score = " + score);
			gtrace("maxScore = " + maxScore);
			gtrace("numQuestions = " + numQuestions);
			gtrace("totalRetries = " + totalRetries);
			gtrace("isPassed = " + isPassed);
			scoreDisplay.score = score;
			scoreDisplay.maxScore = maxScore;
			scoreDisplay.numQuestions = this.numQuestions;
			scoreDisplay.numRetries = totalRetries;
			scoreDisplay.numQuizAttempts = numStarts;
			scoreDisplay.percentCorrect = percentCorrect;
			scoreDisplay.numQuestionsCorrect = this.numQuestionsCorrect;
			scoreDisplay.passed = isPassed;
			if (isPassed) {
				scoreDisplay.feedback = quizParams.passedScoreFeedback;
			} else {
				scoreDisplay.feedback = quizParams.failedScoreFeedback;
			}
			scoreDisplay.quizController = this;
		}
		gtrace(" QC::sending course data");
		playbackController.sendCourseData(false);
	}
	
	public function startQuestion(currentQuestion:Question)
	{
		gtrace("starting the question");
		currentQuestion.slide = playbackController.currentSlide;
		currentQuestion.startQuestion(inReviewMode, getQuestionScore(currentQuestion.questionNumInQuiz));
	}
	
	public function get currentSlideContainer():Object
	{
		return playbackController.currentSlideContainer;
	}
	
	public function get currentMovieContainer():Object
	{
		return playbackController.currentMovieContainer;
	}

	public function get scoreDisplay():ScoreDisplay
	{
		gtrace("QuizController currentSlideContainer = " + currentSlideContainer);
		return currentSlideContainer._scoreDisplay;
	}

	public function slideAfter(slide:SlideInfo):SlideInfo
	{
		if (this != playbackController.quizControllerForSlide(slide)) {
			return null;	
		}
		
		with (quizParams) {
			var pbcontroller:PlaybackController = this.playbackController;
			var slideType:String = getSlideType(slide);
			gtrace("QC::slideAfter slideType = " + slideType);
			switch (slideType) {
				case "passScoreSlide":
					if (passingGradeAction == "gotoSlide") {
						return pbcontroller.getSlide(Number(passingGradeActionArg1));
					} else if (failScoreSlide) {
						return pbcontroller.getSlide(failScoreSlide.slideNum+1);
					} else {
						return pbcontroller.getSlide(passScoreSlide.slideNum+1);
					}
					break;
				case "failScoreSlide":
					if ((failingGradeAction == "gotoSlide") && (this.numStarts >= numQuizAttemptsAllowed)) {
						return pbcontroller.getSlide(Number(failingGradeActionArg1));
					} else {
						return pbcontroller.getSlide(failScoreSlide.slideNum+1);
					}
					break;
				case "anyScoreSlide":
					if (anyGradeAction == "gotoSlide") {
						return pbcontroller.getSlide(Number(anyGradeActionArg1));
					} else if ((passingGradeAction == "gotoSlide") && (this.score >= passingScore)) {
						return pbcontroller.getSlide(Number(passingGradeActionArg1));
					} else if ((failingGradeAction == "gotoSlide") && (this.score < passingScore) && (this.numStarts >= numQuizAttemptsAllowed)) {
							return pbcontroller.getSlide(Number(failingGradeActionArg1));
					} else {
						return pbcontroller.getSlide(anyScoreSlide.slideNum+1);
					}
					break;
				case "question":
				default:
					var lastQuestionSlide:SlideInfo = this.lastQuestionSlideInQuiz;
					if (slide.slideNum < lastQuestionSlide.slideNum) {
						var nextNum:Number = slide.slideNum+1;
						return(pbcontroller.getSlide(slide.slideNum+1));
					} else if (this.isScoreSlide(pbcontroller.getSlide(slide.slideNum+1))) {
						if (this.score >= passingScore) {
							if (passScoreSlide) {
								return passScoreSlide;
							} else if (anyScoreSlide) {
								return anyScoreSlide;
							} else if (failScoreSlide) {
								return pbcontroller.getSlide(failScoreSlide.slideNum+1);
							} else {
								return pbcontroller.getSlide(lastQuestionSlide.slideNum+1);
							}
						} else {
							if (failScoreSlide) {
								return failScoreSlide;
							} else if (anyScoreSlide) {
								return anyScoreSlide;
							} else {
								return pbcontroller.getSlide(passScoreSlide.slideNum+1);
							}
						}
					} else {
						if (anyGradeAction == "gotoSlide") {
							return pbcontroller.getSlide(Number(anyGradeActionArg1));
						} else if ((passingGradeAction == "gotoSlide") && (this.score >= passingScore)) {
							return pbcontroller.getSlide(Number(passingGradeActionArg1));
						} else if ((failingGradeAction == "gotoSlide") && (this.score < passingScore) && (this.numStarts >= numQuizAttemptsAllowed)) {
							return pbcontroller.getSlide(Number(failingGradeActionArg1));
						} else {
							return pbcontroller.getSlide(slide.slideNum+1);
						}
					}
					break;
			}
		}
	}

	public function slideBefore(slide:SlideInfo):SlideInfo
	{
		
        	if (this != this.playbackController.quizControllerForSlide(slide)) {
        		gtrace("slideBefore:: wrong controller");
			return null;
		}
		with (quizParams) {
			var slideType:String = getSlideType(slide);
			gtrace("slideBefore:: slideType = " + slideType);
			switch (slideType) {
				case "question":
				case "passScoreSlide":
				case "failScoreSlide":
				case "anyScoreSlide":
					return this.playbackController.getSlide(slide.slideNum-1);
					break;
			}
		}
	}

	public function canEnterSlide(slide:SlideInfo):String
	{
		if (this != playbackController.quizControllerForSlide(slide)) {
			return "";	// Not our slide...we don't care
		}
		
		var toSlideType:String = quizParams.getSlideType(slide);
		var slideIsScoreSlide:Boolean = false;
		if (onScoreSlide && (toSlideType == "question") && !inReviewMode && (this.numStarts >= quizParams.numQuizAttemptsAllowed)) {
			// don't allow re-entry into quiz if not in review mode and
			// too many quiz attempts already.
			return("QUIZ_ERROR_TOO_MANY_QUIZ_ATTEMPTS");
		}
		if (!quizInProgress || 
			((quizParams.questionAdvance == "optional") && (totalRetries > 0))) {
			// we're allowed to advance past the end of the questions
			switch (toSlideType) {
				case "question":
					if (!inReviewMode && !quizInProgress && (this.numStarts >= quizParams.numQuizAttemptsAllowed)) {
						return("QUIZ_ERROR_TOO_MANY_QUIZ_ATTEMPTS");
					}
					break;
				case "passScoreSlide":
					if (score < quizParams.passingScore) {
						return "QUIZ_ERROR_MUST_PASS_QUIZ_TO_SEE_PASS_SCORE_SLIDE";
					}
					slideIsScoreSlide = true;
					break;
				case "failScoreSlide":
					if (score >= quizParams.passingScore) {
						return "QUIZ_ERROR_MUST_FAIL_QUIZ_TO_SEE_FAIL_SCORE_SLIDE";
					}
					slideIsScoreSlide = true;
					break;
				case "anyScoreSlide":
					slideIsScoreSlide = true;
					break;
			}
			//GS {we should be checking whether quizzing is in progress or not
			//	as with optional quizzing, user may not have answered any question at all
			//  Even the error message says the same}
			//if (slideIsScoreSlide && !anyQuestionsAnswered) {
			gtrace("quizInProgress == " + quizInProgress);
			if (slideIsScoreSlide && !quizInProgress) {
				return "QUIZ_ERROR_MUST_START_QUIZ_TO_SEE_SCORE_SLIDE";
			}
		} else {
			// not allowed to advance past questions -- quiz not finished
			switch (toSlideType) {
				case "question":
					return "";
					break;
				case "passScoreSlide":
				case "failScoreSlide":
				case "anyScoreSlide":
					//return "QUIZ_ERROR_MUST_FINISH_QUIZ_TO_SEE_SCORE_SLIDE"; 
					return "";  // Fix bug #104588 -- don't require interaction to be judged to see scoring screen
					break;
			}
		}
		return "";
	}
	
	public function canLeaveSlide(fromSlide:SlideInfo, movingBackward:Boolean, currSlide:SlideInfo):String
	{
		if (this != playbackController.quizControllerForSlide(fromSlide)) {
			return "";	// Not our slide...we don't care
		}

		var fromSlideType:String = quizParams.getSlideType(fromSlide);
		switch (fromSlideType) {
			case "question":
				// If we're on a question, see if we are allowed to advance past it
				var questionScore:QuestionScore = getQuestionScore(lastQuestionOnCurrentSlide.questionNumInQuiz);
				gtrace("canLeaveSlide questionScore = " + questionScore);
				switch (quizParams.questionAdvance) {
					case "mustAnswer":
						if (!movingBackward && (!questionScore || (questionScore.numTries == 0))) {
							return "QUIZ_ERROR_MUST_ANSWER_QUESTION";
						}
						break;
					case "mustAnswerCorrectly":
						if (!movingBackward && (!questionScore || !questionScore.answeredCorrectly())) {
							return "QUIZ_ERROR_MUST_ANSWER_CORRECTLY";
						}
						break;
					case "optional":
					default:
						// do further checks below
						break;
					
				}
				// If we're the last question, see if we can advance past the end of the quiz
				if (!movingBackward && (fromSlide.sameSlideAs(lastQuestionSlideInQuiz))) {
					// last question in slide
					if ((quizParams.quizAdvance == "mustTake") && !anyQuestionsAnswered && (this.numStarts <= 1)) {
						return "QUIZ_ERROR_MUST_TAKE_QUIZ";
					}
				} else if (movingBackward) {
					if (!inReviewMode && !quizParams.allowBackwardMovementInQuiz && (currSlide == fromSlide)) {
							// This prohibits *any* backward movement
							// (to a question or a non-question slide
							// before the quiz).
							return "QUIZ_ERROR_CANNOT_MOVE_BACKWARD_IN_QUIZ";
					}
				}
				break;
			case "passScoreSlide":
				if (!quizParams.allowSkipPassScoreSlide && (score >= quizParams.passingScore) && !sawPassScoreSlide && quizInProgress) {
					return "QUIZ_ERROR_MUST_SEE_PASS_SCORE_SLIDE";
				}
				if (!movingBackward && (quizParams.quizAdvance == "mustPass") && (score < quizParams.passingScore)) {
					return "QUIZ_ERROR_MUST_PASS_QUIZ";
				}
				break;
			case "failScoreSlide":
				if (!quizParams.allowSkipFailScoreSlide && (score < quizParams.passingScore) && !sawFailScoreSlide && quizInProgress) {
					return "QUIZ_ERROR_MUST_SEE_FAIL_SCORE_SLIDE";
				}
				if (!movingBackward && (quizParams.quizAdvance == "mustPass") && (score < quizParams.passingScore)) {
					return "QUIZ_ERROR_MUST_PASS_QUIZ";
				}
				break;
			case "anyScoreSlide":
				if (!quizParams.allowSkipFailScoreSlide && !sawAnyScoreSlide  && quizInProgress) {
					return "QUIZ_ERROR_MUST_SEE_SCORE_SLIDE";
				}
				if (!movingBackward && (quizParams.quizAdvance == "mustPass") && (this.score < quizParams.passingScore)) {
					return "QUIZ_ERROR_MUST_PASS_QUIZ";
				}
				break;
			default:
				break;
		}

			

		return "";
	}

	public function leaveCurrentSlide(toSlide:SlideInfo)
	{
		//gtrace("in QuizController.leaveCurrentSlide, toSlide # = "+toSlide.slideNum);
		var fromSlide:SlideInfo = playbackController.currentSlide;
		var isLeavingQuiz:Boolean;
		if (this != playbackController.quizControllerForSlide(fromSlide)) {
			return;	// Not our slide...we don't care
		}
		if (playbackController.restoringQuizState) {
			playbackController.restoringQuizState = false;
			return;
		}
		var slideType:String = quizParams.getSlideType(fromSlide);
		isLeavingQuiz = this.leavingQuiz(fromSlide,toSlide);
		with (quizParams) {
			switch (slideType) {
				case "question":
					var currentQuestions:Array = this.getQuestionsForCurrentSlide();
					for (var i in currentQuestions) {
						var currentQuestion:Question = currentQuestions[i];
						if (currentQuestion) {
							gtrace("leaveCurrentSlide endQuestion");
							currentQuestion.endQuestion(false);
							currentQuestion.clearAnswers();
							currentQuestion.leaveSlide();
						}
					}
					if (isLeavingQuiz) {
						if ((passingGradeAction.length > 0) && (this.score >= passingScore)) {
							this.doQuizAction(passingGradeAction, passingGradeActionArg1, passingGradeActionArg2);
						} else if ((failingGradeAction.length > 0) && (this.score < passingScore) && (this.numStarts >= numQuizAttemptsAllowed)) {
							this.doQuizAction(failingGradeAction, failingGradeActionArg1, failingGradeActionArg2);
						} else if (anyGradeAction.length > 0) {
							this.doQuizAction(anyGradeAction, anyGradeActionArg1, anyGradeActionArg2);
						}
					}
					break;
				case "passScoreSlide":
					if (!this.inReviewMode) {
						isLeavingQuiz = true;
					}
					if (isLeavingQuiz) {
						if (passingGradeAction.length > 0) {
							this.doQuizAction(passingGradeAction, passingGradeActionArg1, passingGradeActionArg2);
						} else if (anyGradeAction.length > 0) {
							this.doQuizAction(anyGradeAction, anyGradeActionArg1, anyGradeActionArg2);
						}
					}
					break;
				case "failScoreSlide":
					if (!this.inReviewMode) {
						isLeavingQuiz = true;
					}
					if (isLeavingQuiz) {
						if ((failingGradeAction.length > 0) && (this.numStarts >= numQuizAttemptsAllowed)) {
							this.doQuizAction(failingGradeAction, failingGradeActionArg1, failingGradeActionArg2);
						} else if (anyGradeAction.length > 0) {
							this.doQuizAction(anyGradeAction, anyGradeActionArg1, anyGradeActionArg2);
						}
					}
					break;
				case "anyScoreSlide":
					if (!this.inReviewMode) {
						isLeavingQuiz = true;
					}
					if (isLeavingQuiz) {
						if ((passingGradeAction.length > 0) && (this.score >= passingScore)) {
							this.doQuizAction(passingGradeAction, passingGradeActionArg1, passingGradeActionArg2);
						} else if ((failingGradeAction.length > 0) && (this.score < passingScore) && (this.numStarts >= numQuizAttemptsAllowed)) {
							this.doQuizAction(failingGradeAction, failingGradeActionArg1, failingGradeActionArg2);
						} else if (anyGradeAction.length > 0) {
							this.doQuizAction(anyGradeAction, anyGradeActionArg1, anyGradeActionArg2);
						}
					}
					break;
				default:
					break;
				}
				if (isLeavingQuiz) {
					this.quizInProgress = false;
				}
				if (this.leavingReviewMode(fromSlide,toSlide)) {
					this.inReviewMode = false;
				}
		}


	}

	public function get numStarts():Number
	{
		return _numStarts;
	}
	
	public function set numStarts(num:Number)
	{
		_numStarts = num;
	}

	public function get lastQuestionOnCurrentSlide():Question
	{
		var theQuestions:Array = getQuestionsForCurrentSlide()
		var lastQuestion:Question = null;
		for (var i in theQuestions) {
			var currentQuestion:Question = theQuestions[i];
			if (!lastQuestion || (currentQuestion.questionNumInQuiz > lastQuestion.questionNumInQuiz)) {
				lastQuestion = currentQuestion;
			}
		}
		return lastQuestion;
	}

	public function get firstQuestionSlideInQuiz():SlideInfo
	{
		var firstSlide:SlideInfo = null;
		for (var i in playbackController.slides) {
			var currSlide:SlideInfo = playbackController.slides[i];
			if ((currSlide.slideNum >= quizParams.firstSlideInQuiz.slideNum) && 
				(currSlide.slideNum <= quizParams.lastSlideInQuiz.slideNum)) {
				if ((!firstSlide || (currSlide.slideNum < firstSlide.slideNum)) && 
					(currSlide.questionsOnSlide.length > 0)) {
					firstSlide = currSlide;
				}
			}
		}
		return firstSlide;
	}

	public function get lastQuestionSlideInQuiz():SlideInfo
	{
		var lastSlide:SlideInfo = null;
		for (var i in playbackController.slides) {
			var currSlide:SlideInfo = playbackController.slides[i];
			if ((currSlide.slideNum >= quizParams.firstSlideInQuiz.slideNum) && 
				(currSlide.slideNum <= quizParams.lastSlideInQuiz.slideNum)) {
				if ((!lastSlide || (currSlide.slideNum > lastSlide.slideNum)) && 
					(currSlide.questionsOnSlide.length > 0)) {
					lastSlide = currSlide;
				}
			}
		}
		return lastSlide;
	}

	public function isScoreSlide(slide:SlideInfo):Boolean
	{
		var slideType:String = quizParams.getSlideType(slide);
		switch (slideType) {
			case "passScoreSlide":
			case "failScoreSlide":
			case "anyScoreSlide":
				return true;
			default:
				return false;
		}
	}

	public function get onScoreSlide():Boolean
	{
		var curSlide:SlideInfo = playbackController.currentSlide;
		if (this != playbackController.quizControllerForSlide(curSlide)) {
			return false;
		} else {
			return isScoreSlide(curSlide);
		}
	}

	public function get quizInProgress():Boolean
	{
		return _quizInProgress;
	}

	public function set quizInProgress(inProgress:Boolean)
	{
		if (inProgress && !_quizInProgress) {
			resetQuestionScores();
			_inReviewMode = false;
			_sawPassScoreSlide = false;
			_sawFailScoreSlide = false;
			_sawAnyScoreSlide = false;
			++numStarts;
			onStartQuiz();
		} else if (!inProgress && _quizInProgress) {
			_inReviewMode = false;
			++numFinishes;
			onEndQuiz();
		}
		_quizInProgress = inProgress;
	}

	public function get anyQuestionsAnswered():Boolean
	{
		for (var i in questionScores) {
			var qs:QuestionScore = questionScores[i];
			if (qs.wasJudged && !qs.answersIncomplete) {
				return true;
			}
		}
		return false;
	}

	public function leavingQuiz(fromSlide:SlideInfo, toSlide:SlideInfo):Boolean
	{

		if (quizInProgress) {
			if (toSlide.slideNum >= fromSlide.slideNum) {
				return (toSlide.slideNum > quizParams.lastSlideInQuiz.slideNum);
			} else {
				// moving backward
				return (toSlide.slideNum < this.firstQuestionSlideInQuiz.slideNum)
			}
		} else {
			return false;
		}
	}

	public function getQuestionsForCurrentSlide():Array
	{
		var container:Object = currentSlideContainer;
		var result:Array = [];
		//gtrace("getQuestionsForCurrentSlide container = " + container);
		for (var prop in container) {
			if (prop.indexOf("_question") == 0) {
				result.push(container[prop]);
			}
		}
		return result;
	}

	public function doGetURL(actionArg1:String, actionArg2:String)
	{
		switch (actionArg2) {
			case "0":
			case 0:
				actionArg2 = "_self";
				break;
			case "1":
			case 1:
				actionArg2 = "_blank";
				break;
		}
		getURL(actionArg1, actionArg2);
	}

	public function doQuizAction(actionType:String, actionArg1:String, actionArg2:String) 
	{
		switch (actionType) {
			case "continue":
			case "gotoSlide":
				// handled in slideAfter
				break;
			case "movie":
				doGetURL(actionArg1, actionArg2);
				break;
			case "url":
				doGetURL(actionArg1, actionArg2);
				break;
			case "javascript":
				doGetURL("javascript:"+actionArg1);
				break;
			case "email":
				doGetURL("mailto:"+actionArg1);
				break;
			default:
				break;
		}
	}

	public function leavingReviewMode(fromSlide:SlideInfo, toSlide:SlideInfo):Boolean
	{
		if (inReviewMode) {
			if (toSlide.slideNum >= fromSlide.slideNum) {
				// moving forward
				return (toSlide.slideNum > quizParams.lastSlideInQuiz.slideNum);
			} else {
				// moving backward
				return (toSlide.slideNum < this.firstQuestionSlideInQuiz.slideNum);
			}
		} else {
			return false;
		}
	}

	function resetQuestionScores()
	{
		for (var i in questionScores) {
			var qs:QuestionScore = _questionScores[i];
			qs.resetScore();
		}
	}

	public function onStartQuiz()
	{
		if (quizFinishButton && quizParams.showFinishButton) {
			quizFinishButton._visible = true;
		}
	}

	public function onEndQuiz()
	{
		if (quizFinishButton) {
			quizFinishButton._visible = false;
		}
		playbackController.onEndQuiz(this);
	}

	public function get numFinishes():Number
	{
		return _numFinishes;
	}
	
	public function set numFinishes(num:Number)
	{
		_numFinishes = num;
	}

	public function get quizFinishButton():MovieClip
	{
		return currentSlideContainer._quizFinishButton;
	}

	public function get minScore():Number
	{
		return quizParams.minScore;
	}
	
	public function get maxScore():Number
	{
		return quizParams.maxScore;
	}

	public function get totalRetries():Number
	{
		var total:Number = 0;
		for (var i in questionScores) {
			var qs:QuestionScore = questionScores[i];
			total += qs.numTries;
		}
		return total;
	}
	
	public function get percentCorrect():String
	{
		gtrace("maxScore = " + maxScore + " score = " + score);
		if (maxScore == 0) {
			return " ";
		} else {
			var pct:Number;
			pct = Math.round(score*100.0/maxScore);
			gtrace("pct = " + pct);
			return pct+"%";		
		}

	}
	
	public function get numQuestions():Number
	{
		var total:Number = 0;
		for (var i in playbackController.slides) {
			var currSlide:SlideInfo = playbackController.slides[i];
			if ((currSlide.slideNum >= quizParams.firstSlideInQuiz.slideNum) && 
				(currSlide.slideNum <= quizParams.lastSlideInQuiz.slideNum)) {
				total += currSlide.questionsOnSlide.length;
			}
		}
		return total;
	}
	
	
	public function get numQuestionsCorrect():Number
	{
		var numCorrect:Number = 0;
		for (var i in questionScores) {
			var qs:QuestionScore = questionScores[i];
			if (qs.wasJudged && qs.answeredCorrectly) {
				numCorrect++;
			}
		}
		return numCorrect;
	}

	public function get isPassed():Boolean
	{
		var ip:Boolean = (score >= quizParams.passingScore);
		return (score >= quizParams.passingScore);
	}

	public function reviewAnswers()
	{
		if (quizParams.allowReviewMode) {
			inReviewMode = true;
			playbackController.gotoSlide(firstQuestionSlideInQuiz);
		}
	}

	public function getQuestion(interactionID:String):Object
	{
		var currentQuestions:Array = getQuestionsForCurrentSlide();
		gtrace("getQuestions currentQuestions = " + currentQuestions);
		if (currentQuestions.length > 0) 
		{
			for (var i in currentQuestions) 
			{
				var currentQuestion:Question = Question(currentQuestions[i]);
				gtrace("getQuestions currentQuestion.questionScore.interactionID = " + currentQuestion.questionScore.interactionID);
				if(currentQuestion.questionScore.interactionID == interactionID)
					return currentQuestion;
			}
		}
		return null;
	}
	
	public function get restoringState():Boolean
	{
		return _restoringState;
	}

	public function set restoringState(rs:Boolean)
	{
		_restoringState = rs;
	}
	
	function saveState(myState:QuizState)
	{
		myState.writeBoolean(_inReviewMode);
		gtrace(" QC:: _inReviewMode myState = " + myState.toString());
		myState.writeBoolean(_quizInProgress);
		gtrace(" QC:: _quizInProgress myState = " + myState.toString());
		myState.writeNumber(_numStarts);
		gtrace(" QC:: _numStarts myState = " + myState.toString());
		myState.writeNumber(_numFinishes);
		gtrace(" QC:: _numFinishes myState = " + myState.toString());
		myState.writeBoolean(_sawPassScoreSlide);
		gtrace(" QC:: _sawPassScoreSlide myState = " + myState.toString());
		myState.writeBoolean(_sawFailScoreSlide);
		gtrace(" QC:: _sawFailScoreSlide myState = " + myState.toString());
		myState.writeBoolean(_sawAnyScoreSlide);
		gtrace(" QC:: _sawAnyScoreSlide myState = " + myState.toString());
		myState.writeNumber(questionScores.length);
		gtrace(" QC:: questionScores.length myState = " + myState.toString());
		for (var whichQuestion = 0; whichQuestion < questionScores.length; whichQuestion++) {
			var qs:QuestionScore = questionScores[whichQuestion];
			qs.saveState(myState);
		}
	}
	
	
	function restoreState(myState:QuizState)
	{
		restoringState = true;
		_inReviewMode = myState.readBoolean();
		_quizInProgress = myState.readBoolean();
		_numStarts = myState.readNumber();
		_numFinishes = myState.readNumber();
		_sawPassScoreSlide = myState.readBoolean();
		_sawFailScoreSlide = myState.readBoolean();
		_sawAnyScoreSlide = myState.readBoolean();
		
		var numQuestions:Number = myState.readNumber();
		var whichQuestionScore;
		for (whichQuestionScore = 0; whichQuestionScore < numQuestions; whichQuestionScore++) {
			var qs:QuestionScore = new QuestionScore();
			qs.restoreState(myState);
			addQuestionScore(qs);
		}
		// It may be the case that the restore state comes in after the
		// initial question has started.  If this happens, we need to
		// restore the old answers into the currently displayed questions.
		for (whichQuestionScore in questionScores) {
			var questScore:QuestionScore = questionScores[whichQuestion];
			var currQuestions:Array = getQuestionsForCurrentSlide();
			for (var whichQuestion in currQuestions) {
				var currQuestion:Question = currQuestions[whichQuestion];
				if ((currQuestion.questionNumInQuiz == questScore.questionNumInQuiz) && (currQuestion.state == "playing")) {

					// end the current question.  since restoringState is true,
					// QuizController.saveQuestionScore won't record the current
					// questionScore.
					currQuestion.endQuestion(false);

					// now restart the current question in the right
					// mode with the right previous score
					currQuestion.startQuestion(_inReviewMode,questScore);

					// transfer old answers to the question.  Have to
					// do this explicitly because doLater() call of
					// this inside Question.startQuestion() won't have
					// time to fire...that case is only when the
					// question hasn't fully initialized yet but in
					// this case it already has
					currQuestion.resetPreviousAnswers();

				}
			}
		}
		restoringState = false;
	}

	public function get allQuestionsAnswered():Boolean
	{
		var slidesSeen:Array = [];
		// Make sure that all questions with nonzero weight have been
		// answered.
		for (i in questionScores) {
			slidesSeen[questionScores[i].slideNum] = true;
		}
		for (i = quizParams.firstSlideInQuiz.slideNum; i <= quizParams.lastSlideInQuiz.slideNum; i++) {
			if (!slidesSeen[i]) {
				var theSlide = playbackController.slides[i];  // Note that for Serrano, theSlide is actually of type SlideModel.
				if (theSlide && (theSlide.questionsOnSlide) && (theSlide.questionsOnSlide.length > 0)) {
					if (theSlide.questionWeights && (theSlide.questionWeights > 0)) {
						return false;
					}
				}
			}
		}
		// We can record a questionScore if the user sees a slide but
		// does not answer it completely.  Check for that case.
		for (var i in questionScores) {
			var qs:QuestionScore = questionScores[i];
			if ((qs.weighting > 0) &&  (!qs.wasJudged || qs.answersIncomplete)) {
				return false;
			}
		}
		return true;
	}

	public function finishQuiz()
	{
		if (quizInProgress) {
			var nextSlide:SlideInfo = null; 
			var curSlideType:String = quizParams.getSlideType(playbackController.currentSlide);
			switch (curSlideType) {
				case "question":
					nextSlide = slideAfter(lastQuestionSlideInQuiz);
					break;
				default:
					nextSlide = slideAfter(playbackController.currentSlide);
					break;
			}
			quizInProgress = false;
			playbackController.gotoSlide(nextSlide);
		}
	}

	public function get isAttemptFinished():Boolean
	{
		if ((numStarts > 0) && (numStarts == numFinishes)) {
			return true;
		}
		if (sawPassScoreSlide || sawFailScoreSlide || sawAnyScoreSlide) {
			return true;
		}
		return false;
	}
	
	public function sendInteractionData(questionScore:QuestionScore)
	{
		if (quizParams.isTracked) {
			playbackController.sendInteractionData(questionScore);
		}
	}

	public function doAction(question:Question)
	{
		gtrace("do Action question.questionScore.answeredCorrectly = " + question.questionScore.answeredCorrectly);
		if(question.questionScore.answeredCorrectly)
		{
			if(typeof(question.succeeded) == "function")
				question.succeeded(playbackController.currentSlide);
		}
		else if(typeof(question.failed) == "function")
			question.failed(playbackController.currentSlide);
		question.showHitButton(false);
		question.hideLastFeedback(false);
	}
	
	public function doDefaultAction(question:Question)
	{
		//gtrace("doDefaultAction numTries = " + question.numTries);
		// for Captivate (RoboDemo).  
		if (question.isSurvey || question.answeredCorrectly || (question.numTries >= question.numQuestionAttemptsAllowed)) {
			doAction(question);
		}
	}
	
/****
	public function doAction(actionType:String, actionArg1:String, actionArg2:String)
	{
		switch (actionType) {
			case "continue":
				Selection.setFocus(null);  // workaround crash bug in Flash Player 7
				playbackController.gotoNextSlide();
				break;
			case "gotoSlide":
				var theSlide:SlideInfo = null;

				theSlide = playbackController.findSlideByID(actionArg1);
				if (theSlide) {
					Selection.setFocus(null); // workaround crash bug in Flash Player 7
					playbackController.gotoSlide(theSlide);
				}
				break;
			case "movie":
				doGetURL(actionArg1, actionArg2);
				break;
			case "url":
				doGetURL(actionArg1, actionArg2);
				break;
			case "javascript":
				doGetURL("javascript:"+actionArg1);
				break;
			case "email":
				doGetURL("mailto:"+actionArg1);
				break;
			case "submit":
				//gtrace("calling currentSlideContainer.submit("+actionArg1+","+actionArg2+"), currentSlideContainer = "+currentSlideContainer);
				currentSlideContainer.submit(actionArg1, actionArg2);
				break;
			case "nextSlide":
				playbackController.gotoNextSlide();
				break;
			case "prevSlide":
				playbackController.gotoPrevSlide();
				break;
			default:
				break;
		}
	}
****/

	public function gtrace(str)	{ 
		return;
		if( System.capabilities.playerType == "PlugIn" || System.capabilities.playerType == "ActiveX" ||
			System.capabilities.playerType == "StandAlone")
			_root.debl(str);
		else
			gtrace(str);
	}

}
