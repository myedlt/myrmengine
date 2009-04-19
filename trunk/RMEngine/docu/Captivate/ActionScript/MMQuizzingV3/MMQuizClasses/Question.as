//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"
import MMQuizzingV3.MMQuizClasses.Feedback;
//import MMQuizzingV3.MMQuizClasses.Hint;
import MMQuizzingV3.MMQuizClasses.QuestionScore;
import MMQuizzingV3.MMQuizClasses.TimerBar;
import MMQuizzingV3.MMQuizClasses.QuizController;
import MMQuizzingV3.MMQuizClasses.SlideInfo;
import MMQuizzingV3.MMQuizClasses.ReviewFeedback;
import MMQuizzingV3.MMQuizClasses.AnswerScore;
//import MMQuizzingV3.MMQuizClasses.SubmitButton;
//import MMQuizzingV3.MMQuizClasses.ClearButton;
//import MMQuizzingV3.MMQuizClasses.MultipleChoiceAnswerAccImpl;
//import MMQuizzingV3.MMQuizClasses.MultipleChoiceMultipleAnswerAccImpl;
import MMQuizzingV3.MMQuizClasses.PlaybackController;
import MMQuizzingV3.MMQuizClasses.MultipleChoiceAnswer;
import MMQuizzingV3.MMQuizClasses.MultipleChoiceMultipleAnswer;
import MMQuizzingV3.MMQuizClasses.FillInTheBlankAnswer;
import MMQuizzingV3.MMQuizClasses.MatchAnswer;
import MMQuizzingV3.MMQuizClasses.LikertAnswer;

import AdobeCaptivate.quiz.CpQuizView;

[Event("showFeedback")]
[Event("hideFeedback")]
//[Event("showHint")]
//[Event("hideHint")]
[Event("judge")]
[Event("questionStarted")]
//[Event("questionPaused")]
//[Event("questionResumed")] 
[Event("questionEnded")]
class MMQuizzingV3.MMQuizClasses.Question extends UIComponent {	
	static var symbolName:String = "Question";
	static var symbolOwner:Object = Object(Question);
	var	className:String = "Question";
	
	public var isTracked:Boolean = true;
	public var isSurvey:Boolean = false;
//	public var useHint:Boolean = false;
//	public var questionText:String = "";
	public var timeLimitMSecs:Number = 0;
	public var mustAnswerAll:Boolean = false;
	
	private var _numQuestionAttemptsAllowed:Number = 1;
	private var _lastFeedbackShown:Feedback = null;
//	private var _navigationDirection:String;
	private var _answers:Array;
	private var _timerID;
	private var _timerProgressID;
	public var _questionScore:QuestionScore;
	private var _state:String;		// enumeration of "init", "playing", "paused", "ended"
//	private var _timeBeforePause:Number = 0;
	private var _correctFeedback:Feedback = null;
	private var _incorrectFeedback:Array;
	private var _numIncorrectFeedback:Number = 0;	// Number of failure levels (or incorrect feedback objects in the above array)
	private var _incompleteFeedback:Feedback = null;
	private var _retryFeedback:Feedback = null;
	private var _surveyFeedback:Feedback = null;
	private var _timeoutFeedback:Feedback = null;
//	private var _hint:Hint = null;
	private var _reviewFeedback:ReviewFeedback = null;
	private var _timerBar:TimerBar = null;
	private var _slide:SlideInfo = null;
	private var _questionNumInQuiz:Number = -1;
	private var _quizController:QuizController = null;
	private var _previousQuestionScore:QuestionScore = null;
	private var _inReviewMode = false;
	private var _eachAnswerIsSeparateInteraction = false;
	private var _submitBtn:Button;
	private var _clearBtn:Button;

//	private var _submitButton:SubmitButton;
//	private var _clearButton:ClearButton;
	private var _numTries = 0;
//	private var _accProps:Object;
	// NOTE: It is very important that we only use the tab indices in the range 
	// reserved for us (currently, 0xe000...0xefff). These values are currently
	// defined in SwfBuilder.h in the Star code.
	// @todo -- this is probably all wrong, re-examine
//	public var _curTabIndex:Number = 0xE000;
	private var _startingQuestion:Boolean = false;
/*
debug508 
	private var _sweepIndexStart:Number = 0;
	static private var _allTabIndices:Array;
*/
	public var succeeded:Function;
	public var failed:Function;
	
	private var _hitBtn:Button;
	
	public var isConstructed:Boolean = false;

	private var _quizComp:CpQuizView = null;

	//For sound
	private var m_gPlaySoundID:String = "";
	private var m_gSound:Sound = null;

	
	public function get quizComp():CpQuizView
	{
		return _quizComp;
	}
	public function set quizComp(qv:CpQuizView)
	{
		_quizComp = qv;
	}
/***	
	public function get quizID()
	{
		return quizController.quizParams.quizID;
	}
***/	
	public function get slide():SlideInfo
	{
		return _slide;
	}
	
	public function set slide(si:SlideInfo) 
	{
		_slide = si;
	}

	public function get questionNumInQuiz():Number
	{
		return _questionNumInQuiz;
	}
	
	public function set questionNumInQuiz(num:Number)
	{
		_questionNumInQuiz = num;
		//gtrace("_questionNumInQuiz = " + _questionNumInQuiz);
	}

	public function get answeredCorrectly():Boolean
	{
		if (isSurvey) {
			return true;
		}
		//trace("_answers.length = " + _answers.length);
		if (_answers.length == 0) {
			return false;
		}
		for (var ans in _answers) {
			//trace("_answers[ans].answeredCorrectly = " + _answers[ans].answeredCorrectly);
			if (!_answers[ans].answeredCorrectly) {
				return false;
			}
		}
		return true;
	}

	public function get answersIncomplete():Boolean
	{
		//gtrace("_answers " + _answers);
		for (var ans in _answers) {
			if (mustAnswerAll) {
				if (!_answers[ans].answered) {
					return true;
				}
			} else {
				if (_answers[ans].answered) {
					return false;
				}
			}

		}
		return !mustAnswerAll;
	}
	
	public function get numTries():Number
	{
		if (_questionScore) {
			return _questionScore.numTries;
		} else {
			return _numTries;
		}
		return _questionScore.numTries;
	}
	
	public function set numTries(tries:Number):Void
	{
		if (_questionScore) {
			_questionScore.numTries = tries;
		}
		_numTries = tries;
		//trace("tries = " + tries);
		if (tries >= _numQuestionAttemptsAllowed) {
			disableAnswers();
			if (_submitBtn != undefined) {
				_submitBtn.enabled = false;
			}
			if (_clearBtn != undefined) {
				_clearBtn.enabled = false;
			}
			if(!inReviewMode && _startingQuestion == false)
				showHitButton(true);
		}
	}

	public function get questionScore():QuestionScore
	{
		if (_questionScore) {
			return _questionScore;
		} else {
			return quizController.getQuestionScore(questionNumInQuiz);
		}
	}
	
