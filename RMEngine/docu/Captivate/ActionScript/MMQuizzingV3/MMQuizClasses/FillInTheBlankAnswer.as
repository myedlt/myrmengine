//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"
//import MMQuizzingV3.MMQuizClasses.Feedback;
import MMQuizzingV3.MMQuizClasses.AnswerScore;
import MMQuizzingV3.MMQuizClasses.Question;


class MMQuizzingV3.MMQuizClasses.FillInTheBlankAnswer extends Object {
	var	className:String = "FillInTheBlankAnswer";

	public var _compMC:MovieClip = null;
	
	public var answerID:String = "";
	public var correctAnswers:Array;
	public var allAnswers:Array;
	public var showChoicesAsList:Boolean = false;
	public var ignoreCase:Boolean;

	//private var _retryFeedback:Feedback = null;
	private var _answerScore:AnswerScore;
	public var _comboBox:ComboBox;
	public var _textInput:TextInput;
	//private var _dataExt:String;

	/******
	public function get dataExt():String
	{
		return _dataExt;
	}

	public function set dataExt(data:String):Void
	{
		_dataExt = data;
		var myXML:XML = null;
		var anAnswer:XMLNode;
		var answerProp:XMLNode;
		var isCorrect:Boolean = false;
		
		this.allAnswers = [];
		this.correctAnswers = [];
		myXML = new XML(data);
		for (anAnswer = myXML.firstChild.firstChild; anAnswer != null; anAnswer=anAnswer.nextSibling) {
			for (answerProp = anAnswer.firstChild; answerProp != null; answerProp=answerProp.nextSibling) {
				if (answerProp.attributes.id=="10179") {	// short answer
					var theAnswer = ignoreSpaces(answerProp.attributes.value);
					allAnswers.push(theAnswer);
					correctAnswers.push(theAnswer);
				}
				if (answerProp.attributes.id=="10176") {  // fill in the blank
					var theAnswer = ignoreSpaces(answerProp.attributes.value);
					allAnswers.push(theAnswer);
					if (isCorrect || !this.showChoicesAsList) {
						correctAnswers.push(theAnswer);
					}
				}
				if (answerProp.attributes.id=="10088") {
					if (answerProp.attributes.value=="1") {
						isCorrect = true;
					} else {
						isCorrect = false;
					}
				}
			}
		}

	}
	*****/

	private var _question:Question;

	function get question():Question
	{
		return _question;
	}
	
	function set question(qs:Question)
	{
		_question = qs;
	}

	function get chosenAnswer():String
	{
		return this.text;
	}
	
	function set correctAnswer(correctAns:Array)
	{
		correctAnswers = correctAns;
		for(var i=0; i < correctAns.length; i++)
		{
			//trace("i = " + i);
			//trace(correctAnswers[i] + "XXX");
			correctAnswers[i] = ignoreSpaces(correctAnswers[i]);
			//trace(correctAnswers[i] + "XXX");
		}
	}
	
	function get correctAnswer():String
	{
		var retVal:String = "";
		if (correctAnswers.length > 0) {
			retVal = correctAnswers[0];
		}
		for (var i=1; i < correctAnswers.length; i++) {
			retVal = retVal.concat(";",  correctAnswers[i]);
		}
		return retVal;
	}

	function get text():String
	{
		//trace("_compMC.text = " + _compMC.text);
		if (showChoicesAsList) {
			return ignoreSpaces(_comboBox.text);
		} else {
			if(_textInput != null && _textInput != undefined)
				return ignoreSpaces(_textInput.text);
			else
				return ignoreSpaces(_compMC.text);
		}
	}
	
	function set text(newText:String)
	{
		if (showChoicesAsList) {
			_comboBox.text = newText;
		} else {
			if(_textInput != null && _textInput != undefined)
				_textInput.text = newText;
			else
				_compMC.text = newText;
		}
	}
	

	function get answered():Boolean
	{
		return (this.text.length > 0);
	}
	
	public function ignoreSpaces(s:String):String
	{
		var firstChar:Number;
		var lastChar:Number;
		var len:Number;

		firstChar = 0;
		while (s.charAt(firstChar) == ' ') {
			firstChar++;
		}
		lastChar = s.length - 1;
		while (s.charAt(lastChar) == ' ') {
			lastChar--;
		}
		len = lastChar-firstChar+1;
		s =  s.substr(firstChar, len);
		return s;

	}

