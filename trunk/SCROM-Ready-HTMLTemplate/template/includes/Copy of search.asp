<% option explicit 

' Search scripts
' Written by C Maunder (cmaunder@mail.com)
' www.codeproject.com
%>

<html><head><title>Search This Learning Module</title>
<style>
body, td {
font:normal 11px Arial, Helvetica, sans-serif;
}

a.resultTitle:link, a.resultTitle a.resultTitle:visited  {font:16px;color:blue;}
</style>
</head><body>

<%
'/////////////////////////////////////////////////////////////////////////////////
'// Initialisation

' Declare variables.

'Response.Write Request.ServerVariables("PATH_TRANSLATED")

dim target, firstRow, rowCount




' Get the request parameters.
target	 = Request("target")	' The search request
firstRow = Request("fr")		' First row of results to display
rowCount = Request("rc")		' Record Count - number of rows to show
 
' Set default values if none found
if firstRow = "" or not IsNumeric(firstRow) Then 
	firstRow = 1
else
	firstRow = CInt(firstRow)
End If
if rowCount = "" or not IsNumeric(rowCount) Then 
	rowCount = 50
else
	rowCount = CInt(rowCount)
End If

Dim ScriptName, ServerName
ScriptName = Request.ServerVariables("SCRIPT_NAME")
ServerName = Request.ServerVariables("SERVER_NAME")

' Construct base URL for navigation buttons
dim URL
URL = ScriptName & "?target=" & Server.URLEncode(target)
URL = URL & "&rc=" & Server.URLEncode(rowCount)

'/////////////////////////////////////////////////////////////////////////////////
'// The search form

%>
<form name="searchForm" action="<%=ScriptName%>"  onsubmit="javascript:window.resizeTo(800,600);">
   <b>Search this learning module:</b>
   <INPUT TYPE="text" NAME="target" SIZE="45" MAXLENGTH="100" VALUE="<%=target%>">
   <INPUT TYPE="submit" VALUE=" Search ">
   <br>  
</form>

<hr size=2 noshade><br>
<%

'response.write(Server.MapPath("."))
dim str0, str1, str2, str3, str4, folderarray, lastone, thisfolder
str0 = request.ServerVariables("url")
folderarray=Split(str0, "/")
lastone = UBound(folderarray)-2
thisfolder = folderarray(lastone)
'response.write(folderarray(lastone))

 %>
<% 
DoSearch target

'/////////////////////////////////////////////////////////////////////////////////
'// Perform the search

sub DoSearch(target)

   on error resume next
   if target <> "" then

      dim strQuery
	  
      ' strQuery = "$contents " & target ' for free text search
     '   strQuery = "((#filename *.htm) OR (#filename *.swf) OR (#filename *.html) OR (#filename *doc)) AND (" & target & ")" '&_
	strQuery = "((NOT #vpath *\_notes*) AND (NOT #vpath *\js*) AND (NOT #vpath *\cbtlibdev*)  AND (NOT #vpath *\css*) AND " &_
	           "(NOT #vpath *\z_old*) AND (NOT #vpath *\includes*) AND (NOT #vpath *\prototypes*))" &_
			   " AND  ((#filename *.htm) OR (#filename *.swf) OR (#filename *.html) OR (#filename *doc))" &_
			   " AND (" & target & ")"
			   dim strQuerytest
	'strQuerytest = 	"(" & target & ")"	   
	dim strQueryLocal
