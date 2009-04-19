//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.core.UIComponent;
import AdobeCaptivate.quiz.CpLabel;
import mx.controls.TextInput;
import AdobeCaptivate.quiz.utils.CpItemParams;
import mx.utils.Delegate;

[TagName("CpMatchingQuesItem")]
[Event("changed")]

class AdobeCaptivate.quiz.CpMatchingQuesItem extends UIComponent
{
	// These are required for createClassObject()
	static var symbolName:String = "CpMatchingQuesItem";
	static var symbolOwner:Object = Object(AdobeCaptivate.quiz.CpMatchingQuesItem);
	var className:String = "CpMatchingQuesItem";
	
	// reference to bounding box
	private var boundingBoxQI_mc:MovieClip;
	private var itemLabel_mc:MovieClip = undefined;
	
	// reference to TextField that we will use to display the text
	private var itemText_ti:TextInput = null;
	private var itemLabel_cplbl:CpLabel = null;

	private var _labelText:String = "";
	private var bInitComplete:Boolean = false;
	
	private var depth:Number = 0;
	private var _matchingItemNum:Number;
/**
* @private
* list of clip parameters to check at init
*/
	var clipParameters:Object = { };
/**
* @private
* all components must use this mechanism to merge their clip parameters with their base class clip parameters
*/
	static var mergedClipParameters:Boolean = UIObject.mergeClipParameters(CpMatchingQuesItem.prototype.clipParameters, UIComponent.prototype.clipParameters);

	// This is our constructor.  Most of the time you will
	// just leave this blank when developing UIComponents.
	// Instead we use the init() function to set up our component
	function CpMatchingQuesItem(){};
	

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
		boundingBoxQI_mc._visible = false;
		boundingBoxQI_mc._width = boundingBoxQI_mc._height = 0;
		bInitComplete = true;
	} 
	
	// This function is also called automatically when our component
	// extends the UIComponent class.
	private function createChildren():Void 
	{
		attachMovie("TextInput", "itemText_ti", depth++);
		itemText_ti.maxChars = 1;
		itemText_ti.tabEnabled = true;
		itemText_ti.focusEnabled = true;
		itemText_ti.restrict = "A-Z a-z 0-9";
		itemText_ti.addEventListener("change", Delegate.create(this,changed));
	};

	function createText(newText:String)
	{
		attachMovie("CpLabel", "itemLabel_cplbl", depth++);
		itemLabel_cplbl.hAlign = "left";
		itemLabel_cplbl.vAlign = "center";
		label = newText;
	}
	
	function createTextMC(className:String, initProps:Object)
	{
		itemLabel_mc = createObject(className, "itemLabel_mc", depth++, initProps);
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
		itemText_ti._width = 25;
		itemText_ti._height = 25;
		itemText_ti.setStyle("fontFamily", "Arial");
		itemText_ti.setStyle("fontSize", "14");
		itemText_ti.move(0, height/2 - itemText_ti.height/2);
		
		if(itemLabel_mc != undefined)
		{
			//trace("QuesItem" + itemLabel_mc._width + " " + itemLabel_mc._height);
			//itemLabel_cplbl._width = width - itemText_ti._x;
			//itemLabel_cplbl._height = height;
			itemLabel_mc._x = itemText_ti._width + 5;
			itemLabel_mc._y = 0;//height - itemLabel_mc._height;
		}
		else
		{
			itemLabel_cplbl.setSize(width - itemText_ti._width, height);
			itemLabel_cplbl.move(itemText_ti._width, 0);
			itemLabel_cplbl.text = _labelText;
			itemLabel_cplbl.useHandCursor = true;
		}
		
	}
	
	function set textVisible(v:Boolean)
	{
		itemLabel_mc._visible = v;
		invalidate();
	}
	function get textVisible():Boolean
	{
		return itemLabel_mc._visible;
	}

	function set label(newText:String)
	{
		_labelText = newText;
		invalidate();
	}
	
	function get label():String
	{
		return _labelText;
	}
	
	function get text():String
	{
		return itemText_ti.text;
	}
	
	function set text(newText:String)
	{
		itemText_ti.text = newText;
		changed();
		invalidate();
	}
	
	function getLabelParams():CpItemParams
	{
		var p:CpItemParams = new CpItemParams();
		p._x = itemLabel_cplbl._x;
		p._y = itemLabel_cplbl._y;
		p._width = itemLabel_cplbl._width;
		p._height = itemLabel_cplbl._height;
		
		return p;
	}
	
	private function changed(evt)    
	{
		   itemText_ti.text = itemText_ti.text.toUpperCase();
		   //trace("text changed");
		   dispatchEvent({type:"changed", name:evt.target, target:this});
	}
};
             