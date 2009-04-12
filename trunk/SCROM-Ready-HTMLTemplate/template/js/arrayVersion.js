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
// this uses the module version set by "setVersn()" to choose a PageArray, redraw the navbar and go to the appropriate page

var cookieVrsn=parent.ReadCookie('cVrsn');
var zVrsn1=parent.zVrsn;
 
 function detArrayVrsn(){//this is included in dummypage.htm and uses cookieVrsn to set the correct PageArray.
//if a cookie exists and it does not equal 1
  if ((cookieVrsn!=null)&&(cookieVrsn!="undefined")&&(cookieVrsn!="")&&(cookieVrsn>1)){//if cookieVrsn exists and is > 1
 	 //set PageArray to whichever PageArray matches that number
	 window.PageArray=window.eval('PageArray'+cookieVrsn);//eval function necessary to convert string to variable  
	 }//end if
	 else { //else use the default one
	  window.PageArray=window.eval('PageArray');
	   parent.SetCookie('cVrsn',"",-1);//expire the cookie
	
	  }//end else
	
 	
 if ((parent.justOpened==1)&&(parent.myStage.location.href!=PageArray[0].url)){ //if module was just opened
	parent.myStage.location.href = parent.zurl?parent.zurl:('../'+PageArray[0].url); //change this page to the first page of the correct pageArray
	 parent.justOpened=0;//so it won't keep switching pages to page[0].	 
  }//end if
}//end function detArrayVrsn

	detArrayVrsn();