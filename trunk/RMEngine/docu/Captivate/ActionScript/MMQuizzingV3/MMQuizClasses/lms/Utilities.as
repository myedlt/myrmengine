//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

class MMQuizzingV3.MMQuizClasses.lms.Utilities
{

	private var adapterObject:Object;		// Container object or current swf - we need to know/look for URL parameters passed to the SWF.

    function Utilities(_adapterObject:Object)
    {
        //Constructor function
        if(_adapterObject != undefined)
        {
			adapterObject = _adapterObject;
		} else {
			adapterObject = _root;
		}
    }


    function findDomain(serverURL:String, ignorePort_bln:Boolean):String
    {
        // Finds the domain of a URL
        var search_str = "://";
        var domain_str = serverURL;
        var i = domain_str.indexOf(search_str)
        if (i > -1)
        {
            if (domain_str.indexOf("/", i + search_str.length) > 0)
            {
                domain_str = domain_str.substr(i + search_str.length, domain_str.indexOf("/", i + search_str.length) - (i + search_str.length));
            } else {
                domain_str = domain_str.substr(i + search_str.length);
            }
        } else {
            if (domain_str.indexOf("/", 1) > 0)
            {
                domain_str = domain_str.substr(0, domain_str.indexOf("/", 1));
            } else {
                domain_str = domain_str;
            }
        }
        if(ignorePort_bln)
        {
	        var i = domain_str.indexOf(":");
	        if(i > -1)
	        {
				// Strip off the port - assume same domain even though it's on different ports.
				domain_str = domain_str.substring(0,i);
			}
		}
        return domain_str;
    }


    function findProtocol(serverURL:String, localURL:String):String
    {
        // Finds the protocol for a URL
        var search_str = "://";
        var protocolURL = serverURL;
        var i = protocolURL.indexOf(search_str)
        if (i > -1)
        {
            protocolURL = protocolURL.substr(0, i + search_str.length);
            //protocolURL = protocolURL.substr(0, i);
        } else {
            if (localURL == undefined || localURL == "")
            {
                if (serverURL == _url)
                // Error check (don't want to loop indefinitely)
                {
                    protocolURL = "";
                } else {
                    protocolURL = findProtocol(_url);
                }
            } else {
                protocolURL = findProtocol(localURL);
            }
        }
        return protocolURL;
    }


    function getVersionPlayer(type_int:Number)
    {
        var strVersionFull = getVersion();
        var varVersionFull = strVersionFull.split(" ");
        varVersionFull = varVersionFull[1];
        varVersionFull = varVersionFull.split(",");
        if (type_int == undefined)
        {
            return varVersionFull;
        } else {

            return varVersionFull[type_int];
        }
    }

	function findParameter(type_str)
	{
		var this_obj = adapterObject;
		var this_str = this_obj._url
		while(this_obj != undefined && getParameter(type_str, this_str) == "")
		{
			this_obj = this_obj._parent;
			this_str = this_obj._url;
		}
		return this_obj;
	}


    function getParameter(value_str:String, search_var, delimiter_str:String)
    {
        var result_str:String = "";
        var result_obj:Object = new Object();
        var search_obj:Object = new Object();

        if (delimiter_str == undefined)
        {
            delimiter_str = "=";
        }

        if (search_var == undefined || search_var == "")
        {
            search_var = _url;
            search_var = search_var.split("?")[1].split("&");
        } else {
            search_var = search_var;
            if (typeof(search_var) == "string")
            {
                // Look for different delimiters in string
                if (search_var.indexOf("?") != -1 && search_var.indexOf("=") != -1)
                {
                    // looks like URL parameters
                    search_var = search_var.split("?")[1];
                }

                //var temp_array = ["&", "\r\n", "\r", "\n", ",", ";", "="];
                var temp_array = ["&", "\r\n", "\r", "\n", ",", ";"];
                for (var x = 0; x < temp_array.length; x++)
                {
                    if (search_var.indexOf(temp_array[x]) != -1 && search_var.indexOf("=") != -1) {
                        search_obj = search_var.split(temp_array[x]);
                        break;
                    }
                }
                if(x==temp_array.length && search_var.indexOf(delimiter_str) > -1)
                {
					search_obj[0] = search_var;
				}
            }
        }

        for (var param_str in search_obj)
        {
            if ((typeof(search_obj) == "string" || typeof(search_obj) == "object") && search_obj[param_str].indexOf(delimiter_str) != -1)
            {
                if (value_str != undefined && value_str != "")
                {
                    if (unescape(search_obj[param_str].toString().substr(0, search_obj[param_str].indexOf(delimiter_str)).toLowerCase()) == value_str.toLowerCase())
                    {
                        result_str = search_obj[param_str].substr(search_obj[param_str].indexOf(delimiter_str) + 1, search_obj[param_str].length - 1)
                    }
                } else {
                    result_obj[unescape(search_obj[param_str].toString().substr(0, search_obj[param_str].indexOf(delimiter_str)))] = search_obj[param_str].substr(search_obj[param_str].indexOf(delimiter_str) + 1, search_obj[param_str].length - 1)
                }
            } else {
                if (value_str != undefined && value_str != "")
                {
                    if (param_str.toLowerCase() == value_str.toLowerCase() || search_obj[param_str].toLowerCase() == value_str.toLowerCase())
                    {
                        result_str = search_obj[param_str]
                    }
                } else {
                    result_obj[param_str] = search_obj[param_str];
                }
            }
        }
        if (value_str != undefined && value_str != "")
        {
            return result_str;
        } else {
            return result_obj;
        }
    }

	public function getDirectoryPath(p_filepath:String):String
	{
		var i:Number = Math.max(p_filepath.lastIndexOf("/"), p_filepath.lastIndexOf("\\"));
		if (i != -1)
		{
			return p_filepath.substring(0, i);
		} else {
			return p_filepath;
		}
	}

}















