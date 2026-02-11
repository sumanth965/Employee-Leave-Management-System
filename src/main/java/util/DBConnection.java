package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {

        try {
            System.out.println("LOADING MYSQL DRIVER...");
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("DRIVER LOADED");

            System.out.println("CONNECTING TO DATABASE...");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/leave_management?useSSL=false&serverTimezone=UTC",
                "root",
                "Sumanth#965"
            );

            System.out.println("DATABASE CONNECTED SUCCESSFULLY");
            return con;

        } catch (Exception e) {
            System.out.println("DATABASE CONNECTION FAILED");
            e.printStackTrace();
            return null;
        }
    }
}
