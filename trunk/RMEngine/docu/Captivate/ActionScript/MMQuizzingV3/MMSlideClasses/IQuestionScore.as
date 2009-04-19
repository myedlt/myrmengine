//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

interface MMQuizzingV3.MMSlideClasses.IQuestionScore 
{
	public function getSlideNum():Number;
	public function setSlideNum(num:Number);
	
	public function getStartTime():Date;
	public function setStartTime(time:Date);
	
	public function getEndTime():Date;
	public function setEndTime(time:Date);
	
	public function getInteractionType():String;
	public function setInteractionType(intType:String);
	
	public function getObjectiveID():String;
	public function setObjectiveID(id:String);
	
	public function getInteractionID():String;
	public function setInteractionID(id:String);
	
	public function getWeighting():Number;
	public function setWeighting(wt:Number);
	
	public function getAnswerScores():Array;
	public function setAnswerScores(scores:Array);
	
	public function getNumTries():Number;
	public function setNumTries(num:Number);
	
	public function getAnswersIncomplete():Boolean;
	public function setAnswersIncomplete(incomplete:Boolean);
	
	public function getAnsweredCorrectly():Boolean;
	public function setAnsweredCorrectly(correct:Boolean);
	
	public function getPausedMsecs():Number;
	public function setPausedMsecs(msecs:Number);
	
	public function getQuestionNumInQuiz():Number;
	public function setQuestionNumInQuiz(num:Number);
	
	public function getWasJudged():Boolean;
	public function setWasJudged(judged:Boolean);
};
