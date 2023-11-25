<%
    '//gets the current UTC date time
    Set currentUTCDateTime = CreateObject("WbemScripting.SWbemDateTime")    
    currentUTCDateTime.SetVarDate (now())
%>