package Servlet.picture_servlet;

import DAO.PictureDAO;
import Entity.Picture;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

@WebServlet(name = "UpdateServlet", value = "/update")
public class UpdateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username != null) {
            Picture picture = new Picture();
            picture.setAuthor(username);
            request.setCharacterEncoding("utf-8");
            DiskFileItemFactory diskFileItemFactory = new DiskFileItemFactory();//使用factory的缓冲区和临时文件
            ServletFileUpload servletFileUpload = new ServletFileUpload(diskFileItemFactory);
            List<FileItem> fileItems = null;
            try {
                //获得表单中提交的数据（为List集合）
                fileItems = servletFileUpload.parseRequest(request);
            } catch (FileUploadException e) {
                e.printStackTrace();
            }

            String imgName = "";
            String[] filePath = {getServletContext().getRealPath("/img") + "\\travel-images\\large\\"};
            Iterator iter = fileItems.iterator();
            while (iter.hasNext()) {
                FileItem fileItem = (FileItem) iter.next();
                //如果是表单域，不是文件类型
                if (fileItem.isFormField()) {
                    //获取value值，声明代码编码
                    String value = fileItem.getString("utf-8");
                    switch (fileItem.getFieldName()) {
                        case "id":
                            picture.setID(value);
                            picture.setPath(PictureDAO.findPic(value).getPath());
                            break;
                        case "title":
                            picture.setTitle(value);
                            break;
                        case "content":
                            picture.setContent(value);
                            break;
                        case "country":
                            picture.setCountryName(value);
                            break;
                        case "region":
                            picture.setCityName(value);
                            break;
                        case "description":
                            picture.setDescription(value);
                            break;
                    }
                } else {
                    imgName = fileItem.getName();
                    if (imgName != null && !imgName.equals("")) {
                        picture.setPath(imgName);
                        try {
                            for (String path : filePath)
                                fileItem.write(new File(path + imgName));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
            PictureDAO.update(picture);
            PictureDAO.createSquareImg(getServletContext().getRealPath("/img") + "\\travel-images\\large\\" + imgName, getServletContext().getRealPath("/img") + "\\travel-images\\square-medium\\" + imgName);

            PictureDAO.createSmallImg(getServletContext().getRealPath("/img") + "\\travel-images\\large\\" + imgName, getServletContext().getRealPath("/img") + "\\travel-images\\small\\" + imgName);
        }

        request.getRequestDispatcher("/myPhoto").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}