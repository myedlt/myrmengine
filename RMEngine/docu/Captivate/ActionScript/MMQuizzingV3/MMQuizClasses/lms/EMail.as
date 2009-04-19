//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMQuizClasses.lms.TrackingAdapter;

class MMQuizzingV3.MMQuizClasses.lms.EMail extends TrackingAdapter
{
	//*********************************************
	// Private Props
	// Global Properties
	private var emailTo_str:String = "";
	private var emailBody_str:String = "";
	private var emailSubject_str:String = "";
	private var return_str:String = "\n";
	private var scoreAsPercent_bln:Boolean = false;
	private var emailModified_bln:Boolean = false;
	private var emailInterval_var;					// setInterval variable
	private var emailInterval_int = .1;			// Number of seconds to poll for interval

	//*********************************************
	// Public Props


	//*********************************************
	// Constructor Function

	function EMail(_adapterObject:Object, emailTo)
	{
		if(_adapterObject != undefined)
		{
			setObjectReference(_adapterObject);
		}
		// set the reference to email TO
		emailTo_str = emailTo;

		// Start the global "timer" to track how long the user has been in this file.
		resetTimer();

	}


	// Global functions

	// *************************************************************************
	// *                                                                       *
	// *     Method:          Initialize                                       *
	// *     Description:                                                      *
	// *     Returns:         Boolean                                          *
	// *                                                                       *
	// *************************************************************************
	function initialize():Boolean
	{
		setInitialized(true);
		return isInitialized();
	}

	function flush():Void
	{
		sendEMail();
	}

	function finish():Void
	{
		if(isInitialized() || emailModified_bln)
		{
			// Don't call sendEMail on "finish" only on "flush"
			// sendEMail();
		}
		setInitialized(false);
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
		interaction_ary[temp_int]["latency_str"] = formatTime(latency_str);
		if(date_str == undefined || date_str == "")
		{
			date_str = formatDate();
		}
		interaction_ary[temp_int]["date_str"] = date_str;
		if(time_str == undefined || time_str == "")
		{
			time_str = formatTime(0);
		} else {
			time_str = formatTime(time_str);
		}
		interaction_ary[temp_int]["time_str"] = time_str;
	}


