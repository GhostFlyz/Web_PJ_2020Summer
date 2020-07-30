<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>注册</title>
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
        <h1>注册</h1>
        <div class="col-sm-offset-1 col-sm-10" style="margin-left: 0px;padding-left: 0px;">
            <a href="Login.jsp">已有账号？马上登录！</a>
        </div>
        <br>
    </div>
    <form action="./register" method="post" onsubmit="return check()" class="form-horizontal" role="form">
        <div id="nameGroup" class="form-group ">
            <label class="col-sm-2 control-label">用户名:</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="name" name="name" placeholder="enter name..."
                       onchange="checkName()" required><br>
            </div>
            <span id="helpBlock1" class="help-block"></span>
        </div>
        <div id="emailGroup" class="form-group">
            <label class="col-sm-2 control-label">邮箱:</label>
            <div class="col-sm-4">
                <input type="email" class="form-control" id="email" name="email" placeholder="enter email..."
                       onchange="checkEmail()" required><br>
            </div>
            <span id="helpBlock2" class="help-block"></span>
        </div>
        <div id="passGroup" class="form-group">
            <label class="col-sm-2 control-label">密码:</label>
            <div class="col-sm-4">
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="enter password..."
                       oninput="checkPassWord()" required> <br>
            </div>
            <span id="helpBlock3" class="help-block"></span>
        </div>
        <div id="rePassGroup" class="form-group">
            <label class="col-sm-2 control-label">确认密码:</label>
            <div class="col-sm-4">
                <input type="password" class="form-control" id="rePassword" name="password"
                       placeholder="confirm password..."
                       oninput="checkRePass()" required> <br>
            </div>
            <span id="helpBlock4" class="help-block"></span>
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
            <div class="col-sm-offset-2 col-sm-4">
                <input type="submit" class="btn btn-primary" value="提交">
            </div>
        </div>
    </form>
</div>
<%
    }
%>
<script>
    var namecheck = false;

    function checkName() {
        var name = $("#name").val();
        var pattern = /^[a-zA-Z0-9_]{4,15}$/;
        if (pattern.test(name)) {
            $("#nameGroup").removeClass("has-error");
            $("#helpBlock1").html("");
            $.ajax({
                type: "post",
                async: false,
                url: "./checkUser",
                data: {"name": name},
                timeout: 30000,
                data_type: 'json',
                success: function (data) {
                    if (data === "NameOK") {
                        $("#nameGroup").removeClass("has-error");
                        $("#nameGroup").addClass("has-success");
                        $("#helpBlock1").html('<p style="color: green"> <span class="glyphicon glyphicon-ok"></span></p>');
                        namecheck = true;
                    } else {
                        $("#nameGroup").addClass("has-error");
                        $("#helpBlock1").html("用户名已存在");
                        namecheck = false;
                    }
                }
            });
        } else {
            $("#nameGroup").addClass("has-error");
            $("#helpBlock1").html("用户名长度应当为 4 至 15 位");
            namecheck = false;
        }
    }

    var emailcheck = false;

    function checkEmail() {
        var email = $("#email").val();
        var pattern = /^([A-Za-z0-9_\-.\u4e00-\u9fa5])+@([A-Za-z0-9_\-.])+\.([A-Za-z]{2,8})$/;
        if (pattern.test(email)) {
            $("#emailGroup").removeClass("has-error");
            $("#helpBlock2").html("");
            $.ajax({
                type: "post",
                async: false,
                url: "./checkUser",
                data: {"email": email},
                timeout: 30000,
                data_type: 'json',
                success: function (data) {
                    if (data === "EmailOK") {
                        $("#emailGroup").removeClass("has-error");
                        $("#emailGroup").addClass("has-success");
                        $("#helpBlock2").html('<p style="color: green"> <span class="glyphicon glyphicon-ok"></span></p>');
                        emailcheck = true;
                    } else {
                        $("#emailGroup").addClass("has-error");
                        $("#helpBlock2").html("该邮箱已注册");
                        emailcheck = false;
                    }
                }
            });
        } else {
            $("#emailGroup").addClass("has-error");
            $("#helpBlock2").html("请输入正确的邮箱地址");
            emailcheck = false;
        }
    }

    function checkPassWord() {
        var password = $('#password').val();
        var passGroup = $('#passGroup');

        function getValue(password) {
            var value = 0;
            if (password.length >= 6 && password.length <= 12) {
                value = 1;
                for (var i = 0; i < password.length; i++) {
                    var current = password.charCodeAt(i);
                    //大写或小写字母
                    if (((current >= 65 && current <= 90) || (current >= 97 && current <= 122))) {
                        value = 2;
                    }
                    //特殊字符
                    if (((current >= 33 && current <= 47) || (current >= 58 && current <= 64) || (current >= 91 && current <= 96) || (current >= 123 && current <= 126)) && password.length >= 8) {
                        value = 3;
                        break;
                    }
                }
            }
            return value;
        }

        var value = getValue(password);
        if (value === 0) {
            $("#helpBlock3").html('密码需在6至12位');
            passGroup.removeClass("has-warning");
            passGroup.addClass("has-error");
            return false;
        } else if (value === 1) {
            $("#helpBlock3").html('<p style="color:#8a6d3b"><span class="glyphicon glyphicon-ok">低强度密码</span></p>');
            passGroup.removeClass("has-error");
            passGroup.addClass("has-warning");
            return true;
        } else if (value === 2) {
            $("#helpBlock3").html('<p style="color:#66afe9"><span class="glyphicon glyphicon-ok">中强度密码</span></p>');
            passGroup.removeClass("has-warning");
            passGroup.removeClass("has-error");
            return true;
        } else if (value === 3) {
            $("#helpBlock3").html('<p style="color:green"><span class="glyphicon glyphicon-ok">高强度密码</span></p>');
            passGroup.removeClass("has-warning");
            passGroup.removeClass("has-error");
            passGroup.addClass("has-success");
            return true;
        }
    }

    function checkRePass() {
        var password = $('#password').val();
        var rePassword = $('#rePassword').val();
        if (rePassword === password) {
            $("#rePassGroup").removeClass("has-error");
            $("#rePassGroup").addClass("has-success");
            $("#helpBlock4").html('<p style="color: green"> <span class="glyphicon glyphicon-ok"></span></p>');
            return true;
        } else {
            $("#rePassGroup").addClass("has-error");
            $("#helpBlock4").html("两次密码输入不一致");
            return false;
        }
    }

    function check() {
        if (namecheck && emailcheck && checkPassWord() && checkRePass()) {
            if ($('#verify').val() !== _picTxt) {
                alert("验证码错误");
                return false;
            }
            return true;
        } else {
            alert("请正确填写信息");
            return false;
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