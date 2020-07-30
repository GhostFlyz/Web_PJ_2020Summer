package Servlet.picture_servlet;

import DAO.PictureDAO;
import Entity.Picture;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "DetailServlet", value = "/detail")
public class DetailServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username != null) {
            PictureDAO.addFootprint(username, id);
        }
        Picture picture = PictureDAO.findPic(id);
        request.setAttribute("picture", picture);
        request.getRequestDispatcher("Details.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}