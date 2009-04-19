//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.core.UIComponent;

[TagName("CpLabel")]
[Event("textChange")]

class AdobeCaptivate.quiz.CpLabel extends UIComponent
{
	// These are required for createClassObject()
	static var symbolName:String = "CpLabel";
	static var symbolOwner:Object = Object(AdobeCaptivate.quiz.CpLabel);
	var className:String = "CpLabel";
	
	// reference to bounding box
	private var boundingBox_mc:MovieClip;
	
	// reference to TextField that we will use to display the text
	private var textBoxLabel:TextField = null;

	//alignment references
	var __hAlign:String;
	var __vAlign:String;

	private var _text:String = null;
	private var depth:Number = 0;
	private var bInitComplete:Boolean = false;

	private var	__bResizeOnTextChange:Boolean = false;
	private var	__maxWidth;
	
/**
* @private
* list of clip parameters to check at init
*/
	var clipParameters:Object = { text: 1, hAlign: 1, vAlign: 1};
/**
* @private
* all components must use this mechanism to merge their clip parameters with their base class clip parameters
*/
	static var mergedClipParameters:Boolean = UIObject.mergeClipParameters(CpLabel.prototype.clipParameters, UIComponent.prototype.clipParameters);

	// This is our constructor.  Most of the time you will
	// just leave this blank when developing UIComponents.
	// Instead we use the init() function to set up our component
	function CpLabel(){};
	

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
		// This method is useful for when you want to create attach sub-objects.
		// This method only gets called once.  
// In our component
		// the only child object we need to create is the TextField.  The rest
		// is handled by the draw function as we will see below.
		
		
	   	// createLabel() is a method provided by UIObject that we can use 
	   	// when we want to create a TextField.  This is recommended
	   	// over the use of createTextField() method we are accustomed to.
	   	textBoxLabel =  createLabel("textBoxLabel",depth++);
		textBoxLabel.multiline = true;
		textBoxLabel.wordWrap = true;
		textBoxLabel.selectable = false;
		text = _text;
		//trace("inside create");
	};
	
	// This function is called every time our component is invalidated.
	private function draw():Void
	{
		if(getStyle("backgroundColor") != undefined)
		{
			var bgColor:Number = getStyle("backgroundColor");
			// We draw our box first
			beginFill(bgColor);
			// This is a method provided to us by UIObject to draw rectangles
			drawRect(0,0,width,height);
			endFill();
		}
		
		doSize();

	//	textBoxLabel.text = text;
	//	hAlign = __hAlign;
	} 
	
	[Inspectable(defaultValue="center", enumeration="left,center,right", type="List")]
	function get hAlign():String
	{
		//trace("get " + txt_fmt.align);
		return __hAlign;
	}
	function set hAlign(x:String)
	{
		//trace("set hAlign = " + x);
		var txt_fmt:TextFormat = textBoxLabel.getTextFormat();
		txt_fmt.align = x;
		__hAlign = x;
		textBoxLabel.setTextFormat(txt_fmt);
		invalidate();
	}

	[Inspectable(defaultValue="center", enumeration="top,center,bottom", type="List")]
	function get vAlign():String
	{
		//trace("get " + txt_fmt.align);
		return __vAlign;
	}
	function set vAlign(x:String)
	{
		//trace("set vAlign = " + x);
		__vAlign = x;
		invalidate();
	}

	
	private function doSize():Void
	{
		// We set the size of the Label so that it is viewable

		// resize and reposition internal text field
		var txt_fmt:TextFormat = textBoxLabel.getTextFormat();
		var metrics:Object = txt_fmt.getTextExtent(text, width);
		textBoxLabel.setSize(width, metrics.textFieldHeight);
	//	trace("size textBoxLabel.text = " + text);
	//	trace("size  metrics.textFieldHeight = " +  metrics.textFieldHeight);
		

		textBoxLabel._x = width/2 - textBoxLabel.width/2;
		switch(vAlign)
		{
			case "top":
				textBoxLabel._y = 1;
				break;
			case "center":
			 	textBoxLabel._y = height/2 - textBoxLabel.height/2;
				break;
			case "bottom":
				textBoxLabel._y = height - textBoxLabel.height - 1;
				break;
		}
	//	trace("size _x = " + textBoxLabel._x);
	//	trace("size _y = " + textBoxLabel._y);
	//	trace("size _w = " + textBoxLabel.width);
	//	trace("size _h = " + textBoxLabel.height);
	//	textBoxLabel.move(cWidth,cHeight); 		
	};
	
	// The size function is automatically called whenever our component is
	// resized.  
	private function size():Void 
	{
		invalidate();
	};

	// This is our setter for the text property.
	// This will set the value and invalidate() the component
	
	// by adding the [Inspectable] meta-tag, the Flash IDE will
	// add an available text property to the property inspector
	[Inspectable]
	function set text(newText:String):Void
	{
		_text = newText;
		if(bInitComplete)
		{
			textBoxLabel.text = text;
			hAlign = __hAlign;
			//dispatchEvent({ type:"textChange"});
			//trace("CpLabel -- set text1 = " + _text + " hAlign = " + hAlign + " vAlign = " + vAlign);
		}
//		if(__bResizeOnTextChange)
//			fitInBox(__maxWidth);
		invalidate();
	};
	
	// This is a getter for the text property.  Our user can 
	// use this property to retrieve the current value of the text
	function get text():String
	{
		return _text;
	}
	
	function resizeOnTextChange(bdo:Boolean, wMax:Number)
	{
		__bResizeOnTextChange = bdo;
		__maxWidth = wMax;
	}
	
	private function fitInBox(wMax:Number)
	{
		var txt_fmt:TextFormat = textBoxLabel.getTextFormat();
		var metrics:Object = txt_fmt.getTextExtent(text);
		var w = (metrics.textFieldWidth >= wMax) ? wMax : metrics.textFieldWidth;
		//trace("cplabel w = " + w);
		setSize(w, height);
	}
	
	function getTextFormat():TextFormat
	{
		return textBoxLabel.getTextFormat();
	}
};
             