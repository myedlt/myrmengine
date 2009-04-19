//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMQuizClasses.lms.Response;
import MMQuizzingV3.MMQuizClasses.lms.TrackingAdapter;

class MMQuizzingV3.MMQuizClasses.lms.SCORM_1_3 extends TrackingAdapter
{
    // *************************************************
    // Private Properties

    // SCORM-specific Public properties
    private var version:String = "1.2";
    private var callToJS_array:Array = [];          // Array - contains a list of all javascript calls;
    private var comments_from_lms:String;           // String; Comments from LMS properties
    private var counterInterval;
    private var core_children:String;
    private var core_score_children:String;
    private var interactions_children:String;
    private var interactions_count;
    private var LMSLastError:Object;
    private var LMSLastError_int:Number;
    private var LMSLastError_str:String;
    private var LMSLastErrorCmd_str:String;
    private var waitForData_var = undefined;
    private var waitForData_int:Number = 30			// Number of seconds to wait for LMS to return all data

	var scorm_lc;							// Local Connection object for 2-way non-IE browsers/OS
    var trackingResponse : Response;

	var objAPI_str = "";					// Type of SCORM Communication (fscommand - no clicks; getURL - clicks)
	var objAPI_obj;							// Reference to THIS movie clip
	var tempVar;							// Used for SCORMbuild - when no variable is requested to be updated

    function SCORM_1_3 (_adapterObject:Object, typeEnvironment_int, sendLessonData_bln:Boolean)
    {
		if (sendLessonData_bln != undefined)
		{
			setLessonDataTracked(sendLessonData_bln);
		}
		if(_adapterObject != undefined)
		{
			setObjectReference(_adapterObject);
		}
        init();                                     // Start initialization routine
        // initialize Global properties
        LMSLastError = new Object();
        trackingResponse = new Response();
        if(typeEnvironment_int != undefined && typeEnvironment_int == 0)
        {
			objAPI_str = _adapterObject + ".";
			objAPI_obj = _adapterObject;
		} else {
			var thisObj_obj = this;
			scorm_lc = new LocalConnection();
			scorm_lc.connect("lc_name");
			scorm_lc.methodToExecute = function (result_str) {
				var param_array = result_str.split('|');
				var variableName = unescape(param_array[0]);
				var result = unescape(param_array[1]);
				thisObj_obj[variableName] = result;
				//set(variableName, result);
				for(var counter_int = 0; counter_int < thisObj_obj.callToJS_array.length; counter_int++){
					if (thisObj_obj.callToJS_array[counter_int] == variableName){
						thisObj_obj.callToJS_array.splice(counter_int, 1);
						break;
					}
				}
				if(variableName == "LMSLastError_str")
				{
					thisObj_obj.addToErrorArray(thisObj_obj.LMSLastError_int, thisObj_obj.LMSLastError_str, thisObj_obj.LMSLastErrorCmd_str);
				}
				thisObj_obj.lmsQueue.removeFromQueue();
			};
		}
    }


    // ******************************************************************
    // *
    // *    Method:         init
    // *    Description:
    // *    Date:           03/03/03
    // *    Written by:     Andrew Chemey
    // *    Returns:
    // *
    // ******************************************************************
    function init()
    {
        // Start the global "timer" to track how long the user has been in this file.
        timer_int = int(getTimer()/1000);

        // Initialize LMS
        //initialize();
    }



    // ******************************************************************
    // *
    // *    Method:         initialize
    // *    Type:           Global
    // *    Description:    Attempts to initialize with an LMS
    // *    Date:           02/25/03
    // *    Modified By:    Andrew Chemey
    // *    Parameters:
    // *    Returns:
    // *
    // ******************************************************************
    function initialize()
    {
		if(!isInitialized())
		{
	        // Call JavaScript function (data_str) and return result (variable_str)
	        SCORMbuild("Initialize","","", objAPI_str + "initialized_bln");
		}
    }




