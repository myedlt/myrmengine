//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

import MMQuizzingV3.MMQuizClasses.lms.Queue;
import MMQuizzingV3.MMQuizClasses.lms.Utilities;

class MMQuizzingV3.MMQuizClasses.lms.domainPolicy
{

    var queue_obj : Object;
    var utilitiesURL:Utilities;
    var queue_array:Queue;
    var _remotePolicyXML:String;

    function domainPolicy(_adapterObject:Object)
    {
        //Constructor function
        queue_obj = [];
        queue_array = new Queue(_adapterObject);
        utilitiesURL = new Utilities(_adapterObject);
    }

    function checkServerPolicy(remoteURL:String, localURL:String):Boolean
    {
        // This function checks the server policy file
        var temp_int = -1;
        for (var x in queue_obj)
        {
            // look for existing request.  We need to know if this is a status check; or a first request
            if (queue_obj[x].remoteURL.toLowerCase() == remoteURL.toLowerCase() && queue_obj[x].localURL.toLowerCase() == localURL.toLowerCase())
            {
                // existing request - return status
                temp_int = x;
            }
        }

        if (temp_int == -1)
        {
            // new request
            // add to local queue object, so we know the status;
            temp_int = queue_obj.length;
            queue_obj[temp_int] = new Object();
            queue_obj[temp_int].thisReference = this;
            queue_obj[temp_int].queue_int = temp_int;
            queue_obj[temp_int].remoteURL = remoteURL;
            queue_obj[temp_int].localURL = localURL;
            queue_obj[temp_int].remotePolicyXML = _remotePolicyXML;
            queue_obj[temp_int].status_bln = undefined;

            // add to queue
            queue_array.addToQueue(this, "getDomainPolicy", queue_obj[temp_int], true);
        }

        return queue_obj[temp_int].status_bln;
    }

    function getDomainPolicy(domainPolicy_obj):Boolean
    {
        var _serverPolicy_bln:Boolean = null;
        var _getDomainPolicy = this;
        var _queue_int = domainPolicy_obj.queue_int;
        var _localURL = domainPolicy_obj.localURL;
        var _remoteURL = domainPolicy_obj.remoteURL;
        var _remotePolicyXML = domainPolicy_obj.remotePolicyXML;

        function setDomainPolicy(value_bln):Void
        {
            _serverPolicy_bln = value_bln;
            _getDomainPolicy.queue_obj[_queue_int].status_bln = value_bln;
        }

        if (_localURL == undefined)
        {
            _localURL = _url;
        }
        if (utilitiesURL.findDomain(_remoteURL, true).toLowerCase() == utilitiesURL.findDomain(_localURL, true).toLowerCase())
        {
            // Matching (return true);
            setDomainPolicy(true);
        } else if (utilitiesURL.getVersionPlayer(0) < 7) {
            // Flash Player 6 doesn't support Policy Files (look for N-1 matching)
            var remoteDomain = utilitiesURL.findDomain(_remoteURL, true);
            var localDomain = utilitiesURL.findDomain(_localURL, true);
            remoteDomain = remoteDomain.split(".");
            localDomain = localDomain.split(".");
            var temp_bln = true
            if (remoteDomain.length == localDomain.length)
            {
                for (var subDomain = 1; subDomain < remoteDomain.length; subDomain++)
                {
                    if (Number(remoteDomain[subDomain]) == remoteDomain[subDomain])
                    {
                        temp_bln = false;
                        break;
                    } else {
                        if (remoteDomain[subDomain].toLowerCase() != localDomain[subDomain].toLowerCase())
                        {
                            temp_bln = false;
                        }
                    }
                }
            } else {
                temp_bln = false;
            }
            setDomainPolicy(temp_bln);
        } else {
            // Not matching (try to read policy file)
            var domainPolicyXML = new XML();
            domainPolicyXML.onData = function (data)
            {
                if (data == undefined)
                {
                    setDomainPolicy(false);
                } else {
                    setDomainPolicy(true);
                }
                _getDomainPolicy.queue_array.removeFromQueue();
            }

            if (_remotePolicyXML != undefined && utilitiesURL.getVersionPlayer(0) > 6 && utilitiesURL.getVersionPlayer(2) > 14)
            {
                // set policy file location (if not standard location)
                var _remotePolicyXML_array = _remotePolicyXML.split(";")
                for (var i = 0;i < _remotePolicyXML_array.length;i++)
                {
                    System.security.loadPolicyFile(_remotePolicyXML_array[i]);
                    domainPolicyXML.load(_remotePolicyXML_array[i]);
                }
			} else {
				domainPolicyXML.load(utilitiesURL.findProtocol(_remoteURL, _localURL) + utilitiesURL.findDomain(_remoteURL) + "/crossdomain.xml");
            }
        }
        if (_serverPolicy_bln == null)
        {
            return undefined;
        } else {
			queue_array.removeFromQueue();
            return _serverPolicy_bln;
        }
    }


	function setRemotePolicyXML(remotePolicyXML:String, serverURL:String)
	{
		if(remotePolicyXML.substr(0,1) == "/") {
			if(serverURL == undefined) {
				serverURL = _url;
			}
			_remotePolicyXML = utilitiesURL.findProtocol(serverURL) + utilitiesURL.findDomain(serverURL) + remotePolicyXML;
		} else {
			_remotePolicyXML = remotePolicyXML;
		}
	}

	function getRemotePolicyXML():String
	{
		return _remotePolicyXML;
	}

}















