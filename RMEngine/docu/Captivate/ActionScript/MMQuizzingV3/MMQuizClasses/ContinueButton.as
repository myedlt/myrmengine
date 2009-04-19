//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"
import MMQuizzingV3.MMQuizClasses.Question;
import MMQuizzingV3.MMQuizClasses.UIResourceStub;

[TagName("ContinueButton")]
class MMQuizzingV3.MMQuizClasses.ContinueButton extends Button {
	static var symbolName:String = "ContinueButton";
	static var symbolOwner:Object = Object(ContinueButton);
	var	className:String = "ContinueButton";

	private var _butIcon:MovieClip;
	private var _hint:MovieClip;
	public var useWholeButtonHilite:Boolean = true;
	public var mouseOverHiliteColor:Number = 0x75AEEB;
	public var mouseOverHiliteAlpha:Number = 50;
	

	

	function get question():Question
	{
		var theParent:Object = _parent;
		while (theParent) {
			if (theParent.className == "Question") {
				return Question(theParent);
			} else if (theParent._question.className = "Question") {
				return Question(theParent._question);
			} else {
				theParent = theParent._parent;
			}
		}
		return null;
	}
	
	
	function ContinueButton() 
	{
	}
	
	private function hideButton()
	{
		useHandCursor = true;
		_butIcon.visible = false;
		if (question.inReviewMode) {
			enabled = false;
		}
	}
	
	private function init() 
	{
		if (_hint) {
			_hint._visible = false;
		}
		super.init();
		var me = this;
		visible = true;
		addEventListener("click", this);
		doLater(this,"hideButton");  // Have to do this next frame since button isn't yet constructed and constructor will set visible
		
	}

	private function createChildren() 
	{
		super.createChildren();
		UIResourceStub.findAndUseUIR(this);
	}

	public function uirChanged(p_uir:Object):Void
	{
		if (!isNaN(p_uir.color.glow))
			mouseOverHiliteColor = p_uir.color.glow;
		drawHA();
	}
	
	
	function size() 
	{
		super.size();
		setState(getState());
		refresh();
	}
	
	
	
	function setLabel(label:String):Void
	{
		super.setLabel("");
	}


	function setSkin(tag:Number, linkageName:String, initObj:Object):MovieClip
	{
		var retVal:MovieClip;
		var txt:MovieClip;
		txt = this["_butText"];
//
// DepthManager can act funky and shuffle depths around if you pass an explicit number
// here. Not sure why. But since we want the text on top, let's ask for that explicitly,
// which avoid funky shuffling. (srj)
//		txt.setDepthTo(1000);					// Change depth to allow text to appear above button
//
		// Serrano implements DepthManager as all static methods, NOT by prototype hacking...
		// so always call this static method if present!
		if (typeof(DepthManager["safeSetDepthTo"]) == "function")
			DepthManager["safeSetDepthTo"](txt, DepthManager.kTopmost);
		else
			txt["setDepthTo"](DepthManager.kTopmost);	// Change depth to allow text to appear above button
		if (initObj == undefined) {
			initObj = {styleName: this};
		}

// NOTE: we no longer do this! It is really only necessary if the skin in question doesn't
// have a proper class registration in the FLA, and this conveniently auto-registers it...
// except that Serrano doesn't use SkinElement, so this messes things up. You should be
// able to fix your skins by pre-registering them properly. But please don't re-enable this. (srj)		
//		if (_global.skinRegistry[linkageName] == undefined)
//		{
//			SkinElement.registerElement(linkageName, SkinElement);
//		}
		// attachMovie, NOT createObject
		retVal = attachMovie(linkageName, getSkinIDName(tag), tag-1000, initObj);  // Create skin at depth lower than text label
		calcSize(tag, retVal);
		
		// Position skin to be at same location as placeholder label, _butIcon
		retVal.move(_butIcon._x, _butIcon._y, false);
		retVal.setSize(_butIcon._width,_butIcon._height,true);
		return retVal;
	}

	function adjustFocusRect()
	{
		var rectCol = this["getStyle"]("themeColor");
		if (rectCol==undefined)
			rectCol = 0x80ff4d;

		var o = this._parent.focus_mc;
		o.setSize(_butIcon.width + 4, _butIcon.height + 4, 0, 100, rectCol);
		o.move(x+_butIcon.x - 2, y+_butIcon.y - 2);
	}
	
