//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

interface MMQuizzingV3.MMSlideClasses.IViewerController
{
	// pause or resume playback.
	public function setPlaying(playing:Boolean):Void
	
	// return true if currently playing, false if not.
	public function isPlaying():Boolean
	
	// return number of slides. must be > 0.
	public function getNumSlides():Number
	
	// retreat to prev slide.
	// returns an error string: empty string means "no error",
	// anything else indicates an error.
	public function gotoNextSlide():String

	// advance to next slide.
	// returns an error string: empty string means "no error",
	// anything else indicates an error.
	public function gotoPrevSlide():String

	// move directly to the given slide by index.
	// returns an error string: empty string means "no error",
	// anything else indicates an error.
	public function gotoSlideIndex(slideIndex:Number):String

	// move directly to the given slide by id.
	// returns an error string: empty string means "no error",
	// anything else indicates an error.
	public function gotoSlideID(slideID:String):String

	// retreat to prev slide.
	// returns an error string: empty string means "no error",
	// anything else indicates an error.
	public function gotoFirstSlide():String

	// advance to next slide.
	// returns an error string: empty string means "no error",
	// anything else indicates an error.
	public function gotoLastSlide():String	
	
	// for the given slide, return the url of its parent directory.
	// this includes any necessary directory separator.
	// for instance, if the slide is "data/foo.swf", the return value will be "data/"
	public function getSlideRootURL(slideIndex:Number):String;
	
	// the slide should use this call, instead of getURL(): args and functionality
	// are the same as getURL, but this allows us to control where the windows open 
	// (the "target" stuff) or things like that (or a Live presenter may decide that 
	// a viewer cannot jump around or open browser windows, or maybe that we want 
	// to log the information that they did indeed clicked on those links.)
	public function gotoURL(url:String, window:String):Void;
};

