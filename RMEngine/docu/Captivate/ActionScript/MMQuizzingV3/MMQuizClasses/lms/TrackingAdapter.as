//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMQuizClasses.lms.Queue;
import MMQuizzingV3.MMQuizClasses.lms.domainPolicy;

class MMQuizzingV3.MMQuizClasses.lms.TrackingAdapter
{
	// Properties
	// ------------------------------------------------------
	// Global properties
	private var crossDomain;
	private var crossDomain_bln:Boolean;
	private var lmsQueue;

	// Tracking [Configurable] properties;
	private var trackingAdapterType:Object = new Object();
	private var _initialized_bln:Boolean;
	private var trackingDataLoaded_bln:Boolean = false;
	private var interactionDataTracked_bln:Boolean = true;
	private var lessonDataTracked_bln:Boolean = true;
	private var escapeAICCvs_bln:Boolean = true;
	private var ignoreEscapeList_str:String = "";

	// Tracking [Error] properties
	private var showErrors_int:Number = 1;
	private var errors_array:Array = [];
	private var timer_int:Number = 0;
	private var timer_str:String;
	private var error:String;
	private var error_number:Number=null;
	private var error_text:String;

	// Core properties
	private var score;
	private var score_raw;
	private var score_min;
	private var score_max;
	private var score_scaled;				// SCORM 2004 support
	private var score_pass;					// Used for compatibility with Breeze
	private var score_tot;					// Used for compatibility with Breeze
	private var time:String;
	private var session_time:String 		// Only used to set getter/setter function
	private var total_time:String;  		// Only used to set getter/setter function
	private var lesson_location:String;
	private var lesson_status:String;		// AICC and SCORM 1.2.  For SCORM 2004 - this is used as "completion_status"
	private var success_status:String;		// SCORM 2004 support
	private var statusType_int:Number = 1;	// Status Type is used to determine how to send the tracking status:
											// 1 - normal (incomplete/complete)
											// 2 - scored (passed/failed)
	private var lesson_mode:String;
	private var student_id:String;
	private var student_name:String;
	private var credit:String;
	private var entry:String;
	private var exit:String;

	// Interaction properties
	private var interaction_ary:Array = [];

	// Core_Lesson properties
	private var lesson_data:String;
	private var suspend_data:String;

	// Core_Vendor properties
	private var vendor_data:String;
	private var core_vendor:String; // Only used to set getter/setter function

	// Core_Launch properties
	private var launch_data:String;

	// Core_Comment properties
	private var comments_from_lms:String;
	private var comments:String;

	// Student_data properties
	private var lesson_status_array:Array;
	private var score_array:Array;
	private var mastery_score:Number;
	private var max_time_allowed:String;
	private var time_limit_action:String;


	// Functions
	// -------------------------------------------------------
	// Global functions
	function isCrossDomain():Boolean			{return crossDomain_bln;}

	// Global functions (Get)
	function get initialized_bln():Boolean
	{
		return _initialized_bln;
	}
	function set initialized_bln(value_bln:Boolean)
	{
		if(value_bln == "true")
		{
			value_bln = true;
		} else if(value_bln == "false") {
			value_bln = false;
		}
		_initialized_bln = value_bln;
	}
	function isInitialized():Boolean			{return initialized_bln;}
	function isInteractionDataTracked():Boolean	{return interactionDataTracked_bln;}
	function isLessonDataTracked():Boolean		{return lessonDataTracked_bln;}
	function isTrackingDataLoaded():Boolean 	{return trackingDataLoaded_bln;}
	function isAICCvsEscaped():Boolean			{return escapeAICCvs_bln;}
	function getShowErrors():Number				{return showErrors_int;}
	function getErrorArray():Array 				{return errors_array}
	function getLastError():Object				{return _getLastError();}
	function getLastErrorNumber():Number		{return _getLastError("error_int");}
	function getLastErrorString():String		{return _getLastError("error_str");}
	function getLastErrorCommand():String		{return _getLastError("command");}
	function _getLastError(propertyName)
	{
		if (errors_array.length == 0 || errors_array[errors_array.length-1] == undefined)
		{
			return null;
		} else if (propertyName == undefined) {
			return errors_array[errors_array.length-1];
		} else {
			return errors_array[errors_array.length-1][propertyName];
		}
	}

