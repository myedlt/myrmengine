//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import mx.core.UIComponent;
import AdobeCaptivate.quiz.utils.CpItemParams;
import AdobeCaptivate.quiz.utils.CpLikertHeaderParams;
import AdobeCaptivate.quiz.CpLabel;
import AdobeCaptivate.quiz.utils.CpFont;

[TagName("CpLikertHeader")]

class AdobeCaptivate.quiz.CpLikertHeader extends UIComponent
{
	// These are required for createClassObject()
	static var symbolName:String = "CpLikertHeader";
	static var symbolOwner:Object = Object(AdobeCaptivate.quiz.CpLikertHeader);
	var className:String = "CpLikertHeader";
	
	// reference to bounding box
	private var boundingBox_mc:MovieClip;
	
	private var font:CpFont;	
	private var labels_arr:Array;
	private var labelsNum_arr:Array;
	
	private var _maxHeight:Number = 1;
	
	private var depth:Number = 0;
	
	private var LABEL:String = "LABEL_";
	private var LABELNUM:String = "LABELNUM_";
	
/**
* @private
* list of clip parameters to check at init
*/
	var clipParameters:Object = { };
/**
* @private
* all components must use this mechanism to merge their clip parameters with their base class clip parameters
*/
	static var mergedClipParameters:Boolean = UIObject.mergeClipParameters(CpLikertHeader.prototype.clipParameters, UIComponent.prototype.clipParameters);

	// This is our constructor.  Most of the time you will
	// just leave this blank when developing UIComponents.
	// Instead we use the init() function to set up our component
	function CpLikertHeader()
	{
		labels_arr = new Array();
		labelsNum_arr = new Array();
		font = new CpFont();
		font.name = "Arial";
		font.bBold = font.bItalic = false;
		font.size = 8;
	};
	

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
	} 
	
	// This function is also called automatically when our component
	// extends the UIComponent class.
	private function createChildren():Void 
	{
		super.createChildren();	
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
		size();
	} 

	private function createChild(className, instanceName:String, initProps:Object):MovieClip
	{
		// Attach our object
		var newObj: MovieClip;
		newObj = createObject(className, instanceName, this.getNextHighestDepth(), initProps);

		return newObj;
	}
	
	public function createHeader(labels:Array, labelsNumbers:Array, width:Number, height:Number)
	{
		var xPos:Number = 0;
		var yPos:Number = 0;
		var nWidth:Number = width / labels.length;
		_maxHeight = height;
		for(var count:Number = 0; count < labels.length; count++)
		{
			//var text:String = labels[count] + "\n" + labelsNumbers[count];

			var p:CpLikertHeaderParams = new CpLikertHeaderParams();
		   	var textField:TextField =  createLabel("label_"+count,depth++);
			textField.multiline = true;
			textField.wordWrap = true;
			textField.selectable = false;
			
			p._textField = textField;
			p._text = labels[count];
			
			labels_arr[count] = p;
			
			p._x = xPos;
			p._y = yPos;
			p._width = nWidth;
			
			var p1:CpLikertHeaderParams = new CpLikertHeaderParams();
		   	var textField1:TextField =  createLabel("labelNum_"+count,depth++);
			textField1.multiline = true;
			textField1.wordWrap = true;
			textField1.selectable = false;
			
			p1._textField = textField1;
			p1._text = labelsNumbers[count];
			
			labelsNum_arr[count] = p1;
			
			p1._x = xPos;
			p1._width = nWidth;
			xPos += nWidth;
		}
		invalidate();
	}
	
	public function setHeaderFont(fontName:String, fontColor:Number, fontSize:Number, bold:Boolean, italic:Boolean)
	{
		font.name = fontName;
		font.size = fontSize;
		font.bItalic = italic;
		font.bBold = bold;
		font.color = fontColor;
		invalidate();
	}

/**
	// The size function is automatically called whenever our component is
	// resized.  
	private function size():Void 
	{
		var xPos:Number = 0;
		var yPos:Number = 0;
		var nWidth:Number = this._width / labels_arr.length;
		var heightLabelNum:Number = font.size + 5;
		//trace("this._height = " + this._height);
		var heightLabel:Number = this._height - heightLabelNum;
		//trace("heightLabel = " + heightLabel);
		
		for(var count in labels_arr)
		{
			labels_arr[count].move(xPos, yPos);
			labels_arr[count].size(nWidth, heightLabel);
			setLabelFont(labels_arr[count]);
			
			labelsNum_arr[count].move(xPos, (yPos + heightLabel));
			labelsNum_arr[count].size(nWidth, heightLabelNum);
			//setLabelFont(labelsNum_arr[count]);
			
			xPos += nWidth;
		}
		super.size();
	}
**/

	// The size function is automatically called whenever our component is
	// resized.  
	private function size():Void 
	{
		for(var count in labels_arr)
		{
			var p:CpLikertHeaderParams = labels_arr[count];
			var p1:CpLikertHeaderParams = labelsNum_arr[count];
			
			// resize and reposition internal text field
			var txt_fmt:TextFormat = p._textField.getTextFormat();
			getTextFormat(txt_fmt);
			p._textField.text = p._text;
			p._textField.setTextFormat(txt_fmt);
			p._textField._x = p._x;
			p._textField._y = p._y;
			//p._textField.setSize(p._width, (_maxHeight));
			//trace("p._y = " + p._y);
			
			// resize and reposition internal text field
			txt_fmt = p1._textField.getTextFormat();
			getTextFormat(txt_fmt);
			p1._textField.text = p1._text;
			p1._textField.setTextFormat(txt_fmt);
			p1._textField._x = p1._x;

			
			txt_fmt = p1._textField.getTextFormat();
			var metrics:Object = txt_fmt.getTextExtent(p1._text, p1._width);
			//trace("p._width = " + p._width);
			//trace("_maxHeight = " + _maxHeight);
			//trace("metrics.textFieldHeight = " + metrics.textFieldHeight);
			//trace("p._height = " + (_maxHeight - metrics.textFieldHeight));
			p._textField.setSize(p._width, (_maxHeight - metrics.textFieldHeight + 1));
			
			p1._textField._y = _maxHeight - metrics.textFieldHeight + 1;
			
			p1._textField.setSize(p1._width, metrics.textFieldHeight - 1);
			
			//trace("p1._textField._y = " + p1._textField._y);
			//trace("p1._width = " + p1._width);
			//trace("metrics.textFieldHeight = " + metrics.textFieldHeight);

		}
		
		//trace("header.this._width = " + this._width + " header.this._height = " + this._height);
	}

	function getTextFormat(txt_fmt:TextFormat)
	{
		txt_fmt.align = "center";
		txt_fmt.font = font.name;
		txt_fmt.size = font.size;
		txt_fmt.bold = font.bBold;
		txt_fmt.italic = font.bItalic;
		txt_fmt.color = font.color;
	}

	public function get totalLabels():Number
	{
		return labels_arr.length;
	}	
};
             