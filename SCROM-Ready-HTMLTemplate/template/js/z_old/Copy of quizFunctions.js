var quiz;//is this page a quiz or not?  
var qScore;
var qMax;
var unfinQz='<br>';
var iStatus='';//used to store whether all quizzes are done yet
function setupQuizzes(){
   for(var i=0; i< PageArray.length; i++) { 
	 if (PageArray[i].quiz){ 
		 var q =      PageArray[i];
		 var objectiveID=('Q'+q.quiz);
		 //var qScore;
	     var objMax = (parent.SCOGetObjectiveData(objectiveID, "score.max"))?(parent.SCOGetObjectiveData( objectiveID, "score.max")):'';
		 var objScore = (parent.SCOGetObjectiveData(objectiveID, "score.raw"))?(parent.SCOGetObjectiveData( objectiveID, "score.raw")):'';
		  q.qScore = objScore?(objScore):'';
			/*if (objScore){ 
			//alert('objScore exists'+objScore);
					alert('q.qScore inside if= '+q.qScore);
			q.qScore = parseFloat(objScore);
			}*/
		  qScore=q.qScore; 
		//alert('q.qScore= '+q.qScore);
		//if ( (objMax!='')&&(objMax!=NaN)&&(objMax!='(null)')&&(objMax!=null) ){qMax=objMax;}
		if (objMax){
			
			q.qMax=parseInt(objMax,10);}
		  qMax=q.qMax;
		// var qScore = ((objScore!='')&&(objScore!=NaN)&&(objScore!='(null)')&&(objScore!=null))?objScore:q.qScore;
		// var qMax   = ((objMax!='')&&(objMax!=NaN)&&(objMax!='(null)')&&(objMax!=null))?objMax:q.qMax;
		  document.getElementById('output').innerHTML +=(i+': '+' objMax= '+objMax+', objScore= '+objScore+', title= '+q.buttonTitle+', qMax='+qMax+', qScore='+qScore+'<br>');
		  
		 }//end ifquiz
		 
   } //end for (var...
    	 
 } //end setupQuizzes function
  
 //**********************************//
 function wait(){}
 


function showProgressMsg(){
var progWin=parent.myStage.document.getElementById('quizProgress');	
progWin.style.display="block";
//parent.myStage.document.getElementById('quizMessages').style.display="block";
if ( !progWin.style.top>0){ 
progWin.style.display="block";
}
  else{ }
}



function scoreQuizzes(){ //do this at the end, and maybe replace with a function that adds up the scores from the db

var progWin=parent.myStage.document.getElementById('quizProgress');
var msgWin= parent.myStage.document.getElementById('quizMessages');
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
		 
		       
			   
			   //if any quiz does not have a score yet (qScore is invalid) set status to incomplete
			   //and add it to the warning message that will show up later.
			   if (!objScore){ 
			  //alert('no objScore');
			//if ((qScore=='')||(qScore==NaN)||(qScore=='(null)')||(qScore==null)){  
                 unfinQz += ('You have not completed <a href=\"'+q.url+'\">'+q.buttonTitle+' on page '+(i+1)+'</a><br>');
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
				 msgWin.innerHTML =(' <div id="msgcloser"><a href="javascript:parent.data.closeMsg();">[X] Close this message and continue.</a></div>');
				 msgWin.innerHTML +=('<br><br><span class="iStatusMsg" style="font-size:20px;color:red;">'+iStatus+'</span><br>' );
				 msgWin.innerHTML +=('You got ' + totalRawScore+' points out of a possible '+ totalmaxRawScore+'.<br>');
				 msgWin.innerHTML +=('Your score is ' +totalPercentScore+'%.<br> This module requires '+iMasteryScore+ '% to pass.' );
				 msgWin.innerHTML +=('<a href="javascript:window.print();" style="color:#666">Print this page</a>');
				 msgWin.innerHTML +=('<a href="javascript: parent.SCOFinish();" style="color:#666">OK I\'m done: send my final score to MLearning!</a>');
				 msgWin.innerHTML +=(' <div id="msgcloser"><a href="javascript:parent.data.closeMsg();">[X] Close this message and continue.</a></div>');
				}//end else there IS a mastery score
			}//end if iStatus is not incomplete
	   //iStatus IS incomplete: set status to incomplete and alert to missing quizzes		 
		else if(iStatus=='incomplete'){ 
		    parent.SCOSetValue( "cmi.core.lesson_status", "incomplete" ); 
			
			     msgWin.innerHTML =(' <div id="msgcloser"><a href="javascript:parent.data.closeMsg();">[X] Click to close</a></div>');
				 msgWin.innerHTML +=('<br><br><span class="iStatusMsg" style="font-size:20px;color:red;">'+iStatus+'</span><br>' );
				 msgWin.innerHTML +=(unfinQz+'. <a href="javascript:top.window.close();">Click here to close the module</a> and come back later to finish.');
				
	
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
  }//end scoreQuizzes function
  

function closeMsg(){   
 parent.myStage.document.getElementById('quizMessages').style.display='none';
  
  }