	function get answeredCorrectly():Boolean
	{
		var ans:String = this.text;
		//trace("this._textInput = " + this._textInput);
		//trace("ans = " + ans);
		var corAns:String;
		//trace("correctAnswers = " + correctAnswers + "XXXX");
		//trace("ignoreCase = " + ignoreCase);
		for (var i in correctAnswers) {
			corAns = correctAnswers[i];
			if (ignoreCase) {
				ans = ans.toUpperCase();
				corAns = corAns.toUpperCase();
			}
			if (ans == corAns) {
				return true;
			}
		}
		return false;
	}
	
	function set enabled(e:Boolean):Void
	{
		_compMC.enabled = e;
	}

	function FillInTheBlankListAnswer()
	{
	}
	
	
	public function init() 
	{
		super.init();
		question.registerAnswer(this);
		_compMC.doLater(this, "initAnswerScore");
		
	}

	
	public function clearAnswer():Void
	{
		this.text = "";
	}
	

	public function answerChosen():Void
	{
		_answerScore.chosenAnswer = this.text;
		//trace("_answerScore.chosenAnswer = " + _answerScore.chosenAnswer);
		_compMC.dispatchEvent({type:"chooseAnswer", target:this});
		if (this.answeredCorrectly) {
			_compMC.dispatchEvent({type:"chooseCorrectAnswer", target:this});
		} else {
			_compMC.dispatchEvent({type:"chooseIncorrectAnswer", target:this});
		}
	}
	
	
	function change(evObj:Object):Void
	{
		answerChosen();
	}
	
	function enter(evObj:Object):Void
	{
		answerChosen();
	}

	function close(evObj:Object):Void
	{
		answerChosen();
	}
		
	function get answerScore():AnswerScore
	{
		return _answerScore;
	}
	

/***
	function get retryFeedback():Feedback
	{
		if (_retryFeedback) {
			return(_retryFeedback);
		} else {
			return null;
		}
	}
	
	function set retryFeedback(theFeedback:Feedback):Void
	{
		_retryFeedback = theFeedback;
	}
***/

	public function setFromAnswerScore(answerScore:AnswerScore)
	{
		/****/
		//trace("showChoicesAsList = " + showChoicesAsList);
		if (showChoicesAsList) {
			if (_comboBox.editable) {
				_comboBox.text = answerScore.chosenAnswer;
			} else {
				// find chosen answer index
				var i:Number = -1;
				var theItem;
				var theLabel:String;
				for (i = 0; i < _comboBox.length; i++) {
					theItem = _comboBox.getItemAt(i);
					if (theItem.label != undefined) {
						theLabel = theItem.label;
					} else if (theItem != undefined) {
						theLabel = theItem;
					} else {
						theLabel = "";
					}
					if (theLabel == answerScore.chosenAnswer) {
						break;
					}
				}
				if ((i != -1) && (i < _comboBox.length)) {
					_comboBox.selectedIndex = i;
				}
			}
		} else 
		/****/
		{
			//trace("answerScore.chosenAnswer = " + answerScore.chosenAnswer);
			this.text = answerScore.chosenAnswer;
		}
		answerChosen();
	}

	public function initAnswerScore()
	{
		_answerScore = new AnswerScore();
		_answerScore.answerType = className;
		_answerScore.answerID = answerID;
		_answerScore.correctAnswer = correctAnswer;
		_answerScore.chosenAnswer = "";
		
		//trace("initAnswerScore showChoicesAsList = " + showChoicesAsList);
		/****/
		if (showChoicesAsList) {
			_comboBox.visible = true;
			/*if (_textInput) {
				_textInput.visible = false;
			}* /
			for (var i in allAnswers) {
				_comboBox.addItemAt(0,allAnswers[i]);
			}
			*/
			_comboBox.selectedIndex = 0;
			_comboBox.text = "";
			_comboBox.addEventListener("change", this);
			_comboBox.addEventListener("enter", this);
			_comboBox.addEventListener("close", this);
			//_comboBox.setStyle("fontSize", this.fontSize);
		} else {
			/*if (_comboBox) {
				_comboBox.visible = false;
			}
			
			_textInput.visible = true;
		****/
			if(_textInput != null && _textInput != undefined)
			{
				_textInput.addEventListener("change", this);
				_textInput.addEventListener("enter", this);
			}
			else
			{
				_compMC.addEventListener("change", this);
				_compMC.addEventListener("enter", this);
			}
		}
		
	}
		

	
}
