<!--#include virtual="/includes/jsoninclude.asp"-->
<!--#include virtual="/includes/aspJSON1.19.asp"-->
<%
    Dim id
    id=Int(Request("id")&"")

    jsondata = ""

    dim fs
    set fs=Server.CreateObject("Scripting.FileSystemObject")

    if fs.FileExists(dbjsonpath) then

        set f = fs.OpenTextFile(dbjsonpath, 1)
        jsondata = f.ReadAll
        f.Close
        set f=Nothing

    end if
    set fs=nothing

    set oJSON = New aspJSON

    oJSON.loadJSON(jsondata)

    set objarticle = oJSON.data("articles").item(id)

    objarticle("status") = "D"

    jsondata = oJSON.JSONoutput()

    Dim FSO
    Set FSO = CreateObject("Scripting.FileSystemObject")

    Set OutPutFile = FSO.OpenTextFile(dbjsonpath,2 , True)
    OutPutFile.WriteLine(jsondata)

    Set FSO = Nothing

    Response.Redirect("/")
%>