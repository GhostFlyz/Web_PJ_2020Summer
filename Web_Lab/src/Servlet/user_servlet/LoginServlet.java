package Servlet.user_servlet;

import DAO.UserDAO;
import Entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = request.getParameter("message");
        String pass = request.getParameter("password");
        User user = UserDAO.findUser(message);
        if(user!=null){
            if (user.getPass().equals(pass)) {
                request.setAttribute("info", "Hello! Login Successfully!");
                HttpSession session = request.getSession();
                session.setAttribute("username", user.getUserName());
            } else {
                request.setAttribute("info", "Sorry!Wrong Password!");
            }
        }else {
            request.setAttribute("info", "Sorry!Can't find user");
        }
        response.sendRedirect(request.getHeader("Referer"));
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}