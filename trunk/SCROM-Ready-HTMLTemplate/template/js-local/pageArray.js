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
-->*/



/*v 1.1 9-28-2007*/

/*To use this file:

Scroll down to the line that starts "var PageArray"
Enter every page of your learning module into the array, just as shown in this example. Be very careful to follow the exact punctuation shown.

   Pages will appear in the order you put them in in the array. Do not list any files external to this module in the array. External files should be hard-coded into the "otherLinks" div in includes/navbar.htm

   The filenames do not have to include numbers, like: "page01.htm", "page02.htm", etc. but can be something descriptive, like "emergencies.htm" or "extinguishers.htm" if you wish. You may arrange them in any order in the array.
   
   If you need to use apostrophe's or quotation marks, you must put a slash first:
                patient's    becomes    patient\'s 

   Chapters are used to divide content into sections. Levels are used to determine both the indent of the text on the button, and also which buttons show up in the navbar at any time. For example, in the setup below if you are currently on any page in Chapter 2, the chapter 2 section of the navbar will be expanded. 

    If you do wish to use the expand/collapse feature, you will need to create intro/title pages for each chapter and include them in the array as the level:1 page for each chapter. All pages except the intro/title page should be level:2 or greater.

   If you do not have any chapters, and want all pages to show up in the nav bar at all times, every page should be set to chapter:0,level:1.

   If you want to use chapters, but want all pages to show up at all times, every page should be set to a chapter number, and level:1

NOTE: If you wish to have different titles in the orange bar on each page than are shown in the buttons, comment out the line (approximately line 113 below) that begins with "writePageTitle" by putting two slash marks at the beginning of the line, like this 
//	writePageTitle();

*/


//this is a list of all the pages, and controls the order they appear. You can put your pages in any order, as long as they are 
//listed here in the order you want.


/*be VERY careful not to delete any commas, single quotes, or other punctuation. Titles can be as long as needed. If you need to use any ' or " marks in the page titles, they must have a back-slash before them: ' becomes \' and " becomes \".

URLs need not be in the form of page01.htm, etc - they can be any relative url - do not put external URLs into this array. 
They can be hardcoded into the "otherLinks" div in navbar.htm.

Array items with levels above '1' will be hidden unless they are in the same chapter as the page you are on. 
If you want everything to always show up, make all array items level 1.
Make the number of chapters match whatever you put into the pageArray below. */
var chapterArray=new Array(
{chapter:0,chapterTitle:' '},
{chapter:1,chapterTitle:' '},
{chapter:2,chapterTitle:' '},
{chapter:3,chapterTitle:' '},
{chapter:4,chapterTitle:' '},
{chapter:5,chapterTitle:' '},
{chapter:6,chapterTitle:' '},
{chapter:7,chapterTitle:' '}
);

var docTitle=('Example of a module containing multiple embedded Perception Quizzes');
var headerTitle=('Module containing multiple Perception Quizzes');
var checkBookmark=0;
 
var PageArray = new Array(  
{buttonTitle:'Competency Criteria', title:' ', url:'page01.htm', chapter:0,level:1 },
{buttonTitle:'Section 1 Intro', title:'',url:'page02.htm',chapter:1,level:1 },
{buttonTitle:'Title goes here', title:'',url:'page03.htm',chapter:1,level:2 },
{buttonTitle:'Title goes here', title:'',url:'page04.htm',chapter:1,level:2 },
{buttonTitle:'Title goes here', title:'',url:'page05.htm',chapter:1,level:2 },
{buttonTitle:'Title goes here', title:'',url:'page06.htm',chapter:1,level:2 },
{buttonTitle:'Title goes here', title:'',url:'page07.htm',chapter:1,level:3 },
{buttonTitle:'Title goes here', title:'',url:'page08.htm',chapter:1,level:3 },
{buttonTitle:'Title goes here', title:'',url:'page09.htm',chapter:1,level:2 },
{buttonTitle:'Quizlet 1', title:'',url:'quizWrap.htm?call=embed&session=5338739740083895&href=http://your.perceptionserver.com/q/session.dll',chapter:1,level:2, quiz:'5338739740083895' },
{buttonTitle:'Title of p.11 goes here', title:'',url:'page10.htm',chapter:1,level:3 },
{buttonTitle:'Section 2 Intro', title:'',url:'page11.htm',chapter:2,level:1 },
{buttonTitle:'Title goes here', title:'',url:'page12.htm',chapter:2,level:2 },
{buttonTitle:'Title goes here', title:'',url:'page13.htm',chapter:2,level:3 },
{buttonTitle:'Title goes here', title:'',url:'page14.htm',chapter:2,level:3 },
{buttonTitle:'Title goes here', title:'',url:'page15.htm',chapter:2,level:3 },
{buttonTitle:'Title goes here', title:'',url:'page16.htm',chapter:2,level:2 },
{buttonTitle:'Section 3 Intro', title:'',url:'page17.htm',chapter:3,level:1 },
{buttonTitle:'Title goes here', title:'',url:'page18.htm',chapter:3,level:2 },
{buttonTitle:'Section 4 Intro', title:'',url:'page19.htm',chapter:4,level:1 },
{buttonTitle:'Section 5 Intro', title:'',url:'page20.htm',chapter:5,level:1 },
{buttonTitle:'Quizlet 2', title:'',url:'quizWrap.htm?call=embed&session=7995334546622398&href=http://your.perceptionserver.com/q/session.dll',chapter:5,level:2, quiz:'7995334546622398' },
{buttonTitle:'References', title:'',url:'page21.htm',chapter:6,level:1 },
{buttonTitle:'>Summary, Score & Finish', title:'',url:'scorePage.htm',chapter:7,level:1 }
//IMPORTANT!!! the last item does NOT get a comma at the end
); //do NOT delete this final punctuation       
//alert('length of array is '+PageArray.length);
//alert(parent.document.location.href);
//alert('location of myStage is'+parent.myStage.document.location.href);

