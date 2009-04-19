//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMQuizClasses.SlideInfo;
import MMQuizzingV3.MMQuizClasses.QuizParams;
//import MMQuizzingV3.MMQuizClasses.QuizController;
import MMQuizzingV3.MMQuizClasses.PlaybackController;

class MMQuizzingV3.MMQuizClasses.rdQuizPlaybackController extends MMQuizzingV3.MMQuizClasses.PlaybackController 
{	
	private var _container = null;
	private var _movieContainer = null;
	private var _trackingAdapterReference:MovieClip = null;
	
	var isTrackedFlag:Boolean = false;
	
	function rdQuizPlaybackController()
	{
		//gtrace("rdQuizPlaybackController created");
	}
	
	function init()
	{
		super.init();
		//Need to check with captivate, if we will support this or not
		needToLoadExternalTrackingSWF = true;
	}
	
	function addSlideInfo(slideNumber:Number, firstFrameNum:Number, lastFrameNum:Number)
	{
		var s:SlideInfo = new SlideInfo();
		s.slideNum = slideNumber;
		s.firstFrameNum = firstFrameNum;
		s.lastFrameNum = lastFrameNum;
		s.questionsOnSlide = [];
		
		if ((_slides == null) || (_slides == undefined)) {
			_slides = new Array();
		}
		_slides.push(s);
	}

	function addQuizParams(q:QuizParams)
	{
		// Add quizParams argument to quizParams array
		_quizParams = new Array();
		_quizParams.push(q);
		//gtrace("added quiz params = " + q.quizID);
	}

	public function getCurrentSlideContainer():Object
	{
		//gtrace("into right getCurrentSlideContainer " + _container);
		return _container;
	}
	
	public function setCurrentMovieContainer(container)
	{
		gtrace("into right getCurrentSlideContainer " + _container);
		_movieContainer = container;
	}

	public function getCurrentMovieContainer():Object
	{
		//gtrace("into right getCurrentSlideContainer " + _container);
		return _movieContainer;
	}
	
	public function setCurrentSlideContainer(container)
	{
		_container = container;
	}

	public function enterSlide(toSlide:SlideInfo)
	{
		gtrace("enterSlide:: toSlide = " + toSlide + " currentSlide = " + currentSlide);
		if (toSlide != currentSlide) {
			_gotoSlide(toSlide, /* notifyOnly */ true, /* p_fromHB */ false);
		}
	}

	private function _gotoFLASlide(slideNumber:Number)
	{
		gtrace("_gotoQuestionSlide slideNumber = " + slideNumber + " currentSlide.slideNum = " + currentSlide.slideNum);
		/*****
		if(slideNumber == (currentSlide.slideNum + 1))
		{
			//gtrace("getCurrentSlideContainer = " + getCurrentSlideContainer()); 
			//gtrace("getCurrentMovieContainer = " + getCurrentMovieContainer()); 
			if((getCurrentSlideContainer() != getCurrentMovieContainer()) && getCurrentMovieContainer() != null && getCurrentMovieContainer() != undefined)
				getCurrentMovieContainer().play();
			getCurrentSlideContainer().play();
			return;
		}
		*****/
		gtrace("getCurrentSlideContainer() = " + getCurrentSlideContainer() + "getCurrentMovieContainer() = " + getCurrentMovieContainer());
		var frameLabel:String;
		slideNumber += 1; //quizcontroller has slide numbers w.r.t 0, where as timeline has it w.r.t 1
		if( slideNumber >= 1) {
			frameLabel = "Slide_" + slideNumber;
			//gtrace("next frameLabel = " + frameLabel);
			getCurrentMovieContainer().gotoAndPlay(frameLabel);
		}
	}

	private function _resumeSlide()
	{
		//gtrace("_resumeSlide getCurrentSlideContainer = " + getCurrentSlideContainer()); 
		//gtrace("_resumeSlide getCurrentMovieContainer = " + getCurrentMovieContainer()); 
		if((getCurrentSlideContainer() != getCurrentMovieContainer()) && getCurrentMovieContainer() != null && getCurrentMovieContainer() != undefined)
			getCurrentMovieContainer().play();
		getCurrentSlideContainer().play();
	}
	
	public function gotoSlideFrame(slideNumber:Number, frameNumber:Number):Boolean
	{
		var s:SlideInfo = currentSlide;
		
		var next_slide:SlideInfo = getSlide(slideNumber);
		
		gtrace("---------->rdQSlide.gotoSlideFrame() - frameNumber = " + frameNumber);
		gtrace("---------->rdQSlide.gotoSlideFrame() - currentSlide == "+currentSlide.slideNum);
		gtrace("---------->rdQSlide.gotoSlideFrame() - next_slide == "+next_slide);
		gtrace("---------->rdQSlide.gotoSlideFrame() - next_slide.slideNum == "+next_slide.slideNum);
		if (allowedToGoToSlide(s, next_slide ? next_slide : s) == "")
		{
			gtrace("gotoSlideFrame getCurrentMovieContainer() = " + getCurrentMovieContainer() + " frameNumber = " + frameNumber);
			getCurrentMovieContainer().gotoAndStop(frameNumber);
			return true;
		}
		return false;
	}
	
	public function getTrackingAdapterReference():MovieClip
	{
		return _trackingAdapterReference;
	}

	public function setTrackingAdapterReference(trackingAdapterReference)
	{
		_trackingAdapterReference = trackingAdapterReference;
	}

	function setLmsType(val:Number)
	{
		// Valid argument values correspond to Captivate database values
		//	stNone = 0,
		//	stSCORM = 1,
		//	stAuthorWare = 2,
		//	stAICC = 3,
		//	stQuestionMark = 4,
		//	stEmail = 5
		//	stBreeze = 6
		switch (val)
		{
			case 1:
				preferredLMSType = "SCORM";
				break;
			case 2:
				preferredLMSType = "Authorware";
				break;
			case 3:
				preferredLMSType = "AICC";
				break;
			case 4:
				preferredLMSType = "Questionmark";
				break;
			case 5:
				preferredLMSType = "email";
				break;
			case 6:
				preferredLMSType = "AICC";
				break;
			default:
				preferredLMSType = "";
				break;	
		}
	}
	
	function setSendCompletionFlag(val:Number)
	{
		if (val == 1)
			completionValueToSend = "passed";
		else
			completionValueToSend = "completion";
	}

	function setSendScoreAsPercent(val:Number)
	{
		if (val)
			sendScoreAsPercent = true;
		else
			sendScoreAsPercent = false;
	}

	function setEmailAddress(addr:String)
	{
		emailAddress = addr;
	}
	
	function setAuthorwareDelimeter(val:String)
	{
		AuthorwareDelimeter = val;
	}
	
	function setTrackingLevel(val:Number)
	{
		switch(val)
		{
			case 0:	// Final only
				trackingLevel = "interactions";			
				break;
			case 2:	// Objectives, interactions and final
				trackingLevel = "score";
				break;			
		}
	}

	function setIsTrackedFlag(val:Number)
	{
		//gtrace("--------------rdQuizPlaybackController.setIsTracked("+val+")");
		if (val)
			isTrackedFlag = true;
		else
			isTrackedFlag = false;
	}

	function setSlideInfo(firstSlide:Number, lastSlide:Number)
	{
		for(var count:Number = firstSlide; count <= lastSlide; count++)
		{
			addSlideInfo(count, 0, 0);
		}
	}
}