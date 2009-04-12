//v 1.1 10-8-07 emeiselm
//if we aren't in SCORM mode, and this page is not in a frame, open the frameset, and add the current location to the query string.
 function wrapMe(){ //this gets called by each content page to check if it is wrapped or not.
			if ( (!parent.APIOK())&&(self.location.href == top.location.href) ) { 	
			  top.location.href = 'index.htm?zurl=' + self.location.href;			   
			    }
			}
 
  function waitForFrame(){
	  var zurl=(qsParm['zurl']);
	  //alert(zurl);
	 // alert('frames[0].location'+ frames[0].src);
       //  if(window.myStage.location!='/'){
		    if((frames[0])&&(frames[0].location.href!='/')){
			// alert(frames[0].location.href);
			 frames[0].location.href=zurl;}
         else{  setTimeout("waitForFrame()",100); }
      }
	  
	  
function setFrameSrc(){	//this gets called on the index page
    justOpened=0;
    var zurl=(qsParm['zurl']);
    if(zurl){  waitForFrame(); }
 }


 

