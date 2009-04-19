//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMSlideClasses.*;

/*
	For functions that return an error string, the current
	list of defined errors includes:
	
		"QUIZ_ERROR_BAD_SLIDE_NUM"
		"QUIZ_ERROR_TOO_MANY_QUIZ_ATTEMPTS"
		"QUIZ_ERROR_MUST_PASS_QUIZ_TO_SEE_PASS_SCORE_SLIDE"
		"QUIZ_ERROR_MUST_FAIL_QUIZ_TO_SEE_FAIL_SCORE_SLIDE"
		"QUIZ_ERROR_MUST_START_QUIZ_TO_SEE_SCORE_SLIDE"
		"QUIZ_ERROR_MUST_FINISH_QUIZ_TO_SEE_SCORE_SLIDE"
		"QUIZ_ERROR_MUST_ANSWER_QUESTION"
		"QUIZ_ERROR_MUST_ANSWER_CORRECTLY"
		"QUIZ_ERROR_MUST_TAKE_QUIZ"
		"QUIZ_ERROR_MUST_PASS_QUIZ"
		"QUIZ_ERROR_MUST_SEE_PASS_SCORE_SLIDE"
		"QUIZ_ERROR_MUST_SEE_FAIL_SCORE_SLIDE"
		"QUIZ_ERROR_MUST_SEE_SCORE_SLIDE"
		"QUIZ_ERROR_WAITING_FOR_LMS_RESUME_DATA"
		"QUIZ_ERROR_CANNOT_MOVE_BACKWARD_TO_GO_OUT_OF_QUIZ" (doesn't apply to gotoNextSlide)
		"QUIZ_ERROR_CANNOT_MOVE_BACKWARD_IN_QUIZ" (doesn't apply to gotoNextSlide)

	Note that this is NOT intended to be an exhaustive list; more errors may be added in the future.

*/

[Event("playStateChanged")]
/*
	{type:"playStateChanged", target:ISlideContent, isPlaying:Boolean}
*/

[Event("scrubChanged")]
/*
	{type:"scrubChanged", target:ISlideContent, scrub:Number}
*/

[Event("slideChanged")]
/*
	{type:"slideChanged", target:ISlideContent, slideNum:Number}
	
	Note that this event is broadcast AFTER the slide has become the active slide...
	but the new slide may not necessarily be fully loaded yet, depending on network
	conditions.
*/

[Event("currentSlideLoaded")]
/*
	{type:"currentSlideLoaded", target:ISlideContent, slideNum:Number}
	
	Note that this event is broadcast AFTER the slideChanged event,
	and indicates that the slide is completely loaded. (If the slide
	was completely loaded already, this event should generally immediately
	follow slideChanged.)
*/

[Event("volumeChanged")]
/*
	{type:"volumeChanged", target:ISlideContent, volume:Number}
*/

interface MMQuizzingV3.MMSlideClasses.ISlideContent
{
	// return true if the content is ready to be controlled.
	// if false is returned, the content is NOT ready and may misbehave;
	// you should wait a frame and try again.
	public function isReady():Boolean;

	// return the (0-based) slide number of the current slide
	public function getCurrentSlideIndex():Number;

	// return SlideInfo for the given slide. slideNum must be 0<=slideNum<getNumSlides().
	// return null if out of range.
	public function getSlideInfo(slideNum:Number):MMQuizzingV3.MMSlideClasses.ISlideInfo;

	// return number of slides. must be > 0.
	public function getNumSlides():Number;

	// retreat to prev slide.
	// may fail depending on quiz limitations.
	// returns an error string: empty string means "no error",
	// anything else indicates an error.
	public function gotoNextSlide():String;

	// advance to next slide.
	// may fail depending on quiz limitations.
	// returns an error string: empty string means "no error",
	// anything else indicates an error.
	public function gotoPrevSlide():String;

	// move directly to the given slide.
	// may fail depending on quiz limitations.
	// returns an error string: empty string means "no error",
	// anything else indicates an error.
	public function gotoSlide(slide:MMQuizzingV3.MMSlideClasses.ISlideInfo):String;

	// determine whether the specifed slide-slide transition is legal.
	// if it is, return empty string. if it is not, return an error string.
	public function allowedToGoToSlide(fromSlide:MMQuizzingV3.MMSlideClasses.ISlideInfo, toSlide:MMQuizzingV3.MMSlideClasses.ISlideInfo):String;
	
	// Navigates to first slide/question in quiz and puts the quiz in review 
	// mode in which previous answers are displayed along with an indication 
	// of which is correct and which is in error.
	public function reviewAnswersForCurrentQuiz():Void;

	// show or hide the portion of the UI specified.
	// current well-defined values for part are:
	//
	//		"playbar"	the playbar.
	//		"sidebar"	the sidebar (in Serrano).
	//
	// others might be added.
	//
	// if part is understood by this implementation, true is returned.
	// if part is one not understood buy this implementation, false is returned.
	//
	public function showUI(part:String, show:Boolean):Boolean;

	// pause or resume playback.
	public function setPlaying(playing:Boolean):Void;
	
	// return true if currently playing, false if not.
	public function isPlaying():Boolean;
	
	// return the total "duration" of the current content, in milliseconds,
	// for the given slide. 
	//
	// Obviously, this must always be > 0.
	//
	public function getScrubDuration(slideIndex:Number):Number;

	// return the offset to the beginning of this slide from the start
	// of the presentation, in milliseconds. this should always be the
	// sum of getScrubDuration() for all previous slides.
	//
	// Obviously, this must always be > 0.
	//
	public function getScrubStart(slideIndex:Number):Number;

	// return the "playback head" location of the content, in milliseconds.
	// Note that this is from the start of the current slide, NOT the entire
	// preso; to convert to entire-preso time, add getScrubStart(currentSlide).
	public function getScrubPosition():Number;

	// move the "playback head" location of the content to 
	// the specified position, in milliseconds. the value must be
	// 0<=offset<=getScrubDuration(). Out-of-range values will be clipped.
	//
	// note that this only changes scrub within the current slide.
	// If you want to scrub across the entire preso, you need to
	// convert the scrub time to preso-scrub (by adding getScrubStart),
	// determine which slide may need to activated (by examining
	// getScrubStart/Duration for slides), and calling gotoSlide if necessary.
	//
	public function gotoScrubPosition(position:Number):Void;

	// Informs the containee that it is being contained and gives it a way to call container object methods.
	public function setContainer(container:MMQuizzingV3.MMSlideClasses.ISlideContainer):Void;

	// Tell the containee to serialize itself to state.  Returns error string.
	public function saveQuizState(state:MMQuizzingV3.MMSlideClasses.IQuizState):String;

	// Tell the containee to restore its state (unserialize) from state.  Returns error string.
	public function restoreQuizState(state:MMQuizzingV3.MMSlideClasses.IQuizState):String;

	// Returns total current score in all the quizzes in the containee 
	public function getTotalQuizScore():Number;

	// Returns min/max possible quiz score, summed across all quizzes in the containee 
	public function getMinQuizScore():Number;
	public function getMaxQuizScore():Number;

	// Have all the quizzes in the containee been passed?
	public function isQuizPassed():Boolean;

	// Have all the quizzes/content in the containee been completed?
	public function isQuizCompleted():Boolean;
	
	// Tells the content to resize itself to the given dimensions
	public function setSize(newWidth:Number, newHeight:Number):Void;
	
	//  Registers a listener object with a component instance that is broadcasting an event.
	public function addEventListener(eventName:String, listenerObj:Object):Void;
	
};
