//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.controls.RadioButton;
import mx.controls.RadioButtonGroup;
import mx.core.UIComponent;

class AdobeCaptivate.quiz.CpLikertAnswer extends UIComponent
{
	// These are required for createClassObject()
	static var symbolName:String = "CpLikertAnswer";
	static var symbolOwner:Object = Object(AdobeCaptivate.quiz.CpLikertAnswer);
	var className:String = "CpLikertAnswer";
	
	public var radioGroup:RadioButtonGroup;
	private var totalButtons:Number = 0;
	private var radioButtons:Array;
	
	// reference to bounding box
	private var boundingBox_mc:MovieClip;

	var m_width:Number = 0;
	var m_height:Number = 0;	
/**
* @private
* list of clip parameters to check at init
*/
	var clipParameters:Object = { };
/**
* @private
* all components must use this mechanism to merge their clip parameters with their base class clip parameters
*/
	static var mergedClipParameters:Boolean = UIObject.mergeClipParameters(CpLikertAnswer.prototype.clipParameters, UIComponent.prototype.clipParameters);

	function CpLikertAnswer()
	{
		radioButtons = new Array();	
	}
	
	private function createChild(className, instanceName:String, initProps:Object):MovieClip
	{
		// Attach our object
		var newObj: MovieClip;
		newObj = createObject(className, instanceName, this.getNextHighestDepth(), initProps);

		return newObj;
	}
	
	function createRadioButtons(count:Number, width:Number, height:Number)
	{
		totalButtons = count;
		//trace("setting totalButtons as " + totalButtons);
		var widthButton:Number = 15;
		var widthLabel:Number = width / totalButtons;
		var xButton:Number = (widthLabel - widthButton) / 2;

		//trace("totalButtons = " + totalButtons);
		//trace("widthLabel = " + widthLabel);
		//trace("xButton = " + xButton);
		
		if(xButton < 0) xButton = 0;
		
		var heightButton:Number = height;
		var yButton:Number = 0;
		
		for(var i:Number = 0; i < count; i++)
		{
			var obj:MovieClip = createChild( "RadioButton", "radioButton_mc"+(i+1), {label:"",groupName:"radioGroup",_x:xButton, _y:yButton,_width:widthButton,_height:heightButton});
			radioButtons[i] = RadioButton(obj);
			xButton += widthLabel;
		}
		
		
	}
	
	function resize()
	{
		//setSize(m_width, m_height);
		//trace(m_width);
		_width = m_width;
		_height = m_height;
		//trace(this.width);
	}
	
	function init()
	{
		super.init();
		boundingBox_mc._visible = false;
		boundingBox_mc._width = boundingBox_mc._height = 0;
	}
	
	private function createChildren():Void 
	{	
		super.createChildren();
	}
	
	// This function is called every time our component is invalidated.
	private function draw():Void
	{
		size();
	} 

	function size()
	{
		//super.size();
		
		//trace("totalButtons = " + totalButtons);
		//trace("this._width = " + this._width);
		if(totalButtons == 0)
			return;
			
	}
	
}