	public function set questionScore(qs:QuestionScore)
	{
		_questionScore = qs;
	}
		
	

	public function get lastFeedbackShown():Feedback
	{
		return _lastFeedbackShown;
	}
	
	public function get correctFeedback():Feedback
	{
		if (_parent._correctFeedback)
			return _parent.correctFeedback;
		else
			return _correctFeedback;
	}

	// Can't use traditional "getter" here because we need an arg for the index
	public function getIncorrectFeedback(index:Number):Feedback
	{
		//trace(">>>Question<<< getIncorrectFeedback("+index+") - _numIncorrectFeedback="+_numIncorrectFeedback);
		if (index >= _numIncorrectFeedback)
			return null;
			
		if (_parent._incorrectFeedback[index]) 
			return _parent._incorrectFeedback[index];
		else 
			return _incorrectFeedback[index];
	}

	public function get incompleteFeedback():Feedback
	{
		if (_parent._incompleteFeedback) 
			return _parent._incompleteFeedback;
		else 
			return _incompleteFeedback;
	}

	public function get retryFeedback():Feedback
	{
		if (_parent.retryFeedback) 
			return _parent._retryFeedback;
		else 
			return _retryFeedback;
	}
/***
	public function get hint():Hint
	{
		if (_parent._hint) 
			return _parent._hint;
		else 
			return _hint;
	}
***/
	public function get surveyFeedback():Feedback
	{
		if (_parent._surveyFeedback) 
			return _parent._surveyFeedback;
		else {
			if (isSurvey && !_surveyFeedback) {
				return correctFeedback;
			} else {
				return _surveyFeedback;
			}

		}
	}

	public function get timeoutFeedback():Feedback
	{
		if (_parent._timeoutFeedback)
			return _parent._timeoutFeedback;
		else
			return _timeoutFeedback;
	}

/****gaurav***/
	public function registerCorrectFeedback(feedbackMC:MovieClip, audioID:String)
	{
		//gtrace("RegisterCorrectFeedback = " + feedbackMC);
		if(feedbackMC && !_correctFeedback)
		{
			_correctFeedback = new Feedback();
			_correctFeedback.question = this;
			_correctFeedback._compMC = feedbackMC;
			_correctFeedback.audioClipID = audioID;
			_correctFeedback.init();
			
			//gtrace("question.as" + _correctFeedback._compMC);
		}
	}

	public function registerFailureFeedback(index:Number, feedbackMC:MovieClip, audioID:String)
	{
		//gtrace("index = " + index + " _numIncorrectFeedback =  " + _numIncorrectFeedback);
		if(feedbackMC && !_incorrectFeedback[index] && index < _numIncorrectFeedback)
		{
			_incorrectFeedback[index] = new Feedback();
			_incorrectFeedback[index].question = this;
			_incorrectFeedback[index]._compMC = feedbackMC;
			_incorrectFeedback[index].audioClipID = audioID;
			_incorrectFeedback[index].init();
		}
	}

	public function registerIncompleteFeedback(feedbackMC:MovieClip, audioID:String)
	{
		gtrace("feedbackMC = " + feedbackMC + " audioID = " + audioID);
		if(feedbackMC && !_incompleteFeedback)
		{
			_incompleteFeedback = new Feedback();
			_incompleteFeedback.question = this;
			_incompleteFeedback._compMC = feedbackMC;
			_incompleteFeedback.audioClipID = audioID;
			_incompleteFeedback.init();
		}
	}

	public function registerRetryFeedback(feedbackMC:MovieClip, audioID:String)
	{
		if(feedbackMC && !_retryFeedback)
		{
			_retryFeedback = new Feedback();
			_retryFeedback.question = this;
			_retryFeedback._compMC = feedbackMC;
			_retryFeedback.audioClipID = audioID;
			_retryFeedback.init();
		}
	}

	public function registerSurveyFeedback(feedbackMC:MovieClip, audioID:String)
	{
		if(feedbackMC && !_surveyFeedback)
		{
			_surveyFeedback = new Feedback();
			_surveyFeedback.question = this;
			_surveyFeedback._compMC = feedbackMC;
			_surveyFeedback.audioClipID = audioID;
			_surveyFeedback.init();
		}
	}
	
	public function registerTimeoutFeedback(feedbackMC:MovieClip)
	{
		//gtrace("quizController.playbackController.showTimeoutMessage = " + quizController.playbackController.showTimeoutMessage);
		if(feedbackMC && !_timeoutFeedback )
		{
			_timeoutFeedback = new Feedback();
			_timeoutFeedback.question = this;
			_timeoutFeedback._compMC = feedbackMC;
			//gtrace("_timeoutFeedback._compMC = " + _timeoutFeedback._compMC);
			_timeoutFeedback.init();
		}
	}

	function registerAllFeedbacks(captionParams:Array)
	{
		for(var i in captionParams)
		{
			var param:AdobeCaptivate.quiz.utils.CpCaptionParams = AdobeCaptivate.quiz.utils.CpCaptionParams(captionParams[i]);
			switch(param._name)
			{
			case AdobeCaptivate.quiz.CpQuizView.SUCCESSCAPTION:
				registerCorrectFeedback(param._component, param.audioID);
				break;
			case AdobeCaptivate.quiz.CpQuizView.FAILURECAPTION:
				if(param._failureLevel >= 0)
					registerFailureFeedback(param._failureLevel, param._component, param.audioID);
				break;
			case AdobeCaptivate.quiz.CpQuizView.RETRYCAPTION:
				registerRetryFeedback(param._component, param.audioID);
				break;
			case AdobeCaptivate.quiz.CpQuizView.INCOMPLETECAPTION:
				registerIncompleteFeedback(param._component, param.audioID);
				break;
			case AdobeCaptivate.quiz.CpQuizView.TIMEOUTCAPTION:
				registerTimeoutFeedback(param._component);
				break;
			}
		}
	}
	
	public function registerReviewFeedback(feedbackMC:MovieClip)
	{
		if(feedbackMC && !_reviewFeedback)
		{
			_reviewFeedback = new ReviewFeedback();
			_reviewFeedback.question = this;
			_reviewFeedback._compMC = feedbackMC;
			_reviewFeedback.init();
		}
	}
	
	public function registerSubmitButtonQC(buttonMC:Button)
	{
		if(buttonMC)
		{
			_submitBtn = buttonMC;
		} 
	}

	public function registerClearButtonQC(buttonMC:Button)
	{
		if(buttonMC)
		{
			_clearBtn = buttonMC;
		} 
	}

	public function registerHitButton(buttonMC:Button)
	{
		if(buttonMC)
		{
			_hitBtn = buttonMC;
			_quizComp.addEventListener("hit", this);
		} 
	}
	
	public function hit(ev:Object):Void
	{
		//trace("quizController = " + this._quizController);
		//gtrace("this = " + this);
		this.quizController.doDefaultAction(this);
	}
	
