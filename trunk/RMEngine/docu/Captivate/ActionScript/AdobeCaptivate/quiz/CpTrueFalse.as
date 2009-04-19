//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.controls.RadioButton;
import AdobeCaptivate.quiz.CpMultipleChoice;
import AdobeCaptivate.quiz.utils.CpItemParams;

class AdobeCaptivate.quiz.CpTrueFalse extends CpMultipleChoice
{
	// These are required for createClassObject()
	static var symbolName:String = "CpTrueFalse";
	static var symbolOwner:Object = AdobeCaptivate.quiz.CpTrueFalse;

	// Version string
//#include "../core/ComponentVersion.as"

	var className:String = "CpTrueFalse";

	// reference to bounding box
	private var boundingBoxQ_mc:MovieClip;
	
	function mytrace(str:String)
	{
		//trace("CpTrueFalse---" + str);
	}
	
	function CpTrueFalse()
	{
		slideType = TRUEFALSE;
	}

	// initialize variables
	function init():Void
	{
		//mytrace("init");
		super.init();
		// Since we have a bounding box, we need to hide it and make sure 
		// that its width and height are set to 0.  Notice that we are not using 
		// "this" as we used to in AS1.  In AS2 the compiler automatically
		// references the class members.
		boundingBoxQ_mc._visible = false;
		boundingBoxQ_mc._width = boundingBoxQ_mc._height = 0;
		setType(SINGLE);
	}
	
	// create the mask and make it invisible
	function createChildren(Void):Void
	{
		//mytrace("createChildren width = " + width);
		super.createChildren();
	}

	// if we get invalidated just call super
	function invalidate(Void):Void
	{
		//mytrace("invalidate");
		super.invalidate();
	}

	// redraw by re-laying out
	function draw(Void):Void
	{
		//mytrace("draw");
		size();
	}

	// respond to size changes
	function size(Void):Void
	{
		//mytrace("size");
		super.size();
	}

/**
* @private
* override this to find out when a new object is added that needs to be layed out
* @param object the layout object
*/
	function addLayoutObject(object:Object):Void
	{
		//mytrace("addLayoutObject -- " + object.toString() + " -- " + object.valueOf());
	}

	function initLayout():Void
	{
		//mytrace("initlayout");
		super.initLayout();
	}
/**
* @private
* override this to layout the content
*/
	function doLayout():Void
	{
		//mytrace("inside dolayout");
		super.doLayout();
	}
	
}