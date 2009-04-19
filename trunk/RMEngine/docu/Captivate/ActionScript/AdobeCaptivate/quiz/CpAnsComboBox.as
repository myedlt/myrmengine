//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.core.UIComponent;
import mx.controls.Label;
import mx.controls.ComboBox;

[TagName("CpAnsComboBox")]

class AdobeCaptivate.quiz.CpAnsComboBox extends UIComponent
{
	// These are required for createClassObject()
	static var symbolName:String = "CpAnsComboBox";
	static var symbolOwner:Object = Object(AdobeCaptivate.quiz.CpAnsComboBox);
	var className:String = "CpAnsComboBox";
	
	// reference to bounding box
	private var boundingBox_mc:MovieClip;
	
	// reference to TextField that we will use to display the text
	private var ansText_cmb:ComboBox = null;
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
	static var mergedClipParameters:Boolean = UIObject.mergeClipParameters(CpAnsComboBox.prototype.clipParameters, UIComponent.prototype.clipParameters);

	// This is our constructor.  Most of the time you will
	// just leave this blank when developing UIComponents.
	// Instead we use the init() function to set up our component
	function CpAnsComboBox(){};
	

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
		boundingBox_mc._visible = false;
		boundingBox_mc._width = boundingBox_mc._height = 0;
		bInitComplete = true;
	} 
	
	// This function is also called automatically when our component
	// extends the UIComponent class.
	private function createChildren():Void 
	{	
		attachMovie("Label", "ansNum_lbl", 1);
		ansNum_lbl.text = "10";
		attachMovie("ComboBox", "ansText_cmb", 2);
		ansText_cmb.editable = true;
		//trace("inside create");
	};
	
	// This function is called every time our component is invalidated.
	private function draw():Void
	{
		size();
	} 
	
	
	// The size function is automatically called whenever our component is
	// resized.  
	// The size function is automatically called whenever our component is
	// resized.  
	private function size():Void 
	{
		ansNum_lbl._width = 25;
		ansNum_lbl._height = 25;
		ansNum_lbl.setStyle("fontFamily", "Arial");
		ansNum_lbl.setStyle("fontSize", "14");
		ansNum_lbl.text = _label;
		ansText_cmb._x = ansNum_lbl._width;
		ansText_cmb._y = 0;
		//ansText_cmb._width = width - ansText_cmb._x;
		ansText_cmb.setSize(width - ansText_cmb._x, height);
		//ansNum_lbl.move(0, height/2 - ansText_cmb.height/2);
		ansNum_lbl.move(0, 0);
	}

	function get comboBox():ComboBox { return ansText_cmb; }

	//getter/setter for label
	function get label():String	{	return _label;	}
	function set label(newLabel:String)	
	{
		_label = newLabel;		invalidate();
	}

	function addItems(items:Array)
	{
		for(var i:Number = 0; i < items.length; i++)
			ansText_cmb.addItem({data:i, label:items[i]});
		invalidate();
	}
	
	//getter/setter for text
	function set text(newText:String):Void	{		/*ansText_cmb.text = newText;*/	}
	function get text():String	{		return ""; /*ansText_ti.text;*/	}

	function set enabled(e:Boolean)
	{
		_enabled = e;
		ansText_cmb.enabled = e;
		invalidate();
	}
	function get enabled():Boolean
	{
		return _enabled;
	}

};
             