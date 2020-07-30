package Servlet.friend_servlet;

import DAO.FriendDAO;
import DAO.UserDAO;
import Entity.Friend;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "RejectServlet", value = "/reject")
public class RejectServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String name = (String) session.getAttribute("username");
        String UID = UserDAO.getID(name);
        String id = (String) request.getParameter("id");
        Friend request1 = FriendDAO.findRequest(id, UID);
        FriendDAO.reject(request1.getID());
        response.sendRedirect(request.getHeader("Referer"));
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}