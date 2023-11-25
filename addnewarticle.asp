<!--#include virtual="/includes/adovbs.inc"-->
<!--#include virtual="/includes/helperfunctions.asp"-->
<!--#include virtual="/includes/jsoninclude.asp"-->
<!--#include virtual="/includes/aspJSON1.19.asp"-->
<%
    Dim var_error
    var_error= ""

    Dim articleExists
    articleExists = false

    Dim articleAdded
    articleAdded = false

    Dim articletitle
    articletitle = ""

    Dim articleauthor
    articleauthor = "Administrator"

    Dim articlebody
    articlebody = ""

    Dim articleimage
    articleimage = ""

    if Request("btnAdd")="Add" then
        
        articletitle = Trim(Request("txtarticletitle"))

        articleauthor = Trim(Request("txtarticleauthor"))

        articlebody = Trim(Request("txtarticlebody"))

        articleimage = Trim(Request("hdnarticleimage"))

        if articletitle="" then
            var_error = "Missing Article Title <br />"
        end if

        if articleauthor="" then
            var_error = var_error & "Missing Article Author <br />"
        end if

        if articlebody="" then
            var_error = var_error & "Missing Article Body <br />"
        end if

        if var_error<>"" then
            '//show error message
        else

            fileExists = false

            jsondata = ""

            dim fs
            set fs=Server.CreateObject("Scripting.FileSystemObject")

            if fs.FileExists(dbjsonpath) then

                fileExists = true

                set f = fs.OpenTextFile(dbjsonpath, 1)
                jsondata = f.ReadAll
                f.Close
                set f=Nothing

            end if
            set fs=nothing

            set oJSON = New aspJSON
            

            if fileExists = false then

                '//create json
                With oJSON.data
                    .Add "pk", "1"
                    .Add "articles", oJSON.Collection()

                    With oJSON.data("articles")

                        .Add 0, oJSON.Collection()

                        With .item(0)
                            .Add "id", "1"
                            .Add "articletitle", articletitle
                            .Add "articleauthor", articleauthor
                            .Add "articlebody", articlebody
                            .Add "articleimage", articleimage
                            .Add "createdonutc", (currentUTCDateTime.GetVarDate (false))&""
                            .Add "modifiedonutc", ""
                            .Add "status", "E"
                        End With

                    End With

                End With

            else

                oJSON.loadJSON(jsondata)

                var_pk = oJSON.data("pk")
                new_pk = (Int(var_pk) + 1)&""
                
                var_last_article_index = oJSON.data("articles").count

                With oJSON.data("articles")

                        .Add var_last_article_index, oJSON.Collection()

                        With .item(var_last_article_index)
                            .Add "id", new_pk
                            .Add "articletitle", articletitle
                            .Add "articleauthor", articleauthor
                            .Add "articlebody", articlebody
                            .Add "articleimage", articleimage
                            .Add "createdonutc", (currentUTCDateTime.GetVarDate (false))&""
                            .Add "modifiedonutc", ""
                            .Add "status", "E"
                        End With

                End With

                oJSON.data("pk") = new_pk

            end if

            jsondata = oJSON.JSONoutput()

            Dim FSO
            Set FSO = CreateObject("Scripting.FileSystemObject")

            Set OutPutFile = FSO.OpenTextFile(dbjsonpath,2 , True)
            OutPutFile.WriteLine(jsondata)

            Set FSO = Nothing

            articleAdded = true


        end if


        if articleAdded = true then
            Response.Write("<script type='text/javascript'>parent.newArticleAdded();</script>")
            Response.End()
        end if

    end if
%>

<!--#include virtual="/includes/boostrap_include.asp"-->
<form method="post">

    <div class="container-fluid">

        <%
            if var_error<>"" then
                Response.Write("<div class='row p-2'>")

                Response.Write("<div class='col-sm-12'>")
                                
                Response.Write("<div class='alert alert-danger'>")
                Response.Write("<strong>"& var_error &"</strong>")
                Response.Write("</div>")

                Response.Write("</div>")
                                
                Response.Write("</div>")
            end if
        %>

        <div class="row">

            <div class="col-sm-4">
                Title
            </div>
            <div class="col-sm-8">
                <input type="text" name="txtarticletitle" id="txtarticletitle" value="<%=articletitle %>" class="form-control" style="width:99%" required="required" />
            </div>

        </div>

        <div class="row">

            <div class="col-sm-12">
                &nbsp;
            </div>

        </div>

        <div class="row">

            <div class="col-sm-4">
                Author
            </div>
            <div class="col-sm-8">
                <input type="text" name="txtarticleauthor" id="txtarticleauthor" value="<%=articleauthor %>" class="form-control" style="width:99%" required="required" />
            </div>

        </div>

        <div class="row">

            <div class="col-sm-12">
                &nbsp;
            </div>

        </div>

        <div class="row">

            <div class="col-sm-4">
                Body
            </div>
            <div class="col-sm-8">
                <textarea id="txtarticlebody" name="txtarticlebody" class="form-control" style="width:99%" rows="10"><%=articlebody %></textarea>
            </div>

        </div>

        <div class="row">

            <div class="col-sm-12">
                &nbsp;
            </div>

        </div>

        <div class="row">

            <div class="col-sm-4">
                Article Image
            </div>
            <div class="col-sm-8">
                <input type="file" id="fileArticleImage" class="form-control" style="width:99%" />
                <img id="imagArticlePreview" src="" class="img-fluid" style="max-width:200px;margin-top:5px" />
                <input type="hidden" id="hdnarticleimage" name="hdnarticleimage" value="" />
                <script type="text/javascript">
                    function readFile() {

                        document.querySelector("#imagArticlePreview").src = "";

                        if (!this.files || !this.files[0]) return;

                        const FR = new FileReader();

                        FR.addEventListener("load", function (evt) {
                            document.querySelector("#hdnarticleimage").value = evt.target.result;
                            document.querySelector("#imagArticlePreview").src = evt.target.result;
                            //document.querySelector("#b64").textContent = evt.target.result;
                        });

                        FR.readAsDataURL(this.files[0]);

                    }

                    document.querySelector("#fileArticleImage").addEventListener("change", readFile);
                </script>
            </div>

        </div>

        <div class="row">

            <div class="col-sm-12">
                &nbsp;
            </div>

        </div>

        <div class="row">

            <div class="col-sm-12 text-center">
                <input type="submit" id="btnAdd" name="btnAdd" value="Add" class="btn btn-danger" />
            </div>

        </div>


        <div class="row">

            <div class="col-sm-12">
                &nbsp;
            </div>

        </div>

    </div>

</form>