//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

dynamic class MMQuizzingV3.MMQuizClasses.lms.AICCLoadVars extends LoadVars
{
    var command:String;
    var version:String;
    var session_id:String;
    var aicc_data:String;
    var tracking:String;
    var escapeAICCvs_bln:Boolean;
    var ignoreEscapeList_str:String = "";


	// Constructor Function
	function AICCLoadVars(_escapeAICCvs_bln:Boolean, _ignoreEscapeList_str:String)
	{
		if(_escapeAICCvs_bln != undefined)
		{
			escapeAICCvs_bln = _escapeAICCvs_bln;
		}
		if(_ignoreEscapeList_str != undefined)
		{
			ignoreEscapeList_str = _ignoreEscapeList_str;
		}
	}


    // ******************************************************************
    // *
    // *     Method:           serverPost.toString
    // *     Description:      Overrides the default toString of LoadVars
    // *                       function, so that it does't URL-encode the
    // *                       "name".
    // *     Returns:
    // *
    // ******************************************************************
    function toString():String
    {
        var result_str = [];
        for (var x in this)
        {
            if (x != "onLoad" && x!= "toString" && x!= "parent" && x != "tracking" && x != "escapeAICCvs_bln" && x != "ignoreEscapeList_str")
            {
				if(!escapeAICCvs_bln && (x == "version" || x == "session_id"))
				{
					result_str.push(x + "=" + this[x]);
				} else {
					if(ignoreEscapeList_str != "")
					{
						// do something;
						var temp_str = "";
						// Loop through the entire string, one character at a time
						for(var temp_int = 1; temp_int < this[x].length + 1; temp_int++)
						{
							// Grab each character
							var tempChar_str = this[x].substring(temp_int-1, temp_int);
							// If the character is in the list to ignore - we won't escape it
							if(ignoreEscapeList_str.indexOf(tempChar_str) > -1)
							{
								temp_str += tempChar_str;
							} else {
								temp_str += escape(tempChar_str);
							}
						}
						result_str.push(x + "=" + temp_str);
					} else {
		                result_str.push(x + "=" + escape(this[x]));
					}
				}
            }
        }

        return result_str.join('&');
    }

}