    // ******************************************************************
    // *
    // *    Method:         getTrackingData
    // *    Type:           Global
    // *    Description:    Requests data from the LMS, through JS
    // *    Date:           02/25/03
    // *    Modified By:    Andrew Chemey
    // *    Parameters:     None
    // *    Returns:        Nothing
    // *
    // ******************************************************************
    function getTrackingData()
    {
        // Call JavaScript function (data_str) and return result (variable_str)
        //if (initialized_bln && !isTrackingDataLoaded())
        if(!isTrackingDataLoaded())
        {
			getTrackingDataCore()
			SCORMbuild("GetValue", "cmi.launch_data", "", objAPI_str + "vendor_data");
			SCORMbuild("GetValue", "cmi.objectives._count", "", objAPI_str + "objectives_count");
			if(waitForData_var == undefined)
			{
				waitForData_var = setInterval(waitForData, 100, this, getTimer() + (waitForData_int * 1000));
			}
		}
    }

    function waitForData(this_obj)
    {
		// Not the best implementation, but this function looks to see if the callToJS_array is empty - which means there aren't any
		// current, open requests to the LMS.  This can be broken, if a request never returns OR if a developer constantly keeps
		// pinging the LMS with requests (even send requests).
		if(this_obj.callToJS_array.length == 0 || (timer_int != undefined && getTimer() > timer_int))
		{
			clearInterval(this_obj.waitForData_var);
			this_obj.waitForData_var = undefined;
			this_obj.setTrackingDataLoaded(true);
		}
	}


	function getTrackingDataCore()
	{
		SCORMbuild("GetValue", "cmi.location", "", objAPI_str + "lesson_location");
		//SCORMbuild("GetValue", "cmi.success_status", "", objAPI_str + "lesson_status");
		SCORMbuild("GetValue", "cmi.score._children", "", objAPI_str + "core_score_children", "getTrackingDataScoreValues");
		if(objAPI_str == "")
		{
			trackingResponse.waitForResponse("core_score_children", undefined, this, "getTrackingDataString", "cmi.score.", "core_score_children", "score_");
		}
		SCORMbuild("GetValue", "cmi.suspend_data", "", objAPI_str + "lesson_data");
		SCORMbuild("GetValue", "cmi.interactions._children", "", objAPI_str + "interactions_children");
		SCORMbuild("GetValue", "cmi.interactions._count", "", objAPI_str + "interactions_count");
		if(waitForData_var == undefined)
		{
			waitForData_var = setInterval(waitForData, 100, this, getTimer() + (waitForData_int * 1000));
		}
	}

	function getTrackingDataString(data_str, value_str, additionalValue_var)
	{
		value_str = this[value_str];
		var value_ary = value_str.split(",");
		for(var item_str in value_ary)
		{
			var temp_str = trim(value_ary[item_str]);
			if(temp_str != "")
			{
				if(additionalValue_var == undefined)
				{
					SCORMbuild("GetValue", data_str + temp_str, "", objAPI_str + temp_str );
				} else {
					SCORMbuild("GetValue", data_str + temp_str, "", objAPI_str + additionalValue_var + temp_str);
				}
			}
		}
	}

	function getTrackingDataScoreValues(value_str)
	{
		if(value_str != undefined && value_str.indexOf(",") == -1)
		{
			// assumes value_str is a list of support score data fields from SCORM-compliant LMS
			value_str = this[value_str];
		}
		var temp_ary = value_str.split(",");
		for(var item_str in temp_ary)
		{
			var temp_str = trim(temp_ary[item_str]);
			SCORMbuild("GetValue", "cmi.score." + temp_str, "", objAPI_str + "score_" + temp_str);
		}
	}

	function getTrackingDataObjectives(value_str)
	{
		// complete this function!!!!!!!!!
		var value_int = this[value_str]
		for(var temp_int=0;temp_int<=value_int;temp_int++);
		{
			SCORMbuild("GetValue", "");
		}
	}

