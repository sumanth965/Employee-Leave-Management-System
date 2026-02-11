package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Leave;
import util.DBConnection;

public class LeaveDAO {

    // =====================================
    // 1️⃣ Apply Leave (Employee)
    // =====================================
    public static boolean applyLeave(Leave l) {

        String sql = "INSERT INTO leaves (user_id, start_date, end_date, reason, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, l.getUserId());
            ps.setString(2, l.getStartDate());
            ps.setString(3, l.getEndDate());
            ps.setString(4, l.getReason());
            ps.setString(5, "Pending");

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =====================================
    // 2️⃣ Get All Leave Requests (Manager)
    // =====================================
    public static List<Leave> getAllLeaves() {

        List<Leave> list = new ArrayList<>();
        String sql = "SELECT * FROM leaves";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Leave l = new Leave();

                l.setId(rs.getInt("id"));
                l.setUserId(rs.getInt("user_id"));
                l.setStartDate(rs.getString("start_date"));
                l.setEndDate(rs.getString("end_date"));
                l.setReason(rs.getString("reason"));
                l.setStatus(rs.getString("status"));

                list.add(l);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =====================================
    // 3️⃣ Update Leave Status (Approve/Reject)
    // =====================================
    public static boolean updateStatus(int id, String status) {

        String sql = "UPDATE leaves SET status=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, id);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
