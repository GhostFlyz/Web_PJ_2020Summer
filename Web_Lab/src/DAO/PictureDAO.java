package DAO;

import Entity.Picture;
import Entity.User;
import Util.JdbcUtil;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.awt.image.CropImageFilter;
import java.awt.image.FilteredImageSource;
import java.awt.image.ImageFilter;
import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PictureDAO {

    private static JdbcUtil jdbcUtil = new JdbcUtil();

    public static Picture findPic(String ID) {
        Picture picture = null;
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from travelimage WHERE ImageID = '" + ID + "'";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            if (rs.next()) {
                User user = UserDAO.findUserByID(rs.getString("uid"));
                String countryName = OtherDAO.getCountryName(rs.getString("country_RegionCodeIso"));
                String cityName = OtherDAO.getCityName(rs.getString("cityCode"));
                picture = new Picture(rs.getString("ImageID"),
                        rs.getString("Title"),
                        rs.getString("Description"),
                        cityName,
                        countryName,
                        user.getUserName(),
                        rs.getString("path"),
                        rs.getString("content"),
                        rs.getInt("likeperson"),
                        rs.getTimestamp("updateTime"));
            }
            return picture;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }


    public static List<Picture> getHotPic() {
        String sql = "SELECT ImageID, COUNT(*) AS count FROM travelimagefavor GROUP BY ImageID " +
                "ORDER BY count DESC LIMIT 4";
        return getPicList(sql);
    }

    public static List<Picture> getNewPic() {
        String sql = "SELECT * from travelimage ORDER BY updateTime DESC LIMIT 4";
        return getPicList(sql);
    }

    public static List<Picture> findMyPhoto(String username) {
        User user = UserDAO.findUser(username);
        String userID = user.getID();
        String sql = "SELECT * from travelimage WHERE UID = '" + userID + "'";
        return getPicList(sql);
    }

    public static List<Picture> findFavour(String username) {
        User user = UserDAO.findUser(username);
        String userID = user.getID();
        String sql = "SELECT * from travelimagefavor WHERE UID = '" + userID + "'";
        return getPicList(sql);
    }

    public static List<Picture> searchByTitle(String title, String order) {
        String sql;
        if (!title.contains(" ")) {
            sql = "SELECT * FROM travelimage WHERE Title LIKE '%" + title + "%' ORDER BY " + order + " DESC";
        } else {
            sql = "SELECT * FROM travelimage WHERE ";
            String[] newStr = title.split(" ");
            for (String string : newStr) {
                sql += "Title LIKE '%" + string + "%' AND";
            }
            sql = sql.substring(0, sql.length() - 3);
            sql += "ORDER BY " + order + " DESC";
        }
        return getPicList(sql);
    }

    public static List<Picture> searchByContent(String content, String order) {
        String sql = "SELECT * FROM travelimage WHERE Content LIKE '%" + content + "%' ORDER BY " + order + " DESC";
        return getPicList(sql);
    }

    private static List<Picture> getPicList(String sql) {
        List<Picture> pictures = new ArrayList<>();
        Connection conn = jdbcUtil.getConnection();
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            while (rs.next()) {
                pictures.add(findPic(rs.getString("ImageID")));
            }
            return pictures;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    public static int getFavourNum(String ID) {
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from travelimagefavor WHERE ImageID = '" + ID + "'";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            rs.last();
            return rs.getRow();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    public static boolean alreadyFavoured(String username, String imageID) {
        String UID = UserDAO.getID(username);
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from travelimagefavor WHERE UID=? AND ImageID=?";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, UID);
            pst.setString(2, imageID);
            rs = pst.executeQuery();
            if (rs.next()) {
                return true;
            } else {
                return false;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    public static void addToMyFavour(String UID, String imageID) {
        Connection conn = jdbcUtil.getConnection();
        String sql1 = "INSERT INTO travelimagefavor(UID,ImageID) values(?,?)";
        String sql2 = "UPDATE travelimage SET likeperson=likeperson+1 WHERE ImageID=?";
        PreparedStatement pst = null;
        PreparedStatement pst2 = null;
        TODOMyFavor(UID, imageID, conn, sql1, sql2, pst);
    }

    public static void deleteMyFavour(String UID, String imageID) {
        Connection conn = jdbcUtil.getConnection();
        String sql = "DELETE FROM travelimagefavor WHERE UID=? AND ImageID=?";
        String sql2 = "UPDATE travelimage SET likeperson=likeperson-1 WHERE ImageID=?";
        PreparedStatement pst = null;
        PreparedStatement pst2 = null;
        TODOMyFavor(UID, imageID, conn, sql, sql2, pst);
    }

    private static void TODOMyFavor(String UID, String imageID, Connection conn, String sql, String sql2, PreparedStatement pst) {
        PreparedStatement pst2;
        try {
            pst = conn.prepareStatement(sql);
            pst2 = conn.prepareStatement(sql2);
            pst2.setString(1, imageID);
            pst.setString(1, UID);
            pst.setString(2, imageID);
            pst.execute();
            pst2.execute();
            pst2.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jdbcUtil.close(null, pst, conn);
        }
    }

    public static void save(Picture picture) {
        Connection conn = jdbcUtil.getConnection();
        String sql = "INSERT INTO travelimage(Title,Description,CityCode,Country_RegionCodeISO,UID,PATH,Content,likeperson) " +
                "VALUES (?,?,?,?,?,?,?,?)";
        PreparedStatement pst = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, picture.getTitle());
            pst.setString(2, picture.getDescription());
            pst.setString(3, OtherDAO.getCityCode(picture.getCityName()));
            pst.setString(4, OtherDAO.getCountryISO(picture.getCountryName()));
            pst.setString(5, UserDAO.getID(picture.getAuthor()));
            pst.setString(6, picture.getPath());
            pst.setString(7, picture.getContent());
            pst.setInt(8, 0);
            pst.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jdbcUtil.close(null, pst, conn);
        }

    }

    public static void update(Picture picture) {
        Connection conn = jdbcUtil.getConnection();
        String sql = "update travelimage SET Title = ?,Description=?,CityCode=?,Country_RegionCodeISO=?," +
                "UID=?,PATH=?,Content=? WHERE ImageID= ?";
        PreparedStatement pst = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, picture.getTitle());
            pst.setString(2, picture.getDescription());
            pst.setString(3, OtherDAO.getCityCode(picture.getCityName()));
            pst.setString(4, OtherDAO.getCountryISO(picture.getCountryName()));
            pst.setString(5, UserDAO.getID(picture.getAuthor()));
            pst.setString(6, picture.getPath());
            pst.setString(7, picture.getContent());
            pst.setString(8, picture.getID());
            pst.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jdbcUtil.close(null, pst, conn);
        }
    }

    public static void delete(String id) {
        Connection conn = jdbcUtil.getConnection();
        String sql = "DELETE FROM travelimage WHERE ImageID=" + id;
        String sql2 = "DELETE FROM travelimagefavor WHERE ImageID=" + id;
        String sql3 = "DELETE FROM footprint WHERE ImageID=" + id;
        PreparedStatement pst = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.execute();
            pst = conn.prepareStatement(sql2);
            pst.execute();
            pst = conn.prepareStatement(sql3);
            pst.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jdbcUtil.close(null, pst, conn);
        }
    }

    public static String parseToJson(List<Picture> pictures) {
        if (pictures.size() == 0)
            return "{\"results\":null}";
        String result = "";
        result += "{\"results\":[";
        String title = "";
        for (Picture picture : pictures) {
            title = picture.getTitle();
            if (picture.getTitle().indexOf("'") > 0) {
                title = title.replace("'", "\\'");
            }
            result +=
                    "{\"PATH\":\"" + picture.getPath() + "\"," +
                    " \"Title\":\"" + title + "\"," +
                    " \"Author\":\"" + picture.getAuthor() + "\"," +
                    " \"Content\":\"" + picture.getContent() + "\"," +
                    " \"likeperson\":\"" + picture.getLikePerson() + "\"," +
                    " \"updateTime\":\"" + picture.getUpdate() + "\"," +
                    " \"ImageID\":\"" + picture.getID() + "\"},";
        }
        result = result.substring(0, result.length() - 1);
        result += "]}";
        return result;
    }

    public static void addFootprint(String username, String ImageID) {
        Connection conn = jdbcUtil.getConnection();
        String UID = UserDAO.getID(username);
        String sql = "INSERT INTO footprint(UID, ImageID) VALUES (?,?)";
        PreparedStatement pst = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, UID);
            pst.setString(2, ImageID);
            pst.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jdbcUtil.close(null, pst, conn);
        }
    }

    public static List<Picture> findFootprint(String username) {
        ArrayList<String> ids = new ArrayList<>();
        List<Picture> pictures = new ArrayList<>();
        String UID = UserDAO.getID(username);
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from footprint WHERE UID=? ORDER BY footID DESC LIMIT 50";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, UID);
            rs = pst.executeQuery();
            while (rs.next() && ids.size() < 10) {
                String id = rs.getString("ImageID");
                if (!ids.contains(id)) {
                    ids.add(id);
                }
            }
            for (String id : ids) {
                pictures.add(findPic(id));
            }
            return pictures;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    public static void createSquareImg(String originPath, String squarePath) {
        try {
            BufferedImage src = ImageIO.read(new File(originPath));
            double srcHeight = src.getHeight();
            double srcWidth = src.getWidth();
            double newHeight, newWidth;
            if (srcWidth > srcHeight) {
                newHeight = 150;
                newWidth = srcWidth / srcHeight * 150;
            } else {
                newWidth = 150;
                newHeight = srcHeight / srcWidth * 150;
            }
            Image image = src.getScaledInstance((int) newWidth, (int) newHeight, Image.SCALE_DEFAULT);
            ImageFilter cropFilter = new CropImageFilter((int) newWidth / 2 - 75, (int) newHeight / 2 - 75, 150, 150);
            Image img = Toolkit.getDefaultToolkit().createImage(new FilteredImageSource(image.getSource(), cropFilter));
            BufferedImage tag = new BufferedImage(150, 150, BufferedImage.TYPE_INT_RGB);
            Graphics graphics = tag.getGraphics();
            graphics.drawImage(img, 0, 0, 150, 150, null);
            ImageIO.write(tag, "jpg", new File(squarePath));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void createSmallImg(String originPath, String smallPath) {
        try {
            BufferedImage src = ImageIO.read(new File(originPath));
            double srcHeight = src.getHeight();
            double srcWidth = src.getWidth();
            double newHeight, newWidth;
            if (srcWidth > srcHeight) {
                newHeight = 150;
                newWidth = srcWidth / srcHeight * 150;
            } else {
                newWidth = 150;
                newHeight = srcHeight / srcWidth * 150;
            }
            Image image = src.getScaledInstance((int) newWidth, (int) newHeight, Image.SCALE_DEFAULT);
            ImageFilter cropFilter = new CropImageFilter(0,0, (int)newWidth, (int)newHeight);
            Image img = Toolkit.getDefaultToolkit().createImage(new FilteredImageSource(image.getSource(), cropFilter));
            BufferedImage tag = new BufferedImage((int)newWidth, (int)newHeight, BufferedImage.TYPE_INT_RGB);
            Graphics graphics = tag.getGraphics();
            graphics.drawImage(img, 0, 0, (int)newWidth, (int)newHeight, null);
            ImageIO.write(tag, "jpg", new File(smallPath));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}