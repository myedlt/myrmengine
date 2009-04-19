//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

class MMQuizzingV3.MMQuizClasses.lms.Breeze extends MMQuizzingV3.MMQuizClasses.lms.AICC
{
	// Interaction properties
	private var slideView_ary:Array = [];

	//*********************************************
	// Constructor Function

	function Breeze(_adapterObject, launchURL)
	{
		// Nothing new
		if(_adapterObject != undefined)
		{
			setObjectReference(_adapterObject);
		}

		// Check to see if the constructor was passed the AICC SID and AICC URL parameters
		if(launchURL != undefined)
		{
			setURL(launchURL);
		}
	}

	// ******************************************************************
	// *
	// *     Method:           sendExitData
	// *     Type:             Global
	// *     Description:      Overrides the AICC.as version of sendExitData
	// *                       so it doesn't call getURL - since HTML/JS
	// *					   won't exist in Breeze
	// *     Parameters:       None
	// *     Returns:          Nothing
	// *
	// ******************************************************************
	function sendExitData():Void
	{
		if(isInitialized())
		{
			// Call AICC ExitAU command
			AICCbuild("exitAU", "");
		}
	}

	// ******************************************************************
	// *
	// *     Method:           setInitialized
	// *     Type:             Global
	// *     Description:      Overrides the AICC.as version of setInitialized
	// *                       so it doesn't call getURL - since HTML/JS
	// *					   won't exist in Breeze
	// *     Parameters:       Boolean which indicates whether to
	// * 					   set as initialized or set as NOT initialized
	// *     Returns:          Nothing
	// *
	// ******************************************************************
	function setInitialized(value_bln:Boolean):Void
	{
		initialized_bln = value_bln;
	}


	function setSlideView(slideNumber_int):Void
	{
		var temp_int = slideView_ary.length;
		slideView_ary[temp_int] = new Array();
		slideView_ary[temp_int]["interactionID_str"] = "breeze-slide-" + slideNumber_int;
		slideView_ary[temp_int]["objectiveID_str"] = "0";
		slideView_ary[temp_int]["type_str"] = "slide-view";
		slideView_ary[temp_int]["correctResponse_str"] = slideNumber_int;
		slideView_ary[temp_int]["studentResponse_str"] = slideNumber_int;
		slideView_ary[temp_int]["result_str"] = "correct";
		slideView_ary[temp_int]["weight_int"] = 1;
		slideView_ary[temp_int]["latency_str"] = "00:00:00";
		slideView_ary[temp_int]["date_str"] = formatDate();
		slideView_ary[temp_int]["time_str"] = "00:00:00";
	}


	function sendSlideView(slideNumber_int):Void
	{
		if(isInitialized())
		{
			if(slideNumber_int != undefined && slideNumber_int != "")
			{
				setSlideView(slideNumber_int);
			}
			// Build interaction_data string
			var slideViewData_str = "";
			slideViewData_str = 	"\"course_id\"," +
								"\"student_id\"," +
								"\"date\"," +
								"\"time\"," +
								"\"interaction_id\"," +
								"\"objective_id\"," +
								"\"type_interaction\"," +
								"\"correct_response\"," +
								"\"student_response\"," +
								"\"result\"," +
								"\"weighting\"," +
								"\"latency\"" + return_str;
			for(var slideViewItem_int in slideView_ary)
			{
				slideViewData_str = slideViewData_str +
								"\"0\"," +
								"\"0\"," +
								"\"" + slideView_ary[slideViewItem_int]["date_str"] + "\","+
								"\"" + slideView_ary[slideViewItem_int]["time_str"] + "\","+
								"\"" + slideView_ary[slideViewItem_int]["interactionID_str"] + "\","+
								"\"" + slideView_ary[slideViewItem_int]["objectiveID_str"] +"\","+
								"\"" + slideView_ary[slideViewItem_int]["type_str"] +"\","+
								"\"" + slideView_ary[slideViewItem_int]["correctResponse_str"] +"\","+
								"\"" + slideView_ary[slideViewItem_int]["studentResponse_str"] +"\","+
								"\"" + slideView_ary[slideViewItem_int]["result_str"] +"\","+
								"\"" + slideView_ary[slideViewItem_int]["weight_int"] +"\","+
								"\"" + slideView_ary[slideViewItem_int]["latency_str"] + "\"" + return_str;
			}

			// Send Post to Server
			AICCbuild("putInteractions", slideViewData_str);
			// Clear Interaction Array
			slideView_ary = [];
		}
	}
}