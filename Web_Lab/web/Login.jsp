<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录</title>
    <link rel="shortcut icon" href="img/web-images/Icon.png" type="image/png">
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<%@include file="navbar.jsp" %>
<div style="height: 50px"></div>
<%
    if (session.getAttribute("username") != null) {
%>
<p>您已经登陆啦！</p>
<%
} else {
%>
<div class="container">
    <div class="page-header">
        <h1>登录</h1>
        <div class="col-sm-offset-1 col-sm-10" style="margin-left: 0px;padding-left: 0px;">
            <a href="Register.jsp">没有账号？现在注册！</a>
        </div>
        <br>
    </div>
    <form action="./login" method="post" onsubmit="return checkLogin()" class="form-horizontal" role="form">
        <div class="form-group">
            <label class="col-sm-2 control-label">用户名/邮箱:</label>
            <div class="col-sm-4">
                <input type="text" name="message" class="form-control" id="message" placeholder="enter email/username..."
                       required><br>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">密码:</label>
            <div class="col-sm-4">
                <input type="password" name="password" class="form-control" id="password" placeholder="enter password..."
                       required> <br>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">验证码:</label>
            <div class="col-sm-4">
                <input class="form-control" type="text" name="verify" id="verify" style="width: 50%"
                       placeholder="enter CAPTCHA..." required>
                <canvas id="canvas" width="100px" height="50px" style="margin-left: 225px;margin-top: -42;"></canvas>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-5">
                <button type="submit" class="btn btn-primary">登录</button>
            </div>
        </div>
    </form>
</div>
<%
    }
%>
<script>
    function checkLogin() {
        var status = false;
        var message = $('#message').val();
        var password = $('#password').val();
        if ($('#verify').val() !== _picTxt) {
            alert("验证码错误");
            return false;
        } else {
            $.ajax({
                type: "post",
                async: false,
                url: "./loginCheck",
                data: {"message": message, "password": password},
                timeout: 30000,
                data_type: 'json',
                success: function (data) {
                    if (data === "OK") {
                        status = true;
                    } else if (data === "NO") {
                        status = false;
                    } else {
                        status = false;
                    }
                }
            });
            if (status) {
                alert("登陆成功！");
                self.location = document.referrer;
                return false;
            } else {
                alert("用户名或密码错误");
                $('#password').val("");
                return false;
            }
        }
    }

    //绘制验证码
    //生成随机数
    function randomNum(min, max) {
        return Math.floor(Math.random() * (max - min) + min);
    }

    //生成随机颜色RGB分量
    function randomColor(min, max) {
        var _r = randomNum(min, max);
        var _g = randomNum(min, max);
        var _b = randomNum(min, max);
        return "rgb(" + _r + "," + _g + "," + _b + ")";
    }

    //先阻止画布默认点击发生的行为再执行drawPic()方法
    document.getElementById("canvas").onclick = function (e) {
        e.preventDefault();
        drawPic();
    };
    var _picTxt = "";

    function drawPic() {
        _picTxt = "";
        //获取到元素canvas
        var $canvas = document.getElementById("canvas");
        var _str = "0123456789";//设置随机数库
        var _num = 4;//4个随机数字
        var _width = $canvas.width;
        var _height = $canvas.height;
        var ctx = $canvas.getContext("2d");//获取 context 对象
        ctx.textBaseline = "bottom";//文字上下对齐方式--底部对齐
        ctx.fillStyle = randomColor(180, 240);//填充画布颜色
        ctx.fillRect(0, 0, _width, _height);//填充矩形--画画
        for (var i = 0; i < _num; i++) {
            var x = (_width - 10) / _num * i + 10;
            var y = randomNum(_height / 2, _height);
            var deg = randomNum(-30, 30);
            var txt = _str[randomNum(0, _str.length)];
            _picTxt += txt;//获取一个随机数
            ctx.fillStyle = randomColor(10, 100);//填充随机颜色
            ctx.font = randomNum(25, 40) + "px SimHei";//设置随机数大小，字体为SimHei
            ctx.translate(x, y);//将当前xy坐标作为原始坐标
            ctx.rotate(deg * Math.PI / 180);//旋转随机角度
            ctx.fillText(txt, 0, 0);//绘制填色的文本
            ctx.rotate(-deg * Math.PI / 180);
            ctx.translate(-x, -y);
        }
        for (var i = 0; i < _num; i++) {
            //定义笔触颜色
            ctx.strokeStyle = randomColor(90, 180);
            ctx.beginPath();
            //随机划线--4条路径
            ctx.moveTo(randomNum(0, _width), randomNum(0, _height));
            ctx.lineTo(randomNum(0, _width), randomNum(0, _height));
            ctx.stroke();
        }
        for (var i = 0; i < _num * 10; i++) {
            ctx.fillStyle = randomColor(0, 255);
            ctx.beginPath();
            //随机画原，填充颜色
            ctx.arc(randomNum(0, _width), randomNum(0, _height), 1, 0, 2 * Math.PI);
            ctx.fill();
        }
    }

    drawPic();
</script>
</body>
</html>