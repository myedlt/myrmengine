//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import AdobeCaptivate.quiz.CpQuizView;
import AdobeCaptivate.quiz.CpLabel;
import AdobeCaptivate.quiz.CpReviewArea;
import AdobeCaptivate.quiz.utils.CpItemParams;
import AdobeCaptivate.quiz.utils.CpMatchingAnsParams;
import AdobeCaptivate.quiz.utils.CpMatchingQuesParams;
import AdobeCaptivate.quiz.CpMatchingQuesItem;
import mx.core.UIComponent;
import mx.utils.Delegate;

class AdobeCaptivate.quiz.CpMatching extends CpQuizView
{
	// These are required for createClassObject()
	static var symbolName:String = "CpMatching";
	static var symbolOwner:Object = AdobeCaptivate.quiz.CpMatching;

	// Version string
//#include "../core/ComponentVersion.as"

	var className:String = "CpMatching";

	// reference to bounding box
	private var boundingBoxQ_mc:MovieClip;
	
	private var ansItem_arr:Array;
	private var quesItem_arr:Array;
	private var quesDupItem_arr:Array;
	private var ansDupItem_arr:Array;
	
	private var numAnsItems:Number = 0;
	private var numQuesItems:Number = 0;
		
	private var _itemColumn_prm:CpItemParams;
	private var _ansColumn_prm:CpItemParams;
	private var draggedComp_prm:CpItemParams;
	private var draggedQuesItem_prm:CpItemParams;
	private var draggedAnsItem_prm:CpItemParams;
	
	static var ITEMCOLUMN:String = "ITEMCOLUMN";
	static var ANSCOLUMN:String = "ANSCOLUMN";
	static var QUESITEM:String = "QUES_";
	static var ANSITEM:String = "ANS_";
	static var ANSDUPITEM:String = "ANSDUP_";
	static var QUESDUPITEM:String = "QUESDUP_";
	
	private var bStartDrag:Boolean = false;
	private var bQuesItemDrag:Boolean = false;
	
	function mytrace(str:String)	{
		//trace("CpMatching---" + str);
	}
	
