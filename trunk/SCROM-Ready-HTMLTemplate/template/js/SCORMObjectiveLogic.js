// SCORM 1.2 SCO Objective Logic management script sample
// Copyright 2001,2002,2003 Click2learn, Inc.
// by Claude Ostyn 2003-02-22 
//
// This script implements various aspects of
// common logic behavior of a SCO.
// The SCO can be a HTML document or a frameset.
//
// Change these preset values to suit your taste and requirements.

<!--/*v 1.0 9-7-2007*/-->
function SCOSetObjectiveData(id, elem, v) {
	var result = "false"; 
	var i = SCOGetObjectiveIndex(id);
	if (isNaN(i)) {
		i = parseInt(SCOGetValue("cmi.objectives._count"));
		if (isNaN(i)) i = 0; //if no objectives have been set yet, start w/0
		if (SCOSetValue("cmi.objectives." + i + ".id", id) == "true"){
			result = SCOSetValue("cmi.objectives." + i + "." + elem, v) 
			  } 
			} else {
				result = SCOSetValue("cmi.objectives." + i + "." + elem, v);
				
				if (result != "true") {
					// Maybe this LMS accepts only journaling entries 
					i = parseInt(SCOGetValue("cmi.objectives._count"));
					if (!isNaN(i)) {
						if (SCOSetValue("cmi.objectives." + i + ".id", id) == "true"){
							result = SCOSetValue("cmi.objectives." + i + "." + elem, v) 
							} 
						 } 
					  }
				  } 
				  return result 
			} 
				 
function SCOGetObjectiveData(id, elem) { 
	var i = SCOGetObjectiveIndex(id);
	if (!isNaN(i)) { 
	  return SCOGetValue("cmi.objectives." + i + "."+elem) 
	  }
	  return "" 
	} 
	
function SCOGetObjectiveIndex(id){
	var i = -1; 
	var nCount = parseInt(SCOGetValue("cmi.objectives._count"));//how many are stored?
	if (!isNaN(nCount)) { //if there aren't any
		for (i = nCount-1; i >= 0; i--){ //walk backward in case LMS does journaling 
			if (SCOGetValue("cmi.objectives." + i + ".id") == id) { //if the objective's id matches what I am looking for
				return i //return its index in the array of objectives
			} 
		} 
	} return NaN
}
 