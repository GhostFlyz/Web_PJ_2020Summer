package Servlet.friend_servlet;

import DAO.PictureDAO;
import DAO.UserDAO;
import Entity.Picture;
import Entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "FriendsFavorServlet", value = "/friendFavor")
public class FriendsFavorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String friendName = request.getParameter("friendName");
        User friend = UserDAO.findUser(friendName);
        if (friend.getState() == 1) {
            List<Picture> pictures = PictureDAO.findFavour(friendName);
            String result = PictureDAO.parseToJson(pictures);
            request.setAttribute("friendName", friendName);
            request.setAttribute("pictures", result);
        } else {
            request.setAttribute("friendName", friendName);
            request.setAttribute("pictures", "{\"results\":\"NO\"}");
        }
        request.getRequestDispatcher("FriendsFavourite.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}