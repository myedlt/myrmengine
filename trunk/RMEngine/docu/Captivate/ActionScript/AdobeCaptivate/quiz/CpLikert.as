//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import AdobeCaptivate.quiz.CpQuizView;
import AdobeCaptivate.quiz.CpLabel;
import AdobeCaptivate.quiz.CpLikertAnswer;
import AdobeCaptivate.quiz.CpLikertHeader;
import AdobeCaptivate.quiz.utils.CpItemParams;
import AdobeCaptivate.quiz.utils.CpLikertAnswerParams;
import AdobeCaptivate.quiz.utils.CpLikertQuestionParams;
import mx.core.UIComponent;
import mx.utils.Delegate;

class AdobeCaptivate.quiz.CpLikert extends CpQuizView
{
	// These are required for createClassObject()
	static var symbolName:String = "CpLikert";
	static var symbolOwner:Object = AdobeCaptivate.quiz.CpLikert;

	// Version string
//#include "../core/ComponentVersion.as"

	var className:String = "CpLikert";

	// reference to bounding box
	private var boundingBoxQ_mc:MovieClip;
	
	private var quesItem_arr:Array;
	private var numQuesItem:Number = 0;

	private var ansItem_arr:Array;
	private var numAnsItem:Number = 0;
	
	private var _headerParams:CpItemParams;
	public var _headerLabels:Array;
	
	static var QUESITEM:String = "QUES_";
	static var ANSITEM:String = "ANS_";
	static var HEADER:String = "HEADER";
	
	
	function mytrace(str:String)	{
		//trace("CpLikert---" + str);
	}
	
	function CpLikert()	
	{	
		quesItem_arr = new Array();
		ansItem_arr = new Array();
		slideType = LIKERT; 
	}

	// initialize variables
	function init():Void
	{
		super.init();
		// Since we have a bounding box, we need to hide it and make sure 
		// that its width and height are set to 0.  
		boundingBoxQ_mc._visible = false;
		boundingBoxQ_mc._width = boundingBoxQ_mc._height = 0;
	}
	
	// create the mask and make it invisible
	function createChildren(Void):Void
	{
		super.createChildren();
	}

	public function createQuestionItem(label:String, linkageID:String, interactionID:String, objectiveID:String, x:Number, y:Number, width:Number, height:Number):Void
	{
		var p:CpItemParams = new CpLikertQuestionParams();
		quesItem_arr[numQuesItem] = p;
		
		p._name = QUESITEM + numQuesItem;

		if(linkageID != null && linkageID.length > 0)
		{
			p._movie = true;
			p._component = createChild( linkageID, QUESITEM + numQuesItem + "_mc");
		}
		else
		{
			p._font.name = "Arial";		p._font.size = 14;
			p._component = createChild( "CpLabel", QUESITEM + numQuesItem + "_lbl", {text: label, hAlign: "center", vAlign: "center"});
		}
		setItemCoordinates(p._name, x, y, width, height);
		numQuesItem++;
	}

	function createHeader(labels:Array, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		//headerLabels = labels;
		var labelsNumbers:Array = new Array();
		for(var count=0; count < labels.length; count++)
			labelsNumbers[count] = count + 1;
		_headerParams = new CpItemParams();
		_headerParams._name = HEADER;
		_headerParams._component = createChild( "CpLikertHeader", HEADER);
		var comp:CpLikertHeader = CpLikertHeader(_headerParams._component);
		comp.createHeader(labels, labelsNumbers, nWidth, nHeight);
		//trace("nHeight = " + nHeight);
		setItemCoordinates(_headerParams._name, xPos, yPos, nWidth, nHeight);
		
	}
	
	function setHeaderFont(fontName:String, fontColor:Number, fontSize:Number, bold:Boolean, italic:Boolean)
	{
		var comp:CpLikertHeader = CpLikertHeader(_headerParams._component);
		comp.setHeaderFont(fontName, fontColor, fontSize, bold, italic);
		invalidate();
	}

	function createAnswers()
	{
		for(var count:Number = 0; count < quesItem_arr.length; count++)
		{
			createAnsRadioGroups(quesItem_arr[count], quesItem_arr[count].interactionID, quesItem_arr[count].objectiveID, count);
		}
	}