'	strQueryLocal = "((#vpath " & Server.MapPath(".") & ") AND (NOT #vpath *\_notes*) AND (NOT #vpath *\js*)  AND (NOT #vpath *\css*) AND " &_
'	           "(NOT #vpath *\z_old*) AND (NOT #vpath *\includes*))"  &_
'			   " AND  ((#filename *.htm) OR (#filename *.swf) OR (#filename *.html) OR (#filename *doc))" &_
'			   " AND (" & target & ")"
	strQueryLocal = "(" & target & ")"

	  
	 ' strQuery = "((#filename *.htm) OR (#filename *.swf) OR (#filename *.html) OR (#filename *doc)) AND (" & target & ")" &_  
	          '    "(NOT #vpath *\_notes*) AND (NOT #vpath *\js*) AND " &_
			   '   "(NOT #vpath *\css*) AND (NOT #vpath *\z_old*) AND " &_
			   '   "(NOT #vpath *\includes*) "
			    ' "(" & target & ")"
	'response.write("<BR>" & "queryloc is " & strQueryLocal & "<BR>" )
	 
	

   
      ' Create the Index Server query object, setting the columns, the sort to
      ' descending, the max records to 300, and the query string to the given
      ' target. Note that the query string specifies, with NOT and the
      ' #vpath operators, that any files in the *\_vti path, should be excluded.
      ' (_vti* directories contain FrontPage Extension files, and we don't want
      ' users browsing them.)
      ' response.write(strQuery);
      dim ixQuery   ' Index Server query object.
      set ixQuery = Server.CreateObject("ixsso.Query")
      if (Err.description <> "") Then
         Response.Write ("<p><b>Query object Error: " & Err.description & ".</b></p>" & vbCRLF)
         Exit sub
      end if
   
      ixQuery.Columns    = "doctitle, path, vpath, filename, size, write, characterization, rank"
      ixQuery.SortBy     = "rank[d], doctitle"
      ixQuery.MaxRecords = 300
      ixQuery.Query      = strQueryLocal
      ixQuery.Catalog = "Web" ' Specify you catalog here if it's not the default

      ' Create a search utility object to allow us to specify the search type as 'deep',
      ' meaning it will search recursively down through the directories
      dim util      
      set util = Server.CreateObject("ixsso.Util")
       util.AddScopeToQuery ixQuery, Server.MapPath("/quiz/cbtlib/modules/"& thisfolder), "deep"
      if (Err.description <> "") Then
         Response.Write ("<p><b>Search Utility Error: " & Err.description & ".</b></p>" & vbCRLF)
         Exit sub
      end if
   
      ' Run the query (i.e. create the recordset).
      dim queryRS   ' Query recordset.
      set queryRS = ixQuery.CreateRecordSet("nonsequential")

      ' Check the query result. If it timed out or return no records, then show
      ' an appropriate message. Otherwise, show the hits.
      if (Err.description <> "") Then
         Response.Write ("<p><b>Search Recordset Error: " & Err.description & ".</b></p>" & vbCRLF)
         Exit sub
      Else
         if queryRS is Nothing Then
            Response.Write ("<p>Query returned no matches.</p>" & vbCRLF)      
         elseif (ixQuery.QueryTimedOut) then
            Response.Write ("<p><b>Error: " & timedOut_Text & ".</b></p>" & vbCRLF)
         elseif (queryRS.EOF or queryRS.BOF or queryRS.RecordCount <= 0) then
            Response.Write ("<p>No matches found.</p>" & vbCRLF)
         else
            queryRS.PageSize = rowCount
            call showHits(queryRS)
            if (Err.number <> 0) Then
               Response.Write ("<p><b>Record Display Error: " & Err.description & ".</b></p>" & vbCRLF)
            End If 
         end if
      End If
   
      ' Clean up
      queryRS.close
      set queryRS = nothing
      set ixQuery = nothing
      set util = nothing
      
   End if 
end Sub

