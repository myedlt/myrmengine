//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMQuizClasses.lms.TrackingAdapter;

class MMQuizzingV3.MMQuizClasses.lms.QuestionMark extends TrackingAdapter
{

	var startTime = getTimer();

	//*********************************************
	// Constructor Function

	function QuestionMark(_adapterObject)
	{
		if(_adapterObject != undefined)
		{
			setObjectReference(_adapterObject);
		}
		// Start the global "timer" to track how long the user has been in this file.
		resetTimer();

		//startDev();
	}



	// *************************************************************************
	// *                                                                       *
	// *     Method:           startDev                                        *
	// *     Description:      Only used to set default values for testing     *
	// *     Returns:                                                          *
	// *                                                                       *
	// *************************************************************************
	function startDev ()
	{
		initialized_bln = true;

	}



	// *************************************************************************
	// *                                                                       *
	// *     Method:          Initialize                                       *
	// *     Description:                                                      *
	// *     Returns:         Boolean                                          *
	// *                                                                       *
	// *************************************************************************
	function initialize():Boolean
	{
		if(isInitialized())
		{
			// do nothing - already initialized;
		} else {
			setInitialized(true);
			fscommand("CMIInitialize");
		}
		return isInitialized();
	}



	function flush():Void {sendTrackingData();}
	function finish():Void
	{
		sendTrackingData();
		sendExitData();
	}

	function setInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str):Void
	{
		var temp_int = interaction_ary.length;
		interaction_ary[temp_int] = new Array();
		interaction_ary[temp_int]["interactionID_str"] = interactionID_str;
		interaction_ary[temp_int]["objectiveID_str"] = objectiveID_str;
		interaction_ary[temp_int]["type_str"] = type_str;
		interaction_ary[temp_int]["correctResponse_str"] = escapeJS(correctResponse_str);
		interaction_ary[temp_int]["studentResponse_str"] = escapeJS(studentResponse_str);
		interaction_ary[temp_int]["result_str"] = result_str;
		interaction_ary[temp_int]["weight_int"] = weight_int;
		interaction_ary[temp_int]["latency_str"] = latency_str;
		if(date_str == undefined || date_str == "")
		{
			//date_str = date()
			date_str = formatDate();
		}
		interaction_ary[temp_int]["date_str"] = date_str;
		//BP change latency to old format
		//interaction_ary[temp_int]["latency_str"] = latency_str;
		var newLatency_str = formatTime(latency_str);
		interaction_ary[temp_int]["latency_str"] = newLatency_str;
		if(time_str == undefined || time_str == "")
		{
			time_str = "00:00:00";
		} else {
			time_str = formatTime(time_str);
		}
		interaction_ary[temp_int]["time_str"] = time_str;
	}


	function sendInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str):Void
	{
		if(isInteractionDataTracked() && isInitialized())
		{
			if(interactionID_str != undefined && interactionID_str != "")
			{
				setInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str);
			}
			// Build interaction_data string
			var interaction_data = "";
			var interaction_data = ""
			for(var interactionItem in interaction_ary)
			{
			interaction_data = 	interaction_ary[interactionItem]["date_str"] + ";"+
			        			interaction_ary[interactionItem]["time_str"] + ";"+
			        			interaction_ary[interactionItem]["interactionID_str"] + ";"+
			       				interaction_ary[interactionItem]["objectiveID_str"] +";"+
			      				interaction_ary[interactionItem]["type_str"] +";"+
			        			interaction_ary[interactionItem]["correctResponse_str"] +";"+
			        			interaction_ary[interactionItem]["studentResponse_str"] +";"+
			        			interaction_ary[interactionItem]["result_str"] +";"+
			        			interaction_ary[interactionItem]["weight_int"] +";"+
			        			interaction_ary[interactionItem]["latency_str"] + ";";
			}

			// Send Post to Authorware
			fscommand("MM_cmiSendInteractionInfo", interaction_data);
			// Clear Interaction Array
			interaction_ary = [];
		}
	}



	// ******************************************************************
	// *
	// *     Method:           getTrackingData
	// *      Type:               Global
	// *     Description:      Properly formats a getParam POST to send
	// *                         to an AICC-Compliant LMS.
	// *      Parameters:      None
	// *     Returns:          Nothing
	// *
	// ******************************************************************
	function getTrackingData():Void
	{
		// Check to see if the data has already been loaded...
		if(!isTrackingDataLoaded() && isInitialized())
		{
			// Call AICC GetParam function
			//BP called in initialize() too			fscommand("CMIInitialize");
			setTrackingDataLoaded(true);
		}
	}


	// ******************************************************************
	// *
	// *     Method:           getTrackingDataCore
	// *     Type:             Global
	// *     Description:      Parallel function to SCORM (and other
	// *					  adapters).  Since AICC standard is a single
	// *					  post, we'll *always* return all data
	// *     Parameters:       None
	// *     Returns:          Nothing
	// *
	// ******************************************************************
	function getTrackingDataCore():Void
	{
		if(isInitialized())
		{
			getTrackingData();
		}
	}


	// ******************************************************************
	// *
	// *    Method:         setTrackingData
	// *    Type:           Global
	// *    Description:    Requests data from the LMS, through JS
	// *    Date:           02/25/03
	// *    Modified By:    Andrew Chemey
	// *    Parameters:     None
	// *    Returns:        Nothing
	// *
	// ******************************************************************
	function setTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _resumeData_str):Void
	{
		// call each of the set functions
		if(_scoreAsPercent_bln==true)
		{
			// Set score as a percent
			if(_scoreRaw_int != undefined && _scoreMax_int != undefined && !isNaN(Math.round((_scoreRaw_int/_scoreMax_int)*100)) && _scoreMax_int != 0)
			{
				// based on raw and max
				setScore(Math.round((_scoreRaw_int/_scoreMax_int)*100));
			} else {
				// based on raw score
				setScore(Math.round(_scoreRaw_int));
			}
		} else {
			if(_scoreRaw_int != undefined && _scoreMin_int != undefined && _scoreMax_int != undefined)
			{
				setScore(_scoreRaw_int, _scoreMin_int, _scoreMax_int);
			} else if(_scoreRaw_int != undefined && _scoreMax_int != undefined) {
				setScore(_scoreRaw_int, 0, _scoreMax_int);
			} else if(_scoreRaw_int != undefined) {
				setScore(_scoreRaw_int);
			}
		}
		if(_location_str != undefined)
		{
			setLessonLocation(_location_str);
		}
		if(_statusPreference_bln != undefined)
		{
			// Preference set for what type of status to store/send
			if(_statusPreference_bln == true && _statusCompletion_str != undefined)
			{
				// send Completion Status
				setLessonStatus(_statusCompletion_str);
			} else if(_statusSuccess_str != undefined) {
				// send Success status
				if(_statusCompletion_str != undefined)
				{
					setLessonStatus(_statusCompletion_str, _statusSuccess_str);
				}
			}
		} else {
			// No preference
			if(_statusCompletion_str != undefined)
			{
				setLessonStatus(_statusCompletion_str);
			} else if(_statusSuccess_str != undefined) {
				setLessonStatus(_statusSuccess_str);
			}
		}
		// Set Status to default (incomplete, if set to "not started")
		setLessonStatus(getLessonStatus());

		setTimeInSession(_time_str);

		if(_resumeData_str != undefined)
		{
			setLessonData(_resumeData_str);
		}
	}


	function isPassed(list_str, token_str)
	{
		var a = list_str.split(",");
		var c = token_str.substr(0,1).toLowerCase();
		for (var i=0;i<a.length;i++)
		{
			if (c == trim(a[i]).substr(0,1)) return true;
		}
		return false;
	}


	// ******************************************************************
	// *
	// *     Method:           sendTrackingData
	// *     Type:             Global
	// *     Description:      Properly formats data and sends to a
	// *                       SCORM-Compliant LMS.
	// *     Parameters:       None
	// *     Returns:          Nothing
	// *
	// ******************************************************************
	function sendTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _resumeData_str):Void
	{

		if(isInitialized())
		{
			if(_statusPreference_bln || _statusPreference_bln == undefined)
			{
				setStatusType(1);
			} else {
				setStatusType(2);
			}
			setTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _resumeData_str);



			// Reset the timer variable
			//resetTimer();
		}
	}




	function doExit()
	{
		// Format lesson_Data
		fscommand("CMISetSessionTime", (getTimer() - startTime()));
		if(getStatusType() == 1)
		{
			if(isPassed("passed,completed,1", getLessonStatus()))
			{
				fscommand("CMISetPassed");
			} else {
				fscommand("CMISetFailed");
			}
		} else {
			if(isPassed("passed,completed,1", getLessonStatus()))
			{
				fscommand("CMISetCompleted");
			} else {
				// don't do anything at this time
			}

		}
		fscommand("CMISetScore", getScoreRaw());
		fscommand("CMIExitAU");
	}

