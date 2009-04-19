//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

class MMQuizzingV3.MMQuizClasses.SlideInfo 
	extends Object 
	implements MMQuizzingV3.MMSlideClasses.ISlideInfo {
	
	private var _slideNum:Number;
	private var _firstFrameNum:Number;
	private var _lastFrameNum:Number;
	private var _questionsOnSlide:Array;
	private var _seen:Boolean = false;
	
	public function get slideNum():Number	{	return _slideNum;	}
	public function set slideNum(num:Number)	{	_slideNum = num;	}
	
	public function get firstFrameNum():Number	{	return _firstFrameNum;	}
	public function set firstFrameNum(frameNum:Number)	{	_firstFrameNum = frameNum;	}
	
	public function get lastFrameNum():Number	{	return _lastFrameNum;	}
	public function set lastFrameNum(frameNum:Number)	{	_lastFrameNum = frameNum;	}
	
	public function get questionsOnSlide():Array	{	//trace("SI:: _questionsOnSlide = " + _questionsOnSlide);
		 return _questionsOnSlide;	}
	public function set questionsOnSlide(questions:Array) 	{	_questionsOnSlide = questions;	}

	public function get seen():Boolean	{	return _seen;	}
	public function set seen(seenIt:Boolean)	{	_seen = seenIt;	}

	public function sameSlideAs(slide:SlideInfo):Boolean
	{
		return (slide && (this.slideNum == slide.slideNum));
	}

	function SlideInfo()	{ _questionsOnSlide = [];	}
	
	// ---------------------------------------------------------------------------

	// OVERRIDE from ISlideInfo
	public function getSlideTitle():String
	{
		return "";
	}
}