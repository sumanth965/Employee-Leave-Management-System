package com.elms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.elms.model.Leave;
import com.elms.util.DBConnection;

public class LeaveDAO {

    // =====================================
    // 1️⃣ Apply Leave
    // =====================================
    public static boolean applyLeave(Leave l) {

        String sql = "INSERT INTO leaves (user_id, start_date, end_date, leave_type, reason, status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, l.getUserId());
            ps.setString(2, l.getStartDate());
            ps.setString(3, l.getEndDate());
            ps.setString(4, l.getLeaveType() == null || l.getLeaveType().trim().isEmpty() ? "General" : l.getLeaveType());
            ps.setString(5, l.getReason());
            ps.setString(6, "Pending");

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =====================================
    // 2️⃣ Filtered Pagination
    // =====================================
    public static List<Leave> getLeavesPaginated(int page, int limit, String search, String statusFilter) {

        List<Leave> list = new ArrayList<>();
        int offset = (page - 1) * limit;

        StringBuilder sql = new StringBuilder("SELECT * FROM leaves WHERE 1=1 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND CAST(user_id AS CHAR) LIKE ? ");
        }

        if (statusFilter != null && !"All".equalsIgnoreCase(statusFilter)) {
            sql.append("AND status = ? ");
        }

        sql.append("ORDER BY id DESC LIMIT ? OFFSET ?");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(index++, "%" + search.trim() + "%");
            }

            if (statusFilter != null && !"All".equalsIgnoreCase(statusFilter)) {
                ps.setString(index++, statusFilter);
            }

            ps.setInt(index++, limit);
            ps.setInt(index, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractLeave(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =====================================
    // 3️⃣ Get Total Records (Filtered)
    // =====================================
    public static int getTotalLeaves(String search, String statusFilter) {

        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM leaves WHERE 1=1 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND CAST(user_id AS CHAR) LIKE ? ");
        }

        if (statusFilter != null && !"All".equalsIgnoreCase(statusFilter)) {
            sql.append("AND status = ? ");
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(index++, "%" + search.trim() + "%");
            }

            if (statusFilter != null && !"All".equalsIgnoreCase(statusFilter)) {
                ps.setString(index++, statusFilter);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    // =====================================
    // 4️⃣ Count By Status
    // =====================================
    public static int countByStatus(String status) {

        int count = 0;
        String sql = "SELECT COUNT(*) FROM leaves WHERE status = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    // =====================================
    // 5️⃣ Update Leave Status
    // =====================================
    public static boolean updateStatus(int id, String status) {

        String sql = "UPDATE leaves SET status = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =====================================
    // 6️⃣ Get All Leaves
    // =====================================
    public static List<Leave> getAllLeaves() {

        List<Leave> list = new ArrayList<>();
        String sql = "SELECT * FROM leaves ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractLeave(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =====================================
    // 7️⃣ Get Leaves By User
    // =====================================
    public static List<Leave> getLeavesByUser(int userId) {

        List<Leave> list = new ArrayList<>();
        String sql = "SELECT * FROM leaves WHERE user_id = ? ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractLeave(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =====================================
    // 🔹 Extract Utility
    // =====================================
    private static Leave extractLeave(ResultSet rs) throws Exception {

        Leave l = new Leave();

        l.setId(rs.getInt("id"));
        l.setUserId(rs.getInt("user_id"));
        l.setStartDate(rs.getString("start_date"));
        l.setEndDate(rs.getString("end_date"));
        l.setLeaveType(rs.getString("leave_type"));
        l.setReason(rs.getString("reason"));
        l.setStatus(rs.getString("status"));

        return l;
    }
}