	function sendInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str):Void
	{
		if(interactionID_str != undefined && interactionID_str != "")
		{
			setInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str);
			emailModified_bln = true;
		}
		// do nothing else
	}



	// ******************************************************************
	// *
	// *     Method:           getTrackingData
	// *     Type:             Global
	// *     Description:      Properly formats a getParam POST to send
	// *                         to an AICC-Compliant LMS.
	// *      Parameters:      None
	// *     Returns:          Nothing
	// *
	// ******************************************************************
	function getTrackingData():Void
	{
		if(!isTrackingDataLoaded())
		{
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
		getTrackingData();
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
			} else {
				setScore();
			}
		}
		if(_location_str != undefined && _location_str != "")
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
				setLessonStatus(_statusSuccess_str);
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
		if(_time_str != undefined && _time_str != "" || timer_str == undefined)
		{
			setTimeInSession(_time_str);
		} else {
			setTimeInSession();
		}

		if(_resumeData_str != undefined && _resumeData_str != "")
		{
			setLessonData(_resumeData_str);
		}

		// Determine Status
		setLessonStatus(getLessonStatus());


	}


	// ******************************************************************
	// *
	// *     Method:           sendTrackingData
	// *      Type:               Global
	// *     Description:      Properly formats a putParam POST to send
	// *                         to an AICC-Compliant LMS.
	// *      Parameters:      None
	// *     Returns:          Nothing
	// *
	// ******************************************************************
	function sendTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _resumeData_str):Void
	{
		var temp_str:String = "";               // String; Used for temporary purposes.

		setTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _resumeData_str);
		if(_scoreAsPercent_bln)
		{
			scoreAsPercent_bln = true;
		}
		emailModified_bln = true;

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
		finish();
	}

	function setTrackingComplete():Void
	{
		finish();
	}

	function sendEMail():Void
	{
		var email_str = "";
		var temp_str = "";
		var tempDelimiter_str = return_str;

		if(int(_root.rdIsPreview) == 1 || _root.FlashPlayer)
		{
			//fscommand("execfile", "mailto:" + szScript);
			email_str = emailTo_str + "?subject=" + buildEMailSubject() + "&body=" + buildEMailBodyCore(tempDelimiter_str);
			temp_str = buildEMailBodyInteractionHeader(tempDelimiter_str) + escape(tempDelimiter_str);
			temp_str += buildEMailBodyInteraction(tempDelimiter_str);


			// Limit of approximately 2000 characters (2048 didn't work)  Not sure if this is platform-specific.
			if((email_str.length + temp_str.length) < 2000)
			{
			//	email_str += temp_str;
			}
			fscommand("execfile", "mailto:" + email_str);
		} else {
			tempDelimiter_str = "|";
			// Need to call setInterval because Flash Player seems to have a problem with two getURL calls in a row.
			if(isInteractionDataTracked() && interaction_ary.length > 0 )
			{
				getURL("javascript:padMail('" + emailTo_str + ";','" + buildEMailSubject() + "','" + buildEMailBodyCore(tempDelimiter_str) + buildEMailBodyInteractionHeader(tempDelimiter_str) + "');");
				emailInterval_var = setInterval(loadInteractionData, emailInterval_int * 1000, this, 0, tempDelimiter_str);
			} else {
				getURL("javascript:padMail('" + emailTo_str + "','" + buildEMailSubject() + "','" + buildEMailBodyCore(tempDelimiter_str) + "');");
				emailInterval_var = setInterval(submitEMail, emailInterval_int * 1000, this);
			}
		}
		emailModified_bln = false;
	}

	function buildEMailSubject()
	{
		return escape("Results: " + formatDate());
	}

	function buildEMailBodyCore(emailBodyDelimiter_str)
	{
		emailBodyDelimiter_str = (emailBodyDelimiter_str==undefined?return_str:emailBodyDelimiter_str);
		var emailBody_str = "Core Data" + emailBodyDelimiter_str;
		emailBody_str += "\"Status\"," + "\"Location\"," + (scoreAsPercent_bln?"\"Score\",":"\"Raw Score\",\"Max Score\",\"Min Score\",") + "\"Time\"" + emailBodyDelimiter_str;
		emailBody_str += "\"" + getLessonStatus() + "\"," + "\"" + getLessonLocation() + "\"," + "\"" + (scoreAsPercent_bln?getScore():getScoreRaw() + "\",\"" + getScoreMax() + "\",\"" + getScoreMin()) + "\",\"" + getTimeInSession() + "\"" + emailBodyDelimiter_str + emailBodyDelimiter_str;
		return escape(emailBody_str);
	}

	function buildEMailBodyInteractionHeader(emailBodyDelimiter_str)
	{
		var interactionHeader_str = "";

		if(isInteractionDataTracked() && interaction_ary.length > 0 )
		{
			emailBodyDelimiter_str = (emailBodyDelimiter_str==undefined?return_str:emailBodyDelimiter_str);
			interactionHeader_str += "Interaction Data" + emailBodyDelimiter_str;
			// Build interaction_data string
			interactionHeader_str += 	"\"Date\"," + "\"Time\"," + "\"Interaction ID\"," + "\"Objective ID\"," + "\"Interaction Type\"," +
										"\"Correct Response\"," + "\"Student Response\"," + "\"Result\"," + "\"Weight\"," + "\"Latency\"";
		}
		return escape(interactionHeader_str);
	}

	function buildEMailBodyInteraction(emailBodyDelimiter_str)
	{
		emailBodyDelimiter_str = (emailBodyDelimiter_str==undefined?return_str:emailBodyDelimiter_str);
		var interactionData_str = "";
		if(isInteractionDataTracked() && interaction_ary.length > 0 )
		{
			for(var interaction_int=0;interaction_int<interaction_ary.length;interaction_int++)
			{
				interactionData_str += buildEMailInteractionData(interaction_int, this) + escape(emailBodyDelimiter_str);
			}
		}
		return interactionData_str;
	}

	function buildEMailInteractionData(interaction_int, this_obj)
	{
		this_obj = (this_obj==undefined?this:this_obj);
		var interactionData_str = "";
		if(interaction_int < this_obj.interaction_ary.length)
		{
			interactionData_str += "\"" + this_obj.interaction_ary[interaction_int]["date_str"] + "\","+
								   "\"" + this_obj.interaction_ary[interaction_int]["time_str"] + "\","+
								   "\"" + this_obj.interaction_ary[interaction_int]["interactionID_str"] + "\","+
								   "\"" + this_obj.interaction_ary[interaction_int]["objectiveID_str"] +"\","+
								   "\"" + this_obj.interaction_ary[interaction_int]["type_str"] +"\","+
								   "\"" + this_obj.interaction_ary[interaction_int]["correctResponse_str"] +"\","+
								   "\"" + this_obj.interaction_ary[interaction_int]["studentResponse_str"] +"\","+
								   "\"" + this_obj.interaction_ary[interaction_int]["result_str"] +"\","+
								   "\"" + this_obj.interaction_ary[interaction_int]["weight_int"] +"\","+
								   "\"" + this_obj.interaction_ary[interaction_int]["latency_str"] + "\"";
		}
//_root.debl(">>>before escape()="+interactionData_str);
//_root.debl(">>>after escape()="+escape(interactionData_str));
//		return escape(interactionData_str);
		return interactionData_str;
	}

	function submitEMail(this_obj):Void
	{
		clearInterval(this_obj.emailInterval_var);
		getURL("javascript:sendMail()");
	}

	function loadInteractionData(this_obj, interaction_int, emailBodyDelimiter_str)
	{
		clearInterval(this_obj.emailInterval_var);
		var interactionData_str = "";
		if(interaction_int < this_obj.interaction_ary.length)
		{
			interactionData_str += this_obj.buildEMailInteractionData(interaction_int, this_obj);
			getURL("javascript:appendEmailBody('" + interactionData_str + "');");
			interaction_int++;
			this_obj.emailInterval_var = setInterval(this_obj.loadInteractionData, this_obj.emailInterval_int * 1000, this_obj, interaction_int, emailBodyDelimiter_str);
		} else {
			this_obj.emailInterval_var = setInterval(this_obj.submitEMail, this_obj.emailInterval_int * 1000, this_obj);
		}
	}

}
