//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.core.UIComponent;
import mx.controls.Button;
import mx.utils.Delegate;

[TagName("CpButton")]
[Event("click")]

class AdobeCaptivate.quiz.CpButton extends UIComponent
{
	// These are required for createClassObject()
	static var symbolName:String = "CpButton";
	static var symbolOwner:Object = Object(AdobeCaptivate.quiz.CpButton);
	var className:String = "CpButton";
	
	// reference to bounding box
	private var boundingBoxB_mc:MovieClip;
	
	// reference to Button
	private var button:Button = null;
	// reference to TextField that we will use to display the text
	private var textClip:MovieClip = undefined;
	
	private var _enabled:Boolean = true;
	private var depth:Number;
/**
* @private
* list of clip parameters to check at init
*/
	var clipParameters:Object = { };
/**
* @private
* all components must use this mechanism to merge their clip parameters with their base class clip parameters
*/
	static var mergedClipParameters:Boolean = UIObject.mergeClipParameters(CpButton.prototype.clipParameters, UIComponent.prototype.clipParameters);

	function CpButton(){};
	

	private function init():Void 
	{
		super.init();
		
		boundingBoxB_mc._visible = false;
		boundingBoxB_mc._width = boundingBoxB_mc._height = 0;
	} 
	
	function createChild(className, instanceName:String, initProps:Object):MovieClip
	{
		if (depth == undefined)
			depth = 1;

		// Attach our object
		var newObj: MovieClip;
		newObj = createObject(className, instanceName, depth++, initProps);

		return newObj;
	}

	private function createChildren():Void 
	{	
		var newObj: MovieClip;
		newObj = createChild( "Button", "button1", {label: ""});
		button = Button(newObj);
		button.addEventListener("click", Delegate.create(this,click));
	};

	function attachTextClip(className:String):Void
	{
		textClip = createChild(className, "textClip1");
		invalidate();
	}
	
	// This function is called every time our component is invalidated.
	private function draw():Void
	{
		size();
	} 

	// The size function is automatically called whenever our component is
	// resized.  
	private function size():Void 
	{
		button.move(0, 0);
		button.setSize(width, height);
		if(textClip != undefined)
		{
			//trace(textClip._width + " " + textClip._height + " " + width + " " + height);
			var x:Number = (width - textClip._width) / 2;
			var y:Number = (height - textClip._height) / 2;
			if(x < 0)	x = 0;
			if(y < 0)	y = 0;
			textClip._x = x;
			textClip._y = y;
			//trace(textClip._x + " " + textClip._y);
		}
	}

	function set enabled(e:Boolean)
	{
		_enabled = e;
		button.enabled = e;
		invalidate();
	}
	function get enabled():Boolean
	{
		return _enabled;
	}
	
	private function click(evt)  {   dispatchEvent({type:"click", target:this});    }
	
};
             