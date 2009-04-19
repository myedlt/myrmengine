//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.core.UIComponent;
import mx.controls.Label;
import mx.controls.TextInput;
import AdobeCaptivate.quiz.utils.CpItemParams;

[TagName("CpAnsTextInput")]

class AdobeCaptivate.quiz.CpAnsTextInput extends UIComponent
{
	// These are required for createClassObject()
	static var symbolName:String = "CpAnsTextInput";
	static var symbolOwner:Object = Object(AdobeCaptivate.quiz.CpAnsTextInput);
	var className:String = "CpAnsTextInput";
	
	// reference to bounding box
	private var boundingBoxA_mc:MovieClip;
	
	// reference to TextField that we will use to display the text
	private var ansText_ti:TextInput = null;
	// reference to TextField that we will use to display the text
	private var ansNum_lbl:Label = null;
	
	private var _label:String = "";
	private var _text:String = null;

	private var _enabled:Boolean = true;
	private var bInitComplete:Boolean = false;
	
/**
* @private
* list of clip parameters to check at init
*/
	var clipParameters:Object = { };
/**
* @private
* all components must use this mechanism to merge their clip parameters with their base class clip parameters
*/
	static var mergedClipParameters:Boolean = UIObject.mergeClipParameters(CpAnsTextInput.prototype.clipParameters, UIComponent.prototype.clipParameters);

	// This is our constructor.  Most of the time you will
	// just leave this blank when developing UIComponents.
	// Instead we use the init() function to set up our component
	function CpAnsTextInput(){};
	

	// This function is automatically called when our component
	// extends the UIComponent class.
	private function init():Void 
	{
		// we call the superclass's init function which is required
		// when subclassing UIComponent
		super.init();
		
		// Since we have a bounding box, we need to hide it and make sure 
		// that its width and height are set to 0.  Notice that we are not using 
		// "this" as we used to in AS1.  In AS2 the compiler automatically
		// references the class members.
		boundingBoxA_mc._visible = false;
		boundingBoxA_mc._width = boundingBoxA_mc._height = 0;
		bInitComplete = true;
	} 
	
	// This function is also called automatically when our component
	// extends the UIComponent class.
	private function createChildren():Void 
	{	
		attachMovie("Label", "ansNum_lbl", 1);
		attachMovie("TextInput", "ansText_ti", 2);
	};
	
	// This function is called every time our component is invalidated.
	private function draw():Void
	{
		size();
	} 
	
	
	// The size function is automatically called whenever our component is
	// resized.  
	private function size():Void 
	{
		ansNum_lbl._width = 25;
		ansNum_lbl._height = 25;
		ansNum_lbl.setStyle("fontFamily", "Arial");
		ansNum_lbl.setStyle("fontSize", "14");
		ansNum_lbl.text = _label;
		ansText_ti._x = ansNum_lbl._width;
		ansText_ti._y = 0;
		ansText_ti.setSize(width - ansText_ti._x, height);
		ansNum_lbl.move(0, height/2 - ansNum_lbl.height/2);
	}


	//getter/setter for label
	function get label():String	{	return _label;	}
	function set label(newLabel:String)	
	{
		_label = newLabel;		invalidate();
	}

	//getter/setter for text
	function set text(newText:String):Void	{		ansText_ti.text = newText;	}
	function get text():String	{		return ansText_ti.text;	}

	function set enabled(e:Boolean)
	{
		_enabled = e;
		ansText_ti.enabled = e;
		invalidate();
	}
	function get enabled():Boolean
	{
		return _enabled;
	}
	
	function get textInput():TextInput { return ansText_ti; }
};
             