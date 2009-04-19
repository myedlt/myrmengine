//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

class AdobeCaptivate.rdZoomItem extends MovieClip
{
	//these variables are to be set from outside
	var inBegin:Number = 0;	//zoom starting frame
	var outEnd:Number = 0; //zoom end frame
	
	var inEnd:Number = 0; //fade-in last frame
	var outBegin:Number = 0; //fade-out start frame
	
	var zoomFor:Number = 0;
	
	var movieWidth:Number = 0;
	var movieHeight:Number = 0;

	var srcLeft:Number = 0.0;
	var srcTop:Number = 0.0;
	var srcWidth:Number = 0.0;
	var srcHeight:Number = 0.0;
	var srcBorderClr:Number = 0;
	
	var srcBorderWidth:Number = 0;
	var srcFillClr:Number = 0;
	var srcFillAlpha:Number = 0;

	var desLeft:Number = 0.0;
	var desTop:Number = 0.0;
	var desWidth:Number = 0.0;
	var desHeight:Number = 0.0;
	var desBorderClr:Number = 0;
	
	var desBorderWidth:Number = 0;
	var desFillClr:Number = 0;
	var desFillAlpha:Number = 0;

	var targetMC:MovieClip = null;
	var mask_mc:MovieClip = null;

	var border_mct:MovieClip = null;
	var border_mcb:MovieClip = null;
	var border_mcl:MovieClip = null;
	var border_mcr:MovieClip = null;

	var zoomStarted:Boolean = false;

	//internal variables: postion ans scale
	var xStep:Number = 0.0;
	var yStep:Number = 0.0;
	var widthStep:Number = 0.0;
	var heightStep:Number = 0.0;
	
	var disLeft:Number = 0.0;
	var disTop:Number = 0.0;
	var movieWidthStep:Number = 0.0;
	var movieHeightStep:Number = 0.0;
	
	var borderWidthStep:Number = 0.0;

	//interla variables: movie clips and depths
	var dupTarget_Depth:Number = 0;
	var dupTarget_mc:MovieClip = null;
	var fillClr_mc:MovieClip = null;
	
	//internal variable: alpha transition
	var inEndAlpha:Number = 0.0;
	var outBeginAlpha:Number = 0.0;

	var inAlphaStep:Number = 0.0;
	var outAlphaStep:Number = 0.0;
	
	var alphaStepFillClr:Number = 0.0;

	//internal variable: color transition
	var borderClrT:Object = null;
	var borderClrB:Object = null;
	var borderClrL:Object = null;
	var borderClrR:Object = null;
	
	var sR:Number = 0.0;
	var sG:Number = 0.0;
	var sB:Number = 0.0;
	
	var bcRStep:Number = 0.0;
	var bcGStep:Number = 0.0;
	var bcBStep:Number = 0.0;
	
	var sfcR:Number = 0.0;
	var sfcG:Number = 0.0;
	var sfcB:Number = 0.0;
	
	var fcRStep:Number = 0.0;
	var fcGStep:Number = 0.0;
	var fcBStep:Number = 0.0;
	
	function rdZoomItem()
	{
	}
	
