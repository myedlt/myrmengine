var newWin=null;
var note="无内容……";
function saveNote(noteStr)
{
	if(noteStr!="")
	{
		note=noteStr;
	}
	newWin=window.open("web/note/saveNote.html","SaveNote");	
	setTimeout("doWrite()",100); 
}
function doWrite()
{	
	if(newWin == null)
	{
		return;
	}	     
    if(newWin.document.readyState == "complete")   
    {   
       newWin.document.getElementById("txt").innerHTML=note;
    }   
    else
    {
    	setTimeout("doWrite()",100);
    }    
} 