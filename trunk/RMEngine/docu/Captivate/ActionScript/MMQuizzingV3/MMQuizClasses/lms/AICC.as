//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMQuizClasses.lms.Response;
import MMQuizzingV3.MMQuizClasses.lms.Utilities;
import MMQuizzingV3.MMQuizClasses.lms.AICCLoadVars;
import MMQuizzingV3.MMQuizClasses.lms.TrackingAdapter;

class MMQuizzingV3.MMQuizClasses.lms.AICC extends TrackingAdapter
{
	//*********************************************
	// Private Props
	// Global Properties
	private var contentURL_str:String;

	// AICC-specific properties
	private var version:String;
	private var aicc_url:String;
	private var aicc_sid:String;
	private var aicc_data:String;

	//*********************************************
	// Public Props

	// Configurable Properties
	var overrideQueueTimeoutInterval_int:Number = 10;	// Number of seconds to set queue timeout for commands POSTED to LMS.

	// Global Objects - are these public?
	var serverPost : AICCLoadVars;
	var serverResult : AICCLoadVars;
	var serverTemp : AICCLoadVars;
	var serverUtilities : Utilities;
	var trackingResponse : Response;
	var LMS:Object = new Object();
	var return_str:String = "\r\n";         			// String; Contains the AICC-required format for return strings (Carriage Return + Line Feed)
	var serverBusy_bln:Boolean = false;					// Boolean; Only used to determine is getTrackingData has been called (for now)


	//*********************************************
	// Constructor Function

	function AICC(_adapterObject:Object, launchURL, escapeURLvs_bln:Boolean, ignoreEscape_str:String, sendLessonData_bln:Boolean)
	{
		if (escapeURLvs_bln != undefined)
		{
			setEscapeAICCvs(escapeURLvs_bln);
		}
		if (ignoreEscape_str != undefined)
		{
			setIgnoreEscapeList(ignoreEscape_str);
		}
		if (sendLessonData_bln != undefined)
		{
			setLessonDataTracked(sendLessonData_bln);
		}
		if(_adapterObject != undefined)
		{
			setObjectReference(_adapterObject);
		}
		// Declare vars above and initialize them here...

		// Mark development version
		version = "3.5"
		//version = "2.0";
		// Initialize Global Objects
		serverPost   = new AICCLoadVars(isAICCvsEscaped(), getIgnoreEscapeList());
		serverResult = new AICCLoadVars(isAICCvsEscaped(), getIgnoreEscapeList());
		serverResult.parent = this;
		serverUtilities = new Utilities(_adapterObject);
		trackingResponse = new Response();

		// Override TIMEOUT with LMS
		lmsQueue.setQueueTimeoutInterval(overrideQueueTimeoutInterval_int);

		serverTemp   = new AICCLoadVars(isAICCvsEscaped(), getIgnoreEscapeList());

		// onLoad listener triggered by serverResult
		serverResult.onLoad = function(success):Void
		{
			var LMSLastError:Object = new Object();
			var temp_obj:AICCLoadVars = new AICCLoadVars(isAICCvsEscaped(), getIgnoreEscapeList());
			if(!success) {
				// Error from server
				this["error"] = "-3" + return_str + "error_text=tracking results failed!" + return_str;
			}
			var temp_command_str = this.parent.serverResult.command;
			if (temp_command_str.toUpperCase() == "GETPARAM")
			{
				for(var item_var in this)
				{
					if(item_var != "command" && item_var != "parent")
					{
						temp_obj[item_var] = this[item_var];
					}
				}
				this.parent.LMS = this.parent.parseTrackingData(temp_obj.toString());
				LMSLastError.Errors = this.parent.LMS.Errors;
				//this.parent.setInitialized(this.parent.LMS.Errors.error == 0);
				// should set the next line back to: this.parent.setTrackingDataLoaded(this.parent.LMS.Errors.error == 0);
				this.parent.setTrackingDataLoaded(true);
			} else  {
				LMSLastError = this.parent.parseTrackingdata(this.toString());
				if (temp_command_str.toUpperCase() == "EXITAU")
				{
					if (LMSLastError.Errors.error == 0)
					{
						this.parent.setInitialized(false);
					}
				}
			}
			if(LMSLastError.Errors.error != 0)
			{
				// only add errors != 0 to the array
				this.parent.addToErrorArray(LMSLastError.Errors.error, LMSLastError.Errors.error_text, this.parent.serverResult.command);
			}
			this.parent.serverBusy_bln = false;
			this.parent.lmsQueue.removeFromQueue();
		}

		// Check to see if the constructor was passed the AICC SID and AICC URL parameters
		if(launchURL != undefined)
		{
			setURL(launchURL);
		}

		// Start the global "timer" to track how long the user has been in this file.
		resetTimer();

		//startDev();


	}


