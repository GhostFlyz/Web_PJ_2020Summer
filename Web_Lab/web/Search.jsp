<%--
  Created by IntelliJ IDEA.
  User: ZJT
  Date: 2020/7/28
  Time: 15:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>搜索</title>
    <link rel="shortcut icon" href="img/web-images/Icon.png" type="image/png">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<%@include file="navbar.jsp" %>
<div style="height: 50px"></div>
<div class="container">
    <div class="title"><h3>搜索</h3></div>
    <hr>
    <form action="/search" method="post" class="form-horizontal" role="form">
        <div class="row" style="padding: 5px;">
            <div class="col-md-5">
                <div class="input-group">
                    <input type="text" name="text" id="text" class="form-control" placeholder="${requestScope.text}"
                           required>
                    <span class="input-group-btn">
                    <input class="btn btn-default" type="submit" id="submit" value="搜索">
                </span>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-offset-1 col-md-6" style="margin-left: 5px;">
                <div class="radio">
                    请选择搜索方式：
                    <label><input type="radio" name="type" value="title" required>搜索标题</label>
                    <label><input type="radio" name="type" value="content">搜索主题</label>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-offset-1 col-md-6" style="margin-left: 5px;">
                <div class="radio">
                    请选择排序方式：
                    <label><input type="radio" name="order" value="likeperson" required>按热度排序</label>
                    <label><input type="radio" name="order" value="updateTime">按时间排序</label>
                </div>
            </div>
        </div>
    </form>


    <div class="row">
        <hr>
        <h4>搜索结果</h4>
        <hr>
    </div>

    <div id="resultPart">

    </div>


</div>
</body>
<script type="text/javascript">
    var pageSize = 8;
    var totalCount;
    var totalPage;
    var result;
    var data = '<%=request.getAttribute("result")%>';
    result = JSON.parse(data).results;
    if (result !== null) {
        totalCount = result.length;
        totalPage = Math.ceil(totalCount / pageSize);
    }
    showPage(1);

    function showPage(page) {
        var str = "";
        if (result === null) {
            str =
                '<div class="row">\n' +
                '<p class="text-muted">抱歉，没有找到相关图片。</p>\n' +
                '</div>';
        } else {
            str =
                '<div class="row">\n' +
                '<p class="text-muted">共找到<strong> ' + totalCount + ' </strong>个结果：</p>\n' +
                '</div>';
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
                    "</div>\n" +
                    "</div>\n" +
                    "</div>";
            }
            str +=
                "<div style=\"height: 400px\"></div>\n"+
                "<nav  class='col-md-5' aria-label=\"Page navigation\" style='margin-left: 0px'>\n" +
                "<ul class=\"pagination \">\n";
            for (var i = 1; i <= totalPage; i++) {
                if (page === i) {
                    str += "<li class='active'><a>" + i + "</a></li>";
                } else {
                    str += "<li><a href='javascript:showPage(" + i + ");'>" + i + "</a></li>";
                }
            }
            str +=
                "</ul>\n" +
                "</nav>";
        }
        $('#resultPart').empty().html(str);
    }
</script>
<script src="JS/SpecialEffect.js"></script>
</html>