	function getTrackingDataError(command_str)
	{
		LMSLastError_int = undefined;
		LMSLastError.error = undefined;
		LMSLastError_str = undefined;
		LMSLastErrorCmd_str = command_str;
		SCORMbuild("GetLastError", "", "", objAPI_str + "LMSLastError_int");
		SCORMbuild("GetErrorString", "LMSLastError_int", "", objAPI_str + "LMSLastError_str");
		//trackingResponse.waitForResponse("LMSLastError_int", undefined, this, "getTrackingDataErrorString");
	}

	function setTrackingDataString(dataModel_str, dataValue_str, additionalValue_var)
	{
		var value_str = "";
		dataValue_str = dataValue_str.split(",");
		for(var item_str in dataValue_str)
		{
			if(additionalValue_var == undefined)
			{
				value_str = this[dataValue_str[item_str]];
			} else {
				value_str = this[additionalValue_var + dataValue_str[item_str]];
			}
			if (value_str != undefined && value_str != "")
			{
				SCORMbuild("SetValue", dataModel_str + dataValue_str[item_str], value_str, "");
			}
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
	function setTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _suspendData_str):Void
	{
		// call each of the set functions
		if(_scoreAsPercent_bln==true)
		{
			// Set score as a percent
			if(_scoreRaw_int != undefined && _scoreMax_int != undefined && !isNaN(Math.round((_scoreRaw_int/_scoreMax_int)*100)) && _scoreMax_int != 0)
			{
				// based on raw and max
				setScore(Math.round((_scoreRaw_int/_scoreMax_int)*100), 0, 100);
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
			} else {
				setScore();
			}
		}
		if(_location_str != undefined)
		{
			setLessonLocation(_location_str);
		}
		// *Always send both lesson status and success status - since SCORM 2004 supports them both
		setLessonStatus(_statusCompletion_str, _statusSuccess_str);

		setTimeInSession(_time_str);

		if(_suspendData_str != undefined)
		{
			setLessonData(_suspendData_str);
		}
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
	function sendTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _suspendData_str):Void
	{
		var tempSuccess_str:String = "";
		var tempCompletion_str:String = "";

		setTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _suspendData_str);
		setTrackingDataString("cmi.score.", core_score_children, "score_")

		if(getSuccessStatus() != undefined)
		{
			SCORMbuild("SetValue", "cmi.success_status", getSuccessStatus(), "");
		}
		SCORMbuild("SetValue", "cmi.completion_status", getLessonStatus(), "");
		SCORMbuild("SetValue", "cmi.location", getLessonLocation(), "");
		SCORMbuild("SetValue", "cmi.session_time", getTimeInSession(), "");
		if(getLessonData() != "")
		{
			SCORMbuild("SetValue", "cmi.suspend_data", escape(getLessonData()), "");
		}

		// Don't reset the timer variable, since SCORM reports accumulated time on the last TrackingData request
		// resetTimer();
	}


	function flush()
	{
		SCORMbuild("Commit", "", "", "");
	}

	function set finished_bln(value_bln)
	{
		if(value_bln.toLowerCase() == "true")
		{
			value_bln = true;
		} else if(value_bln.toLowerCase() == "false") {
			value_bln = false;
		}
		initialized_bln = !value_bln;
	}

	function finish()
	{
		SCORMbuild("Commit", "", "", "");
		SCORMbuild("Terminate", "", "", objAPI_str + "finished_bln");
	}

	function setTrackingComplete()
	{
		finish();
	}

	function AICCTokenToSCORMToken(list_str,token_str)
	{
		var a = list_str.split(",");
		var c = token_str.substr(0,1).toLowerCase();
		for (var i=0;i<a.length;i++)
		{
			if (c == a[i].substr(0,1)) return a[i]
		}
		return token_str;
	}

	function normalizeStatus(status_str)
	{
		return AICCTokenToSCORMToken("completed,incomplete,not attempted,failed,passed", status_str)
	}

	function normalizeInteractionType(type_str)
	{
		var returnType_str = type_str;
		if(returnType_str.toLowerCase() == "long-fill-in")
		{
			returnType_str = "long-fill-in";
		} else {
			returnType_str = AICCTokenToSCORMToken("true-false,choice,fill-in,matching,performance,sequencing,likert,numeric", returnType_str)
		}
		if(returnType_str=="" || returnType_str==undefined)
		{
			returnType_str = "other";
		}
		return returnType_str;
	}

