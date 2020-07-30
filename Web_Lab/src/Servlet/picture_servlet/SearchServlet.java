package Servlet.picture_servlet;

import DAO.PictureDAO;
import Entity.Picture;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "SearchServlet", value = "/search")
public class SearchServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String text = request.getParameter("text");
        String type = request.getParameter("type");
        String order = request.getParameter("order");
        List<Picture> pictures = new ArrayList<>();
        if (type.equals("title")) {
            pictures = PictureDAO.searchByTitle(text, order);
        } else if (type.equals("content")) {
            pictures = PictureDAO.searchByContent(text, order);
        }
        String result = PictureDAO.parseToJson(pictures);
        request.setAttribute("result", result);
        request.getRequestDispatcher("Search.jsp").forward(request, response);
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}