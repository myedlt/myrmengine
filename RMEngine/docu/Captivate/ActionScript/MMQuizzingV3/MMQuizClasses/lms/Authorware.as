//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMQuizClasses.lms.TrackingAdapter;

class MMQuizzingV3.MMQuizClasses.lms.Authorware extends TrackingAdapter
{

	private var delimiter_str:String = ";";

	//*********************************************
	// Constructor Function

	function Authorware(_adapterObject:Object, delimiter:String)
	{
		if(_adapterObject != undefined)
		{
			setObjectReference(_adapterObject);
		}
		if(delimiter != undefined)
		{
			setDelimiter(delimiter);
		}
		// Start the global "timer" to track how long the user has been in this file.
		resetTimer();

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
			setInitialized(true)
			fscommand("#Initialize:1");
		}
		return isInitialized();
	}



	function flush():Void {sendTrackingData();}
	function finish():Void
	{
		if(isInitialized())
		{
			sendExitData();
		}
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
			if(interactionID_str != undefined)
			{
				setInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str);
			}
			// Build interaction_data string
			var interaction_data = "";
			var interaction_data = ""
			for(var interactionItem in interaction_ary)
			{
			interaction_data = 	"#Date:" + "\"" + interaction_ary[interactionItem]["date_str"] + "\"" + delimiter_str +
								"#Time:" + "\"" + interaction_ary[interactionItem]["time_str"] + "\"" + delimiter_str +
								"#interaction_ID:" + "\"" + interaction_ary[interactionItem]["interactionID_str"] + "\"" + delimiter_str +
								"#objective_ID:" + "\"" + interaction_ary[interactionItem]["objectiveID_str"] + "\"" + delimiter_str +
								"#interaction_type:" + "\"" + interaction_ary[interactionItem]["type_str"] +"\"" + delimiter_str +
								"#correct_response:" + "\"" + interaction_ary[interactionItem]["correctResponse_str"] +"\"" + delimiter_str +
								"#student_response:" + "\"" + interaction_ary[interactionItem]["studentResponse_str"] +"\"" + delimiter_str +
								"#result:" + "\"" + interaction_ary[interactionItem]["result_str"] +"\"" + delimiter_str +
								"#weighting:" + "\"" + interaction_ary[interactionItem]["weight_int"] +"\"" + delimiter_str +
								"#latency:" + "\"" + interaction_ary[interactionItem]["latency_str"] + "\"" + delimiter_str;
			}

			// Send Post to Authorware
			fscommand(interaction_data);
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

		if(_time_str != undefined)
		{
			setTimeInSession(_time_str);
		}
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
		var temp_str:String = "";

		if(isInitialized())
		{

			if(_time_str == undefined)
			{
				_time_str = "";
			}
			setTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _resumeData_str);

			// Format lesson_Data
			// Nothing to format

			// Build aicc_data string
			var authorwareData_str = "";
			if(_statusPreference_bln != undefined)
			{
				if(_statusPreference_bln == true)
				{
					// Completion status
					temp_str = getLessonStatus();
				} else {
					if(getSuccessStatus() != undefined)
					{
						temp_str = getSuccessStatus();
					} else {
						temp_str = getLessonStatus();
					}
				}
			} else {
				temp_str = getLessonStatus();
			}
			authorwareData_str += (temp_str != undefined?"#Passed:" + isPassed("passed,completed", temp_str) + delimiter_str :"");
			authorwareData_str += "#Score:" + getScoreRaw() + delimiter_str;
			authorwareData_str += "#Possible:" + getScoreMax() + delimiter_str;

			// Send Post to Server
			fscommand(authorwareData_str)

			// Reset the timer variable
			resetTimer();
		}
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
		// Call AICC ExitAU command
		fscommand("#Initialize:0");
		setInitialized(false);
	}

	function setTrackingComplete():Void
	{
		fscommand("#Initialize:0");
		setInitialized(false);
	}


	function setDelimiter(delimiter:String):Void
	{
		delimiter_str = delimiter;
	}

	function getDelimiter():String
	{
		return delimiter_str;
	}


}