	function InitZoomItemData()
	{
		if (typeof(dupTarget_mc) == "movieclip")
			return;//make sure it's called only once
		
		//read data
		movieWidth = _parent.movieWidth;
		movieHeight = _parent.movieHeight;

		targetMC = _parent.targetMC;
		//trace("_parent.targetMC = " + _parent.targetMC);
		//trace("targetMC = " + targetMC);
		
		mask_mc = this.mask_mc;
		
		border_mct = this.border_mct;
		border_mcb = this.border_mcb;
		border_mcl = this.border_mcl;
		border_mcr = this.border_mcr;

		//set data
		zoomStarted = false;
		mask_mc._visible = false;
		
		border_mct._visible = false;
		border_mcb._visible = false;
		border_mcl._visible = false;
		border_mcr._visible = false;
		
		borderClrT = new Color(border_mct);
		borderClrB = new Color(border_mcb);
		borderClrL = new Color(border_mcl);
		borderClrR = new Color(border_mcr);

		//position and scale trnasition steps
		var widthScale:Number = (desWidth - 2*desBorderWidth)/srcWidth;
		var heightScale:Number = (desHeight- 2*desBorderWidth)/srcHeight;
		var disFrames:Number = zoomFor - inBegin;

		//trace(this._name + "::Init:movie=(" + movieWidth + "," + movieHeight +")");
		//trace(this._name + "::Init:Scale=(" + widthScale + "," + heightScale + ")");

		var leftStep = srcLeft * (widthScale - 1) / disFrames;
		var topStep = srcTop * (heightScale - 1) / disFrames;
		
		widthStep = srcWidth * (widthScale - 1) / disFrames;
		heightStep = srcHeight * (heightScale - 1) / disFrames;

		var disXStep = (desLeft + desBorderWidth - srcLeft) / disFrames;
		var disYStep = (desTop + desBorderWidth - srcTop) / disFrames;
		
		disLeft = disXStep - leftStep; 
		disTop = disYStep - topStep;
		
		xStep = leftStep + disLeft;
		yStep = topStep + disTop;

		movieWidthStep = movieWidth * (widthScale - 1) / disFrames;
		movieHeightStep = movieHeight * (heightScale - 1) / disFrames;

		borderWidthStep = (desBorderWidth - srcBorderWidth) / disFrames;
		
		//alpha transition steps
		inEndAlpha = 100;// - desFillAlpha;
		outBeginAlpha = 100 - desFillAlpha;
		
		var fadeInFrms = inEnd - inBegin;
		if (fadeInFrms > 3)
			inAlphaStep = inEndAlpha / fadeInFrms;
		var fadeOutFrms = outEnd - outBegin;
		if (fadeOutFrms > 3)
			outAlphaStep = outBeginAlpha / fadeOutFrms;
			
		alphaStepFillClr = (desFillAlpha - srcFillAlpha) / disFrames;

		//color transition steps: boder
		sR = srcBorderClr >> 16;
		sG = (srcBorderClr & 0x00ff00) >> 8;
		sB = (srcBorderClr & 0x0000ff);
		
		var dR = desBorderClr >> 16;
		var dG = (desBorderClr & 0x00ff00) >> 8;
		var dB = (desBorderClr & 0x0000ff);
		
		bcRStep = (dR - sR) / disFrames;
		bcGStep = (dG - sG) / disFrames;
		bcBStep = (dB - sB) / disFrames;
		
		//color transition steps: fill color
		sfcR = srcFillClr >> 16;
		sfcG = (srcFillClr & 0x00ff00) >> 8;
		sfcB = (srcFillClr & 0x0000ff);

		var dfcR = desFillClr >> 16;
		var dfcG = (desFillClr & 0x00ff00) >> 8;
		var dfcB = (desFillClr & 0x0000ff);
		
		fcRStep = (dfcR - sfcR) / disFrames;
		fcGStep = (dfcG - sfcG) / disFrames;
		fcBStep = (dfcB - sfcB) / disFrames;
	}
	
	function GetRGBColorNumber(r:Number, g:Number, b:Number)
	{
		var rgb:Number = r << 16;
		rgb += g << 8;
		rgb += b;
		
		return rgb;
	}
	
	function CreateDupMovieClip()
	{
		//trace("CreateDupMovieClip");
		if (dupTarget_Depth == 0)
			dupTarget_Depth = ++_parent.dupMCLayer;
		
		dupTarget_mc = targetMC.duplicateMovieClip(targetMC._name + "_dupMC_" + dupTarget_Depth, dupTarget_Depth);
		dupTarget_mc.isDupSlide = true;
		dupTarget_mc.setMask(mask_mc);
		dupTarget_mc._visible = false;
		
		fillClr_mc = this.createEmptyMovieClip("", dupTarget_Depth+1);
		fillClr_mc._visible = false;
		
		//trace(this._name + "::Init:Created:dupTarget_mc._name=" + dupTarget_mc._name);
		ResetMaskPosition();
	}
	
