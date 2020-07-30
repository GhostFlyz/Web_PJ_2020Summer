
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
import java.io.PrintWriter;

@WebServlet(name = "LoginCheckServlet", value = "/loginCheck")
public class LoginCheckServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = request.getParameter("message");
        String pass = request.getParameter("password");
        User user = UserDAO.findUser(message);
        PrintWriter out = null;
        try {
            out = response.getWriter();
            if (user != null) {
                if (user.getPass().equals(pass)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", user.getUserName());
                    out.print("OK");
                } else {
                    out.print("NO");
                }
            } else {
                out.print("NOUSER");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            out.flush();
            out.close();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}