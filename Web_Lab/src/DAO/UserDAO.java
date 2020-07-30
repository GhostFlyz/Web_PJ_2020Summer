package DAO;

import Entity.User;
import Util.JdbcUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private static JdbcUtil jdbcUtil = new JdbcUtil();

    public static String getID(String userName) {
        Connection conn = jdbcUtil.getConnection();
        String sql = "select * from traveluser where username = '" + userName + "'";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            if (rs.next())
                return rs.getString("UID");
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }


    static User findUserByID(String ID) {
        Connection conn = jdbcUtil.getConnection();
        String sql = "select * from traveluser where UID = " + ID;
        PreparedStatement pst = null;
        ResultSet rs = null;
        User user = null;
        try {
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            if (rs.next())
                user = new User(rs.getString("UID"), rs.getString("email"), rs.getString("username"), rs.getString("pass"), rs.getInt("State"), rs.getTimestamp("dateJoined"));
            return user;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    public static User findUser(String message) {
        Connection conn = jdbcUtil.getConnection();
        String sql1 = "select * from traveluser where email=?";
        String sql2 = "select * from traveluser where username=?";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {

            if (message.indexOf('@') > 0 && message.contains(".")) {
                pst = conn.prepareStatement(sql1);
                pst.setString(1, message);
            } else {
                pst = conn.prepareStatement(sql2);
                pst.setString(1, message);
            }

            rs = pst.executeQuery();
            if (rs.next()) {
                User user = new User(rs.getString("UID"), rs.getString("email"), rs.getString("username"), rs.getString("pass"), rs.getInt("State"), rs.getTimestamp("dateJoined"));
                return user;
            } else {
                return null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    public static List<User> findLikeUser(String message) {
        List<User> users = new ArrayList<>();
        Connection conn = jdbcUtil.getConnection();
        String sql2 = "select * from traveluser where username LIKE '%" + message + "%'";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql2);
            rs = pst.executeQuery();
            while (rs.next()) {
                User user = new User(rs.getString("UID"), rs.getString("email"), rs.getString("username"), rs.getString("pass"), rs.getInt("State"), rs.getTimestamp("dateJoined"));
                users.add(user);
            }
            return users;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    public static void saveUser(User user) {
        Connection conn = jdbcUtil.getConnection();
        String sql1 = "INSERT INTO traveluser(email,username,pass,state,DateJoined,DateLastModified) VALUES(?,?,?,?,?,?)";
        PreparedStatement pst = null;
        try {
            pst = conn.prepareStatement(sql1);
            pst.setString(1, user.getEmail());
            pst.setString(2, user.getUserName());
            pst.setString(3, user.getPass());
            pst.setInt(4, 1);
            pst.setDate(5, new Date(new java.util.Date().getTime()));
            pst.setDate(6, new Date(new java.util.Date().getTime()));
            pst.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jdbcUtil.close(null, pst, conn);
        }
    }

    public static void changeState(String username, int state) {
        User user = findUser(username);
        String UID = user.getID();
        Connection conn = jdbcUtil.getConnection();
        String sql = "UPDATE traveluser SET State = ? WHERE UID = ?";
        PreparedStatement pst = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, state);
            pst.setString(2, UID);
            pst.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jdbcUtil.close(null, pst, conn);
        }
    }
}