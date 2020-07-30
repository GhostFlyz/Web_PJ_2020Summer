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

@WebServlet(name = "RegisterServlet", value = "/register")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        if (UserDAO.findUser(name) == null && UserDAO.findUser(email) == null) {
            User user = new User(null, email, name, pass,1,null);
            UserDAO.saveUser(user);
            request.setAttribute("info", "Register success!");
            HttpSession session = request.getSession();
            session.setAttribute("username", user.getUserName());
        } else {
            request.setAttribute("info", "Sorry,You has been registered!");
        }
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}