	public function registerMultipleChoiceAnswers(answersParams:Array)
	{
		var ans:MultipleChoiceAnswer;
		for(var i:Number = 0; i < answersParams.length; i++)
		{
			ans = new MultipleChoiceAnswer();
			ans.answerID = answersParams[i].answerID;
			ans._compMC = answersParams[i]._component;
			//trace("answersParams[i]._component = "+ answersParams[i]._component);
			ans.isCorrect = answersParams[i].isCorrect;
			//trace("ans.isCorrect = " + ans.isCorrect);
			ans.question = this;
			ans.init();
		}
	}

	public function registerMultipleChoiceMultipleAnswers(answersParams:Array)
	{
		var ans:MultipleChoiceMultipleAnswer;
		for(var i:Number = 0; i < answersParams.length; i++)
		{
			ans = new MultipleChoiceMultipleAnswer();
			ans.answerID = answersParams[i].answerID;
			ans._compMC = answersParams[i]._component;
			//gtrace("answersParams[i]._component = "+ answersParams[i]._component);
			ans.isCorrect = answersParams[i].isCorrect;
			ans.question = this;
			ans.init();
		}
	}

	public function registerMatchingAnswers(answersParams:Array)
	{
		var ans:MatchAnswer;
		for(var i:Number = 0; i < answersParams.length; i++)
		{
			ans = new MatchAnswer();
			ans.answerID = ""+i;//answersParams[i].ansReturnID;
			//trace("ans.answerID = " + ans.answerID);
			ans._compMC = answersParams[i]._component;
			//gtrace("answersParams[i]._component = "+ answersParams[i]._component);
			ans.correctAnswer = answersParams[i].ansReturnID;
			ans.question = this;
			ans.init();
		}
	}

	public function registerTrueFalseAnswers(answersParams:Array)
	{
		//trace("registerTrueFalseAnswers");
		registerMultipleChoiceAnswers(answersParams);
	}

	public function registerShortAnswers(answersParams:Array)
	{
		registerFillInTheBlankAnswers(answersParams, true);
	}

	public function registerFillInTheBlankAnswers(answersParams:Array, shortAnswer:Boolean)
	{
		var ans:FillInTheBlankAnswer;
		for(var i:Number = 0; i < answersParams.length; i++)
		{
			ans = new FillInTheBlankAnswer();
			ans.answerID = ""+i;//answersParams[i].answerID;
			gtrace("ans.answerID = " + ans.answerID);
			ans._compMC = answersParams[i]._component;
			//gtrace("answersParams[i]._component = "+ answersParams[i]._component);
			ans.ignoreCase = !answersParams[i].caseSensitive;
			ans.correctAnswer = answersParams[i].correctWords_arr;
			if(shortAnswer == false)
			{
				ans.showChoicesAsList = (answersParams[i]._type == AdobeCaptivate.quiz.CpFillTheBlank.COMBOBOX) ? true : false;
				if(ans.showChoicesAsList)
					ans._comboBox = AdobeCaptivate.quiz.CpAnsComboBox(ans._compMC).comboBox;
				else
					ans._textInput = AdobeCaptivate.quiz.CpAnsTextInput(ans._compMC).textInput;
			}
			gtrace("ans.correctAnswers = " + ans.correctAnswers);
			ans.question = this;
			ans.init();
		}
	}

	public function registerLikertAnswers(answersParams:Array, headerLabels:Array)
	{
		var ans:LikertAnswer;
		for(var i:Number = 0; i < answersParams.length; i++)
		{
			ans = new LikertAnswer();
			ans.answerID = ""+i;//answersParams[i].answerID;
			gtrace("ans.answerID = " + ans.answerID);
			gtrace("headerLabels = " + headerLabels);
			ans.allAnswers = headerLabels;
			gtrace("ans.allAnswers = " + ans.allAnswers);
			ans.radioGroup = answersParams[i].radioGroup;
			ans.interactionID = answersParams[i].interactionID;
			ans.objectiveID = answersParams[i].objectiveID;
			ans.question = this;
			ans.init();
		}
		
	}

	public function registerQuizSlide(qc:CpQuizView, showTimeoutMessage:Boolean)
	{
		gtrace("Doing RegisterQuizSlide");
		_quizComp = qc;
		gtrace("qc.successCaption = " + qc.successCaption);
		/*
		registerCorrectFeedback(qc.successCaption);
		registerIncorrectFeedback(qc.failureCaption);
		registerRetryFeedback(qc.retryCaption);
		registerIncompleteFeedback(qc.incompleteCaption);
		if(showTimeoutMessage)
			registerTimeoutFeedback(qc.timeoutCaption);
		*/
		registerAllFeedbacks(qc.captionParams);
		registerReviewFeedback(qc.reviewArea);
		registerSubmitButtonQC(qc.submitButton);
		registerClearButtonQC(qc.clearButton);
		registerHitButton(qc.hitButton);
		
		switch(qc.slideType)
		{
		case CpQuizView.SHORTANSWER:
			registerShortAnswers(qc.answerParams, true);
			break;
		case CpQuizView.MULTIPLECHOICE:
			{
				if(AdobeCaptivate.quiz.CpMultipleChoice(qc).getType() == AdobeCaptivate.quiz.CpMultipleChoice.MULTIPLE)
					registerMultipleChoiceMultipleAnswers(qc.answerParams);
				else
					registerMultipleChoiceAnswers(qc.answerParams);
				break;
			}
		case CpQuizView.TRUEFALSE:
			registerTrueFalseAnswers(qc.answerParams);
			break;
		case CpQuizView.MATCHING:
			registerMatchingAnswers(qc.answerParams);
			break;
		case CpQuizView.FILLTHEBLANK:
			registerFillInTheBlankAnswers(qc.answerParams, false);
			break;
		case CpQuizView.LIKERT:
			registerLikertAnswers(qc.answerParams, AdobeCaptivate.quiz.CpLikert(qc).headerLabels);
			break;
		}
	}
	
/*************/	

	public function get numQuestionAttemptsAllowed():Number
	{
		if (_numQuestionAttemptsAllowed > 0) {
			return _numQuestionAttemptsAllowed;
		}
	}
	
	public function set numQuestionAttemptsAllowed(numAllowed:Number)
	{
		_numQuestionAttemptsAllowed = numAllowed;
	}
/****
	public function get showingModalFeedback():Boolean
	{
		return (_lastFeedbackShown && _lastFeedbackShown.isModal);
	}
***/
	public function get chosenAnswerFeedback():Feedback
	{
		for (var ans in _answers) {
			if (_answers[ans].feedback && _answers[ans].answered) {
				return(_answers[ans].feedback);
			}
		}
		return null;
	}

	public function get chosenAnswerRetryFeedback():Feedback
	{
		for (var ans in _answers) {
			if (_answers[ans].retryFeedback && _answers[ans].answered) {
				return(_answers[ans].retryFeedback);
			}
		}
	}	