	function normalizeInteractionResult(result_str)
	{
		var tempResult_str = AICCTokenToSCORMToken("correct,wrong,unanticipated,neutral", result_str)
		tempResult_str = (tempResult_str == "wrong"?"incorrect":tempResult_str);
		return tempResult_str
	}

	function normalizeRespose(response_str)
	{
		return AICCTokenToSCORMToken("true,false", response_str);
	}

	function isTokenSupported(list_str, token_str)
	{
		var a = list_str.split(",");
		var c = token_str.toLowerCase();
		for (var i=0;i<a.length;i++)
		{
			if (c == trim(a[i])) return true;
		}
		return false;
	}

	function checkInteractionResponse(response_str):String
	{
		var result_str:String = "";
		for(var char_int=0;char_int<response_str.length;char_int++)
		{
			if(response_str.substr(char_int,1) == "." || response_str.substr(char_int,1) == ",")
			{
				if(response_str.substr(char_int - 1,1) != "[" && response_str.substr(char_int + 1,1) != "]")
				{
					result_str += "[" + response_str.substr(char_int,1) + "]";
				} else {
					result_str += response_str.substr(char_int,1);
				}
			} else {
				result_str += response_str.substr(char_int,1);
			}
		}
		result_str = (result_str==""?"0":escapeJS(result_str));
		return result_str;
	}