	function DrawFillClrRect(fillClr:Number, fillAlpha:Number, left:Number, top:Number, width:Number, height:Number, bFadeout:Boolean)
	{
		var curFA = bFadeout?fillAlpha:100;
		fillClr_mc.clear();
		fillClr_mc.beginFill(fillClr, curFA);
		fillClr_mc.moveTo(left, top);
		fillClr_mc.lineTo(left + width, top);
		fillClr_mc.lineTo(left + width, top + height);
		fillClr_mc.lineTo(left, top + height);
		fillClr_mc.lineTo(left, top);
		fillClr_mc.endFill();
		
		fillClr_mc._x = mask_mc._x;
		fillClr_mc._y = mask_mc._y;
		fillClr_mc._width = mask_mc._width;
		fillClr_mc._height = mask_mc._height;
		
		dupTarget_mc._alpha = bFadeout? fillAlpha : (100 - fillAlpha);
		//trace("dupTarget_mc._alpha = " + dupTarget_mc._alpha + "----fillAlpha=" + curFA + "----bFadeout=" + bFadeout);
	}
	
	function StartZoomItem()
	{
		if (zoomStarted)
			return;

		border_mct._visible = true;
		border_mcb._visible = true;
		border_mcl._visible = true;
		border_mcr._visible = true;
	
		dupTarget_mc._visible = true;
		fillClr_mc._visible = true;
		
		ResetMaskPosition();
		
		zoomStarted = true;
	}

	function StopZoomItem()
	{
		//trace("StopZoomItem");
		//trace("zoomStarted = " + zoomStarted + " dupTarget_mc = " + dupTarget_mc);
		if (!zoomStarted)
			return;
			
		if (typeof(dupTarget_mc) == "movieclip")
		{
			fillClr_mc.removeMovieClip();
			fillClr_mc = null;
			//trace("Removed:dupTarget_mc._name=" + dupTarget_mc._name);
			dupTarget_mc.setMask(null);//cancel the mask before delete it
			dupTarget_mc.removeMovieClip();
			dupTarget_mc = null;
		}
		
		border_mct._visible = false;
		border_mcb._visible = false;
		border_mcl._visible = false;
		border_mcr._visible = false;
		
		mask_mc._visible = false;
		
		zoomStarted = false;
		stopSound();
	}

	function SyncZoomItem(bForce:Boolean)
	{
		var frmIdx = targetMC._currentframe;
		//trace("targetMC = " + targetMC);
		//trace("_parent.slide_2 = " + _parent._parent.slide_2);
		//trace("targetMC.m_isPlaying = " + targetMC.m_isPlaying + " frmIdx = " + frmIdx + " inBegin = " + inBegin + " outEnd = " + outEnd);
		if ((targetMC.m_isPlaying || bForce) && ( frmIdx >= inBegin) && (frmIdx <= outEnd))
		{
			if (typeof(dupTarget_mc) != "movieclip")
				CreateDupMovieClip();
			else
			{
				if (!zoomStarted)
					StartZoomItem();
/**/
				//sync the duplicate mc with target mc
				//trace("dupTarget_mc._currentframe = " + dupTarget_mc._currentframe);
				if (dupTarget_mc._currentframe != frmIdx)
					dupTarget_mc.gotoAndPlay(frmIdx);

				if (frmIdx <= zoomFor)
					ScaleZoomItem(frmIdx);
				else
				{
					/*
					* when scrubber is drageed in opposite direction and the slide enters from the end
					* the zoom should be of final stage
					*/
					ScaleZoomItem(zoomFor);  
				}
				
				if (frmIdx >= outBegin) //fadeout
				{
					var outAlpha = outBeginAlpha - (frmIdx - outBegin) * outAlphaStep;
					SetAlpha(outAlpha);
					DrawFillClrRect(desFillClr, outAlpha, 0, 0, 10, 10, true);
				}
/**/
			}
			playSound();
		}
		else //if (targetMC._currentframe >= outEnd)
			StopZoomItem();
	}
	