	// Global functions (Set)
	function getTrackingAdapterType():Object	{return trackingAdapterType;}
	function setTrackingAdapterType(adapterType_int:Number, adapterType_str:String):Void
	{
		trackingAdapterType.type_int = adapterType_int;
		trackingAdapterType.type_str = adapterType_str;
	 }
	function initialize():Boolean				{return initialized_bln;}
	function flush():Void						{}
	function finish():Void						{}
	function setInitialized(value_bln:Boolean):Void {initialized_bln = value_bln;}
	function getInteractionDataTracked():Boolean {return interactionDataTracked_bln;}
	function getLessonDataTracked():Boolean 	{return lessonDataTracked_bln;}
	function getEscapeAICCvs():Boolean			{return escapeAICCvs_bln;}
	function getIgnoreEscapeList():String		{return ignoreEscapeList_str;}
	function setInteractionDataTracked(isTracked_bln:Boolean):Void 	{if(isTracked_bln != undefined) {interactionDataTracked_bln = isTracked_bln;}}
	function setLessonDataTracked(isTracked_bln:Boolean):Void		{if(isTracked_bln != undefined) {lessonDataTracked_bln = isTracked_bln;}}
	function setEscapeAICCvs(isEscaped_bln:Boolean):Void			{if(isEscaped_bln != undefined) {escapeAICCvs_bln = isEscaped_bln;}}
	function setIgnoreEscapeList(escapeList_str:String):Void		{if(ignoreEscapeList_str != undefined) {ignoreEscapeList_str = escapeList_str;}}
	function setTrackingDataLoaded(value_bln:Boolean):Void {trackingDataLoaded_bln = value_bln;}
	function setTrackingFinished():Void
	{
		setInitialized(false);
		setTrackingDataLoaded(false);
	}
	function setStatusType(type_int:Number):Void {statusType_int = type_int;}
	function getStatusType():Number {return statusType_int;}
	function setShowErrors(value_int:Number):Void {showErrors_int = value_int;}
	function setLastError(error_int:Number, error_str:String, command_str:String) {addToErrorArray(error_int, error_str, command_str);}
	function resetTimer():Void
	{
		timer_int = int(getTimer()/1000);
		timer_str = undefined;
	}

	// Global functions (Misc)
	function addToErrorArray(error_int:Number, error_str:String, command_str:String):Void
	{
		var errorArray_int = errors_array.length;
	    errors_array.push(new Object);
	    errors_array[errorArray_int].command = command_str;
	    errors_array[errorArray_int].error = error_int;
	    errors_array[errorArray_int].error_int = error_int;
	    errors_array[errorArray_int].error_str = error_str;
	}
	function resetErrorArray():Void {errors_array = [];}
	function setCrossDomain(value_bln:Boolean):Void {crossDomain_bln = value_bln;}


	// Core functions (Get)
	function getScore(scoreAsRaw_bln)
	{
		var result = getScoreRaw();
		if(result == "")
		{
			result = " ";
		}
		if(scoreAsRaw_bln == undefined || scoreAsRaw_bln == false)
		{
			if (getScoreMax() != "" && getScoreMin() != "")
			{
				result = result + "," + getScoreMax() + "," + getScoreMin();
			}
		}
		return result;
	}

	function getScoreRaw()
	{
		if (score_raw == undefined)
		{
			score_raw = "";
		}
		return score_raw;
	}
	function getScoreMax()
	{
		if (score_max == undefined || score_max == "" || score_max == " ")
		{
			score_max = "";
		}
		return score_max;
	}
	function getScoreMin()
	{
		if (score_min == undefined || score_min == "" || score_min == " ")
		{
			score_min = "";
		}
		return score_min;
	}
	function getScoreScaled()
	{
		if (score_scaled == undefined || score_scaled == "" || score_scaled == " ")
		{
			score_scaled = 1;
		}
		return score_scaled;
	}
	function getScorePass()
	{
		 return score_pass;
	 }
	 function getScoreTot()
	 {
		 return score_tot;
	 }
	function getTimeInSession():String {return time;}
	function getLessonLocation():String
	{
		if (lesson_location == undefined || lesson_location == "")
		{
			lesson_location = " ";
		}
		return lesson_location;
	}
	function getLessonStatus():String
	{
		if (lesson_status == undefined)
		{
			lesson_status = "incomplete";
		}
		return lesson_status;
	}
	function getSuccessStatus():String
	{
		return success_status;
	}
	function getLessonMode():String {return lesson_mode;}
	function getStudentID():String {return student_id;}
	function getStudentName():String {return student_name;}
	function getCredit():String {return credit;}
	function getEntry():String {return entry;}