	public function get state():String
	{
		return _state;
	}

	public function set state(newState:String):Void
	{
		_state = newState;
	}
	

	public function get quizController():QuizController
	{
		return _quizController;
	}
	
	public function set quizController(qc:QuizController)
	{
		_quizController = qc;
	}

	public function get inReviewMode():Boolean
	{
		return _inReviewMode;
	}
	
	public function get eachAnswerIsSeparateInteraction():Boolean
	{
		return _eachAnswerIsSeparateInteraction;
	}
	
	public function set eachAnswerIsSeparateInteraction(theBool:Boolean)
	{
		_eachAnswerIsSeparateInteraction = theBool;
	}

	public function get previousQuestionScore():QuestionScore
	{
		return _previousQuestionScore;
	}

	public function set previousQuestionScore(qs:QuestionScore)
	{
		_previousQuestionScore = qs;
	}
	

	function Question()
	{
/*
debug508
		if (!_allTabIndices) {
			_allTabIndices = [];
		}
*/
		isConstructed = true;
	}

	
	private function init() {
		_answers = [];
		state = "init";
		_questionScore = new QuestionScore();
		super.init();
		tabEnabled = false;
		tabChildren = true;
		focusEnabled = true;
		//if (useHint) {
		//	doLater(this, "showHint");
		//}
		_incorrectFeedback = new Array(_numIncorrectFeedback);
	}
	
/***	
	public function showHint():Void
	{
		if (hint && (state != "ended")) {
			hint.visible = true;
			dispatchEvent({type:"showHint", target:this});
		}
	}
	
	public function hideHint():Void
	{
		if (hint) {
			hint.visible = false;
			dispatchEvent({type:"hideHint", target:this});
		}
	}
***/
	public function autoJudge() 
	{
		numTries = numQuestionAttemptsAllowed - 1;
		judge(true, true);
	}
	
			
	public function updateTimerProgress()
	{
		if (_timerBar) {
			var currentTime = new Date();
			var startTime = questionScore.startTime;
			var rt = timeLimitMSecs - (currentTime.getTime() - startTime.getTime());
			var rtDate = new Date();
			rtDate.setTime(rt);
			_timerBar.updateProgress(rtDate, rt/timeLimitMSecs);
		}
	}

	public function enableAnswers()
	{
		for (var k in _answers) {
			var ans:Object = _answers[k];
			ans.enabled = true;
			ans.clearAnswer();
		}
	}

	public function disableAnswers()
	{
		//trace("disable Answers");
		for (var k in _answers) {
			var ans:Object = _answers[k];
			//trace("ans = " + ans);
			ans.enabled = false;
		}
	}
	
