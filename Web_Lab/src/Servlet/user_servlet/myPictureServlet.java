
package Servlet.user_servlet;

import DAO.PictureDAO;
import Entity.Picture;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "myPictureServlet", value = "/myPhoto")
public class myPictureServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username != null) {
            List<Picture> pictures = PictureDAO.findMyPhoto(username);
            String json = PictureDAO.parseToJson(pictures);
            request.setAttribute("myPictures", json);
        }
        request.getRequestDispatcher("myPicture.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}