	// Core functions (Set)
	function setScore(_scoreRaw_int, _scoreMin_int, _scoreMax_int):Void
	{
		 if(_scoreRaw_int != undefined)
		 {
			 setScoreRaw(_scoreRaw_int);
		 }
		 if(_scoreMin_int != undefined)
		 {
			 setScoreMin(_scoreMin_int);
		 }
		 if(_scoreMax_int != undefined)
		 {
			 setScoreMax(_scoreMax_int);
		 }
		 if(_scoreMax_int != undefined && _scoreRaw_int != undefined)
		 {
			 setScoreScaled(_scoreRaw_int/_scoreMax_int);
		 } else if (_scoreRaw_int != undefined) {
			 setScoreScaled(_scoreRaw_int/100);
		 }

	}

	private function validateScore(value):String
	{
		var tempValue;
		switch (typeof value)
		{
			case "null":
				tempValue = undefined;
				break;
			case "string":
				if (Number(value) == value)
				{
					tempValue = Number(value);
				}else{
					tempValue = undefined;
				}
				break;
			case "number":
				if(isNaN(value))
				{
					tempValue = undefined;
				} else {
					tempValue = value;
				}
				break;
			default:
				tempValue = undefined;
		}
		if (tempValue != undefined)
		{
			tempValue = roundDecimals(tempValue, 2);
			tempValue = tempValue.toString();
		}else{
			tempValue = " ";
		}
		return tempValue
	}

	function setScoreRaw(value):Void {score_raw = validateScore(value);}
	function setScoreMax(value):Void {score_max = validateScore(value);}
	function setScoreMin(value):Void {score_min = validateScore(value);}
	function setScoreScaled(value):Void {score_scaled = validateScore(value);}
	function setScorePass(value):Void {score_pass = value;}
	function setScoreTot(value):Void {score_tot = value;}
	function setTimeInSession(time_var):Void
	{
		// Don't require a parameter.  If one isn't passed, we'll determine the time automatically.
		if (time_var == undefined || time_var == "" || time_var == null)
		{
			time_var = formatTime(((int(getTimer()/1000)) - timer_int));
		} else if (typeof(time_var == "number")) {
			time_var = formatTime(time_var);
		}
		time = time_var;
		timer_str = time_var;
	}
	function setLessonLocation(value):Void {lesson_location = value;}
	function setLessonStatus(statusCompletion_str:String, statusSuccess_str:String):Void
	{
		// contains optional success status for SCORM 2004 support, primarily
		// Validate Lesson Status
		if (statusCompletion_str.substring(0,1) == "n" || statusCompletion_str == "" || statusCompletion_str == undefined || statusCompletion_str == " "){
			lesson_status = "incomplete";
		} else {
			lesson_status = statusCompletion_str;
		}
		if(statusSuccess_str != undefined)
		{
			success_status = statusSuccess_str;
		}
	}

	function setStudentID(value_str:String):Void {student_id = value_str;}
	function setStudentName(value_str:String):Void {student_name = value_str;}
	function setCredit(value_str:String):Void {credit = value_str;}

	// Core_Lesson functions (Get)
	function getLessonData():String
	{
		if (lesson_data == undefined || isLessonDataTracked() == false)
		{
			setLessonData("");
		}
		return lesson_data;
	}

	// Core_Mode functions (Set)
	function setLessonMode(value_str:String):Void {lesson_mode = value_str;};

	// Core_Lesson functions (Set)
	function setLessonData(value_str:String):Void {lesson_data = value_str;}


	// Core_Vendor functions (Get)
	function getVendorData():String {return vendor_data;}

	// Core_Vendor functions (Set)
	function setVendorData(value_str:String):Void {vendor_data = value_str;}

	// Student_data functions (Get)
	function getLessonStatusArray():Array {return lesson_status_array;}
	function getScoreArray():Array {return score_array;}
	function getMasteryScore():Number {return mastery_score;}
	function getMaxTimeAllowed():String {return max_time_allowed;}
	function getTimeLimitAction():String {return time_limit_action;}

	// Student_data functions (Set)
	function addToLessonStatusArray(value_str:String):Void {lesson_status_array.push(value_str);}
	function addToScoreArray(value):Void {score_array.push(value);}
	function setMasteryScore(value):Void {mastery_score = value;}
	function setMaxTimeAllowed(value_str:String):Void {max_time_allowed = value_str;}
	function setTimeLimitAction(value_str:String):Void {time_limit_action = value_str;}

