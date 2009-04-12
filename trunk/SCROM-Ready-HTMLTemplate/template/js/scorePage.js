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

//v 1.1 emeiselm 11-1-07  
//functions for scorePage.htm

function checkAPI(){
if (!parent.APIOK()){
	var msgWin= document.getElementById('quizMessages');
	msgWin.innerHTML=('Quizzes only run when you access this module through the LMS.');
	msgWin.innerHTML+=('<a href="top.window.close();">Close module</a>')
	return; 
	}
}


function scoreQuizzes(){  
parent.data.scoreQuizzes(); 
}
