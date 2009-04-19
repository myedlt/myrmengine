var aicc_url;
var aicc_sid;
var aicc_version = "2.2";
var aicc_inter;
var numTry = 0;
var ison = false;
var isoff = false;

function runSeekStr(str, from, to) {
	var mystr = str;
	var newstr = 0;
	var str = str.toLowerCase();
	var from = from.toLowerCase();
	var to = to.toLowerCase();
	if (!(str.indexOf(from)+1)) {
		return newstr;
	}
	var fromhere = str.indexOf(from)+from.length;
	var tostr = str.substr(fromhere, str.length-fromhere);
	mystr = mystr.substr(fromhere, str.length-fromhere);
	var tothere = tostr.length;
	if (to != "" && (tostr.indexOf(to)+1)) {
		tothere = tostr.indexOf(to);
	}
	newstr = mystr.substr(0, tothere);
	if (!newstr.length) {
		newstr = 0;
	}
	return newstr;
}
function runFind(url) {
	aicc_url = unescape(runSeekStr(url, "aicc_url=", "&"));
	aicc_sid = unescape(runSeekStr(url, "aicc_sid=", "&"));
	if (aicc_url == 0 || aicc_sid == 0) {
		return false;
	} else {
		if (aicc_url.toLowerCase().indexOf("http://") == -1) {
			aicc_url = "http://"+aicc_url;
		}
		return true;
	}
}
function runURL(win) {
	if (runFind(win.document.location+"") == false) {
		numTry++;
		if (numTry>10) {
			return false;
		}
		if (win.opener != null) {
			if (win == window.top) {
				return (runURL(win.opener));
			}
		}
		return (runURL(win.parent));
	}
	return true;
}

function doGetInter() {
	if (aicc_comm.document.readyState == "complete") {
		clearInterval(aicc_inter);
		window.document.main.SetVariable("dataCourse",aicc_comm.document.body.innerText);
	}
}
function doGetAicc() {
	var aicc_form = "<form action='"+aicc_url+"' method='POST' name='command'>";
	aicc_form += "<input type='hidden' name='command' value='getparam'>";
	aicc_form += "<input type='hidden' name='session_id' value='"+aicc_sid+"'>";
	aicc_form += "<input type='hidden' name='version' value='"+aicc_version+"'>";
	aicc_form += "<input type='hidden' name='aicc_data' value=''></form>";
	aicc_comm.document.write(aicc_form);
	aicc_comm.document.command.submit();
	aicc_inter = setInterval("doGetInter()", 200);
}
function doSetAicc(aicc_data) {
	if(aicc_url!=0){
		var aicc_form = "<form action='"+aicc_url+"' method='POST' name='command'>";
		aicc_form += "<input type='hidden' name='command' value='putparam'>";
		aicc_form += "<input type='hidden' name='session_id' value='"+aicc_sid+"'>";
		aicc_form += "<input type='hidden' name='version' value='"+aicc_version+"'>";
		aicc_form += "<input type='hidden' name='aicc_data' value='"+aicc_data+"'></form>";
		aicc_comm.document.write(aicc_form);
		aicc_comm.document.command.submit();
	}
}
function doTurnoff() {
	if(aicc_url!=0){
		if(!isoff){
			isoff = true;
			var aicc_form = "<form action='"+aicc_url+"' method='POST' name='command'>";
			aicc_form += "<input type='hidden' name='command' value='ExitAU'>";
			aicc_form += "<input type='hidden' name='session_id' value='"+aicc_sid+"'>";
			aicc_form += "<input type='hidden' name='version' value='"+aicc_version+"'>";
			aicc_form += "<input type='hidden' name='aicc_data' value=''></form>";
			aicc_comm.document.write(aicc_form);
			aicc_comm.document.command.submit();
		}
	}
}
function doTurnon() {
	if(!ison){
		ison = true;
		if (runURL(window)) {
			doGetAicc();
		}
	}
}