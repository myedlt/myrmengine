//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

class MMQuizzingV3.MMQuizClasses.lms.Queue
{
	private var _useGlobalQueue_bln:Boolean;
	private var _queueBusy_bln:Boolean;
	private var _queueArray_str:String;
	private var _queueBusy_str:String;
	private var _queue_array:Array;
	private var _queueTimeoutInterval_int:Number = 5;			// Number of seconds to wait for a response in the queue
	private var _queuePollingInterval_int:Number = .10;			// Number of seconds to poll for a response in the queue
	private var _scope_obj:Object

	function Queue(_globalObject:Object)
	{
		// constructor function
		if (_globalObject != undefined)
		{
			useGlobalQueue_bln = true;
			_scope_obj = _globalObject;
			_queueArray_str = "globalQueue_array";
			_queueBusy_str = "globalQueueBusy_bln";
			if (_scope_obj[_queueArray_str] == undefined)
			{
				_scope_obj.globalQueue_array = [];
				_scope_obj.globalQueueBusy_bln = false;
			}
		} else {
			useGlobalQueue_bln = false;
			_scope_obj = this;
			_queueArray_str = "_queue_array";
			_queueBusy_str = "_queueBusy_bln";
			_queue_array = [];
		}
	}


	function isGlobalQueue():Boolean
	{
		return useGlobalQueue_bln;
	}

	// Public Getter/Setter properties
	public function get useGlobalQueue_bln():Boolean
	{
		return _useGlobalQueue_bln;
	}
	public function set useGlobalQueue_bln(_isGlobalQueue_bln:Boolean)
	{
		_useGlobalQueue_bln = _isGlobalQueue_bln;
	}
	public function get queueTimeoutInterval_int():Number
	{
		return _queueTimeoutInterval_int;
	}
	public function set queueTimeoutInterval_int(_timeout_int:Number):Void
	{
		_queueTimeoutInterval_int = _timeout_int;
	}
	public function get queuePollingInterval_int():Number
	{
		return _queuePollingInterval_int;
	}
	public function set queuePollingInterval_int(_polling_int:Number):Void
	{
		_queuePollingInterval_int = _polling_int;
	}

	// Public SET functions
	public function setQueueTimeoutInterval(_timeout_int:Number):Void
	{
		queueTimeoutInterval_int = _timeout_int;
	}
	public function setQueuePollingInterval(_polling_int:Number):Void
	{
		queuePollingInterval_int = _polling_int;
	}

	// Public GET functions
	public function getQueueTimeoutInterval():Number
	{
		return queueTimeoutInterval_int;
	}
	public function getQueuePollingInterval():Number
	{
		return queuePollingInterval_int;
	}

	function waitForQueue(this_obj, _queueTimer_int)
	{
		if(getTimer() > _queueTimer_int)
		{
			this_obj.removeFromQueue();
		}
		this_obj.checkQueue();
	}


    function addToQueue(target_obj, method_str, parameters_var, waitForResponse_bln:Boolean, checkForQueue_bln:Boolean):Array
    {
		var arrayLength_int = _scope_obj[_queueArray_str].length;
		_scope_obj[_queueArray_str][arrayLength_int] = new Object();
		_scope_obj[_queueArray_str][arrayLength_int].target_obj = target_obj;
		_scope_obj[_queueArray_str][arrayLength_int].method_str = method_str;
		_scope_obj[_queueArray_str][arrayLength_int].parameters_var = parameters_var;
		_scope_obj[_queueArray_str][arrayLength_int].waitForResponse_bln = waitForResponse_bln;
		_scope_obj[_queueArray_str][arrayLength_int].interval_var = undefined;
		if(checkForQueue_bln == undefined || checkForQueue_bln == true)
		{
	        checkQueue();
		}
        return _scope_obj[_queueArray_str];
    }


    function removeFromQueue():Object
    {
		if(_scope_obj[_queueArray_str][0].interval_var != undefined)
		{
			clearInterval(_scope_obj[_queueArray_str][0].interval_var);
		}
		_scope_obj[_queueArray_str].shift();
		_scope_obj[_queueBusy_str] = false;

        checkQueue();

        return _scope_obj[_queueArray_str];
    }

    function clearQueue()
    {
		_scope_obj[_queueArray_str] = [];
		return _scope_obj[_queueArray_str];
    }

    function checkQueue()
    {
		var temp_bln = _scope_obj[_queueBusy_str];

    	if (temp_bln)
    	{
			// Do Nothing
 		} else {
			var length_int = _scope_obj[_queueArray_str].length;
        	if (length_int > 0)
        	{
				// Set queue busy
				_scope_obj[_queueBusy_str] = true;
				var _target_obj = _scope_obj[_queueArray_str][0].target_obj
				var _method_str = _scope_obj[_queueArray_str][0].method_str;
				var _parameters_var = _scope_obj[_queueArray_str][0].parameters_var;
				var _waitForResponse_bln = _scope_obj[_queueArray_str][0].waitForResponse_bln
				if(_waitForResponse_bln || _waitForResponse_bln == undefined)
				{
					// We set the interval BEFORE calling the function, just in case the function clears the queue.
					var queueTimer_int = getTimer() + (queueTimeoutInterval_int * 1000);
					_scope_obj[_queueArray_str][0].interval_var = setInterval(waitForQueue, queuePollingInterval_int * 1000, this, queueTimer_int);
				}
				if (_parameters_var != undefined)
				{
					_target_obj[_method_str](_parameters_var);
				} else {
					_target_obj[_method_str]();
				}
				if (!_waitForResponse_bln && _waitForResponse_bln != undefined)
				{
					removeFromQueue();
				}
			}
		}
	}

}