// ******************************************************************
// *
// *     Method:           sendExitData
// *     Type:             Global
// *     Description:      Properly formats an ExitAU POST to send
// *                       to an AICC-Compliant LMS.
// *     Parameters:       None
// *     Returns:          Nothing
// *
// ******************************************************************
function sendExitData():Void
	{
		if(isInitialized())
		{
			// Call AICC ExitAU command
			doExit();
			setInitialized(false);
		}

	}

	function setTrackingComplete():Void
	{
		if(isInitialized())
		{
			doExit();
			setInitialized(false);
		}
	}


	// ******************************************************************
	// *
	// *     Method:           formatDate
	// *     Description:      Formats seconds or "MM/DD/YYYY" to "MM/DD/YYYY"
	// *     Returns:          String (date formatted as MM/DD/YYYY)
	// *
	// ******************************************************************
	function formatDate(date_var, day_str, year_str):String
	{
		var month_str, formattedDate_str

		if (date_var == undefined) {
			// Create date based on today's date
			var date_obj = new Date();
			month_str = formatNum((date_obj.getMonth()+1), 2);
			day_str  = formatNum((date_obj.getDate()), 2);
			year_str = (date_obj.getFullYear());
		} else if(typeof(date_var) == "string" && date_var.indexOf("/") > -1) {
			// Convert from MM/DD/YYYY - this doesn't make sense for most cases, but
			var date_obj = date_var.split("/");
			month_str = formatNum(date_obj[0], 2);
			day_str  = formatNum(date_obj[1], 2);
			year_str = formatNum(date_obj[2], 4);
		}
		formattedDate_str = (year_str + "/" + month_str + "/" + day_str);
		return formattedDate_str;
	}



}