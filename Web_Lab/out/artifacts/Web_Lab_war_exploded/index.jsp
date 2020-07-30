<%@ page import="java.util.List" %>
<%@ page import="DAO.PictureDAO" %>
<%@ page import="Entity.Picture" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>GhostFly's Travel</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="./css/Public.css">
    <link rel="shortcut icon" href="img/web-images/Icon.png" type="image/png">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body style="background: linear-gradient(45deg,rgba(254,172,94,0.5),rgba(199,121,208,0.5),rgba(75,192,200,0.5));">
<%@include file="navbar.jsp" %>
<div style="height: 50px "></div>
<div class="jumbotron"
     style="margin:0;padding-left: 65px;background: linear-gradient(45deg,rgba(254,172,94,0.5),rgba(199,121,208,0.5),rgba(75,192,200,0.5));">
    <h1>Welcome, my travellers!</h1>
    <p>Take a seat by the fire!</p>
</div>

<!-- 轮播 -->
<div id="myCarousel" class="carousel slide" data-ride="carousel" data-interval="2000" style="height: 700px">
    <ol class="carousel-indicators">
        <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
        <li data-target="#myCarousel" data-slide-to="1"></li>
        <li data-target="#myCarousel" data-slide-to="2"></li>
    </ol>
    <div class="carousel-inner" style="height: 700px">
        <%
            List<Picture> pictureList = PictureDAO.getHotPic();
        %>
        <div class="item active">
            <a href="/detail?id=<%=pictureList.get(0).getID()%>">
                <img src="img/travel-images/large/<%=pictureList.get(0).getPath()%>" alt="First slide"
                     style="width: 100%;">
                <div class="carousel-caption"><%=pictureList.get(0).getTitle()%>
                </div>
            </a>
        </div>
        <div class="item">
            <a href="/detail?id=<%=pictureList.get(1).getID()%>">
                <img src="img/travel-images/large/<%=pictureList.get(1).getPath()%>" alt="Second slide"
                     style="width: 100%;">
                <div class="carousel-caption"><%=pictureList.get(1).getTitle()%>
                </div>
            </a>
        </div>
        <div class="item">
            <a href="/detail?id=<%=pictureList.get(2).getID()%>">
                <img src="img/travel-images/large/<%=pictureList.get(2).getPath()%>" alt="Third slide"
                     style="width: 100%;">
                <div class="carousel-caption"><%=pictureList.get(2).getTitle()%>
                </div>
            </a>
        </div>

    </div>
    <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
        <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
    </a>
    <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
        <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
    </a>
</div>
<div class="container">

    <h3>热门照片<span class="label label-danger" style="padding-bottom: 1.6;">HOT!</span></h3>
    <hr>
    <div class="row">
        <%
            for (Picture picture : pictureList) {
        %>
        <div class="col-md-3">
            <div class="card " style="width:200px;height: 400px">
                <img class="card-img-top" src="img/travel-images/square-medium/<%=picture.getPath()%>"
                     style="width:100%" alt="popular picture">
                <div class="card-body">
                    <h4 class="card-title"><%=picture.getTitle()%>
                    </h4>
                    <p class="card-text">作者:<%=picture.getAuthor()%>
                    </p>
                    <p class="card-text">主题:<%=picture.getContent()%>
                    </p>
                    <p class="card-text">收藏人数:<%=picture.getLikePerson()%>
                    </p>
                    <a href="/detail?id=<%=picture.getID()%>" class="btn btn-primary">详情</a>
                </div>
            </div>
        </div>
        <%
            }
        %>

    </div>

    <h3>最新照片<span class="label label-info" style="padding-bottom: 1.6;">NEW!</span></h3>
    <hr>
    <div class="row">
        <%
            List<Picture> pictureList1 = PictureDAO.getNewPic();
            for (Picture picture : pictureList1) {
        %>
        <div class="col-md-3">
            <div class="card " style="width:200px;height: 400px">
                <img class="card-img-top" src="img/travel-images/square-medium/<%=picture.getPath()%>"
                     style="width:100%" alt="new picture">
                <div class="card-body">
                    <h4 class="card-title"><%=picture.getTitle()%>
                    </h4>
                    <p class="card-text">作者:<%=picture.getAuthor()%>
                    </p>
                    <p class="card-text">主题:<%=picture.getContent()%>
                    </p>
                    <p class="card-text">发布时间:<%=picture.getUpdate()%>
                    </p>
                    <a href="/detail?id=<%=picture.getID()%>" class="btn btn-primary">详情</a>
                </div>
            </div>
        </div>
        <%
            }
        %>

    </div>
</div>
<hr>
<div class="foot"><span>Copyright © GhostFly</span></div>
<script src="JS/SpecialEffect.js"></script>
</body>
</html>