	function setHitArea(w:Number,h:Number)
	{
		if (hitArea_mc == undefined)
		{
			if (typeof(UIObject["safeCreateEmptyObject"]) == "function")
				UIObject["safeCreateEmptyObject"](this,"hitArea_mc",100); //reserved depth for hit area
			else
				this["createEmptyObject"]("hitArea_mc",100); //reserved depth for hit area
		}
		drawHA();
	}

	private function drawHA()
	{
		var answerBounds = getBounds(_butIcon);
		var ha = hitArea_mc;
		ha.clear();
		// If we don't do this, then if the regpt for the answer is not at the top left,
		// the hit area will be at the wrong place.  We want the hit area to be the bounding
		// box of the answer movie clip
		//ha._x = answerBounds.xMin;
		//ha._y = answerBounds.yMin;
		ha._x = _butIcon._x;
		ha._y = _butIcon._y;
		ha.beginFill(mouseOverHiliteColor);
		drawRoundRect(ha,0,0,answerBounds.xmax,answerBounds.ymax,5);
		ha.endFill();
		ha._alpha = 0;
		ha.setVisible(true);
	}

	// ---------------------------------------------------------------------------
	private static function drawRoundRect(mc:MovieClip,x:Number,y:Number,w:Number,h:Number,r:Number)
	{
		// Math.sin and Math,tan values for optimal performance.
		// Math.rad = Math.PI/180 = 0.0174532925199433
		// r*Math.sin(45*Math.rad) =  (r*0.707106781186547);
		// r*Math.tan(22.5*Math.rad) = (r*0.414213562373095);
		var oneMinusSin45:Number = 0.29289321881345247559915563789515;
		var oneMinusTan225:Number = 0.5857864376269049511983112757903;
		
		var x2:Number = x+w;
		var y2:Number = y+h;
		
		var a:Number = r*oneMinusSin45; //radius - anchor pt;
		var s:Number = r*oneMinusTan225; //radius - control pt;

		//bottom right corner
		mc.moveTo ( x2,y2-r);
		mc.lineTo ( x2,y2-r );
		mc.curveTo( x2,y2-s,x2-a,y2-a);
		mc.curveTo( x2-s,y2,x2-r,y2);

		//bottom left corner
		mc.lineTo ( x+r,y2 );
		mc.curveTo( x+s,y2,x+a,y2-a);
		mc.curveTo( x,y2-s,x,y2-r);

		//top left corner
		mc.lineTo ( x,y+r );
		mc.curveTo( x,y+s,x+a,y+a);
		mc.curveTo( x+s,y,x+r,y);

		//top right
		mc.lineTo ( x2-r,y );
		mc.curveTo( x2-s,y,x2-a,y+a);
		mc.curveTo( x2,y+s,x2,y+r);
		mc.lineTo ( x2,y2-r );
	}
	
	function drawMouseOverHilite():Void
	{
		if (useWholeButtonHilite) {
			var ha = hitArea_mc;
			ha._alpha = mouseOverHiliteAlpha;
			ha.visible = true;
		}
	}
	
	function eraseMouseOverHilite():Void
	{
		if (useWholeButtonHilite) {
			var ha = hitArea_mc;
			ha._alpha = 0;
		}
	}
	
	function onRollOver(Void):Void
	{
		super.onRollOver();
		drawMouseOverHilite();
		if (_hint) {
			if (hitArea_mc.hitTest(_root._xmouse, _root._ymouse)) {
				_hint._visible = true;
			} else {
				_hint._visible = false;
			}
		}		
	}

	public function click(ev:Object):Void
	{
		if (_hint) {
			_hint._visible = false;
		}
	}
	
	function onRelease() 
	{
		if (_hint) {
			_hint._visible = false;
		}

	}


	function onRollOut(Void):Void
	{
		super.onRollOut();
		eraseMouseOverHilite();
		if (_hint) {
			_hint._visible = false;
		}
	}
	
	function keyDown(e:Object):Void
	{
		if (!question.showingModalFeedback) {
			super.keyDown(e);
		}
	}
	function keyUp(e:Object):Void
	{
		if (!question.showingModalFeedback) {
			super.keyUp(e);
		}
	}
	


}