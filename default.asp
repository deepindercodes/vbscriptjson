<!DOCTYPE html>
<html lang="en">
<head>
    <title>Article Listing</title>
    <!--#include virtual="/includes/boostrap_include.asp"-->
    <script type="text/javascript">
        function newArticleAdded() {
            var myModalEl = document.getElementById('divAddArticle');
            var modal = bootstrap.Modal.getInstance(myModalEl)
            modal.hide();
            location.href = location.href;
        }

        function ArticleEdited() {
            var myModalEl = document.getElementById('divEditArticle');
            var modal = bootstrap.Modal.getInstance(myModalEl)
            modal.hide();

            document.getElementById('iframeEditArticle').src = "";
            document.getElementById('iframeEditArticle').contentWindow.location.href = document.getElementById('iframeEditArticle').contentWindow.location.href;
            location.href = location.href;
        }

        function confirmDelete() {
            return confirm('Are you sure you want to delete this article?');
        }

    </script>
</head>
<body>

    <div class="container">

        <div class="row">
            <div class="col-sm-9">
                &nbsp;
            </div>
            <div class="col-sm-2 p-3">
                <a href="javascript:void(0)" data-bs-toggle="modal" data-keyboard="false" data-backdrop="static" data-bs-target="#divAddArticle">Add New Article</a>
            </div>
            <div class="col-sm-1">
                &nbsp;
            </div>
        </div>
        <div class="row">
            <div class="col-sm-1">
                &nbsp;
            </div>
            <div class="col-sm-10">
                <ul class='list-group'>
                    <li class='list-group-item fs-5 p-3 bg-primary text-white'>Article Listing</li>
                    
                    <!--#include virtual="/includes/jsoninclude.asp"-->
                    <!--#include virtual="/includes/aspJSON1.19.asp"-->
                    <%

                        dim fs
                        set fs=Server.CreateObject("Scripting.FileSystemObject")
                        if fs.FileExists(dbjsonpath) then
                        
                            set f = fs.OpenTextFile(dbjsonpath, 1)
                            jsondata = f.ReadAll
                            f.Close

                            set oJSON = New aspJSON
                            
                            oJSON.loadJSON(jsondata)

                            index = 0

                            For Each article In oJSON.data("articles")
                                set objarticle = oJSON.data("articles").item(article)

                                articlestatus = objarticle("status")
                        
                                if articlestatus="E" then
                        
                        
                                    Response.Write("<li class='list-group-item p-2'>")

                                    Response.Write("<div class='row'>")

                                    Response.Write("<div class='col-sm-10'>"& objarticle("articletitle") &"</div>")
                                    Response.Write("<div class='col-sm-2 text-center'><a href='javascript:void(0)' onclick='openEditingPanel("& index &")'>Edit</a>&nbsp;<a href='delarticle.asp?id="& index &"' onclick='return confirmDelete()'>Delete</a>&nbsp;<a href='view.asp?id="& index &"' target='_blank'>View</a></div>")

                                    Response.Write("</div>")

                                    Response.Write("</li>")

                                end if

                                index = index + 1

                            Next


                        end if
                        set fs=nothing

                    %>

                </ul>
            </div>
            <div class="col-sm-1">
                &nbsp;
            </div>
        </div>
    </div>

    <!--Add Article Modal-->
    <div class="modal fade" id="divAddArticle" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="staticBackdropLabel">Add New Article</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">

              <div class="container">

                  <div class="row">

                      <div class="col-sm-12">
                          <iframe src="addnewarticle.asp" id="iframeAddArticle" style="width:100%;height:750px" border="0"></iframe>
                      </div>
                  </div>

              </div>

          </div>
        </div>
      </div>
    </div>

    <!--Add Article Modal-->
    <div class="modal fade" id="divEditArticle" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="staticBackdropLabelEdit">Edit Article</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">

              <div class="container">

                  <div class="row">

                      <div class="col-sm-12">
                          <iframe src="" id="iframeEditArticle" style="width:100%;height:750px" border="0"></iframe>
                      </div>
                  </div>

              </div>

          </div>
        </div>
      </div>
    </div>

    <script type="text/javascript">
        var myModalEl = document.getElementById('divAddArticle')
        myModalEl.addEventListener('hidden.bs.modal', function (event) {
            document.getElementById('iframeAddArticle').contentWindow.location.href = document.getElementById('iframeAddArticle').contentWindow.location.href;
        })


        var myModalEditArticle = new bootstrap.Modal(document.getElementById("divEditArticle"), {});
        myModalEditArticle.addEventListener('hidden.bs.modal', function (event) {
            document.getElementById('iframeEditArticle').src = "";
            document.getElementById('iframeEditArticle').contentWindow.location.href = document.getElementById('iframeEditArticle').contentWindow.location.href;
        })

        function openEditingPanel(_id) {
            document.getElementById('iframeEditArticle').src = "editarticle.asp?id=" + _id;
            myModalEditArticle.show();
        }


    </script>

</body>
</html>