package com.elms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.elms.model.User;
import com.elms.util.DBConnection;

public class UserDAO {
	public static boolean register(User user, String password) {

	    String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setString(1, user.getUsername());
	        ps.setString(2, password);
	        ps.setString(3, user.getRole());

	        int rows = ps.executeUpdate();
	        return rows > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return false;
	}

    public static User validate(String username, String password) {

        User user = null;

        String sql = "SELECT * FROM users WHERE username=? AND password=?";

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                return null;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setRole(rs.getString("role"));
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }
}
