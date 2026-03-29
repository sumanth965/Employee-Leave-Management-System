package com.elms.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String MYSQL_CONNECTION_PARAMS = "useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    private static String normalizeMySqlJdbcUrl(String rawUrl) {
        if (rawUrl == null || rawUrl.trim().isEmpty()) {
            return rawUrl;
        }

        String dbUrl = rawUrl.trim();

        // Railway Fix: replace mysql:// with jdbc:mysql://
        if (dbUrl.startsWith("mysql://")) {
            dbUrl = dbUrl.replaceFirst("mysql://", "jdbc:mysql://");
        }

        if (!dbUrl.startsWith("jdbc:mysql://")) {
            dbUrl = "jdbc:mysql://" + dbUrl;
        }

        if (!dbUrl.contains("allowPublicKeyRetrieval=")) {
            dbUrl += dbUrl.contains("?")
                    ? "&allowPublicKeyRetrieval=true"
                    : "?" + MYSQL_CONNECTION_PARAMS;
        }

        if (!dbUrl.contains("useSSL=")) {
            dbUrl += dbUrl.contains("?") ? "&useSSL=false" : "?useSSL=false";
        }

        if (!dbUrl.contains("serverTimezone=")) {
            dbUrl += dbUrl.contains("?") ? "&serverTimezone=UTC" : "?serverTimezone=UTC";
        }

        return dbUrl;
    }

    public static Connection getConnection() {
        String dbUrl = System.getenv("MYSQL_URL");
        String host = System.getenv("MYSQLHOST");
        String port = System.getenv("MYSQLPORT");
        String dbName = System.getenv("MYSQLDATABASE");
        String user = System.getenv("MYSQLUSER");
        String password = System.getenv("MYSQLPASSWORD");

        // If MYSQL_URL is not provided, build it from host/db
        if (dbUrl == null || dbUrl.isEmpty()) {
            if (host != null && !host.isEmpty()) {
                dbUrl = "jdbc:mysql://" + host + ":" + (port != null ? port : "3306") + "/" + dbName
                        + "?" + MYSQL_CONNECTION_PARAMS;
            } else {
                // Railway Fallback
                dbUrl = "jdbc:mysql://hopper.proxy.rlwy.net:54877/railway?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                user = (user != null) ? user : "root";
                password = (password != null) ? password : "nUbyUeChBGlaJOsVFEXajsCcnyhJZNOu"; // Update this with your
                                                                                               // Railway password
            }
        }
        dbUrl = normalizeMySqlJdbcUrl(dbUrl);

        try {
            System.out.println("LOADING MYSQL DRIVER...");
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("DRIVER LOADED");

            System.out.println("CONNECTING TO DATABASE...");
            Connection con = DriverManager.getConnection(dbUrl, user, password);

            System.out.println("DATABASE CONNECTED SUCCESSFULLY");
            return con;

        } catch (Exception e) {
            System.out.println("DATABASE CONNECTION FAILED: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
