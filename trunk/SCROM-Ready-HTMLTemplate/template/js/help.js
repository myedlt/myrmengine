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
function modeDisplay(){
	var indicatorString='<div id="apiIndicator"  href="#" onMouseDown="turnOn();return false;">';
indicatorString+='<div id="modeExplanationContainer" style="display:none;" onClick="turnOn();">You are in Unscored Mode because you did not enroll in this module through LMS.</br>No score will be recorded in your LMS Transcript but you may use these materials for reference. <\/div>';
indicatorString+='</div>';

   if (parent.APIOK()){

	 // document.getElementById('apiIndicator').style.display='none';
	 // document.getElementById('LMSControls').style.display='block';
   }
   else {
	 	 document.getElementById('LMSControls').innerHTML=('');
         document.getElementById('LMSControls').innerHTML+=(indicatorString);
   }
}

function turnOn() {
    if ( document.getElementById('modeExplanationContainer').style.display == 'block'){
         document.getElementById('modeExplanationContainer').style.display = 'none';
         }
 else {
         document.getElementById('modeExplanationContainer').style.visibility = 'visible';
		 document.getElementById('modeExplanationContainer').style.display = 'block';
                      }
}			  



			 