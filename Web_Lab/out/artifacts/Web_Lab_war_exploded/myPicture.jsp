<%--
  Created by IntelliJ IDEA.
  User: ZJT
  Date: 2020/7/28
  Time: 15:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的照片</title>
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
    <div class="title">
        <h3><strong><%= session.getAttribute("username") %>
        </strong> 的图片</h3></div>
    <hr>
    <div id="myResult">
    </div>

</div>
<%
    }
%>
</div>
<script type="text/javascript">
    var pageSize = 4;
    var totalCount;
    var totalPage;
    var result;
    var data = '<%=request.getAttribute("myPictures")%>';
    result = JSON.parse(data).results;
    if (result != null) {
        totalCount = result.length;
        totalPage = Math.ceil(totalCount / pageSize);
    }
    showMyPage(1);

    function showMyPage(page) {
        var str = "";
        if (result === null) {
            str = "<p>你还没有上传过图片哦……<p>";
        } else {
            for (var i = (page - 1) * pageSize; i < page * pageSize && i < result.length; i++) {
                str +=
                    "<div class=\"col-md-3\">\n" +
                    "<div class=\"card \" style=\"width:200px;height: 400px\">\n" +
                    "<img class=\"card-img-top\" src=\"img/travel-images/square-medium/" + result[i].PATH + "\" style=\"width:100%\">\n" +
                    "<div class=\"card-body\">\n" +
                    "<h4 class=\"card-title\">" + result[i].Title + "</h4>\n" +
                    "<p>主题：" + result[i].Content + "</p>\n" +
                    "<p>收藏人数：" + result[i].likeperson + "</p>\n" +
                    "<p>发布时间：" + result[i].updateTime + "</p>\n" +
                    "<a href=\"/detail?id=" + result[i].ImageID + "\" class=\"btn btn-primary\">详情</a>\n" +
                    "<a href=\"/findUpdate?id=" + result[i].ImageID + "\" id=\"modify\" class=\"btn btn-default\">修改</a>\n" +
                    "<a href=\"/deletePic?id=" + result[i].ImageID + "\" id=\"delete\" class=\"btn btn-default\">删除</a>\n" +
                    "</div>\n" +
                    "</div>\n" +
                    "</div>";
            }
            str +=
                "<div style=\"height: 400px\"></div>\n" +
                "<nav  class='col-md-5' aria-label=\"Page navigation\" style='margin-left: 0px'>\n" +
                "<ul class=\"pagination \">\n";
            for (var i = 1; i <= totalPage; i++) {
                if (page === i) {
                    str += "<li class='active'><a>" + i + "</a></li>";
                } else {
                    str += "<li><a href='javascript:showMyPage(" + i + ");'>" + i + "</a></li>";
                }
            }
            str +=
                "</ul>\n" +
                "</nav>";
        }
        $('#myResult').empty().html(str);
    }
</script>
</body>
</html>