' showHits(): Displays the query hits from the query recordset.
'
sub showHits(queryRS)
   dim recordNumber  ' record number
   dim docTitle      ' document title
   dim endRow        ' last row being displayed
   dim prevRow       ' row to display for "prev" option
   dim nextRow       ' row to display for "next" option
   dim lastRow       ' row to display for "last" option
   dim remainder     ' remainder (used to determine if last page is short)
   dim recordCount   ' numner of records returned
  
   recordCount = queryRS.RecordCount
   if firstRow > recordCount Then firstRow = 1 
		
   endRow = firstRow + RowCount-1                      ' Last row on page to show
   if endRow > recordCount Then endRow = recordCount
	
   prevRow = firstRow - RowCount                       ' Start of previous page's rows
   if PrevRow < 1 Then PrevRow = 1
	
   nextRow = endRow + 1                                ' Start of next pages rows. May be > CommentCount		
	
   remainder = recordCount mod RowCount
   if remainder = 0 Then
      lastRow = recordCount - RowCount + 1
   else
      lastRow = recordCount - remainder + 1
   End If
   if lastRow < 1 Then lastRow = 1                     ' Start of last pages rows

   ' Go to the top of the record set, then move forward to the record that
   ' corresponds to the first row.
   queryRS.MoveFirst()

   if (firstRow > 1) then
      queryRS.Move(CInt(firstRow) - 1)
   end if

   ' Show the summary info.: # of records found and range showing.
%>
<table border=0>
<tr><td colspan=2>

<table border=0 width=100%><tr>
<td nowrap><b>Found:</b> <%=queryRS.RecordCount%> &nbsp;&nbsp;&nbsp;<b>Showing:</b> <%=firstRow%> - <%=endRow%></td> 
<td align=right nowrap>
<% if firstRow <> "1" Then %>
<a href="<%=URL&"&fr=1"%>">First</a> |
<% Else %>
First |
<% End If %>
<% if firstRow <> "1" Then %>
<a href="<%=URL&"&fr="&prevRow%>">Prev</a> |
<% Else %>
Prev |
<% End If %>
<% if firstRow + RowCount <= recordCount Then %>
<a href="<%=URL&"&fr="&nextRow%>">Next</a> |
<% Else %>
Next |
<% End If %>
<% if firstRow + RowCount <= recordCount Then %>
<a href="<%=URL&"&fr="&lastRow%>">Last</a>
<% Else %>
Last
<% End If %>
</td></tr>
</table></td></tr>

<tr><td colspan=2>&nbsp;</td></tr>
<%
' Show the records.

recordNumber = firstRow

do while ((not queryRS.EOF) and (recordNumber <= endRow))

	' Get the document title. If it's blank, set it to "Untitled".
	docTitle = queryRS("doctitle")

	if docTitle = "" then docTitle = "Untitled"
    
	' Show the record #, link to the document, URL, and characterization.
	Response.Write "<tr >"
	Response.Write "<td valign=top style='border-top:1px solid #CCC;padding:6px;'>" & recordNumber & ".</td>"
	Response.Write "<td valign=top  style='border-top:1px solid #CCC;padding-bottom:12px;'>"
	Response.Write "<a href='" & queryRS("vpath") & "' target='myStage' class='resultTitle'>" & ">" & docTitle &"</a><br>"
	Response.Write Server.HTMLEncode(queryRS("characterization"))
	Response.Write "<p><span style='font:9px Courier, Verdana, Arial, Helvetica, sans-serif'><b>URL: </b> <a href='" & queryRS("vpath") & "' target='myStage'>http://" & ServerName & queryRS("vpath") & "</a></span></p>"
	Response.Write "</td>"
	Response.Write "</tr>"

	recordNumber = recordNumber + 1
	queryRS.MoveNext()
loop

   ' Display the navigation links.
%>
<tr><td colspan=2>&nbsp;</td></tr>

<tr><td colspan=2 align=center>
<% if firstRow <> "1" Then %>
<a href="<%=URL&"&fr=1"%>">First</a> |
<% Else %>
First |
<% End If %>
<% if firstRow <> "1" Then %>
<a href="<%=URL&"&fr="&prevRow%>">Prev</a> |
<% Else %>
Prev |
<% End If %>
<% if firstRow + RowCount <= recordCount Then %>
<a href="<%=URL&"&fr="&nextRow%>">Next</a> |
<% Else %>
Next |
<% End If %>
<% if firstRow + RowCount <= recordCount Then %>
<a href="<%=URL&"&fr="&lastRow%>">Last</a>
<% Else %>
Last
<% End If %>
</td></tr>

</table>

<% end sub %>

</body>
</html>