	function ResetMaskPosition()
	{
		//trace(this._name + "::ResetMaskPosition()");
		
		dupTarget_mc._x = 0;
		dupTarget_mc._y = 0;
		dupTarget_mc._width = movieWidth;
		dupTarget_mc._height = movieHeight;
		
		mask_mc._x = srcLeft;
		mask_mc._y = srcTop;
		mask_mc._width = srcWidth;
		mask_mc._height = srcHeight;
		//trace("ResetMaskPosition mask_mc._y = " + mask_mc._y);
		
		borderClrT.setRGB(srcBorderClr);
		borderClrB.setRGB(srcBorderClr);
		borderClrL.setRGB(srcBorderClr);
		borderClrR.setRGB(srcBorderClr);
		
		SyncBorderAndItem(0);
	}
	
	function SyncBorderAndItem(fD:Number)
	{
		var curBW = srcBorderWidth + fD * borderWidthStep;
		//top border
		border_mct._x = mask_mc._x - curBW;
		border_mct._y = mask_mc._y - curBW;
		border_mct._width = mask_mc._width + 2*curBW;
		border_mct._height = curBW;
		
		//bottom border
		border_mcb._x = mask_mc._x - curBW;
		border_mcb._y = mask_mc._y + mask_mc._height;
		border_mcb._width = mask_mc._width + 2*curBW;
		border_mcb._height = curBW;

		//left border
		border_mcl._x = mask_mc._x - curBW;
		border_mcl._y = mask_mc._y;
		border_mcl._width = curBW;
		border_mcl._height = mask_mc._height;

		//right border
		border_mcr._x = mask_mc._x + mask_mc._width;
		border_mcr._y = mask_mc._y;
		border_mcr._width = curBW;
		border_mcr._height = mask_mc._height;
		
		//fill-in clolor
		if ((fD + inBegin) < outBegin)
		{
			var fc = GetRGBColorNumber(sfcR + fD * fcRStep, sfcG + fD * fcGStep, sfcB + fD * fcBStep);
			var fa = srcFillAlpha + fD * alphaStepFillClr;
			DrawFillClrRect(fc, fa, 0, 0, 10, 10,false);
		}

		//transform border color
		var bc = GetRGBColorNumber(sR + fD * bcRStep, sG + fD * bcGStep, sB + fD * bcBStep);
		borderClrT.setRGB(bc);
		borderClrB.setRGB(bc);
		borderClrL.setRGB(bc);
		borderClrR.setRGB(bc);
	}

	function ScaleZoomItem(frmIdx:Number)
	{
		var fD = frmIdx - inBegin;

		//move and scale mask
		mask_mc._x = srcLeft + fD * xStep;
		mask_mc._y = srcTop + fD * yStep;
		mask_mc._width = srcWidth + fD * widthStep;
		mask_mc._height = srcHeight + fD * heightStep;
		//trace("mask_mc _x = " + mask_mc._x + " _y = " + mask_mc._y + " _w = " + mask_mc._width + " _h = " + mask_mc._height);

		//move and scale dup mc
		dupTarget_mc._x = fD * disLeft;
		dupTarget_mc._y = fD * disTop;
		dupTarget_mc._width = movieWidth + fD * movieWidthStep;
		dupTarget_mc._height = movieHeight + fD * movieHeightStep;
		
		//trace("mask_mc _x = " + mask_mc._x + " _y = " + mask_mc._y + " _w = " + mask_mc._width + " _h = " + mask_mc._height);
		//trace("srcWidth = " + srcWidth + " fD = " + fD + " widthStep = " + widthStep);
		//trace("dupTarget_mc _x = " + dupTarget_mc._x + " _y = " + dupTarget_mc._y + " _w = " + dupTarget_mc._width + " _h = " + dupTarget_mc._height);
		SyncBorderAndItem(fD);
		
		if (frmIdx <= inEnd) //fadein
			SetAlpha(fD * inAlphaStep);
	}
	
	function SetAlpha(aVal:Number)
	{
		//dupTarget_mc._alpha = aVal;
		border_mct._alpha = aVal;
		border_mcb._alpha = aVal;
		border_mcl._alpha = aVal;
		border_mcr._alpha = aVal;
	}
	
	function onEnterFrame()
	{
		SyncZoomItem(false);
	}
	
	function playSound()
	{
		//overrided in subclass
	}
	
	function stopSound()
	{
		//overrided in subclass
	}

}
