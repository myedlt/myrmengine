

function valid(v) {

    return typeof (v) != "undefined";

}

Object.prototype.extend = function (object) {

    for (property in object) {

        this[property] = object[property];

    }

    return this;

};

Object.prototype.clone = function (all) {

    var cloneObj = new Object();

    if (valid(all) && all) {

        for (prop in this) {

            if (typeof (this[prop]) == "object") {

                cloneObj[prop] = this[prop].clone(all);

            } else {

                cloneObj[prop] = this[prop];

            }

        }

    } else {

        for (prop in this) {

            cloneObj[prop] = this[prop];

        }

    }

    return cloneObj;

};

function validProp(prop) {

    return prop != "extend" && prop != "clone";

}

if (!Function.prototype.apply) {

    Function.prototype.apply = function (object, parameters) {

        if (!object) {

            object = window;

        }

        if (!parameters) {

            parameters = new Array();

        }

        var params = new Array();

        for (var i = 0; i < parameters.length; i++) {

            params[i] = "parameters[" + i + "]";

        }

        object.__apply__ = this;

        var result = eval("object.__apply__(" + params.join(", ") + ")");

        object.__apply__ = null;

        return result;

    };

}

Function.prototype.bind = function (object) {

    var __method = this;

    return function () {

        __method.apply(object, arguments);

    };

};

if (!Array.prototype.push) {

    Array.prototype.push = function () {

        var startLength = this.length;

        for (var i = 0; i < arguments.length; i++) {

            this[startLength + i] = arguments[i];

        }

        return this.length;

    };

}

Array.prototype.insert = function (idx, e) {

    this.splice(idx, 0, e);

};

Array.prototype.del = function (idx) {

    return this.splice(idx, 1);

};

Array.prototype.remove = function (item) {

    var i = 0;

    while (i < this.length) {

        if (this[i] == item) {

            this.splice(i, 1);

        } else {

            i++;

        }

    }

};

Array.prototype.removeArray = function (array, idx) {

    var i = 0;

    while (i < this.length) {

        if (this[i][idx] == array[idx]) {

            this.splice(i, 1);

        } else {

            i++;

        }

    }

};

String.prototype.trim = function () {

    return this.replace(/^\s*|\s*$/g, "");

};



function CLASS(base) {

    if (!valid(base)) {

        base = null;

    }

    var clsObj = function () {

        if (this.base == null) {

            this.create.apply(this, arguments);

            return;

        }

        var creators = [clsObj];

        while (this.base) {

            creators.push(this.base);

            this.base = this.base.base;

        }

        for (var i = creators.length - 1; i >= 0; i--) {

            this.extend(creators[i].prototype);

        }

        for (var i = creators.length - 1; i >= 0; i--) {

            creators[i].prototype.create.apply(this, arguments);

        }

    };

    clsObj.prototype.base = base;

    clsObj.prototype.create = function () {

    };

    clsObj.prototype.callof = function (func) {

        func = func.replace(/::/g, ".prototype.");

        func = func.replace(/\(/g, ".apply(this,[");

        func = func.replace(/\)/g, "])");

        eval(func);

    };

    clsObj.declare = function () {

    };

    clsObj.implement = function (implementation) {

        this.prototype.extend((new this.declare()).extend(implementation));

    };

    return clsObj;

}



function tryExe() {

    var ret = null;

    for (var i = 0; i < arguments.length; i++) {

        var fun = arguments[i];

        try {

            ret = fun();

            break;

        }

        catch (e) {

        }

    }

    return ret;

}

var Ajax = {getHttp:function () {

    return tryExe(function () {

        return new XMLHttpRequest();

    }, function () {

        return new ActiveXObject("Microsoft.XMLHTTP");

    }, function () {

        return new ActiveXObject("Msxml2.XMLHTTP");

    }, function () {

        return new ActiveXObject("Msxml3.XMLHTTP");

    }) || false;

}, emEvents:["Uninitialized", "Loading", "Loaded", "Interactive", "Complete"]};

Ajax.CRequest = CLASS();

