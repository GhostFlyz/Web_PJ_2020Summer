package Servlet.picture_servlet;

import DAO.PictureDAO;
import Entity.Picture;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "FindUpDateServlet", value = "/findUpdate")
public class FindUpDateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        Picture picture = PictureDAO.findPic(id);
        request.setAttribute("picture", picture);
        request.getRequestDispatcher("Update.jsp").forward(request, response);
    }
}