	function setSlideView(slideNumber_int):Void
	{
		// placeholder - do nothing (this is currently only used for Breeze tracking adapter)
	}

	function sendSlideView(slideNumber_int):Void
	{
		// placeholder - do nothing (this is currently only used for Breeze tracking adapter)
	}

	function sendTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _resumeData_str):Void
	{
		// placeholder - do nothing (this is a placeholder for each of the tracking adapters)
		if(_time_str == undefined)
		{
			_time_str = "";
		}
		setTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _resumeData_str);
	}

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
		if(_time_str != undefined)
		{
			setTimeInSession(_time_str);
		}
		if(_resumeData_str != undefined)
		{
			setLessonData(_resumeData_str);
		}
	}

	function getTrackingData():Void
	{
		if(isTrackingDataLoaded())
		{
			// do nothing
		} else {
			setTrackingDataLoaded(true);
		}
	}

	function getTrackingDataCore():Void
	{
		if(isTrackingDataLoaded())
		{
			// do nothing
		} else {
			setTrackingDataLoaded(true);
		}
	}

	function setInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str):Void
	{
		var temp_int = interaction_ary.length;
		interaction_ary[temp_int] = new Array();
		interaction_ary[temp_int]["interactionID_str"] = interactionID_str;
		interaction_ary[temp_int]["objectiveID_str"] = objectiveID_str;
		interaction_ary[temp_int]["type_str"] = type_str;
		interaction_ary[temp_int]["correctResponse_str"] = correctResponse_str;
		interaction_ary[temp_int]["studentResponse_str"] = studentResponse_str;
		interaction_ary[temp_int]["result_bln"] = result_str;
		interaction_ary[temp_int]["weight_int"] = weight_int;
		if(latency_str == undefined || latency_str == "" || latency_str == "0")
		{
			latency_str = formatTime(0);
		} else if(typeof(latency_str) == "number") {
			latency_str == formatTime(latency_str);
		}
		interaction_ary[temp_int]["latency_str"] = latency_str;
		if(date_str == undefined || date_str == "")
		{
			date_str = formatDate();
		}
		interaction_ary[temp_int]["date_str"] = date_str;
		if(time_str == undefined || time_str == "")
		{
			time_str = formatTime(0);
		} else if(typeof(time_str) == "number") {
			time_str = formatTime(time_str);
		}
		interaction_ary[temp_int]["time_str"] = time_str;
	}

	function sendInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str):Void
	{
		if(interactionID_str != undefined && interactionID_str != "")
		{
			setInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str);
		}
	}

	// General methods
	// ******************************************************************
	// *
	// *	Method:		 formatDate
	// *	Description:	 Formats seconds or "MM/DD/YYYY" to "MM/DD/YYYY"
	// *	Returns:		String (date formatted as MM/DD/YYYY)
	// *
	// ******************************************************************
	function formatDate(date_var, day_str, year_str):String
	{
		var month_str, formattedDate_str

		if (date_var == undefined)
		{
			// Create date based on today's date
			var date_obj = new Date();
			date_var = formatNum((date_obj.getMonth()+1), 2);
			day_str  = formatNum((date_obj.getDate()), 2);
			year_str = (date_obj.getFullYear());
		} else if(typeof(date_var) == "string" && date_var.indexOf("/") > -1) {
			// Convert from MM/DD/YYYY - this doesn't make sense for most cases, but
			var date_obj = date_var.split("/");
			date_var = formatNum(date_obj[0], 2);
			day_str  = formatNum(date_obj[1], 2);
			year_str = formatNum(date_obj[2], 4);
		}
		formattedDate_str = (date_var + "/" + day_str + "/" + year_str);
		return formattedDate_str;
	}


	// ******************************************************************
	// *
	// *	Method:		 formatTime
	// *	Description:	 Formats seconds (passed as parameter) to
	// *				   HHHH:MM:SS
	// *	Returns:		String (time formatted as HHHH:MM:SS
	// *
	// ******************************************************************
	function formatTime(timeInSeconds:Number):String
	{
		var hours_str, minutes_str, seconds_str, formattedTime_str

		seconds_str = "00";
		minutes_str = "00";
		hours_str   = "00";

		  seconds_str = formatNum(int(timeInSeconds), 2);

		if (seconds_str > 59)
		{
			minutes_str = int(seconds_str / 60);
			   seconds_str = seconds_str - (minutes_str * 60);
			minutes_str = formatNum(minutes_str, 2);
			seconds_str = formatNum(seconds_str, 2);
		}
		if (minutes_str > 59)
		{
			hours_str = int(minutes_str/ 60);
			   minutes_str = minutes_str - (hours_str * 60);
			hours_str = formatNum(hours_str, 2);
			minutes_str = formatNum(minutes_str, 2);
		}
		formattedTime_str = hours_str + ":" + minutes_str + ":" + seconds_str;
		return formattedTime_str;
	}



	// ******************************************************************
	// *
	// *	Method:		 formatNum
	// *	Description:	 Converts the number passed to this function
	// *				   to a padded value, typically 2-digit or
	// *				   4-digit number (e.g. 2 to 02, or 2 to 0002)
	// *	Returns:		String (padded with # of 0's passed
	// *
	// ******************************************************************
	function formatNum (initialValue_var, numToPad_int):String
	{
		var paddedValue_str:String = "";						 // String; Contains the value padded with 0's
		var i:Number = 0;									 // Integer; Variable used for looping
		var initialValue_str:String = initialValue_var.toString();	// String; Converts parameter "initializeValue_var" explicitly to string

		if (initialValue_str.length > numToPad_int){
			// error - length of initial value already exceeds the number to pad
			// Will return the initialValue_var without additional padding
		} else {
			for (var i = 1; i <= (numToPad_int - initialValue_str.length); i++){
				paddedValue_str = paddedValue_str + "0";
			}
		}
		paddedValue_str = paddedValue_str + initialValue_var;
		return paddedValue_str;
	}



	// ******************************************************************
	// *
	// *	Method:		 roundDecimals
	// *	Description:	 Rounds the number passed (num_int) to the
	// *				   number of decimals passed (decimals_int).
	// *	Returns:		Number (truncated, if appropriate to number
	// *				   of decimals
	// *
	// ******************************************************************
	function roundDecimals(num_int, decimals_int):Number
	{
		decimals_int = ((!decimals_int && decimals_int != 0) ? 2 : decimals_int);
		return Math.round(num_int * Math.pow(10,decimals_int))/Math.pow(10,decimals_int);
	}


	// ******************************************************************
	// *
	// *	Method:		 trim
	// *	Description:	 Trims spaces preceeding and proceeding the
	// *					string that is passed to the function.
	// *	 Returns:		 string (without preceeding/proceeding
	// *					spaces)
	// *
	// ******************************************************************
	function trim(s):String {
		while(s.indexOf(' ') == 0)
		s = s.substring(1);
		while(s.length && s.lastIndexOf(' ') == s.length - 1)
			s = s.substring(0, s.length - 1);
		return s;
	}


	function escapeJS(js_str)
	{
		var char_ary = ["\r", "\t", "\'", "\"", "\\"];
		var return_str = js_str;
		for(var item in char_ary)
		{
			return_str = return_str.split(char_ary[item]).join("\\" + char_ary[item]);
		}
		// fix double-encoding
		return_str = return_str.split("\\\\;").join("\\;");
		return_str = return_str.split("\\\\,").join("\\,");
		return return_str;
	}


	function setObjectReference(_adapterReference_obj:Object)
	{
		lmsQueue = new Queue(_adapterReference_obj);
		crossDomain = new domainPolicy(_adapterReference_obj);
	}

	// Create Constructor Functions
	function TrackingAdapter(adapterReference_obj)
	{
		if(adapterReference_obj != undefined)
		{
			// Normally, we'd expect the sub-class to set this reference, but if the TrackingAdapter class is called directly
			// with the adapterObject reference - we'll set it.
			setObjectReference(adapterReference_obj)
		}
		trackingAdapterType.type_int = -1;	// -1 = None, 0 = Internal Adapter, 1 = External Adapter
		trackingAdapterType.type_str = null;
	    addProperty("score", getScore, setScore);
	    //addProperty("lesson_location", getLessonLocation, setLessonLocation);
	    addProperty("core_lesson", getLessonData, setLessonData);
	    addProperty("core_vendor", getVendorData, setVendorData);
	    addProperty("session_time", getTimeInSession, setTimeInSession);
	    addProperty("total_time", getTimeInSession, setTimeInSession)
	    addProperty("score_scaled", getScoreScaled, setScoreScaled)
	}

}