	public function setAnswerInteractionIDs()
	{
		if (this.eachAnswerIsSeparateInteraction) {
			for (var i in _answers) {
				var ans = _answers[i];
				ans.objectiveID = this.questionScore.objectiveID;
				ans.interactionID = this.questionScore.interactionID.concat("_",String(i));
			}
		}
	}
/***/
	public function setVisible()
	{
		_quizComp._visible = true;
		//setAccessibility();
	}

/***/
	public function resetPreviousAnswers()
	{
		/***/
		setAnswerInteractionIDs();
		if (_previousQuestionScore && (state == "playing")) {
			//gtrace("_previousQuestionScore.answerScores = " + _previousQuestionScore.answerScores);
			for (var i in _previousQuestionScore.answerScores) {
				var ansScore:AnswerScore = _previousQuestionScore.answerScores[i];
				
				for (var j in _answers) {
					var ans:Object = _answers[j];
					//trace("ans.answerID = " + ans.answerID + " ansScore.answerID = " + ansScore.answerID);
					if (ans.answerID == ansScore.answerID) {
						ans.setFromAnswerScore(ansScore);
					}
				}
			}
			numTries = _previousQuestionScore.numTries;
			questionScore.wasJudged = _previousQuestionScore.wasJudged;
			questionScore.startTime = _previousQuestionScore.startTime;
			questionScore.weighting = _previousQuestionScore.weighting;
		} else {
			questionScore.questionNumInQuiz = this.questionNumInQuiz;
		}
		if (numTries == 0) {
			/***/
			if (_submitBtn != undefined) {
				_submitBtn.enabled = true;
			}
			if (_clearBtn != undefined) {
				_clearBtn.enabled = true;
			}
			/***/
			enableAnswers();
		}
		if (_inReviewMode) {
			disableAnswers();
			/****/
			if (_submitBtn != undefined) {
				_submitBtn.enabled = false;
			}
			if (_clearBtn != undefined) {
				_clearBtn.enabled = false;
			}
			/****/
		} 
		PlaybackController.doActionLater(this, "setVisible", null, 0, 0, 150, 150)
		/***/
		_startingQuestion = false;
	}
/****
	public function updateQuizProgressIndicator()
	{
		if ((state == "playing") && quizController.quizProgressIndicator && (this == quizController.firstQuestionOnCurrentSlide)) {	
			quizController.quizProgressIndicator.questionNum = 1+questionNumInQuiz;
			quizController.quizProgressIndicator.numQuestions = quizController.numQuestions;
		}
	}
/***
	public function setAccessibilityNone(o:Object)
	{
		if (o) {
			var ap = new Object();
			o._accProps = ap;
			o._accProps.silent = true;
			o._accProps.forceSimple = true;
			o._accProps.name = "";
			o.tabEnabled = false;
			o.tabChildren = false;
			o.focusEnabled = false;
			o.tabIndex = undefined;
		}
	}

	public function setChildAccessibilityNone(o:Object)
	{
		var theObject;
		for (var i in o) {
			theObject = o[i];
			if (theObject._name.length > 0) {
				setAccessibilityNone(theObject);
			}
		}
	}

	
	public function setAccessibilityNonLeafNode(o:Object, setChildNone:Boolean)
	{
		if (setChildNone) {
			setChildAccessibilityNone(o);
		}
		var ap = new Object();
		o._accProps = ap;
		o._accProps.silent = false;
		o._accProps.forceSimple = false;
		o._accProps.name = "";
		o.tabEnabled = false;
		o.tabIndex = _curTabIndex++;
		o.tabChildren = true;
		o.focusEnabled = false;
	}

	public function setAccessibilityLeafNode(o:Object, theName:String)
	{
		if (o) {
			setChildAccessibilityNone(o);
			var ap = new Object();
			o._accProps = ap;
			o._accProps.silent = false;
			o._accProps.forceSimple = true;
			o._accProps.name = theName;
			o.tabChildren = false;
			o.tabIndex = _curTabIndex++;
			o.tabEnabled = true;
			o.focusEnabled = true;
		}
	}


	public function setAccessibilityTextInput(o:Object, theName:String)
	{
		//setChildAccessibilityNone(o);
		var ap = new Object();
		o._accProps = ap;
		o._accProps.silent = false;
		o._accProps.forceSimple = true;
		o._accProps.name = theName;
		o.tabEnabled = false;
		o.tabChildren = true;
		o.label.tabEnabled = true;
		o.label.tabChildren = false;
		o.label.tabIndex = _curTabIndex++;
		o.label.focusEnabled = true;
	}

	public function setAccessibilityComboBox(o:Object, theName:String)
	{
//		var ap = new Object();
//		o._accProps = ap;
//		o._accProps.silent = true;
//		o._accProps.forceSimple = true;
//		o._accProps.name = theName;
//		o.tabEnabled = false;
//		o.tabChildren = true;
//		o.tabIndex = _curTabIndex++;

		setAccessibilityNonLeafNode(o, false);

	}

	public function setMatchingAccessibility()
	{
		var theAnswer = null;
		var ans;
		var me = this;

		setAccessibilityLeafNode(me._col1TextMC, me._col1TextMC._accText);

		var i:Number;
		for (i = 0; i < 9; i++) {
			theAnswer = me["drag"+i];
			if (theAnswer._name.length > 0) {
				setAccessibilityNonLeafNode(theAnswer, true);
				setAccessibilityTextInput(theAnswer._choiceEntry, theAnswer._accText);
			}
		}

		setAccessibilityLeafNode(me.col2TextMC, me.col2TextMC._accText);
		for (i = 0; i < 9; i++) {
			theAnswer = me["choice"+i];
			if (theAnswer._name.length > 0) {
				theAnswer._focusrect = true;
				setAccessibilityLeafNode(theAnswer, theAnswer._accText);
			}
		}

	}

	public function setMultipleChoiceAccessibility()
	{
		var theAnswer = null;
		var me = this;

		MultipleChoiceAnswerAccImpl.enableAccessibility();
		MultipleChoiceMultipleAnswerAccImpl.enableAccessibility();
		

		for (var i = 0; i < 9; i++) {
			theAnswer = me["answer_"+i+"_mc"];
			if (theAnswer._name.length > 0) {
				setAccessibilityLeafNode(theAnswer, theAnswer._accText);
			}
		}
	}

	public function setFillInAccessibility()
	{
		var theAnswer = null;
		var ans;

		ComboBoxAccImpl.enableAccessibility();

		var theAnswer = null;
		var me = this;

		var thePhrase = me._completionPhraseMC;
		if (thePhrase._name.length > 0) {
			setAccessibilityLeafNode(thePhrase, thePhrase._accText);
		}

		for (var i = 0; i < 9; i++) {
			theAnswer = me["answer_"+i+"_mc"];
			if (theAnswer._name.length > 0) {
				setAccessibilityNonLeafNode(theAnswer, true);
				if (theAnswer._textInput) {
					setAccessibilityTextInput(theAnswer._textInput, theAnswer._accText)
				} else if (theAnswer._comboBox) {
					setAccessibilityComboBox(theAnswer._comboBox, theAnswer._accText)
				}
			}
		}
	}


	public function setLikertAccessibility()
	{
		var theAnswer = null;
		var theRB = null;
		var me = this;

		for (var i = 0; i < 9; i++) {
			theAnswer = me["answer_"+i+"_mc"];
			if (theAnswer._name.length > 0) {
				setAccessibilityNonLeafNode(theAnswer, true);
				theAnswer._accProps.name = theAnswer._accText;
				for (var j = 1; j < 10; j++) {
					var k = j-1;
					theRB = theAnswer["radioButton_mc"+j];
					if (theRB != undefined) {
						setAccessibilityLeafNode(theRB, theAnswer.allAnswers[k]);
					}
				}
			}
		}
	}


	public function setAnswersAccessibility()
	{
		var qs:QuestionScore = this.questionScore;

		switch (qs.interactionType) {
			case "true-false":
			case "choice":
				setMultipleChoiceAccessibility();
				break;
			case "likert":
				setLikertAccessibility();
				break;
			case "fill-in":
			case "long-fill-in":
				setFillInAccessibility();
				break;
			case "matching":
				setMatchingAccessibility();
				break;
		}
	}

	public static function compareButtonTabOrder(elt1:MovieClip, elt2:MovieClip)
	{

		var answerBounds1 = elt1.getBounds(elt1._parent);
		var answerBounds2 = elt2.getBounds(elt2._parent);		

		if (answerBounds1.ymin + 10 < answerBounds2.ymin) {
			return -1;
		}
		if (answerBounds2.ymin + 10 < answerBounds1.ymin) {
			return 1;
		}
		if (answerBounds1.xmin < answerBounds2.xmin) {
			return -1;
		}
		if (answerBounds2.xmin < answerBounds1.xmin) {
			return 1;
		}
		return 0;
	}


	public function setButtonsAccessibility()
	{
		var me = this;
		var i:Number;
		ButtonAccImpl.enableAccessibility();

		var butArray:Array = [];

		if (me._clearbutton) {
			butArray.push(me._clearbutton);
		}
		if (me._backbutton) {
			butArray.push(me._backbutton);
		}
		if (me._nextbutton) {
			butArray.push(me._nextbutton);
		}
		if (me._submitbutton) {
			butArray.push(me._submitbutton);
		}
		butArray.sort(Question.compareButtonTabOrder);

		for (i=0; i < butArray.length; i++) {
			var elt = butArray[i];
			if ((elt.className == "SubmitButton") ||
				(elt.className == "ClearButton")) {
				setAccessibilityLeafNode(elt, elt._accText);
			} else {
				setAccessibilityNonLeafNode(elt, true);
				setAccessibilityLeafNode(elt._butIcon, elt._accText);
			}
		}
	}

	public function setPlaybarButtonAccessibility(b:Object)
	{
		b._accProps.silent = false;
		b._accProps.forceSimple = true;
		b.tabIndex = _curTabIndex++;
		b.focusEnabled = true;
		b.tabChildren = false;
	}
			


	public function setPlaybarAccessibility()
	{
		var thePlaybar = this._parent._parent.playbar_mc;
		if (thePlaybar) {
			setAccessibilityNonLeafNode(thePlaybar, false);
			setAccessibilityNone(thePlaybar.progressbar_mc);
			setPlaybarButtonAccessibility(thePlaybar.pbc_Rewind2);
			setPlaybarButtonAccessibility(thePlaybar.pbc_Back3);
			setPlaybarButtonAccessibility(thePlaybar.pbc_Play4);
			setPlaybarButtonAccessibility(thePlaybar.pbc_Pause5);
			setPlaybarButtonAccessibility(thePlaybar.pbc_Forward6);
			setPlaybarButtonAccessibility(thePlaybar.pbc_Exit7);
			setPlaybarButtonAccessibility(thePlaybar.pbc_Information8);
		}
	}


	public function setProgressAccessibility()
	{
		var theProgressMC = quizController.playbackController.currentSlideContainer._progressMC;
		if (theProgressMC)
			setAccessibilityLeafNode(theProgressMC, theProgressMC._accText);
	}

	public function setDocAccessibility()
	{
		var o = this._parent;
		setChildAccessibilityNone(o);
		var ap = new Object();
		o._accProps = ap;
		o._accProps.silent = false;
		o._accProps.forceSimple = false;
		o._accProps.name = "";
		o.tabEnabled = false;
		o.tabChildren = true;
		o.focusEnabled = false;
	}


	public function answersOverridesAccessibility():Boolean
	{
		for (var ans in _answers) {
			var theAnswer = _answers[ans];
			if ((theAnswer.overrideAccessibility == undefined) ||
				(theAnswer.overrideAccessibility == false))	{
				return false;
			}
		}
		return true;
	}
	
	public function setReviewFeedbackAccessibility()
	{
		if (_inReviewMode) {
			if ((_reviewFeedback != undefined) &&(_reviewFeedback != null) && _reviewFeedback._visible) {
				if (_reviewFeedback._correctDisplay._visible) {
					setAccessibilityLeafNode(_reviewFeedback, _reviewFeedback._correctDisplay._accText);
				} else if (_reviewFeedback._incorrectDisplay._visible) {
					var theAccText:String = "";
					theAccText = theAccText.concat(_reviewFeedback._incorrectDisplay._accTextChosen,_reviewFeedback.chosenAnswersAsString,
												   _reviewFeedback._incorrectDisplay._accTextCorrect, _reviewFeedback.correctAnswersAsString);
					setAccessibilityLeafNode(_reviewFeedback, theAccText);
				} else if (_reviewFeedback._incompleteDisplay._visible) {
					setAccessibilityLeafNode(_reviewFeedback, _reviewFeedback._incompleteDisplay._accText);
				}
			}
		}
	}

/*
debug508 

	public function allParentsTabChildren(theRoot:MovieClip):Boolean
	{
		if (!theRoot._visible) {
			return false;
		}
		var p = theRoot._parent;
		while (p) {
			if (!p._visible || !p.tabChildren) {
				return false;
			}
			p = p._parent;
		}
		return true;
	}

	public function checkBadTabIndex(theRoot:MovieClip)
	{
		if (theRoot.tabEnabled && allParentsTabChildren(theRoot)) {
			if (!theRoot.tabIndex) {
				//gtrace("***** Error:  no tabIndex for "+theRoot);
			} else if (_allTabIndices[theRoot.tabIndex]  && (_allTabIndices[theRoot.tabIndex] != theRoot) && (allParentsTabChildren(_allTabIndices[theRoot.tabIndex]))) {
				//gtrace("***** Error:  duplicate tab index for "+theRoot+", previous object with this index = "+_allTabIndices[theRoot.tabIndex]);
			} else {
				_allTabIndices[theRoot.tabIndex] = theRoot;
			}
		}
	}

	public function showAllTabIndicesAux(theRoot:MovieClip)
	{
		var i;
		var o;
		if (theRoot) {
			if (theRoot._sweepIndex == this._sweepIndexStart) {
				return;
			}
			checkBadTabIndex(theRoot);
			theRoot._sweepIndex = this._sweepIndexStart;
			if ((theRoot.tabEnabled || theRoot.tabChildren) && (allParentsTabChildren(theRoot))) {
				//gtrace(theRoot+", _visible = "+theRoot._visible+", tabEnabled = "+theRoot.tabEnabled+", tabChildren = "+theRoot.tabChildren+",focusEnabled = "+theRoot.focusEnabled+", tabIndex = "+theRoot.tabIndex);
			}
			for (i in theRoot) {
				o = theRoot[i];
				if ((o._name.length > 0) && (o._parent == theRoot)) {
					showAllTabIndicesAux(o);
				}
			}
		}
	}


	public function showAllTabIndices()
	{
		var p = this;
		while (p._parent) {
			p = p._parent;
		}
		this._sweepIndexStart++;
		showAllTabIndicesAux(p);
	}

* /
	public function setContainerAccessibility()
	{
		setDocAccessibility();
		setAccessibilityNonLeafNode(quizController.playbackController.currentSlideContainer, true);
	}


	public function setAccessibility()
	{
		if (answersOverridesAccessibility()) {
			return;
		}

		// NOTE: It is very important that we only use the tab indices in the range 
		// reserved for us (currently, 0xe000...0xefff). These values are currently
		// defined in SwfBuilder.h in the Star code.
		_curTabIndex = 0xE000;
		var me = this;
		
		setContainerAccessibility();
		setAccessibilityNonLeafNode(this, true);

		setAccessibilityLeafNode(me._titleMC,  me._titleMC._accText);
		setAccessibilityLeafNode(me._questionTextMC, me._questionTextMC._accText);
		setAnswersAccessibility();
		setButtonsAccessibility();
		setPlaybarAccessibility();
		setProgressAccessibility();
		setReviewFeedbackAccessibility();
		/* debug508 showAllTabIndices(); * /
		Accessibility.updateProperties();
	}

	public function setAccessibilityModal(modalText:String)
	{
		_curTabIndex = 0xE000;
		var me = this;

		setContainerAccessibility();
		setAccessibilityNonLeafNode(this, true);

		setAccessibilityLeafNode(me._titleMC,  modalText);
		setAccessibilityLeafNode(me._questionTextMC, modalText);
		Accessibility.updateProperties();
	}

	public function hideQuestionTextSubclips():Void
	{
		var me = this;
		for (var p in me._questionTextMC) {
			if (typeof(me[p] == "movieclip")) {
				me[p]._visible = false;
			}
		}
	}
****/	
	public function startQuestion(revMode:Boolean, prevQuestionScore:QuestionScore):Void
	{
		//gtrace("startQuestion revMode = " + revMode + " prevQuestionScore = " + prevQuestionScore);
		if ((_state == "init") || (state == "ended")) {
			_startingQuestion = true;
			state = "playing";
			_inReviewMode = revMode;
			if (!this._questionScore) {
				this._questionScore = new QuestionScore();
			}
			_questionScore.questionNumInQuiz = this.questionNumInQuiz;
			//PlaybackController.doActionLater(this, "setAccessibility", null, 0, 0, 2000, 2000)
			

			if (prevQuestionScore) {
				_numTries = prevQuestionScore.numTries;
				_questionScore.weighting = prevQuestionScore.weighting;
				_questionScore.objectiveID = prevQuestionScore.objectiveID;
				_questionScore.interactionID = prevQuestionScore.interactionID;
				_questionScore.interactionType = prevQuestionScore.interactionType;
			} else {
				_numTries = 0;
			}
			if ((timeLimitMSecs > 0) && !_inReviewMode) {
				
				if (_timerBar) {
					var rtDate = new Date();
					rtDate.setTime(timeLimitMSecs);
					_timerBar.updateProgress(rtDate, 1.0);
					_timerProgressID = setInterval(function(question:Question) {
															question.updateTimerProgress();
															},
															250,
															this);
				}
				//gtrace("starting timer");
				_timerID = setInterval(function(question:Question) {
								//gtrace("timeout");
								question.autoJudge();
							},
							timeLimitMSecs,
							this);
				
			}
			dispatchEvent({type:"questionStarted", target:this});
			_previousQuestionScore = prevQuestionScore;
			if (_inReviewMode) {
				/****/
				//gtrace("_reviewFeedback = " + _reviewFeedback);
				if (_reviewFeedback) {
					//gtrace("prevQuestionScore.answeredCorrectly = " + prevQuestionScore.answeredCorrectly);
					//gtrace("prevQuestionScore.toString = " + prevQuestionScore.toString());
					if (prevQuestionScore && (prevQuestionScore.numTries > 0)) {
						_reviewFeedback.correctAnswersAsString = prevQuestionScore.correctAnswersForReview;
						_reviewFeedback.chosenAnswersAsString = prevQuestionScore.chosenAnswersForReview;
						_reviewFeedback.answeredCorrectly = prevQuestionScore.answeredCorrectly;
						_reviewFeedback.answersIncomplete = prevQuestionScore.answersIncomplete;
					} else {
						_reviewFeedback.answersIncomplete = true;
					}
					_reviewFeedback.showFeedbackAndDoAction();
				}
				/****/
			} else if (!_previousQuestionScore) {
				var currentTime = new Date();
				_questionScore.startTime = currentTime;
			}
			/***
			if (!_inReviewMode) {
				_reviewFeedback.visible = false;
			}
			***/
			resetPreviousAnswers();
			//doLater(this, "resetPreviousAnswers");
			//doLater(this, "updateQuizProgressIndicator");
		}
	}
	
/***	
	public function pauseQuestion():Void
	{
		if (_state == "playing") {
			state = "paused";
			if (_timerID) {
				clearInterval(_timerID);
			}
			if (_timerProgressID) {
				clearInterval(_timerProgressID);
			}
			var currentTime = new Date();
			_timeBeforePause = _questionScore.startTime.getMilliseconds() - currentTime.getMilliseconds();
			questionScore.pausedMsecs += _timeBeforePause;
			timeLimitMSecs -= _timeBeforePause;
			_timeBeforePause = 0;
			dispatchEvent({type:"questionPaused", target:this});
		}
	}
	
	public function resumeQuestion():Void
	{
		if (_state == "paused") {
			state = "playing";
			if (!_inReviewMode && (timeLimitMSecs > 0)) {
				_timerID = setInterval(function(question:Question) {
								question.autoJudge();
							},
							timeLimitMSecs,
							this);
				if (_timerBar) {
					var rtDate = new Date();
					rtDate.setTime(timeLimitMSecs);
					_timerBar.updateProgress(rtDate, 1.0);
					_timerProgressID = setInterval(function(question:Question) {
															question.updateTimerProgress();
															},
															250,
															this);
				}
		}

			dispatchEvent({type:"questionResumed", target:this});
		}
	}
****/
	public function endQuestion(wasJudged:Boolean):Void
	{
		gtrace("\b");
		gtrace(" inside endquestion _startingQuestion = " + _startingQuestion);	
		if (_startingQuestion) {
			return;
		}
		gtrace("endquestion _state = " + _state);
		if ((_state == "playing") || (_state == "paused")) {
			_state = "ended";
			if (_timerID) {
				clearInterval(_timerID);
			}
			if (_timerProgressID) {
				clearInterval(_timerProgressID);
			}
			var currentTime = new Date();
			_questionScore.endTime = currentTime;
		
			if (numTries > 0) {
				_questionScore.answerScores = [];
			}
			for (var ans in _answers) {
				var ansScore:AnswerScore = _answers[ans].answerScore.copy();
				gtrace("save ansScore ansScore.chosenAnswer = " + ansScore.chosenAnswer);
				gtrace("ansScore.answerID = " + ansScore.answerID);
				if ((ansScore.answerID != undefined) && (ansScore.answerID.length > 0)) {
					_questionScore.answerScores.push(ansScore);
				}
			}
			questionScore.answersIncomplete = this.answersIncomplete;
			questionScore.answeredCorrectly = this.answeredCorrectly;
			if (wasJudged) {
				questionScore.wasJudged = wasJudged;
			} else {
				if (previousQuestionScore) {
					questionScore.wasJudged = previousQuestionScore.wasJudged;
				} else {
					questionScore.wasJudged = false;
				}
			}
			dispatchEvent({type:"questionEnded", target:this});
			questionScore.slideNum = slide.slideNum;
			gtrace("endquestion quizController = " + quizController);
			if (quizController) {
				gtrace("going to save score");
				quizController.saveQuestionScore(this);
			}
			/****/
			gtrace("\nQuestion End wasJudged = " + wasJudged + " isTracked = " + isTracked);
			if (wasJudged && isTracked) {
				if (eachAnswerIsSeparateInteraction) {
					for (var ans in _answers) {
						var qs:QuestionScore = _answers[ans].getQuestionScore();
						if (qs) {
							quizController.sendInteractionData(qs);
						}
					}
				} else {
					quizController.sendInteractionData(quizController.getQuestionScore(this.questionNumInQuiz));
				}
			}
			if (wasJudged && quizController.playbackController.sendCourseDataWithInteractionData) {
				quizController.playbackController.sendCourseData(false);
			}
			/****/
		}
		
	}

	
	public function showFeedbackAndDoAction(feedback:Feedback) 
	{
		hideLastFeedback(true);
		dispatchEvent({type:"showFeedback", target:this});
		_lastFeedbackShown = feedback;
		//gtrace("setting _lastFeedbackShown = " + _lastFeedbackShown);
		feedback.showFeedbackAndDoAction();
	}
	