	function CpMatching()	
	{
		ansItem_arr = new Array();
		quesItem_arr = new Array();
		quesDupItem_arr = new Array();
		ansDupItem_arr = new Array();
		slideType = MATCHING; 
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

	public function createItemColumn(label:String, linkageID:String, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		_itemColumn_prm = new CpItemParams();
		_itemColumn_prm._name = ITEMCOLUMN;
		if(linkageID != null && linkageID.length > 0)
		{
			_itemColumn_prm._movie = true;
			_itemColumn_prm._component = createChild( linkageID, "itemColumn_mc");
		}
		else
		{
			_itemColumn_prm._font.name = "Arial";		_itemColumn_prm._font.size = 14;
			_itemColumn_prm._component = createChild( "CpLabel", "itemColumn_lbl", {text: label, hAlign: "center", vAlign: "center"});
		}
		setItemCoordinates(ITEMCOLUMN, xPos, yPos, nWidth, nHeight);
	}
	
	function createAnsColumn(label:String, linkageID:String, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		_ansColumn_prm = new CpItemParams();
		_ansColumn_prm._name = ANSCOLUMN;
		if(linkageID != null && linkageID.length > 0)
		{
			_ansColumn_prm._movie = true;
			_ansColumn_prm._component = createChild( linkageID, "ansColumn_mc");
		}
		else
		{
			_ansColumn_prm._font.name = "Arial";		_ansColumn_prm._font.size = 14;
			_ansColumn_prm._component = createChild( "CpLabel", "ansColumn_lbl", {text: label, hAlign: "center", vAlign: "center"});
		}
		setItemCoordinates(ANSCOLUMN, xPos, yPos, nWidth, nHeight);
	}
	
	function createQuesItem(label:String, linkageID:String, ansID:String, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		if(linkageID != null && linkageID.length > 0)
			createQuesItemMC(linkageID, ansID, xPos, yPos, nWidth, nHeight);
		else
			createQuesItemLbl(label, ansID, xPos, yPos, nWidth, nHeight);
	}

	private function createQuesItemLbl(label:String, ansID:String, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		var p:CpMatchingQuesParams = new CpMatchingQuesParams();
		p._font.name = "Arial";		p._font.size = 14;
		p._name = QUESITEM + numQuesItems;
		quesItem_arr[numQuesItems] = p;
		p._component = createChild( "CpMatchingQuesItem", QUESITEM + numQuesItems.toString());
		setItemCoordinates((QUESITEM + numQuesItems), xPos, yPos, nWidth, nHeight);
		var item:CpMatchingQuesItem = CpMatchingQuesItem(p._component);
		//item.label = newText;
		item.createText(label);
		item.addEventListener("changed", Delegate.create(this,onChange));
		//var pitem:CpItemParams = item.getLabelParams();
		xPos += 25;
		nWidth -= 25;
		createDupQuesItem(label, ansID, xPos, yPos, nWidth, nHeight);
		p.ansReturnID = ansID;
		numQuesItems++;
	}
	
	private function createDupQuesItem(label:String, ansID:String, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		var p:CpMatchingQuesParams = new CpMatchingQuesParams();
		p._font.name = "Arial";		p._font.size = 14;
		p._name = QUESDUPITEM + numQuesItems;
		quesDupItem_arr[numQuesItems] = p;
		p.ansReturnID = ansID;
		p._component = createChild( "CpLabel", QUESDUPITEM + numQuesItems.toString(), {text: label, hAlign: "left", vAlign: "center"});
		setItemCoordinates((QUESDUPITEM + numQuesItems), xPos, yPos, nWidth, nHeight);
	}

	private function createQuesItemMC(className:String, ansID:String, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		var p:CpMatchingQuesParams = new CpMatchingQuesParams();
		p._movie = true;
		p._name = QUESITEM + numQuesItems;
		quesItem_arr[numQuesItems] = p;
		p._component = createChild( "CpMatchingQuesItem", QUESITEM + numQuesItems.toString());
		setItemCoordinates((QUESITEM + numQuesItems), xPos, yPos, nWidth, nHeight);
		var item:CpMatchingQuesItem = CpMatchingQuesItem(p._component);
		item.createTextMC(className);
		item.addEventListener("changed", Delegate.create(this,onChange));
		item.textVisible = false;
		xPos += 30;
		nWidth -= 25;
		createDupQuesItemMC(className, ansID, xPos, yPos, nWidth, nHeight);
		p.ansReturnID = ansID;
		//trace("quesItem_arr[numQuesItems] = " + quesItem_arr[numQuesItems]._component + " numQuesItems = " + numQuesItems);
		numQuesItems++;
	}

	private function createDupQuesItemMC(className:String, ansID:String, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		var p:CpMatchingQuesParams = new CpMatchingQuesParams();
		p._name = QUESDUPITEM + numQuesItems;
		quesDupItem_arr[numQuesItems] = p;
		p.ansReturnID = ansID;
		p._movie = true;
		p._component = createChild( className, QUESDUPITEM + numQuesItems.toString());
		setItemCoordinates((QUESDUPITEM + numQuesItems), xPos, yPos, nWidth, nHeight);
	}

	function createAnsItem(label:String, linkageID:String, returnID:String, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		if(linkageID != null && linkageID.length > 0)
			createAnsItemMC(linkageID, returnID, xPos, yPos, nWidth, nHeight);
		else
			createAnsItemLbl(label, returnID, xPos, yPos, nWidth, nHeight);
	}

	private function createAnsItemLbl(newText:String, returnID:String, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		var p:CpMatchingAnsParams = new CpMatchingAnsParams();
		p._font.name = "Arial";		p._font.size = 14;
		p._name = ANSITEM + numAnsItems;
		ansItem_arr[numAnsItems] = p;
		p._component = createChild( "CpLabel", ANSITEM + numAnsItems.toString(), {text: newText, hAlign: "left", vAlign: "center"});
		setItemCoordinates((ANSITEM + numAnsItems), xPos, yPos, nWidth, nHeight);
		p.returnID = returnID;
		createDupAnsItem(newText, returnID, xPos, yPos, nWidth, nHeight);
		numAnsItems++;
		
	}
	
	function createDupAnsItem(newText:String, returnID:String, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		var p:CpMatchingAnsParams = new CpMatchingAnsParams();
		p._font.name = "Arial";		p._font.size = 14;
		p._name = ANSDUPITEM + numAnsItems;
		ansDupItem_arr[numAnsItems] = p;
		p.returnID = returnID;
		p._component = createChild( "CpLabel", ANSDUPITEM + numAnsItems.toString(), {text: newText, hAlign: "left", vAlign: "center"});
		setItemCoordinates((ANSDUPITEM + numAnsItems), xPos, yPos, nWidth, nHeight);
	}

	
	private function createAnsItemMC(className:String, returnID:String, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		var p:CpMatchingAnsParams = new CpMatchingAnsParams();
		p._movie = true;
		p._name = ANSITEM + numAnsItems;
		ansItem_arr[numAnsItems] = p;
		p._component = createChild( className, ANSITEM + numAnsItems.toString());
		setItemCoordinates((ANSITEM + numAnsItems), xPos, yPos, nWidth, nHeight);
		p.returnID = returnID;
		p._component._visible = false;
		createDupAnsItemMC(className, returnID, xPos, yPos, nWidth, nHeight);
		numAnsItems++;
	}

	private function createDupAnsItemMC(className:String, returnID:String, xPos:Number, yPos:Number, nWidth:Number, nHeight:Number)
	{
		var p:CpMatchingAnsParams = new CpMatchingAnsParams();
		p._name = ANSDUPITEM + numAnsItems;
		ansDupItem_arr[numAnsItems] = p;
		p.returnID = returnID;
		p._movie = true;
		p._component = createChild( className, ANSDUPITEM + numAnsItems.toString());
		setItemCoordinates((ANSDUPITEM + numAnsItems), xPos, yPos, nWidth, nHeight);
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
		var p:CpItemParams = _itemColumn_prm;
		setItemParams(p._component, p);

		p = _ansColumn_prm;
		setItemParams(p._component, p);

		for(var i:Number = 0; i < ansItem_arr.length; i++)
		{
			p = ansItem_arr[i];
			setItemParams(p._component, p);
			p = ansDupItem_arr[i];
			setItemParams(p._component, p);
		}
		for(var j:Number = 0; j < quesItem_arr.length; j++)
		{
			p = quesItem_arr[j];
			setItemParams(p._component, p);
			p = quesDupItem_arr[j];
			setItemParams(p._component, p);
		}
		
		drawLine();
	}

	private function drawLine()
	{
		//clear all the graphics in the component.
		//we also dispatch clear event, so make sure the two does not conflict
		this.clear(); 
		
		var sourcep:CpMatchingQuesParams = undefined;
		var ans:String;
		
		//check all the question items, and find thier respective ans items, as 
		//entered by user, and then draw a solid line between the two
		for(var i:Number = 0; i < quesItem_arr.length; i++)
		{
			sourcep = quesItem_arr[i];
			ans = CpMatchingQuesItem(sourcep._component).text;
			//trace(ans);
			var targetp:CpMatchingAnsParams = undefined;
			for(var j:Number = 0; j < ansItem_arr.length; j++)
			{
				targetp = ansItem_arr[j];
				if(targetp.returnID.toUpperCase() == ans.toUpperCase())
					break;
				targetp = undefined;
			}
			
			//trace("sourcep = " + sourcep + " targetp = " + targetp);
			if(sourcep == undefined || targetp == undefined)
				continue;
			
			//Draw the line
			this.lineStyle(2, 0x777777, 50);
			//trace("sourcep._x = " + sourcep._x + " sourcep._width = " + sourcep._width);
			this.moveTo(sourcep._x + sourcep._width, sourcep._y + sourcep._height);
			this.lineTo(targetp._x, targetp._y + targetp._height);
		}
	}
	
	private function getItemParams(item:String):CpItemParams
	{
		for(var i:Number = 0; i < ansItem_arr.length; i++)
		{
			if(item.toUpperCase() == (ANSITEM+i))
				return ansItem_arr[i];
			if(item.toUpperCase() == (ANSDUPITEM+i))
				return ansDupItem_arr[i];
		}
		for(var j:Number = 0; j < quesItem_arr.length; j++)
		{
			if(item.toUpperCase() == (QUESITEM+j))
				return quesItem_arr[j];
			if(item.toUpperCase() == (QUESDUPITEM+j))
				return quesDupItem_arr[j];
		}
		if(item.toUpperCase() == ITEMCOLUMN)
			return _itemColumn_prm;
		if(item.toUpperCase() == ANSCOLUMN)
			return _ansColumn_prm;
		
		return super.getItemParams(item);
	}
	
	function onMouseDown(evt)
	{
		var p:CpItemParams;
		//trace(ansDupItem_arr.length);
		
		//check if the user wants to drag answer item
		for(var i:Number = 0; i < ansDupItem_arr.length; i++)
		{
			p = ansDupItem_arr[i];
			//trace(p._component);
			if (p._component.hitTest(_root._xmouse, _root._ymouse)) {
				
				//draggable item found, drag it within the limits of parent component
				draggedComp_prm = p;
				ansItem_arr[i]._component._visible = true;
				p._component.startDrag(false, 0, 0, this._width, this._height);
				
				bQuesItemDrag = false;
				bStartDrag = true;
				draggedAnsItem_prm = ansItem_arr[i];
				break;
			}
		}
		//trace("quesDupItem_arr.length " + quesDupItem_arr.length);
		
		//check if user wants to drag question item
		for(i = 0; i < quesDupItem_arr.length; i++)
		{
			p = quesDupItem_arr[i];
			//trace(" i = " + i + " " + p._component);
			if (p._component.hitTest(_root._xmouse, _root._ymouse)) {
				
				//draggable item found, drag it within the limits of parent component
				CpMatchingQuesItem(quesItem_arr[i]._component).textVisible = true;
				p._component.startDrag(false, 0, 0, this._width, this._height);
				
				bQuesItemDrag = true;
				bStartDrag = true;
				draggedComp_prm = p;
				draggedQuesItem_prm = quesItem_arr[i];
				break;
			}
		}
	}
	
	/**
	function onMouseMove(evt)
	{
		if(bStartDrag)
		{
	
			if(draggedComp_prm._component._x < this._x)
				draggedComp_prm._component._x = this._x;
			if(draggedComp_prm._component._y < this._y)
				draggedComp_prm._component._y = this._y;
			var p1:Number = draggedComp_prm._component._y + draggedComp_prm._component.height;
			var p2:Number = this._y + this.height;
			if(p1 > p2)
				draggedComp_prm._component._y = p2 - draggedComp_prm._component.height;
			p1 = draggedComp_prm._component._x + draggedComp_prm._component.width;
			p2 = this._x + this.width;
			if(p1 > p2)
				draggedComp_prm._component._x = p2 - draggedComp_prm._component.width;
				
			/***
			if (!this.hitTest(_root._xmouse, _root._ymouse))
			{
				trace("outside");
				draggedComp_prm._component.stopDrag();
			}
			else
				draggedComp_prm._component.startDrag();
			*** /
		}
		
	}
	***/
	
	function onMouseUp(evt)
	{
		//trace(bQuesItemDrag);
		if (bStartDrag && !bQuesItemDrag)
		{
			draggedAnsItem_prm._component._visible = false;
			var p:CpItemParams;
			for(var i:Number = 0; i < quesItem_arr.length; i++)
			{
				p = quesItem_arr[i];
				if (p._component.hitTest(_root._xmouse, _root._ymouse)) {
					CpMatchingQuesItem(p._component).text = CpMatchingAnsParams(draggedComp_prm).returnID.toUpperCase();
					//trace(draggedComp_prm.returnID);
					break;
				}
			}
			draggedComp_prm._component.stopDrag();
			invalidate();
		}
		else if (bStartDrag && bQuesItemDrag)
		{
			CpMatchingQuesItem(draggedQuesItem_prm._component).textVisible = false;
			var p:CpItemParams;
			for(var i:Number = 0; i < ansItem_arr.length; i++)
			{
				p = ansItem_arr[i];
				if (p._component.hitTest(_root._xmouse, _root._ymouse)) {
					CpMatchingQuesItem(draggedQuesItem_prm._component).text = CpMatchingAnsParams(p).returnID.toUpperCase();
					break;
				}
			}
			draggedComp_prm._component.stopDrag();
			invalidate();
		}
		bStartDrag = false;
	}
	

	function clearAll()
	{
		for(var i:Number = 0; i < quesItem_arr.length; i++)
			CpMatchingQuesItem(quesItem_arr[i]._component).text = "";
		invalidate();
	}

	private function onChange(evt)
	{
		invalidate();
	}

/********	
	function getUserAnswers():Array
	{
		var ans:Array = new Array;
		for(var i:Number = 0; i < quesItem_arr.length; i++)
			ans[i] = CpMatchingQuesItem(quesItem_arr[i]._component).inputText;
		return ans;
	}

	function setUserAnswers(ans:Array)
	{
		for(var i:Number = 0; i < quesItem_arr.length; i++)
			CpMatchingQuesItem(quesItem_arr[i]._component).inputText = ans[i];
	}
	
	private function isCorrectAnswer(ansNum:Number, ansText:String):Boolean
	{
		for(var i:Number = 0; i < quesItem_arr.length; i++)
			if(CpMatchingQuesItem(quesItem_arr[i]._component).inputText != CpMatchingQuesParams(quesItem_arr[i]).ansReturnID)
				return false;
		return true;
	}
	
	private function isBlank():Boolean
	{
		for(var i:Number = 0; i < quesItem_arr.length; i++)
			if(CpMatchingQuesItem(quesItem_arr[i]._component).inputText != "")
				return false;
		return true;
	}

	//returns the status on pressing submit
	//0 -- no answer entered
	//1 -- incompete
	//2 -- incorrect
	//3 -- correct
	function getStatus():Number
	{
		var quesStatus:Number = INCORRECT;
		
		if(isBlank())
			quesStatus = BLANK;
		else if(isCorrectAnswer())
			quesStatus = CORRECT;
		
		return quesStatus;
	}
	
	function enableUserInput(e:Boolean)
	{
		for(var i:Number = 0; i < quesItem_arr.length; i++)
			quesItem_arr[i]._component.enabled = false;
		for(i = 0; i < ansItem_arr.length; i++)
			ansItem_arr[i]._component.enabled = false;
		
		enableClearButton(e);
		enableSubmitButton(e);
	}
	
	/*
	* displays the feedback as per the user input
	* if correct answer is given or the attempts 
	* are over then hitbutton is shown
	* /
	function submitAns()
	{
		var status:Number = getStatus();
		showFeedbackOnSubmit(status);
		if((status == CORRECT) || (attempts >= maxAttempts))
		{
			enableUserInput(false);
			showHitButton();
		}
	}
	
	function showReview()
	{
		var comp:CpReviewArea = CpReviewArea(getQuizItem(REVIEWAREA));
		if(lastStatus == CORRECT)
			comp.showCorrectMsg();
		else if(lastStatus == INCOMPLETE || lastStatus == BLANK)
			comp.showIncompleteMsg();
		else
		{
			var userAns:Array = getUserAnswers();
			var correctAns:Array = Array();
			for(var i:Number = 0; i < quesItem_arr.length; i++)
			{
				userAns[i] = CpMatchingQuesItem(quesItem_arr[i]._component).inputText;
				correctAns[i] = CpMatchingQuesParams(quesItem_arr[i]).ansReturnID;
			}
			comp.showIncorrectMsg(userAns.toString(), correctAns.toString());
		}
		setItemVisible(REVIEWAREA, true);
		comp.useHandCursor = true;
	}
****/

	public function get answerParams():Array
	{
		return quesItem_arr;
	}
	
}