	/**	
	function createAnsRadioGroups(p:CpItemParams, numGroup:Number)
	{
		var comp:CpLikertHeader = CpLikertHeader(_headerParams._component);
		if(comp == null || comp == undefined)
			return;
			
		var totalLabels:Number = comp.totalLabels;
		
		trace("totalLabels = " + totalLabels);
		var labelWidth:Number = _headerParams._width / totalLabels;
		var x:Number = _headerParams._x + ((labelWidth - 5) / 2);
		for(var i = 0; i < totalLabels; i++)
		{
			var pRadio:CpItemParams = new CpItemParams();
			pRadio._name = ANSITEM + numAnsItem;
			pRadio._component = createChild( "RadioButton", "radioButton_mc"+i+1, {label:"",groupName:"radioGroup_" + numGroup});
			pRadio._x = x;
			pRadio._y = p._y;
			pRadio._width = 5;
			pRadio._height = 5;
			ansItem_arr[numAnsItem] = pRadio;
			numAnsItem++;
			x += labelWidth;
		}
	}
	**/
	
	function createAnsRadioGroups(pques:CpLikertQuestionParams, interactionID:String, objectiveID:String, numGroup:Number)
	{
		var comp:CpLikertHeader = CpLikertHeader(_headerParams._component);
		if(comp == null || comp == undefined)
			return;
		var totalLabels:Number = comp.totalLabels;

		var ansParams:CpLikertAnswerParams = new CpLikertAnswerParams();
		ansParams._name = ANSITEM + numAnsItem;
		ansParams._component = createChild( "CpLikertAnswer", "likertAnswer"+numGroup);
		ansParams._x = _headerParams._x;
		ansParams._y = pques._y;
		ansParams._width = _headerParams._width;
		ansParams._height = 15;
		ansItem_arr[numAnsItem] = ansParams;
		
		var comp1:CpLikertAnswer = CpLikertAnswer(ansParams._component);
		comp1.createRadioButtons(totalLabels, ansParams._width, ansParams._height);
		ansParams.radioGroup = comp1.radioGroup;
		ansParams.interactionID = interactionID;
		ansParams.objectiveID = objectiveID;
		
		numAnsItem++;
	}
	
	// if we get invalidated just call super
	function invalidate(Void):Void	{
		super.invalidate();
	}

	// redraw by re-laying out
	function draw(Void):Void {
		size();
	}

	// respond to size changes
	function size(Void):Void {
		super.size();
	}

/**
* @private
* override this to find out when a new object is added that needs to be layed out
* @param object the layout object
*/
	function addLayoutObject(object:Object):Void {
	}

	function initLayout():Void {
		super.initLayout();
	}
/**
* @private
* override this to layout the content
*/
	function doLayout():Void
	{
		super.doLayout();

		var p:CpItemParams;
		for(var j in quesItem_arr)
		{
			p = quesItem_arr[j];
			setItemParams(p._component, p);
		}
		p = _headerParams;
		//trace("p.height = " + p._height);
		setItemParams(p._component, p);
		for(var i in ansItem_arr)
		{
			p = ansItem_arr[i];
			setItemParams(p._component, p);
		}
	}

	private function getItemParams(item:String):CpItemParams
	{
		for(var j:Number = 0; j < quesItem_arr.length; j++)
		{
			if(item.toUpperCase() == (QUESITEM+j))
				return quesItem_arr[j];
		}
		for(var i in ansItem_arr)
		{
			if(item.toUpperCase() == (ANSITEM + i))
				return ansItem_arr[i];
		}
		if(item.toUpperCase() == HEADER)
			return _headerParams;
		return super.getItemParams(item);
	}

	
	function clearAll(evt)	{
		for (var j in ansItem_arr)
		{
			for (var i in ansItem_arr[j].radioGroup.radioList) {
				ansItem_arr[j].radioGroup.radioList[i].setSelected(false);
			}
		}
		invalidate();
	}
	
	function set headerLabels(labels:Array)
	{
		//trace("labels = " + labels);
		_headerLabels = labels;
	}
	
	function get headerLabels():Array
	{
		return _headerLabels;
	}

	function get answerParams():Array
	{
		return ansItem_arr;
	}
	
	
}