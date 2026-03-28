package com.elms.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

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
                        + "?useSSL=false&serverTimezone=UTC";
            } else {
                // LOCAL FALLBACK
                dbUrl = "jdbc:mysql://localhost:3306/leave_management?useSSL=false&serverTimezone=UTC";
                user = (user != null) ? user : "root";
                password = (password != null) ? password : "Sumanth#965";
            }
        } else if (!dbUrl.startsWith("jdbc:mysql://")) {
            // Railway sometimes provides URL without the jdbc: prefix
            dbUrl = "jdbc:mysql://" + dbUrl;
        }

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
