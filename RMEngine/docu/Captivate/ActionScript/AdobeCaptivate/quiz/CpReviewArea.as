//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.core.UIComponent;

[TagName("CpReviewArea")]
//[InspectableList("__CorrectMessage","__InCompleteMessage","__InCorrectMessage")]

class AdobeCaptivate.quiz.CpReviewArea extends UIComponent
{
	// These are required for createClassObject()
	static var symbolName:String = "CpReviewArea";
	static var symbolOwner:Object = Object(AdobeCaptivate.quiz.CpReviewArea);
	var className:String = "CpReviewArea";
	
	private var __correctMsg:String 		= "";
	private var __incompleteMsg:String 	= "";
	private var __incorrectMsg_0:String 	= "";
	private var __incorrectMsg_1:String 	= "";
	
	private var __incorrectMsgParam_0:String = "";
	private var __incorrectMsgParam_1:String = "";

	private var CORRECT:Number 	= 0;
	private var INCOMPLETE:Number 	= 1;
	private var INCORRECT:Number	= 2;
	private var __type:Number 		= CORRECT; 
	
	private var msgLabels_0:TextField;
	private var msgLabels_1:TextField;
	private var msgLabels_2:TextField;
	private var msgLabels_3:TextField;
	
	// reference to bounding box
	private var boundingBoxRA_mc:MovieClip;

	private var depth:Number = 0;
	
	var clipParameters:Object = { };

	
/**
* @private
* all components must use this mechanism to merge their clip parameters with their base class clip parameters
*/
	static var mergedClipParameters:Boolean = UIObject.mergeClipParameters(CpReviewArea.prototype.clipParameters, UIComponent.prototype.clipParameters);

	// This is our constructor.  Most of the time you will
	// just leave this blank when developing UIComponents.
	// Instead we use the init() function to set up our component
	function CpReviewArea(){};
	

	// This function is automatically called when our component
	// extends the UIComponent class.
	private function init():Void 
	{
		// we call the superclass's init function which is required
		// when subclassing UIComponent
		super.init();
		boundingBoxRA_mc._visible = false;
		boundingBoxRA_mc._width = boundingBoxRA_mc._height = 0;
	} 
	
	// This function is also called automatically when our component
	// extends the UIComponent class.
	private function createChildren():Void 
	{	
		msgLabels_0 =  createLabel("msgLabels_0",depth++);
		msgLabels_1 =  createLabel("msgLabels_1",depth++);
		msgLabels_2 =  createLabel("msgLabels_2",depth++);
		msgLabels_3 =  createLabel("msgLabels_3",depth++);
		msgLabels_0.selectable = false;
		msgLabels_1.selectable = false;
		msgLabels_2.selectable = false;
		msgLabels_3.selectable = false;
		
	}
	
	// This function is called every time our component is invalidated.
	private function draw():Void
	{
		size();
	} 

	private function setTextFormats()
	{
		var txt_fmt:TextFormat = msgLabels_0.getTextFormat();
		txt_fmt.font = "Arial";
		txt_fmt.bold = true;
		txt_fmt.size = 14;
		msgLabels_0.setTextFormat(txt_fmt);
		msgLabels_1.setTextFormat(txt_fmt);
		
		txt_fmt.bold = false;
		msgLabels_2.setTextFormat(txt_fmt);
		msgLabels_3.setTextFormat(txt_fmt);

	}
	
	// The size function is automatically called whenever our component is
	// resized.  
	private function size():Void 
	{
		if(__type == INCORRECT)
		{
			//trace("__incorrectMsg_0 = " + __incorrectMsg_0);
			//trace("__incorrectMsgParam_0 = " + __incorrectMsgParam_0);
			//trace("review area width = " + width + " height = " + height);
			msgLabels_0.text = __incorrectMsg_0;
			msgLabels_1.text = __incorrectMsg_1;
			msgLabels_2.text = __incorrectMsgParam_0;
			msgLabels_3.text = __incorrectMsgParam_1;

			setTextFormats();

			var txt_fmt:TextFormat = msgLabels_0.getTextFormat();
			var metrics_0:Object = txt_fmt.getTextExtent(__incorrectMsg_0);
			
			txt_fmt = msgLabels_1.getTextFormat();
			var metrics_1:Object = txt_fmt.getTextExtent(__incorrectMsg_1);
	
			var maxWidth = (metrics_0.textFieldWidth >= metrics_1.textFieldWidth) ? metrics_0.textFieldWidth : metrics_1.textFieldWidth;
			
			maxWidth = (maxWidth < width) ? maxWidth + 2 : width;
			var w:Number = width - maxWidth;
			
			msgLabels_0.move(0, 0);
			msgLabels_0.setSize(maxWidth, metrics_0.textFieldHeight + 2);
			//msgLabels_0.border = true;
			
			msgLabels_1.move(0, msgLabels_0._height);
			msgLabels_1.setSize(maxWidth, metrics_1.textFieldHeight + 2);
			//msgLabels_1.border = true;
			
			msgLabels_2.move(maxWidth, msgLabels_0._y);
			msgLabels_2.setSize(w, msgLabels_0._height);
			msgLabels_2.border = true;
			
			msgLabels_3.move(maxWidth, msgLabels_1._y);
			msgLabels_3.setSize(w, msgLabels_1._height);
			msgLabels_3.border = true;
			
		}
		else
		{
			msgLabels_0.move(0, 0);
			msgLabels_0.setSize(width, height);
			if(__type == CORRECT)
				msgLabels_0.text = __correctMsg;
			else
				msgLabels_0.text = __incompleteMsg;
			setTextFormats();
		}
	}

	function setMessages(correctMsg:String, incompleteMsg:String, incorrectMsg_0:String, incorrectMsg_1:String)
	{
		__correctMsg = correctMsg;
		__incompleteMsg = incompleteMsg;
		__incorrectMsg_0 = incorrectMsg_0;
		__incorrectMsg_1 = incorrectMsg_1;
	}
	
	function showCorrectMsg()
	{
		//trace("inside showCorrectMsg");
		__type = CORRECT;
		invalidate();
	}
	
	function showIncompleteMsg()
	{
		//trace("inside showIncompleteMsg");
		__type = INCOMPLETE;
		invalidate();
	}
	
	function showIncorrectMsg(param1:String, param2:String)
	{
		//trace("inside showInCorrectMsg");
		__type = INCORRECT;
		__incorrectMsgParam_0 = param1;
		__incorrectMsgParam_1 = param2;
		invalidate();
	}
}
