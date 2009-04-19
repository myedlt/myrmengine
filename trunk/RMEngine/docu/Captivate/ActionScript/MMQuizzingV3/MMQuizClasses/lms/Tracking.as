//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMQuizClasses.lms.AICC;
import MMQuizzingV3.MMQuizClasses.lms.Breeze;
import MMQuizzingV3.MMQuizClasses.lms.Response;
import MMQuizzingV3.MMQuizClasses.lms.SCORM_1_2;
import MMQuizzingV3.MMQuizClasses.lms.SCORM_1_3;
import MMQuizzingV3.MMQuizClasses.lms.Utilities;
import MMQuizzingV3.MMQuizClasses.lms.TrackingAdapter;
import MMQuizzingV3.MMQuizClasses.lms.EMail;

class MMQuizzingV3.MMQuizClasses.lms.Tracking
{
	// do something
	private var MMtrackingAdapter_mc;
	private var response:Response = null;
	private var trackingType_str:String = "";

	function Tracking()
	{
		// Constructor function (does nothing, at this time)
	}

	// adapted and hacked from DepthManager (srj)
	private static function buildDepthTable(p_mc:MovieClip):Array
	{
		var depthTable:Array = new Array();
		var j:String;
		for (j in p_mc)
		{
			var i = p_mc[j];
			var t:String = typeof(i);
			if (t == "movieclip" || (t == "object" && i.__getTextFormat != undefined))
			{
				if (i._parent == p_mc)
				{
					depthTable[i.getDepth()] = i;
				}
			}
		}
		return depthTable;
	}

	// adapted and hacked from DepthManager (srj)
	private static function findNextAvailableDepth(p_depthTable:Array):Number
	{
		if (p_depthTable[0] == undefined)
			return 0;

		var nextFreeAbove:Number = 0;
		while(p_depthTable[nextFreeAbove] != undefined) {
			++nextFreeAbove;
		}
		return nextFreeAbove;
	}

	public static function loadExternalTrackingAdapter(parentReference:MovieClip, adapterName:String)
	{
		var dt:Array = buildDepthTable(parentReference);
		var depth:Number = findNextAvailableDepth(dt);
		//trace("in Tracking.loadExternalTrackingAdapter, parentReference = "+parentReference+", adapterName = "+adapterName+", depth = "+depth);
		parentReference._mmTrackingSWF = parentReference.createEmptyMovieClip("m_tracking", depth);
		parentReference._mmTrackingSWF.loadMovie(adapterName);
	}

	function createTrackingAdapter(adapterType:String,
									adapterDelimiter:String,
									adapterEMail:String,
									adapterReference:MovieClip,
									externalReference:Object,
									escapeURLvs:Boolean,
									ignoreEscape:String,
									sendLessonData:Boolean):Boolean
	{
		if(currentTrackingAdapter())
		{
			return true;
		}

		// Look for external Tracking SWF
		MMtrackingAdapter_mc = externalReference;
		//trace("in Tracking.createTrackingAdapter, externalReference = "+externalReference);
		if ((MMtrackingAdapter_mc == undefined) || (MMtrackingAdapter_mc == null) || (MMtrackingAdapter_mc.isReady == undefined)) {
			// No external adapter - let's create an internal one
			//trace("in Tracking.createTrackingAdapter, no external adapter found, creating an internal one");
			if(adapterReference === undefined || adapterReference === null)
			{
				// cannot continue!
				return false;
			}
			// it is very important that we find an available depth to create this
			// in, rather than hardcoding a depth. (Note: can use getNextAvailableDepth(),
			// as that requires SWF7, so we do it the hard way.)
			var dt:Array = buildDepthTable(adapterReference);
			var depth:Number = findNextAvailableDepth(dt);
			MMtrackingAdapter_mc = adapterReference.createEmptyMovieClip("MMtracking_mc", depth);
			createInternalAdapter(adapterType, adapterDelimiter, adapterEMail, MMtrackingAdapter_mc, escapeURLvs, ignoreEscape, sendLessonData);
		} else {
			//trace("calling createExternalAdapter");
			MMtrackingAdapter_mc.createExternalAdapter(this, adapterType, adapterDelimiter, adapterEMail, adapterReference, escapeURLvs, ignoreEscape, sendLessonData)
		}
		if (currentTrackingAdapter()) {
			return true;
		} else {
			return false;
		}
	}

