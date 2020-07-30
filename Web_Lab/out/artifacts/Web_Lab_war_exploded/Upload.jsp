<%@ page import="DAO.OtherDAO" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: ZJT
  Date: 2020/7/28
  Time: 15:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>上传</title>
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
        <h3><strong>上传图片</strong></h3>
    </div>
    <hr>
    <div class="row">
        <form action="/upload" onsubmit="return checkDefault()" enctype="multipart/form-data" method="post">
            <div class="col-lg-4">
                <p>选择您要上传的图片：</p>
                <img name="showimg" id="showimg" style="display: none;width: 100%" alt="图片">
                <input name="file" type="file" id="upfile" size="40" onchange="viewmypic(showimg,this.form.upfile);"
                       accept="image/gif, image/jpeg" required>
            </div>
            <div class="col-lg-7 col-lg-offset-1">
                <div class="form-group">
                    <label for="title">标题：</label>
                    <input name="title" class="form-control" id="title" type="text" required>
                </div>
                <div class="form-group">
                    <label for="content">主题：</label>
                    <input name="content" class="form-control" id="content" type="text" required>
                </div>
                <div class="form-group">
                    <label>国家和地区：</label>
                    <select class="form-control" id="country" name="country" style="width: 30%;" onchange="getCity()"
                            required>
                        <option value="default" selected> 请选择</option>
                        <%
                            List<String> allCountries = OtherDAO.getAllCountries();
                            for (String country : allCountries) {
                                out.print("<option value=\"" + country + "\">" + country + "</option>");
                            }
                        %>
                    </select>
                    &nbsp;
                    <select class="form-control" id="region" name="region" style="width: 30%;" required>
                        <option value="default" selected> 无</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>简介：</label>
                    <textarea name="description" class="form-control" rows="2" required></textarea>
                </div>

                <button type="submit" class="btn btn-primary">提交</button>
            </div>

        </form>
    </div>

</div>
<%
    }
%>
<script type="text/javascript">
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
        if (cities)
            city.empty().html(fillContents(cities));
    }

    function fillContents(contents) {
        var str;
        for (var i = 0; i < contents.length; i++) {
            str += '<option value=\"' + contents[i] + '\">' + contents[i] + '</option>';
        }
        return str;
    }

    function checkDefault() {
        var country = $("#country").val();
        var region = $("#region").val();
        if (country === "default" || region === "default") {
            alert("请正确填写国家和地区");
            return false;
        } else {
            if (confirm("是否确认信息无误？")) {
                return true;
            } else {
                return false;
            }
        }
    }
</script>
</body>
</html>