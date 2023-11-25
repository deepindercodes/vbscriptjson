<!--#include virtual="/includes/jsoninclude.asp"-->
<!--#include virtual="/includes/aspJSON1.19.asp"-->
<%
    Dim articletitle
    articletitle = ""

    Dim articleauthor
    articleauthor = "Administrator"

    Dim articlebody
    articlebody = ""

    Dim articleimage
    articleimage = ""

    Dim createdonUTC
    createdonUTC = ""

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
    articletitle = objarticle("articletitle")
    articleauthor = objarticle("articleauthor")
    articlebody = objarticle("articlebody")
    articleimage = objarticle("articleimage")
    createdonUTC = objarticle("createdonutc")

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title><%=articletitle %></title>
    <!--#include virtual="/includes/boostrap_include.asp"-->
</head>
<body>

    <div class="container">

        <div class="row">
            <div class="col-sm-1">
                &nbsp;
            </div>
            <div class="col-sm-10">
                <ul class='list-group'>
                    <li class='list-group-item fs-5 p-3 bg-primary text-white'><%=articletitle %></li>
                    <li class='list-group-item p-2'>
                        <p>
                            <%
                                if articleimage<>"" then
                                    Response.Write("<img class='img-fluid rounded' style='max-width:200px;margin:15px;float:left' src='"& articleimage &"' />")
                                end if
                            %>
                            <b>Author:</b>&nbsp;<%=articleauthor %><br />
                            <b>Date (UTC):</b>&nbsp;<%=createdonUTC %><br /><br />
                            <%=articlebody %>
                        </p>
                    </li>
                </ul>
            </div>
            <div class="col-sm-1">
                &nbsp;
            </div>
        </div>
    </div>


</body>
</html>