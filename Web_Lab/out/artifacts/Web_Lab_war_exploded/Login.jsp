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
                <input type="text" name="message" class="form-control" id="message"
                       placeholder="enter email/username..."
                       required><br>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">密码:</label>
            <div class="col-sm-4">
                <input type="password" name="password" class="form-control" id="password"
                       placeholder="enter password..."
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
        var val = $('#verify').val().toLowerCase();
        var num = show_num.join("");
        if (val !== num) {
            alert("验证码错误");
            draw(show_num);
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

    var show_num = [];
    draw(show_num);

    //先阻止画布默认点击发生的行为再执行drawPic()方法
    document.getElementById("canvas").onclick = function (e) {
        e.preventDefault();
        draw(show_num);
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