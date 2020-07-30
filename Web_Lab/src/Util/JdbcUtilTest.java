package Util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class JdbcUtilTest {
    public static void main(String[] args) {
        JdbcUtil jdbcUtil = new JdbcUtil();
        Connection conn = jdbcUtil.getConnection();
        String sql = "select * from traveluser";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            while (rs.next()) {
                System.out.println(rs.getString("UserName"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }
}