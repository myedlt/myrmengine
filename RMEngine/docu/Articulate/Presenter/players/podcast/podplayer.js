//********************************************
// Swf Options
//********************************************
var g_strSwfFile = "podplayer.swf";
var g_nWidth = "330";		// 330 | 100%
var g_nHeight = "30";		// 30 | 100%
var g_strScale = "noscale";	// noscale | show all
var g_strAlign = "middle";
var g_strQuality = "best";
var g_strBgColor = "#ffffff";
var g_strId = "podplayer";
var g_strFlashVars = "";

//********************************************
// Comm Options
//********************************************
g_strFlashVars += "vSwfId=" + g_strId + "&";
g_strFlashVars += "vJavascriptAlert=false" + "&";

//********************************************
// Audio Info
//********************************************
g_strFlashVars += "vVolume=80" + "&";

//********************************************
// Color Options
//********************************************
g_strFlashVars += "vColorize=" + __COLORIZE__ + "&";

g_strFlashVars += "vButtonColor=" + __BTN_COLOR__  + "&";
g_strFlashVars += "vButtonHoverColor=" + __BTN_HOVER_COLOR__ + "&";

g_strFlashVars += "vPanelBgColor=" + __PANEL_BG_COLOR__ + "&";
g_strFlashVars += "vPanelBorderColor=" + __PANEL_BORDER_COLOR__ + "&";

g_strFlashVars += "vSeekbarBgColor=" + __SEEK_BG_COLOR__ + "&";
g_strFlashVars += "vSeekbarLoadColor=" + __SEEK_LOAD_COLOR__ + "&";
g_strFlashVars += "vSeekbarColor=" + __SEEK_PROGRESS_COLOR__ + "&";
g_strFlashVars += "vTextColor=" + __TEXT_COLOR__ + "&";

g_strFlashVars += "vVolumeBgColor=" + __VOLUME_BG_COLOR__ + "&";
g_strFlashVars += "vVolumeBarColor=" + __VOLUME_BAR_COLOR__ + "&";

function CreatePodPlayer(strMP3, nDuration, bAutoPlay)
{
	g_strFlashVars += "vAudioFile=" + strMP3 + "&";
	g_strFlashVars += "vDuration=" + nDuration + "&";
	g_strFlashVars += "vAutoPlay=" + bAutoPlay + "&";

	WriteSwfObject(g_strSwfFile,
			       g_nWidth, 
			       g_nHeight, 
			       g_strScale,
			       g_strAlign, 
			       g_strQuality, 
			       g_strBgColor, 
			       g_strFlashVars,
			       g_strId);
}


function WriteSwfObject(strSwfFile, nWidth, nHeight, strScale, strAlign, strQuality, strBgColor, strFlashVars, strId)
{
	var strHtml = "";

	strHtml += "<object classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' codebase='http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,79,0' width='" + nWidth + "' height='" + nHeight + "' align='" + strAlign + "' id='" + strId + "'>";
	strHtml += "<param name='allowScriptAccess' value='sameDomain' />";
	strHtml += "<param name='scale' value='" + strScale + "' />";
	strHtml += "<param name='movie' value='" + strSwfFile + "' />";
	strHtml += "<param name='quality' value='" + strQuality + "' />";
	strHtml += "<param name='bgcolor' value='" + strBgColor + "' />";
	strHtml += "<param name='flashvars' value='" + strFlashVars + "' />";
	strHtml += "<embed src='" + strSwfFile +"' flashvars='" + strFlashVars + "' name='" + strId + "' scale='" + strScale + "' quality='" + strQuality + "' bgcolor='" + strBgColor + "' width='" + nWidth + "' height='" + nHeight + "' align='" + strAlign + "' allowscriptaccess='sameDomain' type='application/x-shockwave-flash' pluginspage='http://www.macromedia.com/go/getflashplayer' />";
	strHtml += "</object>";

	document.write(strHtml);
}

function GetSwf(strId)
{
	if (navigator.appName.indexOf("Microsoft") !=-1) 
	{
		return window[strId];
	}
	else 
	{
		return document[strId];
	}
}

function Play(strId)
{
	var oSwf = GetSwf(strId);
	oSwf.SetVariable("oPlayerControl.play", "1");
}

function Pause(strId)
{
	var oSwf = GetSwf(strId);
	oSwf.SetVariable("oPlayerControl.pause", "1");

}

function SetVolume(strId, nVolume)
{
	var oSwf = GetSwf(strId);
	oSwf.SetVariable("oPlayerControl.volume", nVolume);
}

function Seek(strId, nPosition)
{
	var oSwf = GetSwf(strId);
	oSwf.SetVariable("oPlayerControl.seek", nPosition);
}

function SwfPlay(strId)
{
}

function SwfPause(strId)
{
}
