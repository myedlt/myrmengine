//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

class MMQuizzingV3.MMQuizClasses.AnswerScore extends Object {

	private var _answerType:String;
	private var _answerID:String;
	private var _chosenAnswer:String;
	private var _correctAnswer:String;
	private var _isTrueAnswer:Boolean = false;
	
	public function get answerType():String
	{
		return _answerType;
	}
		
	
	public function set answerType(theType:String)
	{
		_answerType = theType;
	}
	

	public function get answerID():String
	{
		return _answerID;
	}
	
	public function set answerID(theID:String)
	{
		_answerID = theID;
		}

	public function get chosenAnswer():String
	{
		return _chosenAnswer;
	}
	
	public function set chosenAnswer(theChosenAnswer:String)
	{
		_chosenAnswer = theChosenAnswer;
	}

	public function get correctAnswer():String
	{
		return _correctAnswer;
	}
	
	public function set correctAnswer(theCorrectAnswer:String)
	{
		_correctAnswer = theCorrectAnswer;
	}

	public function get isTrueAnswer():Boolean
	{
		return _isTrueAnswer;
	}

	public function set isTrueAnswer(isTrue: Boolean)
	{
		_isTrueAnswer = isTrue;
	}

	public function copy():AnswerScore
	{
		var result:AnswerScore = new AnswerScore();
		
		result._answerType = answerType;
		result._answerID = answerID;
		result._chosenAnswer = chosenAnswer;
		result._correctAnswer = correctAnswer;
		result._isTrueAnswer = isTrueAnswer;
		return result;
	}

	function AnswerScore() 
	{
	}

}