	public function hideLastFeedback(doAction:Boolean) 
	{
		dispatchEvent({type:"hideFeedback", target:_lastFeedbackShown});
		//gtrace("_lastFeedbackShown = " + _lastFeedbackShown);
		if (_lastFeedbackShown) {
			//setAccessibility();
			_lastFeedbackShown.hideFeedback(doAction);
			_lastFeedbackShown = null;
		}
		//hideHint();
	}
	
	public function getFeedbackToShow(treatIncompleteAsIncorrect: Boolean, showTimeoutFeedback:Boolean):Feedback
	{
		if (showTimeoutFeedback && timeoutFeedback) {
			return timeoutFeedback
		} else if (answersIncomplete && !treatIncompleteAsIncorrect && incompleteFeedback) {
			return incompleteFeedback; 	// Don't count as a try if no answer has been chosen
		} else {
			if ((numTries < numQuestionAttemptsAllowed) && chosenAnswerRetryFeedback) {
				return chosenAnswerRetryFeedback;
			} else if (chosenAnswerFeedback) {
				return chosenAnswerFeedback;
			} else if (answeredCorrectly) {
				return correctFeedback;
			} else {
				if (retryFeedback && (numTries < numQuestionAttemptsAllowed)) {
					return retryFeedback;
				} else {
					if ((answersIncomplete && treatIncompleteAsIncorrect) || (numTries >= numQuestionAttemptsAllowed)) 
					{
						gtrace(">>>Question<<< getFeedbackToShow() ---condition 1: ");
						return getIncorrectFeedback(_numIncorrectFeedback-1); // get the last one
					}else if (numTries <= _numIncorrectFeedback) 
					{
						gtrace(">>>Question<<< getFeedbackToShow ---condition 2: ");
						return getIncorrectFeedback(numTries-1); 
					}else 
					{
						gtrace(">>>Question<<< getFeedbackToShow ---condition 3: ");
						return null;
					}
				}
			}
		}

	}

	
	public function judge(treatIncompleteAsIncorrect:Boolean, showTimeoutFeedback:Boolean) 
	{
		hideLastFeedback(false);	// in case previous feedback was nonModal
		gtrace("in Question.judge, isSurvey = "+isSurvey+" _numQuestionAttemptsAllowed = "+_numQuestionAttemptsAllowed);
		gtrace("numTries = " + numTries);
		if (isSurvey) {
			gtrace("answersIncomplete = " + answersIncomplete);
			if (answersIncomplete) {
				gtrace("incompleteFeedback = " + incompleteFeedback);
				if (incompleteFeedback) {
					showFeedbackAndDoAction(incompleteFeedback);
				} else if (surveyFeedback) {
					showFeedbackAndDoAction(surveyFeedback);
				} else {
					//gtrace("in Question.judge, for survey with incomplete answers calling doDefaultAction");
					quizController.doDefaultAction(this);
				}
			} else {
				//gtrace("in Question.judge, survey answersIncomplete = false, surveyFeedback = "+surveyFeedback);
				numTries = numTries + 1;
				endQuestion(true);
				if (chosenAnswerFeedback) {
					showFeedbackAndDoAction(chosenAnswerFeedback);
				} else if (surveyFeedback) {
					showFeedbackAndDoAction(surveyFeedback);
				} else {
					//gtrace("in Question.judge, for survey with complete answers calling doDefaultAction");
					quizController.doDefaultAction(this);
				}
			}
		} else if (numTries < _numQuestionAttemptsAllowed) {
			//gtrace("Not in review mode");
			dispatchEvent({type:"judge", target:this});
			gtrace("answersIncomplete = " + answersIncomplete + "incompleteFeedback = " + incompleteFeedback);
			if (answersIncomplete && !treatIncompleteAsIncorrect && incompleteFeedback) {
				showFeedbackAndDoAction(incompleteFeedback); 	// Don't count as a try if no answer has been chosen
			} else {
				numTries = numTries + 1;
				if ((numTries >= numQuestionAttemptsAllowed) || answeredCorrectly) {
					endQuestion(true);
				}
				var feedbackToShow = getFeedbackToShow(treatIncompleteAsIncorrect, showTimeoutFeedback);
				gtrace("feedbackToShow = " + feedbackToShow);
				if (feedbackToShow) {
					showFeedbackAndDoAction(feedbackToShow);
				} else if (quizController) {
					quizController.doDefaultAction(this);
				}
			}
		}
	}