    //*********************************************
    // AICC-specific functions (Get)

    function getAICCversion():String {return version;}

    function getURLparameter(value_str):String
    {
        var result_str = "";
        for (var param_str in _root)
        {
            if (unescape(param_str.toString().toUpperCase()) == value_str.toUpperCase())
            {
                result_str = unescape(_root[param_str]);
            }
        }
        return result_str;
    }

    function getAICCurl():String
    {
        if (aicc_url == undefined) {
            setAICCurl(serverUtilities.getParameter("aicc_url", contentURL_str));
        }
        return aicc_url;
    }

    function getAICCsid():String
    {
        if (aicc_sid == undefined) {
            //setAICCsid(getURLparameter("aicc_sid"));
            setAICCsid(serverUtilities.getParameter("aicc_sid", contentURL_str));
        }
		return aicc_sid;
	}


	function getURL():String
	{
		return contentURL_str;
	}


	//*********************************************
	// AICC-specific functions (Set)

	function fixAICCurl(value_str:String):String
	{
		if (value_str.toUpperCase().substr(0, 4) != "HTTP")
		{
			if (contentURL_str.toUpperCase().substr(0,5) == "HTTPS")
			{
				value_str = contentURL_str.substr(0,5) + "://" + value_str;
			} else {
				if (contentURL_str.toUpperCase().substr(0,4) == "HTTP")
				{
					value_str = contentURL_str.substr(0,4) + "://" + value_str;
				} else {
					value_str = "http://" + value_str
				}
			}
		}
		return value_str;
	}

	function setAICCversion(value_str:String):Void
	{
		version = value_str;
	}
	function setAICCurl(value_str:String):Void
	{
		value_str = unescape(value_str);
		if (value_str != "" && value_str != undefined)
		{
			aicc_url = fixAICCurl(value_str);
		} else {
			aicc_url = value_str;
		}
	}
	function setAICCsid(value_str:String):Void
	{
		aicc_sid = unescape(value_str);
	}



