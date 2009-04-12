//version 1.2 10-4-07 emeiselm

var quiz;//is this page a quiz or not?  
var qScore;
var qMax;
var unfinQz='<br><ul>';
var iStatus='';//used to store whether all quizzes are done yet
var btnImg;

//var courseStructure=top.API_extensions.gSCOCourseStructure  //added 10-7
function chooseBtn(){
	 
		if(top.API_extensions.gSCOCourseStructure.getNextSCO().index>0){
			btnImg=('nextModule');
			return;
			}
		else{btnImg=('closeWindow');
		return;}
		
 
}

function closeIfLastSCO(){  

var courseStructure=top.API_extensions.gSCOCourseStructure
	if(courseStructure.getNextSCO().index>0){
		courseStructure.changeSCOContent(courseStructure.getNextSCO(),parent.frames[0]);
		}
	else{top.window.close();}
}
function setupQuizzes(){
   for(var i=0; i< PageArray.length; i++) { 
	 if (PageArray[i].quiz){ 
		 var q =      PageArray[i];
		 var objectiveID=('Q'+q.quiz);
		 //var qScore;
	     var objMax = (parent.SCOGetObjectiveData(objectiveID, "score.max"))?(parent.SCOGetObjectiveData( objectiveID, "score.max")):'';
		 var objScore = (parent.SCOGetObjectiveData(objectiveID, "score.raw"))?(parent.SCOGetObjectiveData( objectiveID, "score.raw")):'';
		  q.qScore = objScore?(objScore):'';
		  qScore=q.qScore; 
		
		if (objMax){
			q.qMax=parseInt(objMax,10);}
		  qMax=q.qMax; 
		  document.getElementById('output').innerHTML +=(i+': '+' objMax= '+objMax+', objScore= '+objScore+', title= '+q.buttonTitle+', qMax='+qMax+', qScore='+qScore+'<br>');
		  
		 }//end ifquiz
		 
   } //end for (var...
    	 
 } //end setupQuizzes function
  
 //**********************************//
 function wait(){}
 


function showProgressMsg(){
var progWin=parent.myStage.document.getElementById('quizProgress');	
progWin.style.display="block";

if ( !progWin.style.top>0){ 
progWin.style.display="block";
}
  else{ }
}



