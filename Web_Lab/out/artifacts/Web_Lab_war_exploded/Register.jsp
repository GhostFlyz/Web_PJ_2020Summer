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
            var val = $('#verify').val().toLowerCase();
            var num = show_num.join("");
            if (val !== num) {
                alert("验证码错误");
                draw(show_num)
                return false;
            }
            alert("注册成功！");
            return true;
        } else {
            alert("请正确填写信息");
            return false;
        }
    }

    var show_num = [];
    draw(show_num);

    //先阻止画布默认点击发生的行为再执行drawPic()方法
    document.getElementById("canvas").onclick = function (e) {
        e.preventDefault();
        draw(show_num)
    };

    //生成并渲染出验证码图形
    function draw(show_num) {
        var canvas_width = $('#canvas').width();
        var canvas_height = $('#canvas').height();
        var canvas = document.getElementById("canvas");//获取到canvas的对象，演员
        var context = canvas.getContext("2d");//获取到canvas画图的环境，演员表演的舞台
        canvas.width = canvas_width;
        canvas.height = canvas_height;
        var sCode = "a,b,c,d,e,f,g,h,i,j,k,m,n,p,q,r,s,t,u,v,w,x,y,z,A,B,C,E,F,G,H,J,K,L,M,N,P,Q,R,S,T,W,X,Y,Z,1,2,3,4,5,6,7,8,9,0";
        var aCode = sCode.split(",");
        var aLength = aCode.length;//获取到数组的长度

        for (var i = 0; i < 4; i++) {  //for循环可以控制验证码位数
            var j = Math.floor(Math.random() * aLength);//获取到随机的索引值
            var deg = Math.random() - 0.5; //产生一个随机弧度
            var txt = aCode[j];//得到随机的一个内容
            show_num[i] = txt.toLowerCase();
            var x = 10 + i * 20;//文字在canvas上的x坐标
            var y = 20 + Math.random() * 8;//文字在canvas上的y坐标
            context.font = "bold 23px 微软雅黑";

            context.translate(x, y);
            context.rotate(deg);

            context.fillStyle = randomColor();
            context.fillText(txt, 0, 0);

            context.rotate(-deg);
            context.translate(-x, -y);
        }
        for (var i = 0; i <= 5; i++) { //验证码上显示线条
            context.strokeStyle = randomColor();
            context.beginPath();
            context.moveTo(Math.random() * canvas_width, Math.random() * canvas_height);
            context.lineTo(Math.random() * canvas_width, Math.random() * canvas_height);
            context.stroke();
        }
        for (var i = 0; i <= 30; i++) { //验证码上显示小点
            context.strokeStyle = randomColor();
            context.beginPath();
            var x = Math.random() * canvas_width;
            var y = Math.random() * canvas_height;
            context.moveTo(x, y);
            context.lineTo(x + 1, y + 1);
            context.stroke();
        }
    }

    //得到随机的颜色值
    function randomColor() {
        var r = Math.floor(Math.random() * 256);
        var g = Math.floor(Math.random() * 256);
        var b = Math.floor(Math.random() * 256);
        return "rgb(" + r + "," + g + "," + b + ")";
    }
</script>
</body>
</html>