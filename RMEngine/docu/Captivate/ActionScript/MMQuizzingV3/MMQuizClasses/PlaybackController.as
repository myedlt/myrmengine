//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"
import MMQuizzingV3.MMQuizClasses.QuizParams;
import MMQuizzingV3.MMQuizClasses.QuizController;
//import MMQuizzingV3.MMQuizClasses.Question;
import MMQuizzingV3.MMQuizClasses.SlideInfo;
import MMQuizzingV3.MMQuizClasses.lms.Tracking;
import MMQuizzingV3.MMQuizClasses.lms.TrackingAdapter;
import MMQuizzingV3.MMQuizClasses.QuizState;
import MMQuizzingV3.MMQuizClasses.QuestionScore;
//import MMQuizzingV3.MMSlideClasses.ISlideContent2;
import MMQuizzingV3.MMSlideClasses.IQuizState;
import MMQuizzingV3.MMSlideClasses.ISlideInfo;
//import MMQuizzingV3.MMSlideClasses.ISlideContainer;
import MMQuizzingV3.MMQuizClasses.lms.Utilities;


class MMQuizzingV3.MMQuizClasses.PlaybackController
	extends UIObject{
	//implements ISlideContent2 {

	private var _quizControllers:Array;
	private var _currentSlide:SlideInfo = null;
	private var _slides:Array;
	private var _quizParams:Array;
	private var _isTracked:Boolean = false;
	private var _trackingIsOn:Boolean = false;

	private var _pollLMSIntervalID:Number = 0;
	private var _pollLMSStartTime:Date;
	private var _pollLMSInitializeTimeoutSecs = 2;
	private var _pollLMSGetTrackingDataTimeoutSecs:Number = 15;
	private var _pollEnterCurrentSlideIntervalID:Number = -1;
	private var _pollLMSLoadExternalTrackingSWFTimeoutSecs:Number = 2.5;
	private var _pollLMSLoadExternalTrackingSWFStartTime:Date;
	private var _pollLMSLoadExternalTrackingSWFIntervalID:Number = 0;
	private var _trackingUpdateIntervalSecs:Number = 120;		// How often we send tracking (bookmark) info to the LMS, in seconds.
	public var externalTrackingSWFName:String = "MMTracking.swf";

	private var _sendCourseDataWithInteractionData:Boolean = true;

	private static var _doActionLaterIntervals:Array;
	private var _restoringQuizState:Boolean = false;

	private var _preferredLMSType:String = "SCORM";
	private var _AuthorwareDelimeter:String = ";";
	private var _emailAddress:String = "";
	public var completionValueToSend:String = "default";		// one of "completion", "passed", or "default"
			/*
				We support sending of one of 3 different completion values
				
				1) "completion":  Always only send to the LMS complete/incomplete.  Never send passed/failed.  This is because some LMS's, such as Pathlore, will ONLY accept a status of completed/incomplete and will balk on receiving passed/failed.
				2) "passed": Always only send to the LMS passed/failed.  Never send completed/incomplete.  This is provided for completeness although we don't know of any LMS's for which this is a problem.
				3) "default": Let the content decide whether to send completed/incomplete or passed/failed based on one of the 5 settings below (see completionTrigger).
			*/
  	public var completionTrigger:String = "quiz_only";	// one of "quiz_only", "quiz_and_views", "views_only", or "access"
			/*
			We support the following completion trigger options:
			1) "quiz-only"
				a)f there is no quiz, and the user has viewed 100% of the slides in the presentation, then set a lesson status of "completed"
				b) if there is a quiz, but FOR ALL QUIZZES the score required to pass is zero, then always set a status of "completed" when ALL THE QUIZZES ARE completed
				c) if there is ANY quiz, with a passing score>0, then on quiz completion OF ALL QUIZZES set a status of 'passed' if the score was at least the passing score FOR ALL QUIZZES, or 'failed' otherwise.

			2)quiz-and-views"
				a) if there is no quiz, and the user has viewed 100% of the slides in the presentation, then set a lesson status of "completed"
				b) if there is a quiz, but FOR ALL QUIZZES the score required to pass is zero,then we will potentially set a lesson status of "completed" twice:when the user completes ALL THE QUIZZES, and when the last slide is viewed
				c) if there is ANY quiz, with a passing score > 0, then set 2 distinct lesson status:on quiz completion OF ALL QUIZZES set a status of 'passed' if the score was at least the passing score FOR ALL QUIZZES, or 'failed' otherwise, and set a status of "completed" when the user has viewed 100% of the slides in the presentation.

			3)views-only"
				a) whether or not there is a quiz, set a lesson status of "completed" when the user has viewed all slides.Set no lesson status on quiz completion.

			4)access"
				a) whether or not there is a quiz, set a lesson status of "completed" when the presentation is loaded.Set no lesson status on quiz completion, or when all slides have been viewed.

			5) "breeze"
				a) if not all the slides have been seen, then send "incomplete" on each slide view
				b) If 100& of the slides have been seen, then do the following:
						- If there are any quizzes present, send "passed" if the user passed all the quizzes or "failed" if they did not.
						- If there are no quizzes present, send "completed".


			In addition:
			- We will send LMS course data (including overall score and interaction data if necessary) after each question is answered, not just after the entire quiz is finished.   I believe today we guarantee that interaction ID's are pre-populated with coursewide-unique identifiers.
			- The overall raw score will be the SUM of the scores of each of the quizzes.
			- Max score is the sum of the max scores of all the quizzes.
			- Min score is the sum of the min scores of all the quizzes.
			- Percent correct is the fraction:  (total score across all quizzes)/(sum of max scores of all quizzes)
			- We will have a UI setting that determines which of the 4 lesson status settings to use.  This will apply to all LMS's, not just breeze.  The default will be "quiz-only".  The completion and passed/fail status will be determined by the rules 1-4 above.    When running under a SCORM 2004 LMS, we can send both completion and passed/failed status.  Otherwise, if not running under Breeze we will send EITHER completion or passed/fail status based on a the existing Serrano authortime UI setting.  When running under Breeze, regardless of UI setting, we will only send lesson status as either completed/incomplete or passed/failed based on rules 1-4.

			NOTE: the percentage of slides that must be viewed for these options is 100% by default, but is configurable  (e.g. a customer could specify that for their account presentations are complete once 50% of the slides have been viewed).
			*/
	
	public var completionSlideViewPercentage:Number = 100;

	private var _sendScoreAsPercent = false;
	private var _trackingLevel:String = "interactions";		// "interactions", "objectives", or "score"
	////private var _slideContainer:ISlideContainer = null;	///Not sure if i need to check it, so i will keep the code commented until i get response from Ed.
	private var _tracking:Tracking;

	private var _loadingResumeData:Boolean = true;				// Needs to be set initially to true for Captivate.  Captivate waits until this flag changes
	public var needToLoadExternalTrackingSWF:Boolean = false;
	public var trackingUrlEncodeVersionAndSession:Boolean = true;
	public var trackingCharsToNotUrlEncode:String = "";
	public var trackingSendResumeData:Boolean = true;
	public var _restoredSlideNum:Number = -1;
	private var _allowForceQuitContainer:Boolean = true;

	private var _showTimeoutMessage:Boolean = false;
	private var _timeoutMessage:String = "";
	private var _reviewMessages:Array;
	
	function init()
	{
		// check for undefined to guard against order-of-initialization
		// weirdness when used by Serrano
		if (_quizControllers == undefined) _quizControllers = [];
		if (_slides == undefined) _slides = [];
		if (_reviewMessages == undefined) _reviewMessages = [];
		
		super.init();
		doActionLater(this, "postInit", currentSlideContainer, currentSlideContainer._currentframe+1, 9999999, 100, 1000);
	}
	
	function postInit()
	{
	}

	public function get currentSlideContainer():Object
	{
		return getCurrentSlideContainer();
	}

	// bottleneck it here rather than in the getter (easier to override at runtime)
	public function getCurrentSlideContainer():Object
	{
		gtrace("into wrong getCurrentSlideContainer");
		// override in subclasses
		return null;
	}

	public function get currentMovieContainer():Object
	{
		return getCurrentSlideContainer();
	}

	// bottleneck it here rather than in the getter (easier to override at runtime)
	public function getCurrentMovieContainer():Object
	{
		gtrace("into wrong getCurrentSlideContainer");
		// override in subclasses
		return null;
	}

	public function get restoringQuizState():Boolean
	{
		return _restoringQuizState;
	}

	public function set restoringQuizState(restoring:Boolean)
	{
		_restoringQuizState = restoring;
	}

	public function get currentSlide():SlideInfo	{	return _currentSlide;	}
	public function set currentSlide(slide:SlideInfo)	{	_currentSlide = slide;	}

	public function get slides():Array	{	return _slides;	}

	public function quizParamsOfQuiz(quizID:Number):QuizParams
	{
		for (var i = 0; i < _quizParams.length; i++) {
			if (_quizParams[i].quizID == quizID) {
				return _quizParams[i];
			}
		}
		var qp:QuizParams = new QuizParams();
		qp.quizID = quizID;
		qp.firstSlideInQuiz = new SlideInfo();
		qp.firstSlideInQuiz.slideNum = 999999;
		qp.lastSlideInQuiz = new SlideInfo();
		qp.lastSlideInQuiz.slideNum = -1;
		return qp;
	}

	public function getQuizController(quizID):QuizController
	{
		//gtrace("quizID = " + quizID);
		if (quizID < 0) {
			return null;
		} else {

			var quizController:QuizController = null;
			for (var i=0; i < _quizControllers.length; i++) {
				var qc:QuizController = _quizControllers[i];
				if (qc.quizParams.quizID == quizID) {
					quizController = qc;
				}
			}
			if (quizController) {
				return quizController;
			} else {
				quizController = new QuizController();
				quizController.quizParams = quizParamsOfQuiz(quizID);
				quizController.playbackController = this;
				_quizControllers.push(quizController);
				return quizController;
			}
		}
	}

	public function quizIDForSlide(slide:SlideInfo):Number
	{
		//gtrace("_quizParams.length  = " + _quizParams.length);
		// need to override this for Serrano
		for (var i=0; i < _quizParams.length; i++) {
			var qp:QuizParams = _quizParams[i];
			//gtrace("qp = " + qp + " slide = " + slide + "slide.slideNum = " + slide.slideNum);
			//gtrace("qp.firstSlideInQuiz.slideNum = " + qp.firstSlideInQuiz.slideNum);
			//gtrace("qp.lastSlideInQuiz.slideNum = " + qp.lastSlideInQuiz.slideNum);
			if (qp && slide &&
				(slide.slideNum >= qp.firstSlideInQuiz.slideNum) &&
				(slide.slideNum <= qp.lastSlideInQuiz.slideNum)) {
				return qp.quizID;
			}
		}
		return -1;
	}

	public function quizControllerForSlide(slide:SlideInfo):QuizController
	{
		return getQuizController(quizIDForSlide(slide));
	}

	public function getSlide(slideNum:Number):SlideInfo
	{
		gtrace("getSlide:: slideNum = " + slideNum);
		var i;
		if ((slides == null) || (slides == undefined)) {
			return null;
		}
		for (i = 0; i < slides.length; i++) {
			if (slides[i].slideNum == slideNum) {
				return slides[i];
			}
		}
		return null;
	}

	// this should really be private, but is public to allow for
	// Serrano to access it at runtime without complaints
	public function activateSlide(toSlide:SlideInfo)
	{
	gtrace("activating slide = " + toSlide.slideNum);
		_gotoFLASlide(toSlide.slideNum);
		//_gotoFrame(toSlide.firstFrameNum);
	}


	public function doPollEnterCurrentSlide()
	{
		var currQuiz:QuizController = quizControllerForSlide(currentSlide);
		if (!currQuiz) {
			clearInterval(_pollEnterCurrentSlideIntervalID);
			_pollEnterCurrentSlideIntervalID = -1;
			return;
		}

		var currSlideType:String = currQuiz.quizParams.getSlideType(currentSlide);

		switch (currSlideType) {
			case "question":
				//if (allQuestionsOnCurrentSlideConstructed()) 
				{
					clearInterval(_pollEnterCurrentSlideIntervalID);
					_pollEnterCurrentSlideIntervalID = -1;
					currQuiz.enterCurrentSlide();
				}
				break;
			case "passScoreSlide":
			case "failScoreSlide":
			case "anyScoreSlide":
				//if (scoreDisplayConstructed()) 
				{
					clearInterval(_pollEnterCurrentSlideIntervalID);
					_pollEnterCurrentSlideIntervalID = -1;
					//gtrace("in doPollEnterCurrentSlide, calling enterCurrentSlide for score slide");
					currQuiz.enterCurrentSlide();
				}
				break;
			default:
				clearInterval(_pollEnterCurrentSlideIntervalID);
				_pollEnterCurrentSlideIntervalID = -1;
				break;
		}
	}

/******************************old version*************************
	private function _gotoSlide(toSlide:SlideInfo, notifyOnly:Boolean, p_fromHB:Boolean)
	{
		/****Later
		if (_pollEnterCurrentSlideIntervalID != -1) {
			clearInterval(_pollEnterCurrentSlideIntervalID);
			_pollEnterCurrentSlideIntervalID = -1;
		}
		// for compatibility with existing Captivate code.
		if (p_fromHB == undefined) //@G@
			p_fromHB = false;//@G@
		**** /
		
		var fromQuiz:QuizController = quizControllerForSlide(currentSlide);
		var toQuiz:QuizController = quizControllerForSlide(toSlide);

		gtrace("_gotoSlide fromQuiz = " + fromQuiz);
		if (fromQuiz) {
			fromQuiz.leaveCurrentSlide(toSlide);
		}
		
		if(notifyOnly) //should happen when called from onload of question only
			currentSlide = toSlide;

		
		if (!notifyOnly) {//@G@
		//should actually move to the new slide in main timeline
			activateSlide(toSlide);
		}

		/*** /
		// Dispatching to our clients
		if (notifyOnly)
			onSlideChanged(toSlide.slideNum, p_fromHB);
		
		/*** /
		gtrace("_gotoslide toQuiz = " + toQuiz + " notifyOnly = " + notifyOnly);
		if (toQuiz && notifyOnly) {
		//should happen when called from onload of question only
			toQuiz.enterCurrentSlide();
		//	if (_pollEnterCurrentSlideIntervalID == -1) {
		//		_pollEnterCurrentSlideIntervalID = setInterval(this, "doPollEnterCurrentSlide", 100, this);
		//	}
		}
		else if(!toQuiz){
			gtrace(" PC:: _gotoSlide sending course data");
			sendCourseData(false);
		}
		
	}
**********************************************************************/
/*******************************new version****************************/
	private function _gotoSlide(toSlide:SlideInfo, notifyOnly:Boolean, p_fromHB:Boolean)
	{
		var fromQuiz:QuizController = quizControllerForSlide(currentSlide);
		var toQuiz:QuizController = quizControllerForSlide(toSlide);
		gtrace("_gotoSlide fromQuiz = " + fromQuiz);

		if(notifyOnly) //should happen when called from onload of question only
		{
			if (fromQuiz) {
				fromQuiz.leaveCurrentSlide(toSlide);
			}

			currentSlide = toSlide;
		}
				
		if (!notifyOnly) {//@G@
			//should actually move to the new slide in main timeline
			activateSlide(toSlide);
		}

		// Dispatching to our clients
		if (notifyOnly)
			onSlideChanged(toSlide.slideNum, p_fromHB);
		
		gtrace("_gotoslide toQuiz = " + toQuiz + " notifyOnly = " + notifyOnly);
		if (toQuiz && notifyOnly) {
			//should happen when called from onload of question only
			toQuiz.enterCurrentSlide();
		}
		else if(!toQuiz){
			gtrace(" PC:: _gotoSlide sending course data");
			sendCourseData(false);
		}
		
	}

/**********************************************************************/
	static public function dispatchDoActionLater(params:Object)
	{
		for (var i in _doActionLaterIntervals) {
			var intObj = _doActionLaterIntervals[i];
			var theDate = new Date();
			if (intObj.params == params) {
				if (!params.counterObj ||
					((params.counterObj._currentframe >= params.lowerFrame) && (params.counterObj._currentframe <= params.upperFrame)) ||
					(theDate.getTime() > params.timeout)) {
					clearInterval(intObj.intID);
					_doActionLaterIntervals.splice(i,1);
					params.obj[params.funcName]();
				}
			}
		}
	}

	static public function doActionLater(obj:Object, funcName:String, counterObj:Object, lowerFrame:Number, upperFrame:Number, minDelayMsecs:Number, maxDelayMsecs:Number)
	{
		var theDate = new Date();
		if ((maxDelayMsecs == undefined) || (maxDelayMsecs == 0)) {
			maxDelayMsecs = 2000;
		}
		var timeout:Number = theDate.getTime() + maxDelayMsecs;
		var params:Object = {obj:obj ,funcName:funcName, counterObj:counterObj, lowerFrame:lowerFrame, upperFrame:upperFrame, timeout:timeout};
		if ((minDelayMsecs == undefined)  || (minDelayMsecs == 0)) {
			minDelayMsecs = 100;
		}
		var intID = setInterval(dispatchDoActionLater, minDelayMsecs, params);
		if (_doActionLaterIntervals == undefined) {
			_doActionLaterIntervals = new Array();
		}
		_doActionLaterIntervals.push({params:params, intID:intID});
	}

	// return the slide that would be activated by a "next slide" command,
	// *if* the specified slide was the current slide.
	// null if no such slide in the current context.
	public function getSlideAfter(s:SlideInfo):SlideInfo
	{
		// please do not reference currentSlide here.
		// our subclasses may call it for non-current slides.

		var qc:QuizController = quizControllerForSlide(s);
		var nextSlide:SlideInfo = null;

		if (qc) {
			var qp = qc.quizParams;
			var lastSlideNum:Number = qp.lastSlideInQuiz.slideNum;
			gtrace("PC:: getSlideAfter, lastSlideNum = " + lastSlideNum);
			nextSlide = qc.slideAfter(s);
			gtrace("PC:: getSlideAfter, nextSlide = " + nextSlide.slideNum);
			if (qc.inReviewMode) {
				while (nextSlide && (nextSlide.slideNum < lastSlideNum) && (qp.getSlideType(nextSlide) == "")) {
					nextSlide = qc.slideAfter(nextSlide);
				}
			}
		}
		if (!nextSlide) {
			nextSlide = getSlide(s.slideNum+1);
		}
		gtrace("getSlideAfter, nextSlide = " + nextSlide.slideNum);

		return nextSlide;
	}

	// determine whether the specifed slide-slide transition is legal.
	// if it is, return empty string. if it is not, return an error string.
	public function allowedToGoToSlide(fromSlide:ISlideInfo, toSlide:ISlideInfo):String
	{
		var myFromSlide = SlideInfo(fromSlide);
		var myToSlide = SlideInfo(toSlide);
		var err:String = "";
		var movingBackward = (myToSlide.slideNum < myFromSlide.slideNum);
		var fromQuiz:QuizController;
		var toQuiz:QuizController;
		var inc = (myFromSlide.slideNum < myToSlide.slideNum ? 1 : -1);

		/****/
		if (loadingResumeData) {
			// don't allow navigation while waiting to get initial LMS resume data
			//gtrace("allowedToGoToSlide returning QUIZ_ERROR_WAITING_FOR_LMS_RESUME_DATA");
			return "QUIZ_ERROR_WAITING_FOR_LMS_RESUME_DATA";
		}
		/****/
		if ((myFromSlide == undefined) || !myFromSlide ||
			(myToSlide == undefined)   || !myToSlide) {
			//gtrace("allowedToGoToSlide returning QUIZ_ERROR_BAD_SLIDE_NUM");
			return "QUIZ_ERROR_BAD_SLIDE_NUM";
		}
		while (true) {
			if (myFromSlide.sameSlideAs(myToSlide)) {
				toQuiz = quizControllerForSlide(myToSlide);
				if (toQuiz) {
					err = toQuiz.canEnterSlide(myToSlide);
					//gtrace("allowedToGoToSlide returing error because of canEnterSlide, error =  '"+err+"'");
					gtrace("canEnterSlide err = " + err);
					return err;
				} else {
					//gtrace("allowedToGoToSlide returning empty string (IS ALLOWED)");
					return "";
				}
			}
			fromQuiz = quizControllerForSlide(myFromSlide);
			if (fromQuiz) {
				err = fromQuiz.canLeaveSlide(myFromSlide, movingBackward, this.currentSlide);
				gtrace("canLeaveSlide err = " + err);
			} else {
				err = "";
			}
			if (err != "") {
				//gtrace("allowedToGoToSlide returing error "+err);
				return err;
			}
			myFromSlide = getSlide(myFromSlide.slideNum + inc);
		}

	}

	// private version that allows us to specify notifyOnly and fromHB. (srj)
	// note that this is 'public' but is really only intended for 'friendly' usage...
	// so please don't use it unless you are quite certain of what you are doing.
	public function gotoSlideEx(slide:ISlideInfo, p_notifyOnly:Boolean, p_fromHB:Boolean):String
	{
		var mySlide = SlideInfo(slide);
		var errStr = allowedToGoToSlide(currentSlide, mySlide);
		gtrace("errStr" + errStr);
		if (errStr == "")
		{
			_gotoSlide(mySlide, p_notifyOnly, p_fromHB);
		} 
		else 
		{
			//gtrace("cannot go to slide "+mySlide.slideNum+" because of error: "+errStr);
		}
		return errStr;
	}

	// move directly to the given slide.
	// may fail depending on quiz limitations.
	// returns an error string: null means "no error",
	// anything else (even an empty string!) indicates an error.
	public function gotoSlide(slide:ISlideInfo):String
	{
		return gotoSlideEx(slide, /*notifyOnly*/false, /*fromHB*/false);
	}

	// advance to next slide.
	// may fail depending on quiz limitations.
	// returns an error string: null means "no error",
	// anything else (even an empty string!) indicates an error.
	public function gotoNextSlide():String
	{
		//gtrace("inside gotoNextSlide currentSlide.slideNum = " + currentSlide.slideNum);
		return gotoSlide(getSlideAfter(currentSlide));
	}


	// return the slide that would be activated by a "previous slide" command,
	// *if* the specified slide was the current slide.
	// null if no such slide in the current context.
	public function getSlideBefore(s:SlideInfo):SlideInfo
	{
		// please do not reference currentSlide here.
		// our subclasses may call it for non-current slides.
		
		var qc:QuizController = quizControllerForSlide(s);
		var prevSlide:SlideInfo = null;
		if (qc) {
			var qp = qc.quizParams;
			var firstSlideNum:Number = qp.firstSlideInQuiz.slideNum;
			prevSlide = qc.slideBefore(s);
			if (qc.inReviewMode) {
				if (prevSlide.slideNum < firstSlideNum) {
					prevSlide = getSlide(firstSlideNum);
				} else {
					while (prevSlide && (prevSlide.slideNum > firstSlideNum) && (qp.getSlideType(prevSlide) == "")) {
						prevSlide = getSlide(prevSlide.slideNum-1);
					}
				}
			}
		}
		gtrace(prevSlide.slideNum);
		if (!prevSlide) {
			prevSlide = getSlide(s.slideNum-1);
		}
		gtrace(prevSlide.slideNum);
		return prevSlide;
	}

	// retreat to prev slide.
	// may fail depending on quiz limitations.
	// returns an error string: null means "no error",
	// anything else (even an empty string!) indicates an error.
	public function gotoPrevSlide():String
	{
		return gotoSlide(getSlideBefore(currentSlide));
	}

	function resumeSlide() 
	{
		gtrace("------------->rdQSlide.resumeSlide()");
		var s:SlideInfo = currentSlide;
		
		//var qc:QuizController = quizControllerForSlide(s);
		var next_slide:SlideInfo = getSlideAfter(s);
		
		gtrace("---------->rdQSlide.resumeSlide() - currentSlide == "+currentSlide.slideNum);
		gtrace("---------->rdQSlide.resumeSlide() - next_slide == "+next_slide);
		gtrace("---------->rdQSlide.resumeSlide() - next_slide.slideNum == "+next_slide.slideNum);
		if (next_slide && (next_slide.slideNum != (s.slideNum + 1)) && (next_slide.slideNum != s.slideNum))
		{				
			gtrace("---------->rdQSlide.resumeSlide() -	 calling gotoNextSlide()");
			gotoSlide(next_slide);
		}
		else if (allowedToGoToSlide(s, next_slide ? next_slide : s) == "")
		{
			gtrace("---------->rdQSlide.resumeSlide() -	 calling resumeSlide()");
			// we resume rather than call gotoNextSlide() so any
			// outgoing transitions on the slide execute, since it this
			// case we are playing from slide n to n+1.
			// No need to call leaveSlide() here.  Playback of resume
			// slide will call rdQuizPlaybackController enterSlide which will call _gotoSlide to
			// inform the quiz controller that the slide has changed.
			
			///Leave slide will be called by last frame of current slide
			//GS change---We will call leave slide here only
			if( next_slide.slideNum > s.slideNum)
			{
				var fromQuiz:QuizController = quizControllerForSlide(currentSlide);
				gtrace("resumeslide fromQuiz = " + fromQuiz);
				if (fromQuiz) {
					fromQuiz.leaveCurrentSlide(currentSlide);
				}
			}
			_resumeSlide();
		}
	}
	
	public function leaveCurrentSlide()
	{
		var fromQuiz:QuizController = quizControllerForSlide(currentSlide);
		gtrace("\n\n\n\nresumeslide fromQuiz = " + fromQuiz + "\n\n\n\n");
		if (fromQuiz) {
			fromQuiz.leaveCurrentSlide(currentSlide);
		}
	}
	
	private function _gotoFrame(frameNum:Number)
	{
		// Override in subclasses
	}

	private function _gotoFLASlide(frameNum:Number)
	{
		// Override in subclasses
	}

	private function _resumeSlide()
	{
		// Override in subclasses
	}

	function gotoSlideNum(index:Number)
	{
		// quizzing stuff
	
		var targetSlide = getSlide(index);
		var errStr = allowedToGoToSlide(currentSlide, targetSlide);
		gtrace("errStr" + errStr);
		if (errStr == "")
		{
			_gotoSlide(targetSlide, false, false);
		} 
		else 
		{
			//gtrace("cannot go to slide "+mySlide.slideNum+" because of error: "+errStr);
		}
	
		return;			
	}	

	// Navigates to first slide/question in quiz and puts the quiz in review
	// mode in which previous answers are displayed along with an indication
	// of which is correct and which is in error.
	public function reviewAnswersForCurrentQuiz():Void
	{
		var qc:QuizController = quizControllerForSlide(currentSlide);
		qc.reviewAnswers();
	}

	
	public function getQuestion(interactionID:String):Object
	{
		var qc:QuizController = quizControllerForSlide(currentSlide);
		gtrace("getQuestion --- quizControllerForSlide = " + qc);
		return qc.getQuestion(interactionID);
	}
	
	public function set preferredLMSType(theType:String)
	{
		_preferredLMSType = theType;
	}

	public function get preferredLMSType():String
	{
		return _preferredLMSType;
	}


	public function set AuthorwareDelimeter(delim:String)
	{
		_AuthorwareDelimeter = delim;
	}

	public function get AuthorwareDelimeter():String
	{
		return _AuthorwareDelimeter;
	}

	public function set emailAddress(addr:String)
	{
		_emailAddress = addr;
	}

	public function get emailAddress():String
	{
		return _emailAddress;
	}

	public function get sendScoreAsPercent():Boolean
	{
		return _sendScoreAsPercent;
	}

	public function set sendScoreAsPercent(asPercent:Boolean)
	{
		_sendScoreAsPercent = asPercent;
	}

	public function get trackingLevel():String
	{
		return _trackingLevel;
	}

	public function set trackingLevel(theLevel:String)
	{
		_trackingLevel = theLevel;
	}

	public function get isTracked():Boolean
	{
		return _isTracked;
	}

	public function set isTracked(tracked:Boolean)
	{
		// When running under Breeze lms, force tracking to be on to
		// report slide view's properly
		var urlUtilities:Utilities = new Utilities();
		var temp_obj = urlUtilities.findParameter("airspeed");
		if(temp_obj != undefined) {
			tracked = true;
		}

		if (tracked && (tracked != _isTracked)) {
			turnOnTracking();
		} else if (!tracked) {
			if (tracked != _isTracked) {
				turnOffTracking();
			} else {
				loadingResumeData = false;
			}
		}
		_isTracked = tracked;
	}

	function turnOnTracking()
	{
		gtrace("in PlaybackController.turnOnTracking");
		if (!_trackingIsOn /**&& !_slideContainer***/) {
			this.loadingResumeData = true;
			_trackingIsOn = true;
			/**/
			if (needToLoadExternalTrackingSWF) {
				loadExternalTrackingAdapter(getTrackingAdapterReference(),  externalTrackingSWFName)
			} else {
				createTrackingAdapter();
			}
		}
	}

	function turnOffTracking()
	{
		if (_trackingIsOn) {
			//gtrace("in PlaybackController.turnOffTracking");
			loadingResumeData = false;
			clearInterval(_pollLMSIntervalID);
			_trackingIsOn = false;
		}
	}

	public function get loadingResumeData():Boolean
	{
		return _loadingResumeData;
	}

	public function set loadingResumeData(loading:Boolean)
	{
		_loadingResumeData = loading;
	}

	public function gotoRestoredQuizSlide()
	{
		if (_restoredSlideNum < 0) {
			_restoredSlideNum = 0;
		}
		//currentSlide = getSlide(_restoredSlideNum);
		//_restoringQuizState = true;
		//_gotoSlide(getSlide(_restoredSlideNum), /*notifyOnly*/false, /*fromHB*/false);
	}

	// Tell the containee to restore its state (unserialize) from state.  Returns error string;
	public function restoreQuizState(state:IQuizState):String
	{
		var myState:QuizState = QuizState(state);
		var stateStr:String = myState.toString();
		if (stateStr.length > 0) {
			_restoredSlideNum = myState.readNumber();
			for (var whichSlide in slides) {
				slides[whichSlide].seen = myState.readBoolean();
			}
			for (var whichQuiz in _quizParams) {
				var qc:QuizController = getQuizController(_quizParams[whichQuiz].quizID);
				qc.restoreState(myState);
			}
			doActionLater(this, "gotoRestoredQuizSlide", null, 0,0,500, 500);
		}
		return "";
	}

	public function _doPollLMSGetTrackingDataLoaded()
	{
		if (this.isTracked) {
			var trAdapter = _tracking.currentTrackingAdapter();
			if (trAdapter && trAdapter.isTrackingDataLoaded()) {
				clearInterval(_pollLMSIntervalID);
				var quizLocation:String = trAdapter.getLessonLocation();
				var quizStateStr:String = trAdapter.getLessonData();
			
				var quizState:QuizState = new QuizState();
				quizState.fromString(quizStateStr);
				restoreQuizState(quizState);
				loadingResumeData = false;
				_pollLMSIntervalID = setInterval(this, "doSendLMSTrackingData", trackingUpdateIntervalSecs*1000, this);
			
			} else {
				var curTime:Date = new Date();
				var deltaSecs:Number = (curTime.getTime() - this._pollLMSStartTime.getTime())/1000.0;
				if (deltaSecs > this.pollLMSGetTrackingDataTimeoutSecs) {
					turnOffTracking();
				}
			}
		}
	}

	public function doPollLMSGetTrackingDataLoaded(pbcontroller:PlaybackController)
	{
		pbcontroller._doPollLMSGetTrackingDataLoaded();
	}

	public function getTrackingData()
	{
		var trAdapter = _tracking.currentTrackingAdapter();
		trAdapter.getTrackingData();	// must call getTrackingData() after initializing tracking adapter.
		_pollLMSIntervalID = setInterval(this, "doPollLMSGetTrackingDataLoaded", 250, this);
		_pollLMSStartTime = new Date();
	}

	public function doPollLMSInitialized(pbcontroller:PlaybackController)
	{
		var trAdapter = pbcontroller._tracking.currentTrackingAdapter();
		if (trAdapter && trAdapter.isInitialized()) {
			setBreezeDefaults();
			gtrace("!!!----tracking adapter is initialized during poll, calling getTrackingData()");
			clearInterval(pbcontroller._pollLMSIntervalID);
			getTrackingData();
		} else {
			gtrace("!!!----tracking adapter fails to initialized during poll");
			var curTime:Date = new Date();
			var deltaSecs:Number = (curTime.getTime() - pbcontroller._pollLMSStartTime.getTime())/1000.0;
			if (deltaSecs > pbcontroller.pollLMSInitializeTimeoutSecs) {
				turnOffTracking();
			}
		}
	}

	public function createTrackingAdapter()
	{
		_tracking = new Tracking();
		
		gtrace("preferredLMSType = " + preferredLMSType);
		gtrace("AuthorwareDelimeter = " + AuthorwareDelimeter);
		gtrace("emailAddress = " + emailAddress);
		gtrace("getTrackingAdapterReference = " + getTrackingAdapterReference());
		gtrace("this.mmTrackingSWF = " + this.mmTrackingSWF);
		gtrace("trackingUrlEncodeVersionAndSession = " + trackingUrlEncodeVersionAndSession);
		gtrace("trackingCharsToNotUrlEncode = " + trackingCharsToNotUrlEncode);
		gtrace("trackingSendResumeData = " + trackingSendResumeData);

		if (_tracking.createTrackingAdapter(preferredLMSType, AuthorwareDelimeter, emailAddress, getTrackingAdapterReference(),
									   this.mmTrackingSWF, trackingUrlEncodeVersionAndSession, 
									   trackingCharsToNotUrlEncode, trackingSendResumeData))
		{
			var trAdapter = _tracking.currentTrackingAdapter();
			gtrace("Adapter created = " + trAdapter + " trAdapter.isInitialized() " + trAdapter.isInitialized());
			//gtrace("in PlaybackController.createTrackingAdapter, trAdapter = "+trAdapter);
			if ((trAdapter == null) || (trAdapter == undefined)) {
				
			} else if (trAdapter.isInitialized()) {
				gtrace("tracking adapter is initialized, calling getTrackingData()");
				//gtrace("tracking adapter is initialized, calling getTrackingData()");
				getTrackingData();
			} else {
				gtrace("polling for tracking adapter to become initialized");
				_pollLMSIntervalID = setInterval(this, "doPollLMSInitialized", 250, this);
				_pollLMSStartTime = new Date();
			} 
		}
		else
		{
			_root.debl("Adapter failed");
			gtrace("PlaybackController.createTrackingAdapter returns false");
			delete _tracking;
			_tracking = null;
			loadingResumeData = false;
			_trackingIsOn = false;
		}
	}

	public function isExternalTrackingSWFLoaded():Boolean
	{
		//gtrace("in isExternalTrackingSWFLoaded, mmTrackingSWF = "+mmTrackingSWF);
		if (mmTrackingSWF && (mmTrackingSWF.isReady != undefined)) {
			//gtrace("in isExternalTrackingSWFLoaded, isReady = "+mmTrackingSWF.isReady);
			return mmTrackingSWF.isReady;
		} else {
			//gtrace("isExternalTrackingSWFLoaded returning false");
			return false;
		}
	}

	public function doPollLMSLoadExternalTrackingSWF(pbcontroller:PlaybackController)
	{
		if (pbcontroller.isExternalTrackingSWFLoaded()) {
			//gtrace("in doPollLMSLoadExternalTrackingSWF, externalTrackingSWF is loaded");
			clearInterval(pbcontroller._pollLMSLoadExternalTrackingSWFIntervalID);
			pbcontroller.createTrackingAdapter();	// This will initialize the external adapter.
		} else {
			var curTime:Date = new Date();
			var deltaSecs:Number = (curTime.getTime() - pbcontroller._pollLMSLoadExternalTrackingSWFStartTime.getTime())/1000.0;
			if (deltaSecs > pbcontroller.pollLMSLoadExternalTrackingSWFTimeoutSecs) {
				gtrace("in doPollLMSLoadExternalTrackingSWF, load of externalTrackingSWF timed out, deltaSecs = "+deltaSecs);
				clearInterval(pbcontroller._pollLMSLoadExternalTrackingSWFIntervalID);
				pbcontroller.createTrackingAdapter();  // Will create an internal adapter rather than using external MMTracking.swf
			}
		}
	}
	
	
	public function loadExternalTrackingAdapter(parentReference:MovieClip, adapterName:String)
	{
		Tracking.loadExternalTrackingAdapter(parentReference, adapterName);
		_pollLMSLoadExternalTrackingSWFStartTime = new Date();
		_pollLMSLoadExternalTrackingSWFIntervalID = setInterval(this, "doPollLMSLoadExternalTrackingSWF", 250, this);
	}

	// bottleneck it here rather than in the getter (easier to override at runtime)
	public function getTrackingAdapterReference():MovieClip
	{
		// override in subclasses
		return null;
	}

	public function get mmTrackingSWF():Object
	{
		var p:Object = getTrackingAdapterReference();
		while (p) {
			//gtrace("in mmTrackingSWF getter, p = "+p+", p._mmTrackingSWF = "+p._mmTrackingSWF);
			if ((p._mmTrackingSWF != undefined) &&
				(p._mmTrackingSWF != null)) {
				return p._mmTrackingSWF;
			}
			p = p._parent;
		}
		return null;
	}

	public function get trackingUpdateIntervalSecs():Number
	{
		return _trackingUpdateIntervalSecs;
	}


	public function set trackingUpdateIntervalSecs(numSecs:Number)
	{
		_trackingUpdateIntervalSecs = numSecs;
	}

	public function get pollLMSGetTrackingDataTimeoutSecs():Number
	{
		return _pollLMSGetTrackingDataTimeoutSecs;
	}

	public function get pollLMSLoadExternalTrackingSWFTimeoutSecs():Number
	{
		return _pollLMSLoadExternalTrackingSWFTimeoutSecs;
	}

	public function set pollLMSGetTrackingDataTimeoutSecs(secs:Number)
	{
		_pollLMSGetTrackingDataTimeoutSecs = secs;
	}

	public function get pollLMSInitializeTimeoutSecs():Number
	{
		return _pollLMSInitializeTimeoutSecs;
	}

	public function set pollLMSInitializeTimeoutSecs(secs:Number)
	{
		_pollLMSInitializeTimeoutSecs = secs;
	}

	public function setBreezeDefaults()
	{
		if (this.LMSIsBreeze) {
			completionValueToSend = "default";
			completionTrigger = "breeze";
			completionSlideViewPercentage = 100;
			sendScoreAsPercent = false;
			trackingLevel = "interactions";
			trackingUrlEncodeVersionAndSession = true;
			trackingCharsToNotUrlEncode = "";
			trackingSendResumeData = true;
		}
	}

	public function get totalQuizScore():Number
	{
		var result:Number = 0;
		for (var i in _quizControllers) {
			result += _quizControllers[i].score;
		}
		return result;
	}

	public function get totalQuizMaxScore():Number
	{
		var result:Number = 0;
		for (var i in _quizControllers) {
			result += _quizControllers[i].maxScore;
		}
		return result;
	}

	public function get totalQuizMinScore():Number
	{
		var result:Number = 0;
		for (var i in _quizControllers) {
			result += _quizControllers[i].minScore;
		}
		return result;
	}

	public function get totalQuizLocation():String
	{
		return String(currentSlide.slideNum);
	}

	public function set totalQuizLocation(theSlide:String)
	{
		gotoSlide(getSlide(Number(theSlide)));
	}


	public function get totalQuizPassed():String
	{
		var s = this.totalQuizStatusAll;
		if (s.isPassed) {
			return "passed";
		} else {
			return "failed";
		}
	}

	public function get totalQuizCompleted():String
	{
		var s = this.totalQuizStatusAll;
		if (s.isCompleted) {
			return "completed";
		} else {
			return "incomplete";
		}
	}
	
	public function get totalQuizSendCompletion():Boolean
	{
		var result:Boolean = true;
		gtrace("completionValueToSend = " + completionValueToSend);
		switch (completionValueToSend) {
			case "completion":
				result = true;
				break;
			case "passed":
				result = false;
				break;
			case "default":
			default:
				var s = this.totalQuizStatusAll;
				result = s.sendCompletion;
				break;
		}
		return result;
	}

	public function get totalQuizStatus():String
	{
		var s = this.totalQuizStatusAll;
		gtrace("s.sendCompletion = " + s.sendCompletion);
		if (s.sendCompletion) {
			return this.totalQuizCompleted;
		} else {
			return this.totalQuizPassed;
		}
	}


	public function get totalQuizStatusAll():Object
	/* Returns an object with 3 fields:  
			isPassed:Boolean;  				
			isCompleted:Boolean;			
			sendCompletion:Boolean;
			sendNothing:Boolean;

	   See comments for completionOption field of PlaybackController, at the beginning of this file.
	*/
	{
		var result:Object = {isPassed:false, isCompleted:false, sendCompletion:true, sendNothing:false};

		var myCompletionTrigger:String = "";

		if (this.LMSIsBreeze) {
			myCompletionTrigger = "breeze";
		} else {
			myCompletionTrigger = this.completionTrigger;
		}

		switch (myCompletionTrigger) {
			case "breeze":
				if (this.hasQuizzes) {
					if (this.allQuestionsAnswered) {
						if (this.allQuizzesPassed) {
							result.isPassed = true;
							result.isCompleted = true;
							result.sendCompletion = false;
						} else {
							result.isPassed = false;
							result.isCompleted = true;
							result.sendCompletion = false;
						}
					} else {
						result.isPassed = false;
						result.isCompleted = false;
						result.sendCompletion = true;
					}
				} else {
					// no quizzes
					if (this.allSlidesSeen) {
						result.isPassed = true;
						result.isCompleted = true;
						result.sendCompletion = true;
					} else {
						// Not all slides seen
						result.isPassed = false;
						result.isCompleted = false;
						result.sendCompletion = true;
					}
				}
				break;
			case "quiz_only":
				if (!this.hasQuizzes) {
					if (this.passingNumSlidesSeen) {
						result.isPassed = true;
						result.isCompleted = true;
						result.sendCompletion = true;
					} else {
						result.isPassed = false;
						result.isCompleted = false;
						result.sendCompletion = true;
					}
				} else { // have quizzes
					if (this.allQuizzesPassingScore == 0) {
						if (this.allQuizAttemptsFinished) {
							result.isPassed = true;
							result.isCompleted = true;
							result.sendCompletion = true;
						} else {
							result.isPassed = false;
							result.isCompleted = false;
							result.sendCompletion = true;
						}
					} else { // passing score > 0
						if (this.allQuizzesPassed) {
							result.isPassed = true;
							result.isCompleted = true;
							result.sendCompletion = false;
						} else if (this.allQuizAttemptsFinished) {
							result.isPassed = false;
							result.isCompleted = true;
							result.sendCompletion = false;
						} else {
							result.isPassed = false;
							result.isCompleted = false;
							result.sendCompletion = true;
						}
					}

				}
				break;
			case "quiz_and_views":
				if (!this.hasQuizzes) {
					if (this.passingNumSlidesSeen) {
						result.isPassed = true;
						result.isCompleted = true;
						result.sendCompletion = true;
					} else {
						result.isPassed = false;
						result.isCompleted = false;
						result.sendCompletion = true;
					}
				} else { // have quizzes
					if (this.allQuizzesPassingScore == 0) {
						if (this.allQuizAttemptsFinished) {
							result.isPassed = true;
							result.isCompleted = true;
							result.sendCompletion = true;
						} else {
							result.isPassed = false;
							result.isCompleted = false;
							result.sendCompletion = true;
						}
					} else { // passing score > 0
						if (this.allQuizzesPassed) {
							result.isPassed = true;
							result.sendCompletion = false;
						} else if (this.allQuizAttemptsFinished) {
							result.isPassed = false;
							result.sendCompletion = false;
						}
						if (this.passingNumSlidesSeen) {
							result.isCompleted = true;
							result.sendCompletion = true;
						} 
					}

				}
				break;
			case "views_only":
				if (this.passingNumSlidesSeen) {
					result.isPassed = true
					result.isCompleted = true;
					result.sendCompletion = true;
				} else {
					result.isPassed = false
					result.isCompleted = false;
					result.sendCompletion = true;
				}
				break;
			case "access":
			default:
				if (this.numSlidesSeen < 1) {
					result.isPassed = false;
					result.isCompleted = false;
					result.sendCompletion = true;

				} else {
					result.isPassed = true;
					result.isCompleted = true;
					result.sendCompletion = true;
				}
				break;
		}
		return result;
	}


	public function get allQuestionsAnswered():Boolean
	{
		for (var qp in _quizParams) {
			var qc:QuizController = getQuizController(_quizParams[qp].quizID);
			if (!qc.allQuestionsAnswered) {
				return false;
			}
		}
		return true;
	}


	public function sendCourseData(flush:Boolean)
	{
		setBreezeDefaults();
		/****
		if (_slideContainer) {
			_slideContainer.sendCourseData(flush);
		} else 
		****/
		{
			var curAdapter:TrackingAdapter = _tracking.currentTrackingAdapter();
			gtrace("sendCourseData curAdapter = " + curAdapter);
			gtrace("sendCourseData: totalQuizState = "+totalQuizState);
			
			if (isTracked && curAdapter) {
				//gtrace("sendCourseData: totalQuizScore = "+totalQuizScore);
				//gtrace("sendCourseData: totalQuizMinScore = "+totalQuizMinScore);
				//gtrace("sendCourseData: totalQuizMaxScore = "+totalQuizMaxScore);
				//gtrace("sendCourseData: sendScoreAsPercent = "+sendScoreAsPercent);
				//gtrace("sendCourseData: totalQuizLocation = "+totalQuizLocation);
				//gtrace("sendCourseData: totalQuizCompleted = "+totalQuizCompleted);
				//gtrace("sendCourseData: totalQuizPassed = "+totalQuizPassed);
				gtrace("sendCourseData: totalQuizSendCompletion = "+totalQuizSendCompletion);
				//gtrace("sendCourseData: totalQuizTime = "+totalQuizTime);				
				//gtrace("sendCourseData: totalQuizState = "+totalQuizState);
				curAdapter.sendTrackingData(totalQuizScore, totalQuizMinScore, totalQuizMaxScore,
								sendScoreAsPercent, totalQuizLocation, totalQuizCompleted, 
								totalQuizPassed, totalQuizSendCompletion, totalQuizTime, 
								totalQuizState);
				if (flush) {
					curAdapter.flush();
				}
			}
		}
	}

	public function onEndQuiz(qc:QuizController)
	{
		if (isTracked && (preferredLMSType.toUpperCase() != "EMAIL")) {
			gtrace("PC:: onEndQuiz sending course data");
			sendCourseData(true);
		}
	}


	public function sendEmailResults()
	{
		gtrace("isTracked = " + isTracked + " preferredLMSType.toUpperCase() = " + preferredLMSType.toUpperCase());
		if (isTracked && (preferredLMSType.toUpperCase() == "EMAIL")) {
			gtrace("PC:: sendEmailResults sending course data");
			sendCourseData(true);
		}
	}

	public function doSendLMSTrackingData(pbcontroller:PlaybackController)
	{
		gtrace("PC:: doSendLMSTrackingData sending course data");
		pbcontroller.sendCourseData(false);
	}

	public function finishCurrentQuiz()
	{
		var qc = quizControllerForSlide(currentSlide);
		qc.finishQuiz();
	}

	public function get LMSIsBreeze():Boolean
	{
		return (this.actualLMSType == "BREEZE");
	}

	public function get hasQuizzes():Boolean
	{
		return (_quizParams.length > 0);
	}

	public function get allQuizzesPassed():Boolean
	{
		for (var qp in _quizParams) {
			var qc:QuizController = getQuizController(_quizParams[qp].quizID);
			if (!qc.isPassed) {
				return false;
			}
		}
		return true;
	}

	public function get passingNumSlidesSeen():Boolean
	{
		return ((this.numSlidesSeen/slides.length)*100.0 >= completionSlideViewPercentage);
	}

	public function get allSlidesSeen():Boolean
	{
		return (this.numSlidesSeen == slides.length);
	}

	public function get allQuizzesPassingScore():Number
	{
		var result:Number = 0;
		for (var qp in _quizParams) {
			result += _quizParams[qp].passingScore;
		}
		return result;
	}

	public function get allQuizAttemptsFinished():Boolean
	{
		for (var qp in _quizParams) {
			var qc:QuizController = getQuizController(_quizParams[qp].quizID);
			if (!qc.isAttemptFinished) {
				return false;
			}
		}
		return true;
	}

	public function get numSlidesSeen():Number
	{
		var numSeen:Number = 0;
		for (var whichSlide in slides) {
			if (slides[whichSlide].seen) {
				numSeen++;
			}
		}
		return numSeen;
	}

	public function get totalQuizTime():String
	{
		return null;
	}

	public function get actualLMSType():String
	{
		var actualType:String = null;
		if (_tracking) {
			var trackingAdapter = _tracking.currentTrackingAdapter();
			if (trackingAdapter) {
				return trackingAdapter.getTrackingAdapterType().type_str;
			}
		}
		if (!actualType) {
			actualType = this.preferredLMSType;
		}
		return actualType;
	}
	
	// Tell the containee to serialize itself to state.  Returns error string.
	public function saveQuizState(state:IQuizState):String
	{
		var myState:QuizState = QuizState(state);
		myState.writeNumber(currentSlide.slideNum);
		gtrace(" PC:: currentSlide.slideNum myState = " + myState.toString());
		for (var whichSlide in slides) {
			myState.writeBoolean(slides[whichSlide].seen);
			gtrace(" PC:: slides[whichSlide].seen myState = " + myState.toString());
		}
		for (var whichQuiz in _quizParams) {
			var qc:QuizController = getQuizController(_quizParams[whichQuiz].quizID);
			qc.saveState(myState);
		}
		return "";
	}
	

	public function get totalQuizState():String
	{

		var myState:QuizState = new QuizState();
		saveQuizState(myState);
		var s:String = myState.toString();
		return s;
	}

	function doFinalExit()
	{
		turnOffTracking();
		if (_allowForceQuitContainer) {
			if (_root.FlashPlayer) {
				fscommand ("quit");
			} else {
				if(preferredLMSType.toUpperCase() != "AUTHORWARE") {
					getURL("javascript:window.close();", "_self");
				}
			}
		}
	}

	function exitCourse()
	{
		/****
		if (_slideContainer) {
			_slideContainer.exitCourse();
		} else 
		*****/
		{
			if (isTracked && _tracking.currentTrackingAdapter()) {
				if (preferredLMSType.toUpperCase() != "EMAIL") {
					gtrace("PC:: exitCourse sending course data");
					sendCourseData(true);
				}
				_tracking.currentTrackingAdapter().finish();
				// Wait 3 seconds to allow LMS data to flush
				doActionLater(this, "doFinalExit", null, 0, 0, 3000, 3000);
			} else {
				doFinalExit();
			}
		}
	}
	
	public function sendInteractionData(questionScore:QuestionScore)
	{
		gtrace("in PlaybackController.sendInteractionData(), isTracked = "+isTracked+", trackingLevel = "+trackingLevel);
		gtrace(" questionScore = " + questionScore);
		gtrace(" correctAnswersAsString = "+questionScore.correctAnswersAsString);
		gtrace(" chosenAnswersAsString = "+questionScore.chosenAnswersAsString);
		setBreezeDefaults();
		/*****
		if (_slideContainer) {
			_slideContainer.sendInteractionData(questionScore);
		} else 
		*****/
		if (isTracked && (trackingLevel == "interactions")) {
			var trackingAdapter = _tracking.currentTrackingAdapter();
			if (trackingAdapter) {
				with (questionScore) {
					 //gtrace("about to call trackingAdapter.sendInteractionData");
					 //gtrace("interactionID = "+interactionID);
					 //gtrace("objectiveID = "+objectiveID);
					 //gtrace("interactionType = "+interactionType);
					 gtrace(" correctAnswersAsString = "+questionScore.correctAnswersAsString);
					 gtrace(" chosenAnswersAsString = "+questionScore.chosenAnswersAsString);
					 gtrace(" isCorrectAsString = "+questionScore.isCorrectAsString);
					 //gtrace("weighting = "+weighting);
					 //gtrace("latencyAsSeconds = "+latencyAsSeconds);
					 //gtrace("curDateAsString = "+curDateAsString);
					 //gtrace("curTimeAsSecondsSinceMidnight = "+curTimeAsSecondsSinceMidnight);
					 trackingAdapter.sendInteractionData(interactionID,
													 objectiveID,
													 interactionType,
													 correctAnswersAsString,
													 chosenAnswersAsString,
													 isCorrectAsString,
													 weighting,
													 latencyAsSeconds,
													 curDateAsString,
													 curTimeAsSecondsSinceMidnight
													 );

				}
			}
		}
	}

	public function get sendCourseDataWithInteractionData():Boolean
	{
		return _sendCourseDataWithInteractionData;
	}

	public function set sendCourseDataWithInteractionData(doSend:Boolean)
	{
		_sendCourseDataWithInteractionData = doSend;
	}


	// If set to false, this will prevent the content from "force
	// quitting" the container when the user attempts to exit the course.  In the
	// case of content running inside of Breeze Live, for instance, we
	// DON'T want the content to quit the container.  However, when we
	// are running "stand-alone" in Breeze, we do want to allow the
	// content to quit the containing browser window.  The default is
	// true.
	public function setAllowForceQuitContainer(allow:Boolean):Void
	{
		_allowForceQuitContainer = allow;
	}


     public function onSlideChanged(i:Number, p_fromHB:Boolean)
     {
		// for compatibility with existing Captivate code.
		if (p_fromHB == undefined)
			p_fromHB = false;

		// force currentSlide to stay in sync. this can happen in Captivate...
		if (i >= 0 && i < slides.length)
		{
			slides[i].seen = true;
			currentSlide = slides[i];
			if (_tracking) {
				var trackingAdapter = _tracking.currentTrackingAdapter();
				if (trackingAdapter) {
					//works only for breeze
					trackingAdapter.sendSlideView(i);
				}
			}
		}
     	dispatchEvent({type:"slideChanged", target:this, slideNum:currentSlide.slideNum, fromHB:p_fromHB});
     }


	public function get timeoutMessage():String { return _timeoutMessage;	}
	public function set timeoutMessage(msg:String) { 
		_timeoutMessage = msg;
		gtrace("_timeoutMessage = " + _timeoutMessage + " _timeoutMessage.length = " + _timeoutMessage.length);
		if(_timeoutMessage.length > 0)
			showTimeoutMessage = true;
	}
	
	public function get showTimeoutMessage():Boolean { return _showTimeoutMessage; }
	public function set showTimeoutMessage(show:Boolean) { _showTimeoutMessage = show; }
	
	public function get reviewMessages():Array { return _reviewMessages; }
	public function set reviewMessages(msg:Array) { _reviewMessages = msg; }
	
	public function gtrace(str)	{ 
		return;
		if( System.capabilities.playerType == "PlugIn" || System.capabilities.playerType == "ActiveX" ||
			System.capabilities.playerType == "StandAlone")
			_root.debl(str);
		else
			gtrace(str);
	}
}
