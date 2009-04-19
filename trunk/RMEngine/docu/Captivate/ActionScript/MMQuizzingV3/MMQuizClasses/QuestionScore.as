//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMQuizClasses.AnswerScore;
import MMQuizzingV3.MMQuizClasses.QuizState;
import MMQuizzingV3.MMSlideClasses.IQuestionScore


class MMQuizzingV3.MMQuizClasses.QuestionScore 
	extends Object 
	implements IQuestionScore {	
	public var _slideNum:Number;
	private var _startTime:Date;
	private var _endTime:Date;
	private var _interactionType:String;	// String enumeration.  Values are 
											// "choice", "true-false",
											// "likert", "fill-in",
											// "long-fill-in",
											// "matching"
	private var _objectiveID:String;
	private var _interactionID:String;
	private var _weighting:Number;
	private var _answerScores:Array;		// An array that has one entry per answer.  Each entry in this array gives the correct answer
											// and the chosen answer.
	private var _numTries:Number = 0;		// Number of tries/attempts user made answering the question.
	private var _answersIncomplete:Boolean = true;	// Were the answers for the last attempt complete?
	private var _answeredCorrectly = false;
	private var _pausedMsecs:Number = 0;
	private var _questionNumInQuiz:Number = -1;
	private var _wasJudged:Boolean;
	
	
	
	public function get slideNum():Number	{	return _slideNum;	}
	public function set slideNum(num:Number)	{	_slideNum = num;	}
	
	public function get startTime():Date	{	return _startTime;	}
	public function set startTime(time:Date):Void	{	_startTime = time;	}
	
	public function get endTime():Date	{	return _endTime;	}
	public function set endTime(time:Date):Date	{	_endTime = time;	}

	public function get pausedMsecs():Number	{	return _pausedMsecs;	}
	public function set pausedMsecs(msecs:Number):Void		{	_pausedMsecs = msecs;	}

	public function get interactionType():String	{	return _interactionType;	}
	public function set interactionType(theType:String):Void	{	_interactionType = theType;	}
	
	public function get objectiveID():String	{	return _objectiveID;	}
	public function set objectiveID(id:String):Void	{	_objectiveID = id;	}
	
	public function get questionNumInQuiz():Number	{	return _questionNumInQuiz;	}
	public function set questionNumInQuiz(num:Number)	{	_questionNumInQuiz = num;	}
	
	// Returns number of seconds spent on this question
	public function get latency():Number
	{
		var msecs:Number;
		var seconds:Number;
		
		msecs = endTime.getTime() - startTime.getTime() - pausedMsecs;
		seconds = msecs/1000;
		return seconds;
	}
	
	
	public function get answerScores():Array	{	return _answerScores;	}
	public function set answerScores(scores:Array)	{	_answerScores = scores;	}
	
	public function get answersIncomplete():Boolean	{	return _answersIncomplete;	}
	public function set answersIncomplete(incomplete:Boolean)	{	_answersIncomplete = incomplete;	}

	public function spacesToUnderscores(s:String):String
	{
		var r:String = "";

		for (var i = 0; i < s.length; i++) {
			 var c:String = s.charAt(i);
			 if (c == " ") {
				 c = "_";
			 }
			 r = r.concat(c);
		}

		return r;
	}

	public function escapeCommasAndSemiColons(s:String):String
	{
		var result:String = "";
		var ind:Number = 0;
		var indResult:Number = 0;
		var curChar;

		for (ind = 0; ind < s.length; ind++) {
			curChar = s.charAt(ind);
			if ((curChar == ";") ||
				  (curChar == ",")) {
				result = result + "\\"
			} 
			result = result + curChar;
		}
		return result;
	}



	public function answersAsString(whichProp:String, forReview:Boolean):String
	{
		var result:String = "";
		
		var currAnswerScore:AnswerScore = null;
		var thisAns:String;
		var result:String = "";
		var separator:String = ",";
		gtrace("answerScores = " + answerScores);
		for (var ans in answerScores) {
			thisAns = "";
			currAnswerScore = answerScores[ans];
			gtrace("currAnswerScore.answerType = " + currAnswerScore.answerType);
			switch (currAnswerScore.answerType) {
				case "MultipleChoiceAnswer":
				case "MultipleChoiceMultipleAnswer":
					if (currAnswerScore[whichProp] == "1") {
						if (!forReview && (interactionType == "true-false")) {
							if (currAnswerScore.isTrueAnswer) {
								thisAns = "true";
							} else {
								thisAns = "false";
							}
						} else {
							thisAns = currAnswerScore.answerID;
						}
					} 
					break;
				case "LikertAnswer":
					thisAns = spacesToUnderscores(currAnswerScore[whichProp]);
					separator = ";";
					break;
				case "rdInteractionAnswer":
				case "FillInTheBlankAnswer":
					thisAns = currAnswerScore[whichProp];
					gtrace("whichProp = " + whichProp + " currAnswerScore[whichProp] = " + currAnswerScore[whichProp]);
					if (!forReview) {
						thisAns = escapeCommasAndSemiColons(thisAns);
					}
					separator = ",";
					break;
				case "MatchAnswer":
				default:
					if (forReview) {
						if (currAnswerScore[whichProp].length == 0) {
							thisAns = " ";
						} else {
							thisAns = currAnswerScore[whichProp];
						}
					} else {
						thisAns = currAnswerScore.answerID;
						thisAns = thisAns.concat(".", currAnswerScore[whichProp])
					}
					break;
			}
			if (thisAns.length > 0) {
				if (result.length > 0) {
					result += separator;
				}
				result += thisAns;
			}
		}
		
		return result;
	}

	public function get correctAnswersAsString():String
	{
		return answersAsString("correctAnswer", false);
	}
	
	public function get chosenAnswersAsString():String
	{
		return answersAsString("chosenAnswer", false);
	}

	public function get correctAnswersForReview():String
	{
		return answersAsString("correctAnswer", true);
	}

	public function get chosenAnswersForReview():String
	{
		return answersAsString("chosenAnswer", true);
	}

	public function get answeredCorrectly():Boolean	{	return _answeredCorrectly;	}
	public function set answeredCorrectly(isCorrect:Boolean)	{	_answeredCorrectly = isCorrect;	}
	
	public function get isCorrectAsString():String
	{
		if (answeredCorrectly) {
			return "C";
		} else {
			return "W";
		}
	}

	public function get numTries():Number	{	return _numTries;	}
	public function set numTries(tries:Number):Void	{	_numTries = tries;	}
		
	public function get weighting():Number	{	return _weighting;	}
	public function set weighting(wt:Number):Void	{	_weighting = wt;	}
	
	public function addLeadingZero(n:Number):String
	{
		if (n < 10) {
			return "0"+String(n);
		} else {
			return String(n);
		}
	}
	

	public function get latencyAsString():String
	{
		var latency_str:String = addLeadingZero(Math.round(latency/3600))+":"+addLeadingZero(Math.round((latency % 3600)/60))+":"+addLeadingZero(Math.round(latency) % 60);
		return latency_str;
	}
	
	public function get latencyAsSeconds():Number
	{
		return latency;
	}
	
	
	public function get curDateAsString():String
	{
		var today_date:Date = new Date();
		var date_str:String = addLeadingZero(today_date.getMonth()+1)+"/"+addLeadingZero(today_date.getDate())+"/"+today_date.getFullYear();
		return date_str;
	}
	
	
	public function get curTimeAsString():String
	{
		var today_date:Date = new Date();
		var time_str:String = addLeadingZero(today_date.getHours())+":"+addLeadingZero(today_date.getMinutes())+":"+addLeadingZero(today_date.getSeconds());
		return time_str;
	}
	
	public function get curTimeAsSecondsSinceMidnight():Number
	{
		var today_date:Date = new Date();
		return today_date.getHours()*3600 + today_date.getMinutes()*60+today_date.getSeconds();
	}
	
	
	public function get score():Number
	{
		if (answeredCorrectly && wasJudged) {
			return weighting;
		} else {
			return 0;
		}
	}
	
	public function get wasJudged():Boolean
	{
		return _wasJudged;
	}

	public function set wasJudged(judged:Boolean)
	{
		_wasJudged = judged;
	}

	
	function saveState(myState:QuizState)
	{
		myState.writeNumber(_slideNum);
		gtrace(" QS:: _slideNum myState = " + myState.toString());
		myState.writeNumber(_questionNumInQuiz);
		gtrace(" QS:: _questionNumInQuiz myState = " + myState.toString());
		myState.writeNumber(_startTime.getTime());
		gtrace(" QS:: _startTime.getTime() myState = " + myState.toString());
		myState.writeBoolean(_wasJudged);
		gtrace(" QS:: _wasJudged myState = " + myState.toString());
		myState.writeBoolean(_answeredCorrectly);
		gtrace(" QS:: _answeredCorrectly myState = " + myState.toString());
		myState.writeBoolean(_answersIncomplete);
		gtrace(" QS:: _answersIncomplete myState = " + myState.toString());
		myState.writeNumber(_numTries);
		gtrace(" QS:: _numTries myState = " + myState.toString());
		myState.writeNumber(_weighting);
		gtrace(" QS:: _weighting myState = " + myState.toString());
		myState.writeNumber(answerScores.length);
		gtrace(" QS:: answerScores.length myState = " + myState.toString());
		for (var whichAns = 0; whichAns < answerScores.length; whichAns++) {
			myState.writeString(answerScores[whichAns].answerID);
			gtrace(" QS:: answerScores[whichAns].answerID myState = " + myState.toString());
			myState.writeString(answerScores[whichAns].chosenAnswer);
			gtrace(" QS:: answerScores[whichAns].chosenAnswer myState = " + myState.toString());
			myState.writeString(answerScores[whichAns].correctAnswer);
			gtrace(" QS:: answerScores[whichAns].correctAnswer myState = " + myState.toString());
			myState.writeAnswerType(answerScores[whichAns].answerType);
			gtrace(" QS:: answerScores[whichAns].answerType myState = " + myState.toString());
		}
	}

	function restoreState(myState:QuizState)
	{
		_slideNum = myState.readNumber();
		_questionNumInQuiz= myState.readNumber();
		_startTime.setTime(myState.readNumber());
		_wasJudged = myState.readBoolean();
		_answeredCorrectly = myState.readBoolean();
		_answersIncomplete = myState.readBoolean();
		_numTries = myState.readNumber();
		_weighting = myState.readNumber();
		var numAnswerScores:Number = myState.readNumber();
		for (var whichAns = 0; whichAns < numAnswerScores; whichAns++) {
			var ansScore:AnswerScore = new AnswerScore();
			ansScore.answerID = myState.readString();
			ansScore.chosenAnswer = myState.readString();
			ansScore.correctAnswer = myState.readString();
			ansScore.answerType = myState.readAnswerType();
			answerScores.push(ansScore);
		}
	}
	
	function QuestionScore()
	{
		_numTries = 0;
		_answerScores = [];
	}
	
	
	public function get interactionID():String	{	return _interactionID;	}
	public function set interactionID(id:String):Void	{	_interactionID = id;	}
	
	
	////////////////////////////////////////////////////////////////////////////////////
	// IQuestionScore
	////////////////////////////////////////////////////////////////////////////////////
	
	
	public function getSlideNum():Number	{	return slideNum;	}
	public function setSlideNum(num:Number)	{	slideNum = num;	}
	
	public function getStartTime():Date	{	return startTime;	}
	public function setStartTime(time:Date)	{	startTime = time;	}
	
	public function getEndTime():Date	{	return endTime;	}
	public function setEndTime(time:Date)	{	endTime = time;	}
	
	public function getInteractionType():String	{	return interactionType;	}
	public function setInteractionType(intType:String)	{	interactionType = intType	}
	
	public function getObjectiveID():String	{	return objectiveID;	}
	public function setObjectiveID(id:String)	{	objectiveID = id;	}
	
	public function getInteractionID():String	{	return interactionID;	}
	public function setInteractionID(id:String)	{	interactionID = id;	}
	
	public function getWeighting():Number	{	return weighting;	}
	public function setWeighting(wt:Number)	{	weighting = wt;	}
	
	public function getAnswerScores():Array	{	return answerScores;	}
	public function setAnswerScores(scores:Array)	{	answerScores = scores;	}
	
	public function getNumTries():Number	{	return numTries;	}
	public function setNumTries(num:Number)	{	numTries = num;	}
	
	public function getAnswersIncomplete():Boolean	{	return answersIncomplete	}
	public function setAnswersIncomplete(incomplete:Boolean)	{	answersIncomplete = incomplete	}
	
	public function getAnsweredCorrectly():Boolean	{	return answeredCorrectly;	}
	public function setAnsweredCorrectly(correct:Boolean)	{	answeredCorrectly = correct;	}
	
	public function getPausedMsecs():Number	{	return pausedMsecs;	}
	public function setPausedMsecs(msecs:Number)	{	pausedMsecs = msecs;	}
	
	public function getQuestionNumInQuiz():Number	{	return questionNumInQuiz;	}
	public function setQuestionNumInQuiz(num:Number)	{	questionNumInQuiz = num;	}
	
	public function getWasJudged():Boolean	{	return wasJudged;	}
	public function setWasJudged(judged:Boolean)	{	wasJudged = judged;	}

	public function resetScore()
	{
		_answerScores = [];
		_numTries = 0;
		_startTime = null;
		_endTime = null;
		_answersIncomplete = false;
		_answeredCorrectly = false;
		_pausedMsecs = 0;
		_wasJudged = false;
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