	// Global functions
	// *************************************************************************
	// *                                                                       *
	// *     Method:           setURL                                          *
	// *     Description:      Intended to set the URL of the current file     *
	// *                       because this file may be loaded via a loadMovie *
	// *					   and not receive the parameters that are 		   *
	// *				 	   required for AICC communication.				   *
	// *     Returns:                                                          *
	// *                                                                       *
	// *************************************************************************
	function setURL(URL_str)
	{
		// the next line is removed explicitly for SABA, since it includes characters that breaks the getParameter function.  We'll escape each parameter that is returned by the getParameter function.
		//URL_str = unescape(URL_str);
		setAICCurl(unescape(serverUtilities.getParameter("aicc_url", URL_str)));
		setAICCsid(unescape(serverUtilities.getParameter("aicc_sid", URL_str)));
		// Set the tracking URL from the parameters passed to the file
		if (getAICCurl() == "")
		{
			addToErrorArray(-2, "Tracking URL not found");
		} else {
			if(contentURL_str == undefined)
			{
				contentURL_str = _url;
			}
			crossDomain.checkServerPolicy(getAICCurl(), contentURL_str);
		}
		if (getAICCsid() == "")
		{
			addToErrorArray(-1, "Session ID not found");
		}
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
		//setURL("http://locahost/content/flash.swf?aicc_url=http://10.200.2.149/cgi-bin/wrapper.exe&aicc_sid=0001");
		setURL("http://locahost/content/flash.swf?aicc_url=http://achemeylaptop/cgi-bin/wrapper.exe&aicc_sid=0001");
		//_root.aicc_url = "http://achemeylaptop/cgi-bin/wrapper.exe";
		//aicc_url = "http://achemeylaptop/cgi-bin/wrapper.exe";
		//_root.aicc_url = "";
		//_root.aicc_sid = "0001";
		//aicc_sid = "0001";

		//initialized_bln = true;

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
			// Return true or false, based on whether aicc_url and aicc_sid parameters exist
			if(getAICCurl() == "" && getAICCsid() == "")
			{
				var temp_obj = serverUtilities.findParameter("aicc_url");
				if(temp_obj!=undefined)
				{
					setURL(temp_obj._url);
					setInitialized(true);
				}
			} else {
				setInitialized(true);
			}
			if(aicc_url != "" && aicc_url != undefined)
			{
				crossDomain.checkServerPolicy(getAICCurl(), contentURL_str);
			}
		}
		return isInitialized();
	}

	function AICCbuild(command, AICCdata):Void
	{
		//trace("Starting AICCPost...");
		var temp_obj : AICCLoadVars = new AICCLoadVars(isAICCvsEscaped(), getIgnoreEscapeList());
		temp_obj.aicc_data = AICCdata;
		temp_obj.session_id = getAICCsid();
		temp_obj.version = getAICCversion();
		temp_obj.command = command;
		lmsQueue.addToQueue(this, "AICCpost", temp_obj);
	}

	function AICCpost(parameter_obj):Void
	{
		if (isInitialized() || (parameter_obj.command.toUpperCase() == "GETPARAM" && getAICCurl() <> ""))
		{
			if(parameter_obj.command.toUpperCase() == "EXITAU")
			{
				// This isn't always caught (especially when using external tracking mechanism), so we'll add it here for now
				setInitialized(false);
			}
			var serverNew = new AICCLoadVars(isAICCvsEscaped(), getIgnoreEscapeList());
			serverNew = parameter_obj;
			if (crossDomain.checkServerPolicy(getAICCurl(), contentURL_str))
			{
				serverResult.command = serverNew.command;
				serverNew.sendAndLoad(getAICCurl(), serverResult, "POST");
			} else {
				serverNew.send(getAICCurl(), "cmiresults", "POST");
				lmsQueue.removeFromQueue();
			}
		} else {
			// Don't post - LMS is not initialized
			lmsQueue.removeFromQueue();
		}
	}


	function flush():Void
	{
		// No need to call this anymore - since we aren't storing any data to 'flush'
		// sendTrackingData();
	}
	function finish():Void
	{
		sendExitData();
	}

	function checkInteractionResponse(response_str):String
	{
		var result_str:String = "";
		var encapsulate_bln:Boolean = false;
		for(var char_int=0;char_int<response_str.length;char_int++)
		{
			if(response_str.substr(char_int,1) == ",")
			{
				if(response_str.substr(char_int - 1,1) != "\\")
				{
					encapsulate_bln = true;
				}
			}
		}
		if (encapsulate_bln)
		{
			result_str = "{" + escapeJS(response_str) + "}"
		} else {
			result_str = escapeJS(response_str);
		}
		return result_str;
	}

	function setInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str):Void
	{
		var temp_int = interaction_ary.length;
		interaction_ary[temp_int] = new Array();
		interaction_ary[temp_int]["interactionID_str"] = interactionID_str;
		interaction_ary[temp_int]["objectiveID_str"] = objectiveID_str;
		interaction_ary[temp_int]["type_str"] = type_str;
		interaction_ary[temp_int]["correctResponse_str"] = checkInteractionResponse(correctResponse_str);
		interaction_ary[temp_int]["studentResponse_str"] = checkInteractionResponse(studentResponse_str);
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
			if(interactionID_str != undefined && interactionID_str != "")
			{
				setInteractionData(interactionID_str, objectiveID_str, type_str, correctResponse_str, studentResponse_str, result_str, weight_int, latency_str, date_str, time_str);
			}
			// Build interaction_data string
			var interaction_data = "";
			var interaction_data = ""
			interaction_data = 	"\"course_id\"," +
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
			for(var interactionItem in interaction_ary)
			{
				interaction_data = interaction_data +
								"\"0\"," +
								"\"0\"," +
								"\"" + interaction_ary[interactionItem]["date_str"] + "\","+
								"\"" + interaction_ary[interactionItem]["time_str"] + "\","+
								"\"" + interaction_ary[interactionItem]["interactionID_str"] + "\","+
								"\"" + interaction_ary[interactionItem]["objectiveID_str"] +"\","+
								"\"" + interaction_ary[interactionItem]["type_str"] +"\","+
								"\"" + interaction_ary[interactionItem]["correctResponse_str"] +"\","+
								"\"" + interaction_ary[interactionItem]["studentResponse_str"] +"\","+
								"\"" + interaction_ary[interactionItem]["result_str"] +"\","+
								"\"" + interaction_ary[interactionItem]["weight_int"] +"\","+
								"\"" + interaction_ary[interactionItem]["latency_str"] + "\"" + return_str;
			}

			// Send Post to Server
			AICCbuild("putInteractions", interaction_data);
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
		// First, check to see if the data has already been loaded...
		if(!isTrackingDataLoaded() && isInitialized() && !serverBusy_bln)
		{
			// Automatically set getTrackingData Loaded - prevents multiple calls from occurring
			// this status can change, when the results of the getParam are returned.
			//setTrackingDataLoaded(true);
			serverBusy_bln = true;

			// Call AICC GetParam function
			AICCbuild("getParam", "");
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
			var temp_str:String = "";               // String; Used for temporary purposes.

			if(_time_str == undefined)
			{
				_time_str = "";
			}
			setTrackingData(_scoreRaw_int, _scoreMin_int, _scoreMax_int, _scoreAsPercent_bln, _location_str, _statusCompletion_str, _statusSuccess_str, _statusPreference_bln, _time_str, _resumeData_str);


			// Format lesson_Data
			// Nothing to format

			// Build aicc_data string
			aicc_data = "";
			aicc_data = aicc_data + "[Core]" + return_str;
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
			aicc_data = aicc_data + "lesson_status=" + temp_str + return_str;
			aicc_data = aicc_data + "lesson_location=" + getLessonLocation() + return_str;
			aicc_data = aicc_data + "score=" + getScore(_scoreAsPercent_bln) + return_str;
			aicc_data = aicc_data + "time=" + getTimeInSession() + return_str;
			temp_str = getLessonData();
			if (temp_str != "")
			{
				aicc_data = aicc_data + "[Core_lesson]" + return_str + escape(temp_str) + return_str;
			}

			// Send Post to Server
			AICCbuild("putParam", aicc_data);

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
		if(isInitialized())
		{
			// Manually call the JS method on ExitAU, because of problems where it's not always called
			//getURL("javascript:setFinished(true)");

			// Call AICC ExitAU command
			AICCbuild("exitAU", "");
		}
	}

	function setTrackingComplete():Void
	{
		sendExitData();
	}

	function setInitialized(value_bln:Boolean):Void
	{
		initialized_bln = value_bln;
		//getURL("javascript:setFinished(" + !value_bln + ")");
	}


	// ******************************************************************
	// *
	// *     Method:           capitalize
	// *     Description:      Capitalizes the first character of the
	// *                       string that is passed to the function
	// *                       and explicitly forces the rest of the
	// *                       string to be lowercase.
	// *     Returns:          string
	// *
	// ******************************************************************
	function capitalize(s):String {
		return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
	}


	// ******************************************************************
	// *
	// *     Method:           parseINIData
	// *     Description:      Parses the results of posting to an AICC-
	// *                       Compliant LMS, which is in an INI-format
	// *     Returns:		   Object
	// *
	// ******************************************************************
	function parseTrackingData(text)
	{
		var result_obj = new Object();
		text = unescape(text);
		var n;
		var names = new Array('Core', 'Core_lesson', 'Core_vendor', 'Evaluation', 'Objectives_status', 'Student_preferences', 'Student_data', 'Student_demographics');
		var searchText = text.toLowerCase();
		for(var cur in names)
		{
			var target = "[" + names[cur] + "]";
			while((n = searchText.indexOf(target.toLowerCase())) != -1)
			{
				text = text.substring(0, n) + "%^" + names[cur] + "|" + text.substring(n + 2 + names[cur].length);
				searchText = text.toLowerCase();
			}
		}
		text = "Errors|" + text;
		var content = text.split("%^");
		text = "";
		for(var i in content)
		{
			var start = content[i].indexOf("|");
			var self = new Object();
			self.name = content[i].substring(0, start);
			self.blob = content[i].substring(start+1);
			var temp = self.blob.split(return_str);
			if(self.name=="Core_lesson" || self.name == "Core_vendor")
			{
				var temp_str = temp.join("\r");
				if(temp_str.substr(0,1) == "\r")
				{
					temp_str = temp_str.substr(1);
				}
				this[self.name.toLowerCase()] = temp_str;
			}
			for(var j in temp)
			{
				var eqr;
				eqr = temp[j].indexOf("=");
				if(eqr != -1)
				{
					// possible name/value
					var id = trim(temp[j].substring(0, eqr)).toLowerCase();
					var val = trim(temp[j].substring(eqr+1, temp[j].length));
					self[id] = val;
					this[id] = val;
				}
			}
			result_obj[self.name] = self;
		}
		return result_obj;
	}


}