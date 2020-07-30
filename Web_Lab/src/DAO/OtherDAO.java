package DAO;

import Util.JdbcUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OtherDAO {
    private static  JdbcUtil jdbcUtil=new JdbcUtil();

    static String getCountryName(String ISO) {
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from geocountries_regions WHERE ISO = '" + ISO +"'";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            if (rs.next())
                return rs.getString("Country_RegionName");
            else
                return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    static String getCountryISO(String name) {
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from geocountries_regions WHERE Country_RegionName = '" + name +"'";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            if (rs.next())
                return rs.getString("ISO");
            else
                return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }


    static String getCityName(String cityCode){
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from geocities WHERE GeoNameID = '" + cityCode +"'";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            if (rs.next())
                return rs.getString("AsciiName");
            else
                return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    static String getCityCode(String name){
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from geocities WHERE AsciiName = ?";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1,name);
            rs = pst.executeQuery();
            if (rs.next())
                return rs.getString("GeoNameID");
            else
                return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    public static List<String> getAllCountries(){
        List<String> allCountries = new ArrayList<>();
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from geocountries_regions";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            while (rs.next())
                allCountries.add(rs.getString("Country_RegionName"));
            return allCountries;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }

    public static List<String> getAllCities(String countryName){
        List<String> allCities = new ArrayList<>();
        Connection conn = jdbcUtil.getConnection();
        String sql = "SELECT * from geocities inner join geocountries_regions " +
                "on geocities.Country_RegionCodeISO = geocountries_regions.ISO " +
                "WHERE geocountries_regions.Country_RegionName = ?";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1,countryName);
            rs = pst.executeQuery();
            while (rs.next())
                allCities.add(rs.getString("AsciiName"));
            return allCities;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            jdbcUtil.close(rs, pst, conn);
        }
    }
}