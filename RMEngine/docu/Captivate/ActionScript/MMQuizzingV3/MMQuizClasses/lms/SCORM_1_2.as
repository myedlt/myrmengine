//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMQuizClasses.lms.Response;
import MMQuizzingV3.MMQuizClasses.lms.TrackingAdapter;

class MMQuizzingV3.MMQuizClasses.lms.SCORM_1_2 extends TrackingAdapter
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

    function SCORM_1_2 (_adapterObject:Object, typeEnvironment_int, sendLessonData_bln:Boolean)
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
	        gtrace(" objAPI_str = " + objAPI_str);
	        SCORMbuild("LMSInitialize","","", objAPI_str + "initialized_bln");
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
        if(!isTrackingDataLoaded())
        {
			getTrackingDataCore();
			SCORMbuild("LMSGetValue", "cmi.launch_data", "", objAPI_str + "vendor_data");
			SCORMbuild("LMSGetValue", "cmi.objectives._count", "", objAPI_str + "objectives_count");
			if(waitForData_var == undefined)
			{
				waitForData_var = setInterval(waitForData, 100, this, getTimer() + (waitForData_int * 1000));
			}
		}
    }

    function waitForData(this_obj, timer_int)
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
		SCORMbuild("LMSGetValue", "cmi.core._children", "", objAPI_str + "core_children", "getTrackingDataCoreValues");
		SCORMbuild("LMSGetValue", "cmi.suspend_data", "", objAPI_str + "lesson_data");
		SCORMbuild("LMSGetValue", "cmi.interactions._children", "", objAPI_str + "interactions_children");
		SCORMbuild("LMSGetValue", "cmi.interactions._count", "", objAPI_str + "interactions_count");

		if(objAPI_str == "")
		{
			trackingResponse.waitForResponse("core_children", undefined, this, "getTrackingDataCoreValues", 'core_children');
		}

		if(waitForData_var == undefined)
		{
			waitForData_var = setInterval(waitForData, 100, this, getTimer() + (waitForData_int * 1000));
		}
	}

	function getTrackingDataCoreValues(value_str)
	{
		if(value_str == "")
		{
			// We didn't receive anything.  We could assume NO core data fields are supported (SCORM compliant that way).
			// or we could assume that there is SUPPOSED to be some default values and try to get them from the LMS.
			// The list below is (with some additional fields) fields we care about.
			// It's commented out, because we might only want to do this, if a customer says we need to (since it's against the standard)
			// value_str = "student_id,student_name,lesson_location,lesson_status,score,session_time";
		}
		if(value_str != undefined && value_str.indexOf(",") == -1)
		{
			// assumes value_str is a list of support core data fields from SCORM-compliant LMS
			value_str = this[value_str];
		}
		var temp_ary = value_str.split(",");
		for(var item_str in temp_ary)
		{
			var temp_str = trim(temp_ary[item_str]);
			if(temp_str != "session_time" && temp_str != "exit" && temp_str != "student_id" && temp_str != "student_name" && temp_str != "credit" && temp_str != "lesson_status" && temp_str != "entry" && temp_str != "total_time" && temp_str != "lesson_mode")
			{
				if(temp_str == "score")
				{
					SCORMbuild("LMSGetValue", "cmi.core.score._children", "", objAPI_str + "core_score_children", "getTrackingDataScoreValues");
					if(objAPI_str == "")
					{
						trackingResponse.waitForResponse("core_score_children", undefined, this, "getTrackingDataString", "cmi.core.score.", "core_score_children", "score_");
					}
				} else {
					SCORMbuild("LMSGetValue", "cmi.core." + temp_str, "", objAPI_str + temp_str );
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
			SCORMbuild("LMSGetValue", "cmi.core.score." + temp_str, "", objAPI_str + "score_" + temp_str);
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
					SCORMbuild("LMSGetValue", data_str + temp_str, "", objAPI_str + temp_str);
				} else {
					SCORMbuild("LMSGetValue", data_str + temp_str, "", objAPI_str + additionalValue_var + temp_str);
				}
			}
		}
	}



	function getTrackingDataObjectives(value_str)
	{
		// complete this function!!!!!!!!!
		var value_int = this[value_str]
		for(var temp_int=0;temp_int<=value_int;temp_int++);
		{
			SCORMbuild("LMSGetValue", "");
		}
	}

	function getTrackingDataError(command_str)
	{
		LMSLastError_int = undefined;
		LMSLastError.error = undefined;
		LMSLastError_str = undefined;
		LMSLastErrorCmd_str = command_str;
		SCORMbuild("LMSGetLastError", "", "", objAPI_str + "LMSLastError_int");
		SCORMbuild("LMSGetErrorString", "LMSLastError_int", "", objAPI_str + "LMSLastError_str");
	}

	function getTrackingDataErrorString()
	{
		if(LMSLastError_int != 0)
		{
			SCORMbuild("LMSGetErrorString", "", "", objAPI_str + "LMSLastError_str", "getTrackingDataErrorStringResult");
			if(objAPI_str == "")
			{
				trackingResponse.waitForResponse("LMSLastError_str", undefined, this, "getTrackingDataErrorStringResult");
			}
		} else {
			LMSLastError_str = "";
		}
	}

	function getTrackingDataErrorStringResult()
	{
		addToErrorArray(LMSLastError_int, LMSLastError_str, LMSLastErrorCmd_str);
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
				SCORMbuild("LMSSetValue", dataModel_str + dataValue_str[item_str], value_str, "");
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
		var temp_str:String = "";

		setTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _suspendData_str);
		setTrackingDataString("cmi.core.score.", core_score_children, "score_")
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
		SCORMbuild("LMSSetValue", "cmi.core.lesson_status", normalizeStatus(temp_str), "");
		SCORMbuild("LMSSetValue", "cmi.core.lesson_location", getLessonLocation(), "");
		SCORMbuild("LMSSetValue", "cmi.core.session_time", getTimeInSession(), "");
		if(getLessonData() != "")
		{
			SCORMbuild("LMSSetValue", "cmi.suspend_data", escape(getLessonData()), "");
		}

		// Don't reset the timer variable, since SCORM reports accumulated time on the last TrackingData request
		// resetTimer();
	}

	function flush()
	{
		SCORMbuild("LMSCommit", "", "", "");
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
		SCORMbuild("LMSCommit", "", "", "");
		SCORMbuild("LMSFinish", "", "", objAPI_str + "finished_bln");
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
		return token_str
	}

	function normalizeStatus(status_str){
		return AICCTokenToSCORMToken("completed,incomplete,not attempted,failed,passed", status_str)
	}

	function normalizeInteractionType(type_str){
		if(type_str.toLowerCase() == "long-fill-in")
		{
			return "fill-in";
		} else {
			return AICCTokenToSCORMToken("true-false,choice,fill-in,matching,performance,sequencing,likert,numeric", type_str)
		}
	}

	function normalizeInteractionResult(result_str){
		return AICCTokenToSCORMToken("correct,wrong,unanticipated,neutral", result_str)
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

	function setInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str):Void
	{
		var temp_int = interaction_ary.length;
		interaction_ary[temp_int] = new Array();
		interaction_ary[temp_int]["interactionID_str"] = interactionID_str;
		interaction_ary[temp_int]["objectiveID_str"] = objectiveID_str;
		interaction_ary[temp_int]["type_str"] = normalizeInteractionType(type_str);
		//interaction_ary[temp_int]["correctResponse_str"] = (correctResponse_str==""?"\"\"":correctResponse_str);
		interaction_ary[temp_int]["correctResponse_str"] = (correctResponse_str==""?"0":escapeJS(correctResponse_str));
		//interaction_ary[temp_int]["correctResponse_str"] = correctResponse_str;
		//interaction_ary[temp_int]["studentResponse_str"] = (studentResponse_str==""?"\"\"":studentResponse_str);
		interaction_ary[temp_int]["studentResponse_str"] = (studentResponse_str==""?"0":escapeJS(studentResponse_str));
		//interaction_ary[temp_int]["studentResponse_str"] = studentResponse_str;
		interaction_ary[temp_int]["result_str"] = normalizeInteractionResult(result_str);
		interaction_ary[temp_int]["weight_int"] = weight_int;
		interaction_ary[temp_int]["latency_str"] = formatTime(latency_str);
		if(date_str == undefined || date_str == "")
		{
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
//		_root.debl("AEC: Sending Interaction Data - " + isInteractionDataTracked());
		if(isInteractionDataTracked())
		{
			if(interactionID_str != undefined && interactionID_str != "")
			{
				setInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str);
			}

			for(var ia_int=0;ia_int<interaction_ary.length;ia_int++)
			{
				// check to see if the interaction type is supported
				if(isTokenSupported(interactions_children, "id") && (interaction_ary[ia_int].interactionID_str != undefined))
				{
					SCORMbuild("LMSSetValue", "cmi.interactions." + interactions_count.toString() + ".id", interaction_ary[ia_int].interactionID_str, "");
				}
				if(isTokenSupported(interactions_children, "time") && (interaction_ary[ia_int].time_str != undefined))
				{
					SCORMbuild("LMSSetValue", "cmi.interactions." + interactions_count.toString() + ".time", interaction_ary[ia_int].time_str, "");
				}
				if(isTokenSupported(interactions_children, "type") && (interaction_ary[ia_int].type_str != undefined))
				{
					SCORMbuild("LMSSetValue", "cmi.interactions." + interactions_count.toString() + ".type", interaction_ary[ia_int].type_str, "");
				}
				if(isTokenSupported(interactions_children, "correct_responses") && (interaction_ary[ia_int].correctResponse_str != undefined))
				{
					SCORMbuild("LMSSetValue", "cmi.interactions." + interactions_count.toString() + ".correct_responses.0.pattern", interaction_ary[ia_int].correctResponse_str, "");
				}
				if(isTokenSupported(interactions_children, "weighting") && (interaction_ary[ia_int].weight_int != undefined))
				{
					SCORMbuild("LMSSetValue", "cmi.interactions." + interactions_count.toString() + ".weighting", interaction_ary[ia_int].weight_int, "");
				}
				if(isTokenSupported(interactions_children, "student_response") && (interaction_ary[ia_int].studentResponse_str != undefined))
				{
					SCORMbuild("LMSSetValue", "cmi.interactions." + interactions_count.toString() + ".student_response", interaction_ary[ia_int].studentResponse_str, "");
				}
				if(isTokenSupported(interactions_children, "result") && (interaction_ary[ia_int].result_str != undefined))
				{
					SCORMbuild("LMSSetValue", "cmi.interactions." + interactions_count.toString() + ".result", interaction_ary[ia_int].result_str, "");
				}
				if(isTokenSupported(interactions_children, "latency") && (interaction_ary[ia_int].latency_str != undefined))
				{
					SCORMbuild("LMSSetValue", "cmi.interactions." + interactions_count.toString() + ".latency", interaction_ary[ia_int].latency_str, "");
				}
				interactions_count++;
			}
			interaction_ary = [];
			// format and send tracking data to LMS
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
		if(getShowErrors() == 1 && function_str.substr(0,18) != "LMSLastErrorString" && function_str.substr(0, 15) != "LMSGetLastError" && (function_str.substr(0,11) == "LMSGetValue" || function_str.substr(0,11) == "LMSSetValue"))
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
		if(variable_str=="core_children")
		{
			referenceObject.getTrackingDataCoreValues(newValue);
		}
		if(variable_str == "core_score_children")
		{
			referenceObject.getTrackingDataScoreValues(newValue);
		}
		if(variable_str=="LMSLastError_str")
		{
			referenceObject.getTrackingDataErrorStringResult();
		}
		referenceObject.lmsQueue.removeFromQueue();

	}

	function callJS(parameter_obj) {
		if(parameter_obj.function_str == "LMSGetErrorString" && LMSLastError_int == 0 || (parameter_obj.function_str != "LMSInitialize" && !isInitialized()))
		{
			// Remove the GetErrorString from queue, since we don't need to call it.
			lmsQueue.removeFromQueue();
		} else {
			var function_str = parameter_obj.function_str;
			if(function_str == "LMSGetErrorString")
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
				value_str = (value_str==undefined || value_str==""?"\"\"":"'" + value_str + "'");
				var nav = "javascript:dataFromFlash('" + function_str + "', '" + property_str + "', " + value_str + ", '" + variable_str + "');"
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

	public function gtrace(str)	{ 
		return;
		if( System.capabilities.playerType == "PlugIn" || System.capabilities.playerType == "ActiveX" ||
			System.capabilities.playerType == "StandAlone")
			_root.debl(str);
		else
			trace(str);
	}

}