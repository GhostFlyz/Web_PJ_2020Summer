package DAO;

import Entity.Friend;
import Entity.User;
import Util.JdbcUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FriendDAO {
    private static JdbcUtil jdbcUtil = new JdbcUtil();

    public static Friend findRequest(String from, String to) {
        Friend request = null;
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from friend WHERE fromUID=? AND toUID=?";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, from);
            pst.setString(2, to);
            rs = pst.executeQuery();
            while (rs.next()) {
                request = new Friend(rs.getString("friendID"), from, to, rs.getInt("status"));
            }
            return request;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    public static void send(Friend request) {
        Connection conn = jdbcUtil.getConnection();
        String sql1 = "INSERT INTO friend(fromUID, toUID, status) VALUES (?,?,?)";
        PreparedStatement pst = null;
        try {
            pst = conn.prepareStatement(sql1);
            pst.setString(1, request.getFromUID());
            pst.setString(2, request.getToUID());
            pst.setInt(3, 0);
            pst.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jdbcUtil.close(null, pst, conn);
        }
    }

    public static void agree(String friendID) {
        Connection conn = jdbcUtil.getConnection();
        String sql = "UPDATE friend SET status = 1 WHERE friendID= ?";
        PreparedStatement pst = null;
        decision(friendID, conn, sql, pst);
    }

    public static void reject(String friendID) {
        Connection conn = jdbcUtil.getConnection();
        String sql = "UPDATE friend SET status = -1 WHERE friendID= ?";
        PreparedStatement pst = null;
        decision(friendID, conn, sql, pst);
    }

    private static void decision(String friendID, Connection conn, String sql, PreparedStatement pst) {
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, friendID);
            pst.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jdbcUtil.close(null, pst, conn);
        }
    }

    public static List<User> allFriends(String UID) {
        List<User> users = new ArrayList<>();
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from friend WHERE (fromUID=? OR toUID=?) AND status=1";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, UID);
            pst.setString(2, UID);
            rs = pst.executeQuery();
            while (rs.next()) {
                if (UID.equals(rs.getString("fromUID"))) {
                    users.add(UserDAO.findUserByID(rs.getString("toUID")));
                } else {
                    users.add(UserDAO.findUserByID(rs.getString("fromUID")));
                }
            }
            return users;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    public static List<User> allRequestsIReceived(String UID) {
        List<User> users = new ArrayList<>();
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from friend WHERE toUID=? AND status=0";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, UID);
            rs = pst.executeQuery();
            while (rs.next()) {
                users.add(UserDAO.findUserByID(rs.getString("fromUID")));
            }
            return users;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    public static List<User> allRequestsISent(String UID) {
        List<User> users = new ArrayList<>();
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from friend WHERE fromUID=? AND status=0";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, UID);
            rs = pst.executeQuery();
            while (rs.next()) {
                users.add(UserDAO.findUserByID(rs.getString("toUID")));
            }
            return users;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }

    }
}