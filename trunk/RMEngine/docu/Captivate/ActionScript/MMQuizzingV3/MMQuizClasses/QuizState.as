//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMSlideClasses.IQuizState;

class MMQuizzingV3.MMQuizClasses.QuizState
	extends Object
	implements IQuizState {

	private var _curReadPos:Number = 0;

	private var _b64Alphabet:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-";
	private var _to64:Array;
	private var _from64:Array;

	private var _escAlphabet:String = "$.!*+";
	private var _doubleEsc:String = "~";
	private var _esc:Array;
	private var _mask:Array = [63, 4095, 262143, 16777215, 1073741823];
	private var _fromEsc:Array;

	private var _state:String;


	function QuizState()
	{
		var i:Number;
		_to64 = new Array();
		_from64 = new Array();
		_state = "";
		for (i=0; i<_b64Alphabet.length ;i++) {
        	_to64[i] = _b64Alphabet.charAt(i);
            _from64[_b64Alphabet.charCodeAt(i)] = i;
        }
		_esc = new Array();
		_fromEsc = new Array();
		for (i=0; i < _escAlphabet.length; i++) {
			_esc[i] = _escAlphabet.charAt(i);
			_fromEsc[_escAlphabet.charAt(i)] = i+1;
		}
	}

	function toString():String
	{
		return _state;
	}

	function fromString(theString:String)
	{
		_state = theString;
		_curReadPos = 0;
	}

	function writeNumber(num:Number)
	{
		var numBytes:Number;
		var rShift:Number;
		var b:Number;

		num = Math.floor(num);
		if (num > _mask[_mask.length-1]) {
			_state = _state.concat(_doubleEsc);
			writeNumber(num / (_mask[_mask.length-1]+1));
			writeNumber(num & _mask[_mask.length-1]);
			// Write it in two parts because of limitations of 32-bit logical arithmetic in ActionScript
		} else {
			for (numBytes=0; numBytes < _esc.length; numBytes++) {
				if ((num & _mask[numBytes]) == num) {
					if (numBytes > 0) {
						_state = _state.concat(_esc[numBytes-1]);
					}
					rShift = 0;
					for (var i=0; i <= numBytes; i++) {
						b = (num >> rShift) & 63;
						_state = _state.concat(_to64[b]);
						rShift += 6;
					}
					break;
				}
			}
		}
	}

	function readNumber():Number
	{
		var escByteChar = _state.charAt(_curReadPos);
		var escByteCode = _state.charCodeAt(_curReadPos++);
		var numBytes;
		var i:Number;
		var b:Number;
		var result:Number = 0;
		var lShift:Number;


		if (escByteChar == _doubleEsc) {
			var num1 = readNumber();
			var num2 = readNumber();
			return (num1 * (_mask[_mask.length-1]+1)) + num2;
		} else {
			numBytes = _fromEsc[escByteChar];
			if ((numBytes == 0) || (numBytes == undefined)) {
				result = _from64[escByteCode];
			} else {
				lShift = 0;
				for (i=0; i <= numBytes; i++) {
					b = _from64[_state.charCodeAt(_curReadPos++)];
					result |= (b << lShift);
					lShift += 6;
				}
			}
			return result;
		}
	}


	function writeBoolean(theBool:Boolean)
	{
		_state = _state.concat(theBool ? "1" : "0");

	}

	function readBoolean():Boolean
	{

		return (_state.charAt(_curReadPos++) == "1");
	}

	function writeString(theString:String)
	{
		var stringToWrite:String = theString;
		writeNumber(stringToWrite.length);
		_state = _state.concat(stringToWrite);

	}

	function readString():String
	{
		var len = readNumber();
		var theStr = _state.substr(_curReadPos, len);
		_curReadPos += len;
		return theStr;

	}

	public function writeAnswerType(theString:String)
	{
		var theNum:Number;
		switch (theString) {
			case "FillInTheBlankAnswer":
				theNum = 1;
				break;
			case "LikertAnswer":
				theNum = 2;
				break;
			case "MatchAnswer":
				theNum = 3;
				break;
			case "MultipleChoiceAnswer":
				theNum = 4;
				break;
			case "MultipleChoiceMultipleAnswer":
				theNum = 5;
				break;
			case "rdInteractionAnswer":
				theNum = 6;
				break;
			default:
				theNum = 0;
				break;
		}
		writeNumber(theNum);
	}

	public function readAnswerType():String
	{
		var theNum:Number = readNumber();
		var theType:String = "";
		switch (theNum) {
			case 1:
				theType = "FillInTheBlankAnswer";
				break;
			case 2:
				theType = "LikertAnswer";
				break;
			case 3:
				theType = "MatchAnswer";
				break;
			case 4:
				theType =  "MultipleChoiceAnswer";
				break;
			case 5:
				theType = "MultipleChoiceMultipleAnswer";
				break;
			case 6:
				theType = "rdInteractionAnswer";
				break;
			default:
				theType = "";
				break;
		}
		return(theType);
	}


	public function getReadPos():Number
	{
		return _curReadPos;
	}

	public function setReadPos(newPos:Number)
	{
		_curReadPos = newPos;
	}

	public function getWritePos():Number
	{
		return _curReadPos;
	}

	public function setWritePos(newPos:Number)
	{
		_curReadPos = newPos;
	}

	public function getData():String
	{
		return toString();
	}

	public function setData(newData:String)
	{
		fromString(newData);
	}



}