//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

class MMQuizzingV3.MMQuizClasses.lms.Response
{
	private var _timeout:Number = 5000;
	private var _interval:Number = 100;
	private var _obj:Object;
	private var _array:Array;
	private var _array_str:String;

	private var _useGlobalResponse_bln:Boolean;

	// constructor function
	function Response(_globalObject:Object)
	{
		if(_globalObject != undefined)
		{
			setGlobalResponse(true);
			_obj = _globalObject;
			_array_str = "globalResponse_array";
			if (_obj[_array_str] == undefined)
			{
				_obj.globalResponse_array = [];
			}
		} else {
			setGlobalResponse(false);
			_obj = this;
			_array_str = "_array";
			_array = [];
		}
	}


	function waitForResponse(variable_str, variableDefault_var, this_obj, function_str, functionParam1_var, functionParam2_var, functionParam3_var, functionParam4_var, timeout_var)
	{
		var arrayLength_int = _obj[_array_str].length;
		if (timeout_var != undefined)
		{
			// Let's see if timeout_var is a number or a value to be evaluated
			if (typeof timeout_var == "string")
			{
				timeout_var = eval(timeout_var);
			}
			// Let's see if timeout_var is less than the current timer...
			if (timeout_var < getTimer())
			{
				timeout_var = timeout_var + getTimer();
			}
		} else {
			timeout_var = _timeout + getTimer();
		}
		_obj[_array_str][arrayLength_int] = setInterval(checkResponse, _interval, variable_str, variableDefault_var, this_obj, function_str, functionParam1_var, functionParam2_var, functionParam3_var, functionParam4_var, timeout_var, arrayLength_int, this);
	}

	function checkResponse(variable_str, variableDefault_var, this_obj, function_str, functionParam1_var, functionParam2_var, functionParam3_var, functionParam4_var, timeout_var, arrayLength_int, response_obj) {
		if (variable_str.indexOf(".")>0) {
			var variableOriginal_str = variable_str;
			var refOriginal_obj = this_obj;
			var ref_obj = eval(variable_str.substr(0, variable_str.indexOf(".")));
			variable_str = variable_str.substr(variable_str.indexOf(".")+1);
		} else {
			var ref_obj = this_obj;
		}
		if (typeof ref_obj[variable_str] == "function") {
			var response_var = ref_obj[variable_str]();
		} else if (typeof this[variable_str] == "function") {
			var response_var = this[variable_str]();
		} else {
			if (typeof this_obj[ref_obj][variable_str] != "undefined") {
				var response_var = this_obj[ref_obj][variable_str];
			} else if (typeof ref_obj[variable_str] != "undefined") {
				var response_var = ref_obj[variable_str];
			} else {
				if (typeof refOriginal_obj[variableOriginal_str]!= "undefined") {
					var response_var = refOriginal_obj[variableOriginal_str];
				} else if (typeof eval(variableOriginal_str) != "undefined") {
					var response_var = eval(variableOriginal_str);
				} else {
					var response_var = eval(variable_str);
				}
			}
		}
		if (response_var != variableDefault_var || timeout_var <= getTimer()) {
			clearInterval(response_obj._obj[response_obj._array_str][arrayLength_int]);
			if(function_str.indexOf(".")>0) {
				var func_obj = function_str.substr(0,function_str.indexOf("."));
				function_str = function_str.substr(function_str.indexOf(".")+1);
			} else {
				var func_obj = this_obj;
			}
			if (typeof func_obj[function_str] == "function") {
				func_obj[function_str](functionParam1_var, functionParam2_var, functionParam3_var, functionParam4_var);
			} else if (typeof this[function_str] == "function") {
				this[function_str](functionParam1_var, functionParam2_var, functionParam3_var, functionParam4_var);
			} else if (typeof this_obj[func_obj][function_str] == "function") {
				this_obj[func_obj][function_str](functionParam1_var, functionParam2_var, functionParam3_var, functionParam4_var);
			} else {
				this_obj[function_str](functionParam1_var, functionParam2_var, functionParam3_var, functionParam4_var);
			}
		}
	}

	function getResponseLength()
	{
		return _obj[_array_str].length;
	}

	function setResponseTimeOut(timeoutLimit_int)
	{
		_timeout = timeoutLimit_int;
	}

	function getResponseTimeOut()
	{
		return _timeout;
	}

	function setResponseInterval(interval_int)
	{
		_interval = interval_int;
	}

	function getResponseInterval()
	{
		return _interval;
	}

	function isGlobalResponse():Boolean
	{
		return _useGlobalResponse_bln;
	}

	function setGlobalResponse(value_bln):Void
	{
		_useGlobalResponse_bln = value_bln;
	}
}