	public function registerIncorrectFeedback(index:Number, f:Object)
	{
		//trace(">>>Question<<< registerIncorrectFeedback("+index+", "+f+")");
		if (index < _numIncorrectFeedback)
			_incorrectFeedback[index] = f;
	}

	public function registerAnswer(ans:Object)
	{
		gtrace("Answer Registered");
		_answers.push(ans);
	}
/***
	public function registerSubmitButton(theButton:SubmitButton) 
	{
		_submitButton = theButton;
	}
	
	public function registerClearButton(theButton:ClearButton) 
	{
		_clearButton = theButton;
	}
/***/	
	public function clearAnswers()
	{
		if (numTries < _numQuestionAttemptsAllowed) {
			for (var ans in _answers) {
				_answers[ans].clearAnswer();
			}
		}
	}

	public function leaveSlide() 
	{
		this._visible = false;
		dispatchEvent({type:"leaveSlide", target:this});
	}
	
/****	
	// Find the callback that the Serrano viewer gives us to play back
	// audio files with a given ID. 
	function get playSoundFunc():Function
	{
		var p = this;
		while (p) {
			if (p.g_playSoundFile) {
				return p.g_playSoundFile;
			}
			p = p._parent;
		}
		return null;
	}

	// Plays audio file associated with id.  The viewer maintains the
	// id-to-audio-file mapping and provides us with a callback
	// (g_playSoundFile in our parent chain) that
	// takes that ID to play the corresponding audio file.
	// Returns true for success, false for failure.
	function playAudioID(id:String, callback:Function):Boolean
	{
		var soundFunc:Function = this.playSoundFunc;
		if (soundFunc) {
			return soundFunc(id, callback);
		} else {
			if (callback) {
				callback();
			}
		}
	}
***/

