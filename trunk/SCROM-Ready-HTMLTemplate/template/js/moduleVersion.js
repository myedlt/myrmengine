/*<!--SCORM-Compatible Learning Module Template.

written by Ellen Meiselman © 2006, 2007

http://thedesignspace.net



    This file is part of the SCORM-Compatible Learning Module Template.



    The SCORM-Compatible Learning Module Template is free software; you can redistribute it and/or modify

    it under the terms of the GNU General Public License as published by

    the Free Software Foundation; either version 3 of the License, or

    (at your option) any later version.



    The SCORM-Compatible Learning Module Template  is distributed in the hope that it will be useful,

    but WITHOUT ANY WARRANTY; without even the implied warranty of

    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

    GNU General Public License for more details.



    You should have received a copy of the GNU General Public License

    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->
*/


//this gets included in "index.htm"
//it checks the url for a parameter "vrsn" and sends the correct variable value to the page "dummypage.htm" where it is used by the function  detArrayVrsn()
 
var cookieVrsn;
    
function setVrsn(){//sets cookie and persistent variable to correct version

	     zVrsn=qsParm['vrsn'];//get the parameter vrsn from the url
	 //"vrsn" parameter WAS specified 
   if (qsParm['vrsn']!=null){	  
        if(cookieVrsn!=zVrsn){ // and, if the current variable cookievrsn1 doesn't equal the parameter 'vrsn'	        
            SetCookie('cVrsn',zVrsn,1);//set the cookie cVrsn to whatever the new version is supposed to be
            cookieVrsn=ReadCookie('cVrsn');//set cookieVrsn1 to that version also	  
        	return cookieVrsn }//end if cookieVrsn1!
	  
	  //"vrsn" parameter WAS NOT specified
	 else if (qsParm['vrsn']==null){ //but if there is no param vrsn we want to use the default array so set to 1
	   if ((cookieVrsn!=null)&&(cookieVrsn!="undefined")&&(cookieVrsn!="")&&(cookieVrsn>1)){//and if current var was not yet set to 1
			 cookieVrsn=null; //set the var to 1
			 SetCookie('cVrsn',"",-1);//and expire the cookie
						} //end if ((cookieVrsn1
 	 }//end else if(qsParm
   }//end if (qsParm[v
}//end function detrmnVrsn

setVrsn();

  