function scoreQuizzes(){ //do this at the end, and maybe replace with a function that adds up the scores from the db
var progWin=parent.myStage.document.getElementById('quizProgress');
var msgWin= parent.myStage.document.getElementById('quizMessages');
if (parent.APIOK()){  //added 10-7
btnImg = chooseBtn();

			 progWin.style.display="block";
			    
				var sMasteryScore = parent.SCOGetValue("cmi.student_data.mastery_score");
				var iMasteryScore = parseInt(sMasteryScore,10);				
				var totalmaxRawScore= 0; //total points possible -sent by questionmark upon finishing each quiz
				var totalRawScore = 0;//total of all quizzes in points
				var totalPercentScore=0; //total of all points received divided by totalmaxRawScore
				var unfinQz='<br>'; 
				document.getElementById('output').innerHTML +=('sMasteryScore= '+sMasteryScore+'<br>');
				document.getElementById('output').innerHTML +=('iMasteryScore= '+iMasteryScore+'<br>');
				document.getElementById('output').innerHTML +=('iStatus= '+iStatus+'<br>');
				document.getElementById('output').innerHTML +=('totalmaxRawScore= '+totalmaxRawScore+'<br>');
				document.getElementById('output').innerHTML +=('totalmaxRawScore= '+totalRawScore+'<br>');
				document.getElementById('output').innerHTML +=('totalPercentScore= '+totalPercentScore+'<br>');
				//	 
//////////////////////////////	
	
	
	  	
	 for(var i=0; i< PageArray.length; i++) { //loop thru all pages
               var q = PageArray[i]; 
			   if(q.quiz){ //if this page is a quiz
			   var objectiveID=('Q'+q.quiz);
			   objMax = (parent.SCOGetObjectiveData(objectiveID, "score.max"))?parseInt(parent.SCOGetObjectiveData( objectiveID, "score.max"),10):'';
			   objScore = (parent.SCOGetObjectiveData(objectiveID, "score.raw"))?(parent.SCOGetObjectiveData( objectiveID, "score.raw")):'';			   
			   q.qScore = objScore?(objScore):'';				
			   qScore=(q.qScore);  
		 
		       
			   if(objScore){
				unfinQz +=('<li>You scored '+qScore +' out of '+ objMax+' on page '+(i+1)+'. <a href="javascript:takeItAnyway();" style="color:#DC2F44">Try again? >></a><br>');   
			   }
 
			   if (!objScore){ 
 
                 unfinQz += ('<li>You have not completed the quiz on page '+(i+1)+' <a href=\"'+q.url+'\">Go there now!</a><br>');
			      iStatus = 'incomplete'				 
				  }//end if ((qScore=='')||...
		     
	  else if (objMax){ q.qMax=objMax;}   
		         qMax= (q.qMax);
				 totalmaxRawScore+=(qMax);
				 totalRawScore +=parseFloat(qScore);
		 // for testing 
		  document.getElementById('output').innerHTML +=('-'+i+': objMax= '+objMax+'typeOf objMax='+(typeof objMax)+', objScore= '+objScore+'typeOf objScore='+(typeof objScore)+',  qMax='+qMax+', qScore='+qScore+', totalmaxRawScore so far='+ totalmaxRawScore+', totalRawScore so far= '+ totalRawScore+', iStatus='+iStatus+'<br>');
		     
			 }//end if q.quiz  
	   }//end page loop 
	   
	    //********************figure out overall status and total score*******//
	  //if the status is not incomplete
			if (iStatus != 'incomplete'){	  
	  //and, if there isn't a mastery score we aren't gonna bother with the scores - just set it to completed no matter what.
				if (isNaN(iMasteryScore)) { 
				parent.SCOSetValue("cmi.core.score.raw", totalPercentScore+'' ); //send raw score
				parent.SCOSetValue( "cmi.core.lesson_status", "completed" ); 
				alert('there is no mastery score set in MLearning. Module completed.');
				} 
				else { //or, if there IS a mastery score : score pass/fail
				 //first determine and then set the percent score in mlearning
				 totalPercentScore=Math.round((totalRawScore/totalmaxRawScore)*100);   
				 parent.SCOSetValue("cmi.core.score.raw", totalPercentScore+'' ); 
					 //if failed set status to failed
				(iMasteryScore > totalPercentScore)?( parent.SCOSetValue( "cmi.core.lesson_status", "failed" ),iStatus="failed"):(parent.SCOSetValue( "cmi.core.lesson_status", "passed" ),iStatus="passed");//end else there IS a mastery score
				
				 msgWin.innerHTML +=(unfinQz);
				 msgWin.innerHTML +=('<br><br><span class="iStatusMsg" style="font-size:20px;color:red;">'+iStatus+'</span><br>' );
				 msgWin.innerHTML +=('<ul><li>You scored <b>' + totalRawScore+' point(s)</b> out of a possible <b>'+ totalmaxRawScore+'</b>.<br>');
				 msgWin.innerHTML +=('<li>Your total score for this module is <b>');
				 msgWin.innerHTML +=(totalPercentScore+'%</b>.<br> This module requires <b>'+iMasteryScore+ '%</b> to pass.</li></ul>' );
					 msgWin.innerHTML +=('<p>You may improve your score by taking any quiz again, until you finalize the score by  clicking the "Send score to MLearning" button below.</p>' );
				 msgWin.innerHTML +=('<p><a href="javascript:window.print();"  id="printScoreBtn" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage(\'printPage\',\'\',\'images/quiz/over/printPage.jpg\',1)"><img src="images/quiz/up/printPage.jpg" alt="close window"  width="155" height="48" border="0" name="printPage" id="printPage" style="float:left;margin:12px;"/></a></p>');
				 msgWin.innerHTML +=('<p><a href="javascript: parent.SCOFinish();closeIfLastSCO();"  onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage(\''+btnImg+'\',\'\',\'images/quiz/over/'+btnImg+'.jpg\',1)"><img src="images/quiz/up/nextModule.jpg" alt="close window"  width="155" height="48" border="0" name="nextModule" id="nextModule"  style="float:left;margin:12px;"/></a></p>');
				
				}//end else there IS a mastery score
			}//end if iStatus is not incomplete
	   //iStatus IS incomplete: set status to incomplete and alert to missing quizzes		 
		else if(iStatus=='incomplete'){ 
		    parent.SCOSetValue( "cmi.core.lesson_status", "incomplete" ); 
			
			    // msgWin.innerHTML =(' <div id="msgcloser"><a href="javascript:parent.data.closeMsg();">[X] Click to close</a></div>');
				 msgWin.innerHTML +=('<br><br><span class="iStatusMsg" style="font-size:20px;color:red;">'+iStatus+'</span><br>' );
				 msgWin.innerHTML +=(unfinQz+'</ul><br><a href="javascript:top.window.close();" style="color:red">Want to close and continue later? CLICK HERE</a>.<br> ');
				 msgWin.innerHTML +=('<b style="color:red;">This module will not be marked Complete until all the quiz pages are completed.</b><br> ');
				
	
			}//end iStatus IS incomplete - set incomplete status in mlearning
		    
		parent.SCOCommit();//commit data to db
		 
		//parent.myStage.document.getElementById('rightColumn').innerHTML+=(''+unfinQz+'. <a href="javascript:something();">Click here to close the module</a> and come back later.');
	// for testing  
	            document.getElementById('output').innerHTML +=('sMasteryScore= '+sMasteryScore+'<br>');
				document.getElementById('output').innerHTML +=('iMasteryScore= '+iMasteryScore+'<br>');
				document.getElementById('output').innerHTML +=('iStatus= '+iStatus+'<br>');
				document.getElementById('output').innerHTML +=('totalmaxRawScore= '+totalmaxRawScore+'<br>');
				document.getElementById('output').innerHTML +=('totalRawScore= '+totalRawScore+'<br>');
				document.getElementById('output').innerHTML +=('totalPercentScore= '+totalPercentScore+'<br>');	
				//parent.myStage.document.getElementById('quizProgress').style.display="none";
				
				
				 msgWin.style.display='block';
				progWin.style.display="none";
				 }//end if parent.APIOK();
 else { msgWin.innerHTML +=('LMS not detected');
 msgWin.style.display='block';}
 }//end scoreQuizzes function
  
function closeMsg(){   
 parent.myStage.document.getElementById('quizMessages').style.display='none';
  
  }