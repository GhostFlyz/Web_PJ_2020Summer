<%@ page import="Entity.Picture" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: ZJT
  Date: 2020/7/28
  Time: 15:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的收藏</title>
    <link rel="shortcut icon" href="img/web-images/Icon.png" type="image/png">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<%@include file="navbar.jsp" %>
<div style="height: 50px"></div>
<%
    if (session.getAttribute("username") == null) {
%>
<p>请先登录</p>
<%
} else {
%>
<div class="container">
    <div class="row">
        <div class="col-md-9">
            <div class="title">
                <h3 style="margin-top: 35px;"><strong><%= session.getAttribute("username") %>
                </strong>的收藏</h3></div>
        </div>
        <hr>

        <p>是否公开我的收藏：</p><select class="col-md-10 form-control" id="limit" style="width: 10%;left: 1020px;top: -38;"
                                name="limit"
                                onchange="changeStatus()">
        <%
            String limit = (String) request.getAttribute("limit");
            if (limit != null) {
                if (limit.equals("1")) {
        %>
        <option value="1" selected>是</option>
        <option value="0">否</option>
        <%
        } else {
        %>
        <option value="1"> 是</option>
        <option value="0" selected> 否</option>
        <%
                }
            }
        %>
    </select>
        <div style="height: 1px"></div>
        <hr>
        <div id="favourResult"></div>
    </div>
    <div class="col-md-3" style="left: 1200px;top: -575;">
        <div class="panel panel-default">
            <!-- Default panel contents -->
            <div class="panel-heading"><strong>我的足迹</strong></div>
            <% List<Picture> pictures = (List<Picture>) request.getAttribute("footprint");
                if (pictures != null) {
                    for (Picture picture : pictures) {
            %>
            <a href="/detail?id=<%=picture.getID()%>" class="list-group-item">
                <%=picture.getTitle()%>
            </a>
            <%
                    }
                }
            %>
        </div>
    </div>

</div>
</div>
<script type="text/javascript">
    var pageSize = 4;
    var totalCount;
    var totalPage;
    var result;
    var data = '<%=request.getAttribute("pictures")%>';
    result = JSON.parse(data).results;
    if (result !== null) {
        totalCount = result.length;
        totalPage = Math.ceil(totalCount / pageSize);
    }
    showFavourPage(1);

    function showFavourPage(page) {
        var str = "";
        if (result === null) {
            str = "<p>你还没有收藏过图片哦……<p>";
        } else {
            for (var i = (page - 1) * pageSize; i < page * pageSize && i < result.length; i++) {
                str +=
                    "<div class=\"col-md-3\">\n" +
                    "<div class=\"card \" style=\"width:200px;height: 500px\">\n" +
                    "<img class=\"card-img-top\" src=\"img/travel-images/square-medium/" + result[i].PATH + "\" style=\"width:100%\">\n" +
                    "<div class=\"card-body\">\n" +
                    "<h4 class=\"card-title\">" + result[i].Title + "</h4>\n" +
                    "<p>作者：" + result[i].Author + "</p>\n" +
                    "<p>主题：" + result[i].Content + "</p>\n" +
                    "<p>收藏人数：" + result[i].likeperson + "</p>\n" +
                    "<p>发布时间：" + result[i].updateTime + "</p>\n" +
                    "<a href=\"/detail?id=" + result[i].ImageID + "\" class=\"btn btn-primary\">详情</a>\n" +
                    "<a href=\"/deleteFavor?imageID=" + result[i].ImageID + "\" class=\"btn btn-default\">取消收藏</a>" +
                    "</div>\n" +
                    "</div>\n" +
                    "</div>";
            }
            str +=
                "<div style=\"height: 500px\"></div>\n" +
                "<nav  class='col-md-5' aria-label=\"Page navigation\" style='margin-left: 0px'>\n" +
                "<ul class=\"pagination \">\n";
            for (var i = 1; i <= totalPage; i++) {
                if (page === i) {
                    str += "<li class='active'><a>" + i + "</a></li>";
                } else {
                    str += "<li><a href='javascript:showFavourPage(" + i + ");'>" + i + "</a></li>";
                }
            }
            str +=
                "</ul>\n";
        }
        $('#favourResult').empty().html(str);
    }

    function changeStatus() {
        var limit = $("#limit").val();
        $.ajax({
            type: "post",
            async: false,
            url: "/changeStatus",
            data: {"limit": limit},
            data_type: 'json',
            success: function (data) {
                alert("修改成功！");
            }
        })
    }
</script>
<%
    }
%>
</body>
</html>