	function playAudio(id:String):Boolean
	{
		if(id == m_gPlaySoundID)
			return false;
			
		if(m_gSound != null)
			stopAudio(m_gPlaySoundID);
					
		m_gSound = new Sound();
		m_gSound.attachSound(id);
		m_gPlaySoundID = id;
		m_gSound.start();
	}
	
	function stopAudio(id:String):Void
	{
		gtrace("Doing a stop sound id = " + id + " m_gPlaySoundID = " + m_gPlaySoundID + " m_gSound = " + m_gSound);
		if(m_gSound != null && id == m_gPlaySoundID)
			m_gSound.stop(id);
	}

	public function judgeInteraction() 
	{
		gtrace("judgeInteraction = numTries = " + numTries + " _numQuestionAttemptsAllowed = " + _numQuestionAttemptsAllowed)

		if ((_numQuestionAttemptsAllowed < 0) || (numTries < _numQuestionAttemptsAllowed)) {
			dispatchEvent({type:"judge", target:this});
			numTries = numTries + 1;
			gtrace("judgeInteraction = numTries = " + numTries + " answeredCorrectly = " + answeredCorrectly)
			if (((numTries >= numQuestionAttemptsAllowed) && (_numQuestionAttemptsAllowed > 0)) || answeredCorrectly) {
				endQuestion(true);
			}
		}
		
	}

	public function showHitButton(show:Boolean) { 
		if(_hitBtn != undefined && _hitBtn != null) 
			_hitBtn._visible = show; 
	}

	public function gtrace(str)	{ 
		return;
		if( System.capabilities.playerType == "PlugIn" || System.capabilities.playerType == "ActiveX" ||
			System.capabilities.playerType == "StandAlone")
			_root.debl(str);
		else
			trace(str);
	}
	
}
