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

//v 1.1 10-8-07 emeiselm
//if we aren't in SCORM mode, and this page is not in a frame, open the frameset, and add the current location to the query string.
 function wrapMe(){ //this gets called by each content page to check if it is wrapped or not.
            //alert('running wrapMe()');
			//if (!parent.APIOK()&&(self.location.href == top.location.href)) { 
			 if (self.location.href == top.location.href){
			   top.location.href = 'index.htm?zurl=' + self.location.href;			   
			}
 }
 
 
function setFrameSrc() {	//this gets called on the index page
justOpened=0;
   var zurl=(qsParm['zurl']);
   if((!APIOK())&&zurl){	//if you're not under scorm, and a new url is specified (zurl parameter in query string)...

//add something to check that the page is indeed part of the page array of the current version.
				
				//self.html.innerHTML=(''); //wipe out the html on index.htm and replace with...
					document.writeln('<frameset rows=\"100%,*\" id=\"moduleFrameset\" onunload=\"completeIfLastPage()\" onbeforeunload=\"completeIfLastPage()\"  >');
					document.writeln('<frame name=\"myStage\" id=\"myStage\" src=\"'+zurl+'\" \/>');
					document.writeln('<frame name=\"data\" id=\"data\" src=\"includes/dummypage.htm\" \/>');
					document.writeln('<noframes>');
					document.writeln('<body>');
					document.writeln('<p>Note that this site requires a browser that supports frames.<\/p>');
					document.writeln('<\/body>');
					document.writeln('<\/noframes>');
					document.writeln('<\/frameset>'); 
				  }//end if(!parent.APIOK())
}//end setFrameSrc




