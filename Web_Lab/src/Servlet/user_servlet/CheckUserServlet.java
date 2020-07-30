package Servlet.user_servlet;

import DAO.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "CheckUserServlet", value = "/checkUser")
public class CheckUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        PrintWriter out = null;
        try {
            out = response.getWriter();
            if (name != null) {
                if (UserDAO.findUser(name) == null) {
                    out.print("NameOK");
                } else {
                    out.print("NameExist");
                }
            } else if (email != null) {
                if (UserDAO.findUser(email) == null) {
                    out.print("EmailOK");
                } else {
                    out.print("EmailExist");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            out.flush();
            out.close();
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}