	function setInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str):Void
	{
		var temp_int = interaction_ary.length;
		interaction_ary[temp_int] = new Array();
		interaction_ary[temp_int]["interactionID_str"] = interactionID_str;
		interaction_ary[temp_int]["objectiveID_str"] = objectiveID_str;
		interaction_ary[temp_int]["type_str"] = normalizeInteractionType(type_str);
		interaction_ary[temp_int]["correctResponse_str"] = checkInteractionResponse(correctResponse_str);
		interaction_ary[temp_int]["studentResponse_str"] = checkInteractionResponse(studentResponse_str);
		interaction_ary[temp_int]["result_str"] = normalizeInteractionResult(result_str);
		interaction_ary[temp_int]["weight_int"] = weight_int;
		interaction_ary[temp_int]["latency_str"] = formatTime(latency_str);
		if(date_str == undefined || date_str == "")
		{
			date_str = formatDate();
		} else {
			date_str = formatDate(date_str);
		}
		interaction_ary[temp_int]["date_str"] = date_str;
		if(time_str == undefined || time_str == "")
		{
			time_str = formatTimestamp(0);
		} else {
			time_str = formatTimestamp(time_str);
		}
		interaction_ary[temp_int]["time_str"] = time_str;
	}

	function sendInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str):Void
	{
		if(isInteractionDataTracked())
		{
			if(interactionID_str != undefined && interactionID_str != "")
			{
				setInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str);
			}
			// format and send tracking data to LMS
			for(var ia_int=0;ia_int<interaction_ary.length;ia_int++)
			{
				// check to see if the interaction type is supported
				if(isTokenSupported(interactions_children, "id") && (interaction_ary[ia_int].interactionID_str != undefined))
				{
					SCORMbuild("SetValue", "cmi.interactions." + interactions_count.toString() + ".id", interaction_ary[ia_int].interactionID_str, "");
				}
				if(isTokenSupported(interactions_children, "timestamp") && (interaction_ary[ia_int].time_str != undefined))
				{
					SCORMbuild("SetValue", "cmi.interactions." + interactions_count.toString() + ".timestamp", interaction_ary[ia_int].time_str, "");
				}
				if(isTokenSupported(interactions_children, "type") && (interaction_ary[ia_int].type_str != undefined))
				{
					SCORMbuild("SetValue", "cmi.interactions." + interactions_count.toString() + ".type", interaction_ary[ia_int].type_str, "");
				}
				if(isTokenSupported(interactions_children, "correct_responses") && (interaction_ary[ia_int].correctResponse_str != undefined))
				{
					SCORMbuild("SetValue", "cmi.interactions." + interactions_count.toString() + ".correct_responses.0.pattern", interaction_ary[ia_int].correctResponse_str, "");
				}
				if(isTokenSupported(interactions_children, "weighting") && (interaction_ary[ia_int].weight_int != undefined))
				{
					SCORMbuild("SetValue", "cmi.interactions." + interactions_count.toString() + ".weighting", interaction_ary[ia_int].weight_int, "");
				}
				if(isTokenSupported(interactions_children, "learner_response") && (interaction_ary[ia_int].studentResponse_str != undefined))
				{
					SCORMbuild("SetValue", "cmi.interactions." + interactions_count.toString() + ".learner_response", interaction_ary[ia_int].studentResponse_str, "");
				}
				if(isTokenSupported(interactions_children, "result") && (interaction_ary[ia_int].result_str != undefined))
				{
					SCORMbuild("SetValue", "cmi.interactions." + interactions_count.toString() + ".result", interaction_ary[ia_int].result_str, "");
				}
				if(isTokenSupported(interactions_children, "latency") && (interaction_ary[ia_int].latency_str != undefined))
				{
					SCORMbuild("SetValue", "cmi.interactions." + interactions_count.toString() + ".latency", interaction_ary[ia_int].latency_str, "");
				}
				interactions_count++;
			}
			interaction_ary = [];
		}
	}

    // Local functions to communicate to JavaScript

    function SCORMbuild(function_str, property_str, value_str, variable_str, functionToCall_str)
    {
		var temp_obj = new Object();
		temp_obj.function_str = function_str;
		temp_obj.property_str = property_str;
		temp_obj.value_str = value_str;
		temp_obj.variable_str = variable_str;
		temp_obj.functionToCall_str = functionToCall_str;
		lmsQueue.addToQueue(this, "callJS", temp_obj, true);
		if(getShowErrors() == 1 && function_str.substr(0, 14) != "GetErrorString" && function_str.substr(0, 12) != "GetLastError" && (function_str.substr(0,8) == "GetValue" || function_str.substr(0,8) == "SetValue"))
		{
			getTrackingDataError(function_str + ":" + property_str);
		}
	}

	function watchForLMSResponse(variable_str, oldValue, newValue, referenceObject)
	{
		referenceObject.objAPI_obj.unwatch(variable_str);
		// check the initialized_bln and finished_bln variables - because we need to know if the value is "true" or "false"
		// depending on the actual implementation, some LMSs might return "True" or "False" (or that's how it appears from the
		// Flash player if they actually return a boolean true or false (it's an edge case - but provides less problems).
		if(variable_str.indexOf("initialized_bln") > -1 || variable_str.indexOf("finished_bln") > -1)
		{
			newValue = unescape(newValue).toLowerCase();
		} else {
			newValue = unescape(newValue);
		}
		// Update this TrackingAdapter variable with new value;
		referenceObject[variable_str] = newValue;
		for(var counter_int = 0; counter_int < referenceObject.callToJS_array.length; counter_int++){
			if (referenceObject.callToJS_array[counter_int] == this + "." + variable_str){
				referenceObject.callToJS_array.splice(counter_int, 1);
				break;
			}
		}
		if(variable_str == "core_score_children")
		{
			referenceObject.getTrackingDataScoreValues(newValue);
		}
		referenceObject.lmsQueue.removeFromQueue();

	}

	function callJS(parameter_obj) {
		if(parameter_obj.function_str == "GetErrorString" && LMSLastError_int == 0 || (parameter_obj.function_str != "Initialize" && !isInitialized()))
		{
			// Remove the GetErrorString from queue, since we don't need to call it.
			lmsQueue.removeFromQueue();
		} else {
			var function_str = parameter_obj.function_str;
			if(function_str == "GetErrorString")
			{
				var property_str = LMSLastError_int;
			} else {
				var property_str = parameter_obj.property_str;
			}
			var value_str = parameter_obj.value_str;
			var variable_str = parameter_obj.variable_str;
			if(objAPI_str == "")
			{
				variable_str = (variable_str==undefined || variable_str==""?objAPI_str + "tempVar":variable_str);
				//set(variable_str, undefined);
				callToJS_array.push(variable_str);
				var nav = "javascript:dataFromFlash('" + function_str + "', '" + property_str + "', '" + value_str + "', '" + variable_str + "');"
				getURL(nav);
			} else {
				variable_str = (variable_str==undefined || variable_str==""?objAPI_str + "tempVar":variable_str);
				value_str = (value_str==undefined || value_str==""?"''":value_str);
				set(variable_str, undefined);
				callToJS_array.push(variable_str);
				var variableName_str = variable_str.substr(variable_str.lastIndexOf(".") + 1);
				objAPI_obj.watch(variableName_str, watchForLMSResponse, this);
				fscommand(function_str, property_str + "|" + value_str + "|" + variable_str);
			}
		}
    }


	function formatTimestamp(time_var)
	{
		return formatDate() + "T" + formatTime(time_var, undefined, undefined, 2);
	}


	// ******************************************************************
	// *
	// *     Method:           formatTime
	// *     Description:      Formats seconds (passed as parameter) to
	// *                       PTxHyMzS
	// *     Returns:          String (time formatted as HHHH:MM:SS
	// *
	// ******************************************************************
	function formatTime(time_var, minutes_str, seconds_str, typeFormat_int):String
	{
		var days_str, hours_str, formattedTime_str;
		days_str = "0";
		if(time_var == undefined) {
			// create time based on today's current time
			var time_obj = new Date();
			hours_str = time_obj.getHours();
			minutes_str = time_obj.getMinutes();
			seconds_str = time_obj.getSeconds();
		} else if(typeof(time_var) == "string" && time_var.indexOf(":") > -1) {
			var time_obj = time_var.split(":");
			hours_str = time_obj[0];
			minutes_str = time_obj[1];
			seconds_str = time_obj[2];
		} else {
			days_str    = "0";
			seconds_str = "0";
			minutes_str = "0";
			hours_str 	= "0";

			seconds_str = int(time_var);
			if(seconds_str > 59)
			{
				minutes_str = int(seconds_str / 60);
				seconds_str = seconds_str - (minutes_str * 60);
			}
			if(minutes_str > 59)
			{
				hours_str = int(minutes_str / 60);
				minutes_str = minutes_str - (hours_str * 60);
			}
			if(hours_str > 23)
			{
				days_str = int(hours_str / 24);
				hours_str = hours_str - (days_str * 24);
			}
		}

		if(typeFormat_int == undefined || typeFormat_int == 1)
		{
			formattedTime_str = "P";

			if(days_str != "0")
			{
				formattedTime_str += days_str + "D";
			}
			formattedTime_str += "T" + hours_str + "H" + minutes_str + "M" + seconds_str + "S";
		} else {
			formattedTime_str = formatNum(hours_str, 2) + ":" + formatNum(minutes_str, 2) + ":" + formatNum(seconds_str, 2);
		}
		return formattedTime_str;
	}

	// ******************************************************************
	// *
	// *     Method:           formatDate
	// *     Description:      Formats seconds or "MM/DD/YYYY"
	// *     Returns:          String (date formatted as "YYYY-MM-DD")
	// *
	// ******************************************************************
	function formatDate(date_var, day_str, year_str):String
	{
		if (date_var == undefined) {
			// Create date based on today's date
			var date_obj = new Date();
			date_var = formatNum((date_obj.getMonth()+1), 2);
			day_str  = formatNum((date_obj.getDate()), 2);
			year_str = (date_obj.getFullYear());
		} else if(typeof(date_var) == "string" && date_var.indexOf("/") > -1) {
			// Convert from MM/DD/YYYY
			var date_obj = date_var.split("/");
			date_var = formatNum(date_obj[0], 2);
			day_str  = formatNum(date_obj[1], 2);
			year_str = formatNum(date_obj[2], 4);
		}
		var formattedDate_str = (year_str + "-" + date_var + "-" + day_str);
		return formattedDate_str;
	}

}