Ajax.CRequest.declare = function () {

    this.http = null;

    this.domDoc = null;

    this.async = true;

    this.header = {};

    this.event = {};

    this.create = function () {

    };

    this.Get = function () {

    };

    this.Post = function () {

    };

    this.disconnect = function () {

    };

    this.onStateChange = function () {

    };

    this.responseIsSuccess = function () {

    };

    this.responseIsFailure = function () {

    };

    this.getData = function () {

        return this.http.responseBody;

    };

    this.getText = function () {

       // alert(this.http.responseText)

        return this.http.responseText;

    };

    this.getXML = function () {

        return this.http.responseXML;

    };

    this.getXMLData = function (tag) {

    };

};

Ajax.CRequest.implement({create:function (async) {

    this.async = async;

    this.http = Ajax.getHttp();

}, post:function (url) {

    this.header.Content_type = "application/x-www-form-urlencoded";

    if (this.http.overrideMimeType) {

        this.header.Connection = "close";

    }

    this.domDoc = null;

    try {

        var i = url.indexOf("?");

        var param = i < 0 ? "" : url.substring(i + 1, url.length);

        this.http.open("post", url, this.async);

        var reg = /_/g;

        for (prop in this.header) {

            if (validProp(prop)) {

                this.http.setRequestHeader(prop.replace(reg, "-"), this.header[prop]);

            }

        }

        if (this.async) {

            this.http.onreadystatechange = this.onStateChange.bind(this);

            setTimeout(function () {

                this.onStateChange(1);

            }.bind(this), 10);

        }

        this.http.send(param);

    }

    catch (e) {

    }

}, get:function (url) {

    this.domDoc = null;

    try {

        this.http.open("get", url, this.async);

        for (prop in this.header) {

            if (validProp(prop)) {

                this.http.setRequestHeader(prop, this.header[prop]);

            }

        }

        if (this.async) {

            this.http.onreadystatechange = this.onStateChange.bind(this);

            setTimeout(function () {

                this.onStateChange(1);

            }.bind(this), 10);

        }

        this.http.send();

    }

    catch (e) {

    }

}, disconnect:function () {

    if (this.http) {

        this.http.abort();

    }

}, onStateChange:function (readyState) {

    if (typeof (state) == "undefined") {

        readyState = this.http.readyState;

        if (readyState == 1) {

            return;

        }

    }

    var eventPrc = this.event["on" + Ajax.emEvents[readyState]];

    if (valid(eventPrc)) {

        eventPrc(this);

    }

    if (readyState == 4) {

        this.http.onreadystatechange = function () {

        };

    }

}, responseIsSuccess:function () {

    return (this.http.status == undefined || this.http.status == 0 || (this.http.status >= 200 && this.http.status < 300));

}, responseIsFailure:function () {

    return !this.responseIsSuccess();

}, getXMLData:function (tag) {

    if (this.domDoc == null) {

        this.domDoc = this.getXML();

    }

    if (this.domDoc == null) {

        return "";

    }

    var root = this.domDoc.documentElement;

    if (root == null) {

        return "";

    }

    var data = root.getElementsByTagName(tag).item(0);

    if (data) {

        return data.firstChild.nodeValue;

    }

    return "";

}});



/**

 *

 * ??????????IP??????????????????????

 *

 */

function getStreamIP(){



	//var serviceURL = "http://localhost:9081/elms/StreamService";//提供获取最近流媒体IP的服务路径（根据实际情况改动）



	//var serviceURL = "http://course.bjce.gov.cn/relay/StreamService";//提供获取最近流媒体IP的服务路径（根据实际情况改动）



    var serviceURL = "http://coursetest.bjce.gov.cn/elms/StreamService";//提供获取最近流媒体IP的服务路径（根据实际情况改动）



	var http = new Ajax.CRequest(false);

	

	http.post(serviceURL);

	

	return http.getText();

}



//换掉 mms://127.0.0.1/zxxx/ecell.wma 里的IP



function updateIP(oldURL,newIP){

	var ary = oldURL.split("/");

	ary[2] = newIP;

	var newURL = "";

	for(var i=0;i<ary.length;i++){

		if(i!=0){

			newURL += "/"+ary[i];

		}else{

			newURL += ary[i];

		}

	}

	return newURL;

}

