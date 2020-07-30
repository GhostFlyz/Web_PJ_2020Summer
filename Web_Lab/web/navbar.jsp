<%--
  Created by IntelliJ IDEA.
  User: ZJT
  Date: 2020/7/28
  Time: 15:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script id="jquery_172" type="text/javascript" class="library"
        src="http://apps.bdimg.com/libs/jquery/1.9.1/jquery.min.js"></script>

<nav class="navbar navbar-default " role="navigation" style="margin-bottom: 0px;position: fixed;right: 0px;left: 0px;z-index:9999"
     id="fixed">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="index.jsp" style="padding: 0"><img src="img/web-images/logo.png" alt="logo" height="50px"></a>
        </div>

        <ul class="nav navbar-nav">
            <li><a href="index.jsp">首页</a></li>
            <li><a href="Search.jsp">搜索</a></li>
            <li><a href="#">其他</a></li>
        </ul>

        <ul class="nav navbar-nav navbar-right">
            <%
                if (session.getAttribute("username") != null) {
                    String name = (String) session.getAttribute("username");
            %>
            <li class="dropdown">
                <a href="#"> <span class="glyphicon glyphicon-user"></span> 欢迎! <%=name%>
                </a>
                <ul class="dropdown-menu" style="left: 0">
                    <li><a href="/myfavour">我的收藏</a></li>
                    <li><a href="/myPhoto">我的图片</a></li>
                    <li><a href="/myFriend">我的好友</a></li>
                    <li><a href="Upload.jsp">上传图片</a></li>
                </ul>
            </li>
            <li><a href="./logout">登出</a></li>
            <%
            } else {
            %>
            <li><a href="Register.jsp">注册</a></li>
            <li><a href="Login.jsp">登录</a></li>
            <%
                }
            %>
        </ul>
    </div>
</nav>
<script>
    window.onscroll = function () {
        var sl = -Math.max(document.body.scrollLeft, document.documentElement.scrollLeft);
        document.getElementById('fixed').style.left = sl + 'px';
    }

    $('li.dropdown').mouseover(function () {
        $(this).addClass('open');
    }).mouseout(function () {
        $(this).removeClass('open');
    });

    $('.navbar-nav li').mouseover(function () {
        $(this).addClass('active');
    }).mouseout(function () {
        $(this).removeClass('active');
    })
</script>