var PageArray2 = new Array(  

{buttonTitle:'Shortened version', title:'',url:'page02.htm',chapter:0,level:1 },
{buttonTitle:'Title goes here', title:'',url:'page03.htm',chapter:2,level:1 },
{buttonTitle:'Title goes here', title:'',url:'page04.htm',chapter:3,level:1 },
{buttonTitle:'Title goes here', title:'',url:'page05.htm',chapter:4,level:1 },
{buttonTitle:'Quizlet 1', title:'',url:'quizWrap.htm?call=embed&session=5338739740083895&href=http://your.perceptionserver.com/q/session.dll',chapter:4,level:2, quiz:'5338739740083895' },
{buttonTitle:'>Summary, Score & Finish', title:'',url:'scorePage.htm',chapter:5,level:1 }
//IMPORTANT!!! the last item does NOT get a comma at the end
); //do NOT delete this final punctuation       
//alert('length of array is '+PageArray.length);
//alert(parent.document.location.href);
//alert('location of myStage is'+parent.myStage.document.location.href);
var PageArray3 = new Array(  
{buttonTitle:'No Quiz version', title:' ', url:'page01.htm', chapter:0,level:1 },
{buttonTitle:'Section 1 Intro', title:'',url:'page02.htm',chapter:1,level:1 },
{buttonTitle:'Title goes here', title:'',url:'page03.htm',chapter:1,level:2 },
{buttonTitle:'Title goes here', title:'',url:'page04.htm',chapter:1,level:2 },
{buttonTitle:'Title goes here', title:'',url:'page05.htm',chapter:1,level:2 },
{buttonTitle:'Title goes here', title:'',url:'page06.htm',chapter:1,level:2 },
{buttonTitle:'Title goes here', title:'',url:'page07.htm',chapter:1,level:3 },
{buttonTitle:'Title goes here', title:'',url:'page08.htm',chapter:1,level:3 },
{buttonTitle:'Title goes here', title:'',url:'page09.htm',chapter:1,level:2 },
{buttonTitle:'Section 2 Intro', title:'',url:'page11.htm',chapter:2,level:1 },
{buttonTitle:'Title goes here', title:'',url:'page12.htm',chapter:2,level:2 },
{buttonTitle:'Title goes here', title:'',url:'page13.htm',chapter:2,level:3 },
{buttonTitle:'Title goes here', title:'',url:'page14.htm',chapter:2,level:3 },
{buttonTitle:'Title goes here', title:'',url:'page15.htm',chapter:2,level:3 },
{buttonTitle:'Title goes here', title:'',url:'page16.htm',chapter:2,level:2 },
{buttonTitle:'Section 3 Intro', title:'',url:'page17.htm',chapter:3,level:1 },
{buttonTitle:'Title goes here', title:'',url:'page18.htm',chapter:3,level:2 },
{buttonTitle:'Section 4 Intro', title:'',url:'page19.htm',chapter:4,level:1 },
{buttonTitle:'Section 5 Intro', title:'',url:'page20.htm',chapter:5,level:1 },
{buttonTitle:'References', title:'',url:'page21.htm',chapter:6,level:1 }
//IMPORTANT!!! the last item does NOT get a comma at the end
); //do NOT delete this final punctuation       
//alert('length of array is '+PageArray.length);
//alert(parent.document.location.href);
//alert('location of myStage is'+parent.myStage.document.location.href);
