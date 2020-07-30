package Servlet.picture_servlet;

import DAO.OtherDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "FindCityServlet", value = "/getCity")
public class FindCityServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String country = request.getParameter("country");
        String json = "{\"city\":[";
        List<String> cities = OtherDAO.getAllCities(country);
        for (String city : cities) {
            json = json + "\"" + city + "\",";
        }
        json = json.substring(0, json.length() - 1);
        json = json + "]}";
        PrintWriter out = null;
        try {
            out = response.getWriter();
            out.print(json);
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