	function createInternalAdapter(adapterType_str:String, adapterDelimiter_str:String, adapterEMail_str:String, adapterReference_obj:Object, escapeURLvs_bln:Boolean, ignoreEscape_str:String, sendLessonData_bln:Boolean)
	{
		// _root.debl("AEC: starting createInteranalAdapter: " + adapterReference_obj);
		var urlUtility:Utilities = new Utilities(adapterReference_obj);
		var adapterType_ary = new Array();
		response = new Response(adapterReference_obj);

		if(adapterType_str == undefined || adapterType_str == "")
		{
			adapterType_ary = ["BREEZE", "AICC", "SCORM_1_3", "SCORM_1_2"];
		} else {
			if(adapterType_str.toUpperCase() == "SCORM")
			{
				// *always* look for BREEZE adapter.
				// SCORM is generic, so we need to know what version of SCORM (1.3 = SCORM 2004; 1.2 = SCORM 1.2)
				adapterType_ary = ["BREEZE", "SCORM_1_3", "SCORM_1_2", "AICC"];
			} else {
				// *always* look for BREEZE adapter
				adapterType_ary = ["BREEZE", adapterType_str.toUpperCase(), "AICC", "SCORM_1_3", "SCORM_1_2"];
			}
		}

		var counter_int = 0;

		while(MMtrackingAdapter_mc.MMtracking == null && counter_int < adapterType_ary.length)
		{
			trackingType_str = adapterType_ary[counter_int];
			switch(trackingType_str)
			{
				/*case "AUTHORWARE":
					MMtrackingAdapter_mc.MMtracking = new Authorware(adapterReference_obj, adapterDelimiter_str);
					MMtrackingAdapter_mc.MMtracking.initialize();
					MMtrackingAdapter_mc.MMtracking.getTrackingData();
					break;
				case "QUESTIONMARK":
					MMtrackingAdapter_mc.MMtracking = new QuestionMark(adapterReference_obj);
					MMtrackingAdapter_mc.MMtracking.initialize();
					MMtrackingAdapter_mc.MMtracking.getTrackingData();
					break;
				*/
				case "EMAIL":
					MMtrackingAdapter_mc.MMtracking = new EMail(adapterReference_obj, adapterEMail_str);
					MMtrackingAdapter_mc.MMtracking.initialize();
					MMtrackingAdapter_mc.MMtracking.getTrackingData();
					break;
				
				case "BREEZE":
					var temp_obj = urlUtility.findParameter("airspeed");
					if(temp_obj != undefined)
					{
						// _root.debl('AEC: creating BREEZE adapter');
						MMtrackingAdapter_mc.MMtracking = new Breeze(adapterReference_obj, temp_obj._url);
						MMtrackingAdapter_mc.MMtracking.initialize();
						// We'll get the tracking data - though it isn't necessary at this point
						MMtrackingAdapter_mc.MMtracking.getTrackingData();
					}
					break;
				case "AICC":
					var temp_obj = urlUtility.findParameter("aicc_url");
					if(temp_obj != undefined)
					{
						// _root.debl("AEC: AICC");
						MMtrackingAdapter_mc.MMtracking = new AICC(adapterReference_obj, temp_obj._url, escapeURLvs_bln, ignoreEscape_str, sendLessonData_bln);
						MMtrackingAdapter_mc.MMtracking.initialize();
						// We'll get the tracking data - though it isn't necessary at this point
						MMtrackingAdapter_mc.MMtracking.getTrackingData();
					}
					break;
				case "SCORM_1_3":
					var temp_obj = urlUtility.findParameter("scorm_api");
					if(temp_obj != undefined && urlUtility.getParameter("scorm_api", temp_obj._url) > "0.2")
					{
						// found SCORM 2004 API
						MMtrackingAdapter_mc.MMtracking = new SCORM_1_3(adapterReference_obj, urlUtility.getParameter("scorm_type", temp_obj._url), sendLessonData_bln);
						MMtrackingAdapter_mc.MMtracking.initialize();
					}
					break;
				case "SCORM_1_2":
					var temp_obj = urlUtility.findParameter("scorm_api");
					if(temp_obj != undefined && urlUtility.getParameter("scorm_api", temp_obj._url) == "0.2")
					{
						// found SCORM 1.2 API
						MMtrackingAdapter_mc.MMtracking = new SCORM_1_2(adapterReference_obj, urlUtility.getParameter("scorm_type", temp_obj._url), sendLessonData_bln);
						MMtrackingAdapter_mc.MMtracking.initialize();
						// _root.debl("AEC: at end of SCORM_1_2");
					}
					break;
			}
			counter_int++;
		}
		if(MMtrackingAdapter_mc.MMtracking != null)
		{
			MMtrackingAdapter_mc.MMtracking.setTrackingAdapterType(0, trackingType_str);
		} else {
			//trace("in createInternalAdapter, could not create adapter, preferred adapterType = "+adapterType_str);
			if(adapterType_str == undefined || adapterType_str == "")
			{
				MMtrackingAdapter_mc.MMtracking = new TrackingAdapter(adapterReference_obj);
				MMtrackingAdapter_mc.MMtracking.setLessonDataTracked(sendLessonData_bln);
				MMtrackingAdapter_mc.MMtracking.setEscapeAICCvs(escapeURLvs_bln);
				MMtrackingAdapter_mc.MMtracking.setIgnoreEscapeList(ignoreEscape_str);
				MMtrackingAdapter_mc.MMtracking.initialize();
				MMtrackingAdapter_mc.MMtracking.setTrackingAdapterType(0, "TrackingAdapter");
			}
		}
	}

	function currentTrackingAdapter():TrackingAdapter
	{
		return MMtrackingAdapter_mc.MMtracking;
	}

}

