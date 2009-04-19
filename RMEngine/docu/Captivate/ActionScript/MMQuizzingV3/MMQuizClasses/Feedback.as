//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"

import MMQuizzingV3.MMQuizClasses.Question;
import MMQuizzingV3.MMQuizClasses.PlaybackController;
import AdobeCaptivate.quiz.CpQuizView;

[Event("feedbackStarted")]
[Event("feedbackFinished")]
class MMQuizzingV3.MMQuizClasses.Feedback extends Object {
	
	public var isModal:Boolean = true;
	public var _onlyDoAction:Boolean = false;
	public var actionType:String = "default";
	public var actionArg1:String = "";
	public var actionArg2:String = "";
	public var audioClipID:String = "";
	public var _accText:String;		// accessibility screen-reader text
	public var _modalParentMC:MovieClip = null;
	public var _compMC:MovieClip = null;
	
	private var hitArea_mc:Object;
	
	private var _question:Question = null;
	
	//[Inspectable(defaultValue="anywhere",enumeration="anywhere,onSelf,nowhere")]
	var modalDismissClick:String = "anywhere";
			
	public function get question():Question
	{
		/***
		var theParent:Object = _parent;
		while (theParent) {
			if (theParent.className == "Question") {
				return Question(theParent);
			} else if (theParent._question.className = "Question") {
				return Question(theParent._question);
			} else {
				theParent = theParent._parent;
			}
		}
		****/
		return _question;
	}
	
	public function set question(q:Question)
	{
		_question = q;
	}
	
	public function get playbackController():PlaybackController
	{
		if (this.question && this.question.quizController) {
			return this.question.quizController.playbackController;
		} else {
			return null;
		}
	}
	
	public function get onlyDoAction():Boolean
	{
		if ((question && question.isSurvey)) {
			return true;
		} else {
			return _onlyDoAction;
		}
	}

	public function set onlyDoAction(doAction:Boolean)
	{
		_onlyDoAction = doAction;
	}


	function Feedback() 
	{
	}
	
	// initialize this form
	public function init() 
	{	
		super.init();
		//_compMC.addEventListener("press", onPress);
		question.quizComp.showChild(_compMC, false);
	}
	
	public function doAction():Void
	{
		if (actionType != "") {
			//this.question.quizController.doAction(actionType, actionArg1, actionArg2);
		}
	}
	
	// Plays audio associated with this feedback.  Returns true if
	// success, false for failure.
	public function playAudio(callback:Function):Boolean
	{
		var quest = this.question;
		if (quest) {
			return quest.playAudioID(String(this.audioClipID), callback);
		}
	}

	private static function createDelegate(p_obj:Object, p_func:Function):Function
	{
		var f:Function = function()
		{
			var target = arguments.callee.target;
			var func = arguments.callee.func;

			return func.apply(target, arguments);
		};

		f.target = p_obj;
		f.func = p_func;

		return f;
	}

	public function showFeedbackAndDoAction():Void 
	{
		//trace("onlyDoAction = " + onlyDoAction);
		//if (onlyDoAction) {
			//Selection.setFocus(null);	// or else submit button won't unhilite.
			//playAudio(createDelegate(this, this.doAction));
			// doAction(); - do action will be called when the sound
			// finishes playing (by the serrano viewer).
		//} else {
			//playAudio(null);
			//_compMC.dispatchEvent({type:"feedbackStarted", target:this});
			//trace(_compMC);
			question.playAudio(String(this.audioClipID));
			question.quizComp.showChild(_compMC, true);
			//Selection.setFocus(null);	// otherwise submit button doesn't unhilite

			//this.setAccessibility();
		//}
	}
	
	public function hideFeedback(doAction:Boolean) 
	{
		//trace("inside hide feedback _compMC.visible = " + _compMC.visible);
		if (_compMC.visible) {
			_compMC.dispatchEvent({type:"feedbackFinished", target:this});
			question.quizComp.showChild(_compMC, false);
			if (doAction) {
				_compMC.doLater(this, "doAction");
			}
			question.stopAudio(String(this.audioClipID));
		}
	}
	/***/
	public function onPress() 
	{
		//trace("onFeedback Press");
		//super.onPress();
		if (_compMC.visible && (question.lastFeedbackShown == this) ) {
			question.hideLastFeedback(true);
		}
	}

/***	
	public function mouseDownOutside(eventObject:Object) 
	{
		if (_compMC.visible && isModal && (question.lastFeedbackShown == this) && (modalDismissClick == "anywhere")) {
			question.hideLastFeedback(true);
		}
	}
****/	
	
	function onMouseDown(Void):Void
	{
		//super.onMouseDown;
		if ((question.lastFeedbackShown == this) && _compMC.hitTest(_root._xmouse, _root._ymouse, false)) {
			_compMC.onPress();
		}
	}
	/****/
}
