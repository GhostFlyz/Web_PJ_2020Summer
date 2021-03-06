package Servlet.user_servlet;

import DAO.PictureDAO;
import DAO.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "DeleteFavouriteServlet", value = "/deleteFavor")
public class DeleteFavouriteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String name = (String) session.getAttribute("username");
        String imageID = request.getParameter("imageID");
        PictureDAO.deleteMyFavour(UserDAO.getID(name), imageID);
        response.sendRedirect(request.getHeader("Referer"));
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}