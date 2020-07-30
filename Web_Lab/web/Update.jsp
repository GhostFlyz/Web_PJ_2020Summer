<%@ page import="DAO.OtherDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="Entity.Picture" %><%--
  Created by IntelliJ IDEA.
  User: ZJT
  Date: 2020/7/28
  Time: 15:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>修改</title>
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
} else{
%>
<div class="container">
    <div class="title">
        <h3><strong>修改图片</strong></h3>
    </div>
    <hr>
    <%
        Picture picture = (Picture) request.getAttribute("picture");
    %>
    <div class="row">
        <form action="/update" onsubmit="return confirm('确定要修改吗？')" enctype="multipart/form-data" method="post">
            <input type="hidden" name="id" value="<%=picture.getID()%>">
            <div class="col-lg-4">
                <p>选择您要上传的图片：</p>
                <img name="showimg" src="img/travel-images/large/<%=picture.getPath()%>" id="showimg" style="width: 100%" alt="图片">
                <input name="file" type="file" id="upfile" size="40"  onchange="viewmypic(showimg,this.form.upfile);"
                       accept="image/gif, image/jpeg" >
            </div>
            <div class="col-lg-7 col-lg-offset-1">
                <div class="form-group">
                    <label for="title">标题：</label>
                    <input name="title" class="form-control" id="title" value="<%=picture.getTitle()%>"  type="text" required>
                </div>
                <div class="form-group">
                    <label for="content">主题：</label>
                    <input name="content" class="form-control" id="content" value="<%=picture.getContent()%>" type="text" required>
                </div>
                <div class="form-group">
                    <label>国家和地区：</label>
                    <select class="form-control" id="country" name="country" style="width: 30%;"  onchange="getCity()" required>
                        <%
                            List<String> allCountries = OtherDAO.getAllCountries();
                            for (String country : allCountries) {
                                if (country.equals(picture.getCountryName())){
                                    out.print("<option value=\"" + country + "\" selected>" + country + "</option>");
                                }else {
                                    out.print("<option value=\"" + country + "\">" + country + "</option>");
                                }
                            }
                        %>
                    </select>
                    &nbsp;
                    <select class="form-control" id="region" name="region"  style="width: 30%;" required>
                        <option value="<%=picture.getCityName()%>" selected><%=picture.getCityName()%></option>
                    </select>
                </div>
                <div class="form-group">
                    <label>简介：</label>
                    <textarea name="description" id="description" class="form-control" rows="2" required></textarea>
                </div>

                <button type="submit" class="btn btn-primary">提交</button>
            </div>

        </form>
    </div>

</div>
<script type="text/javascript">
    $('#description').val("<%=picture.getDescription()%>");
    function viewmypic(mypic, upfile) {
        if (upfile.files && upfile.files[0]) {
            mypic.style.display = "";
            mypic.src = window.URL.createObjectURL(upfile.files[0]);
        } else {
            mypic.style.display = "none";
        }
    }
    function getCity() {
        var country = $("#country").val();
        var city = $("#region");
        var cities;
        $.ajax({
            type: "post",
            async: false,
            url: "./getCity",
            data: {"country": country},
            timeout: 30000,
            data_type: 'json',
            success: function (data) {
                cities = JSON.parse(data).city;
            }, error: function () {
                alert("请求出错");
            }
        });
        if (cities) {
            city.empty().html(fillContents(cities));
        }
    }
    function fillContents(contents) {
        var str;
        for (var i = 0; i < contents.length; i++) {
            str += '<option value=\"' + contents[i] + '\">' + contents[i] + '</option>';
        }
        return str;
    }
</script>
<%
    }
%>
</body>
</html>