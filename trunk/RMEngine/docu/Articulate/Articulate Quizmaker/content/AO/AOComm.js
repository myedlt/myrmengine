
var g_strApiUrl = "";
var g_strResultData = "";
var g_strResultAction = "";

function AO_DoFSCommand(command, args)
{
	args = String(args);
	command = String(command);

	var arrArgs = args.split(g_strDelim);
	
	switch (command)
	{
		case "AO_UpdateAOData":
			
			g_strApiUrl = unescape(arrArgs[0]);
			g_strResultAction = unescape(arrArgs[1]);
			g_strResultData = unescape(arrArgs[2]);
			
			g_strResultData = AOReplaceAll(g_strResultData, "~&amp;#", "&#");
			break;
	}
}

function AOReplaceAll(strTarget, strChar, strNew)
{
	var arrRemoved = strTarget.split(strChar);
	
	return arrRemoved.join(strNew);
}

function CreateXmlHttp()
{
	var xmlHttp = null;
	var arrCtrlName = new Array("MSXML2.XMLHttp.5.0", "MSXML2.XMLHttp.4.0", "MSXML2.XMLHttp.3.0", "MSXML2.XMLHttp", "Microsoft.XMLHttp");
	var nIndex = 0;
	
	if (window.XMLHttpRequest) 
	{
		try
		{
			xmlHttp = new XMLHttpRequest();
		}
		catch (e)
		{
			xmlHttp = null;
		}
	}
	
	if (xmlHttp == null && window.ActiveXObject)
	{
		// Use the ActiveX Control
		while (xmlHttp == null && nIndex < arrCtrlName.length)
		{
			try
			{
				xmlHttp = new ActiveXObject(arrCtrlName[nIndex]);
			}
			catch (e)
			{
				xmlHttp = null;
			}
			
			nIndex++;
		}

	}

	return xmlHttp;
}

function PostAORequest(strApiUrl, strXmlData, strRequestAction)
{
	var xmlHttp = CreateXmlHttp();
	
	if (xmlHttp != null)
	{
		try
		{
			xmlHttp.open("POST", strApiUrl, false);
			xmlHttp.setRequestHeader("SOAPAction", strRequestAction);
			xmlHttp.send(strXmlData);
			
			if(xmlHttp.status != 200)
			{	
				if(confirm("Could not save results. You may need to login again. Retry?"))
				{		    
					PostAORequest(strApiUrl, strXmlData, strRequestAction);
					return;
				}
			}
			
		}
		catch (error)
		{
		    if(confirm("Unable connect to server.  Please verify you can connect to the internet. Retry?"))
		    {		    
			    PostAORequest(strApiUrl, strXmlData, strRequestAction);
				return;
		    }
		    else
		    {
			    alert("Request to the url "+ strApiUrl +" failed for the following reason: " + error);
		    }
		}
	}
}

var g_bResultsPosted = false;
function PostResultsOnUnload()
{
	if (g_strApiUrl !="" && g_strResultData != "" && g_strResultAction != "")
	{
		if (!g_bResultsPosted)
		{
			PostAORequest(g_strApiUrl, g_strResultData, g_strResultAction);
			g_bResultsPosted = true;
		}
	}
	
	if (window.opener)
	{
		if (window.opener.refreshStatus)
		{
			window.opener.refreshStatus();
		}
	}
}

window.onunload = PostResultsOnUnload;
window.onbeforeunload = PostResultsOnUnload;
