package com.elms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

import com.elms.model.Leave;
import com.elms.model.LeaveRequest;
import com.elms.util.DBConnection;

public class LeaveDAO {

    public static boolean applyLeave(Leave l) {

        String sql = "INSERT INTO leaves (user_id, start_date, end_date, leave_type, reason, status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, l.getUserId());
            ps.setString(2, l.getStartDate());
            ps.setString(3, l.getEndDate());
            ps.setString(4, l.getLeaveType());
            ps.setString(5, l.getReason());
            ps.setString(6, "Pending");

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

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

    public static List<Leave> getLeavesByUser(int userId) {
        return getLeavesByUserAndStatus(userId, "All");
    }

    public static List<Leave> getLeavesByUserAndStatus(int userId, String statusFilter) {
        List<Leave> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM leaves WHERE user_id = ? ");
        if (statusFilter != null && !"All".equalsIgnoreCase(statusFilter)) {
            sql.append("AND status = ? ");
        }
        sql.append("ORDER BY start_date DESC, id DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            ps.setInt(1, userId);
            if (statusFilter != null && !"All".equalsIgnoreCase(statusFilter)) {
                ps.setString(2, statusFilter);
            }

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


    public static List<LeaveRequest> getRecentLeaveRequests(int employeeId) {
        List<LeaveRequest> requests = new ArrayList<>();

        // Preferred schema from prompt: leave_requests(employee_id, from_date, to_date, no_of_days, applied_on)
        String promptSchemaSql = "SELECT id, employee_id, leave_type, from_date, to_date, no_of_days, status, applied_on "
                + "FROM leave_requests WHERE employee_id = ? ORDER BY applied_on DESC LIMIT 10";

        // Backward-compatible fallback for current ELMS schema: leaves(user_id, start_date, end_date, days, created_at)
        String legacySchemaSql = "SELECT id, user_id AS employee_id, leave_type, start_date AS from_date, end_date AS to_date, "
                + "days AS no_of_days, status, created_at AS applied_on "
                + "FROM leaves WHERE user_id = ? ORDER BY created_at DESC, id DESC LIMIT 10";

        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(promptSchemaSql)) {
                ps.setInt(1, employeeId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        requests.add(extractLeaveRequest(rs));
                    }
                }
            } catch (SQLException promptSchemaError) {
                try (PreparedStatement ps = con.prepareStatement(legacySchemaSql)) {
                    ps.setInt(1, employeeId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            requests.add(extractLeaveRequest(rs));
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return requests;
    }

    public static boolean cancelLeave(int leaveId) {
        String promptSchemaSql = "UPDATE leave_requests SET status = 'CANCELLED' WHERE id = ? AND UPPER(status) = 'PENDING'";
        String legacySchemaSql = "UPDATE leaves SET status = 'Cancelled' WHERE id = ? AND UPPER(status) = 'PENDING'";

        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(promptSchemaSql)) {
                ps.setInt(1, leaveId);
                return ps.executeUpdate() > 0;
            } catch (SQLException promptSchemaError) {
                try (PreparedStatement ps = con.prepareStatement(legacySchemaSql)) {
                    ps.setInt(1, leaveId);
                    return ps.executeUpdate() > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static int getUsedLeaveDaysByType(int userId, String leaveType) {
        String sql = "SELECT COALESCE(SUM(DATEDIFF(end_date, start_date) + 1), 0) AS used_days "
                + "FROM leaves WHERE user_id = ? AND leave_type = ? AND status = 'Approved'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, leaveType);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("used_days");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public static int getAllocatedLeaveDaysByType(int userId, String leaveType) {
        String sql = "SELECT total_leaves FROM leave_balance WHERE user_id = ? AND leave_type = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, leaveType);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Math.max(0, rs.getInt("total_leaves"));
                }
            }

        } catch (Exception e) {
            // Leave-balance table may not be configured yet; callers should fallback to default policy.
        }

        return -1;
    }

    public static boolean hasOverlappingLeave(int userId, String startDate, String endDate) {
        String sql = "SELECT COUNT(*) FROM leaves "
                + "WHERE user_id = ? AND status IN ('Pending','Approved') "
                + "AND NOT (end_date < ? OR start_date > ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, startDate);
            ps.setString(3, endDate);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public static boolean cancelPendingLeave(int userId, int leaveId) {
        String sql = "UPDATE leaves SET status = 'Cancelled' WHERE id = ? AND user_id = ? AND status = 'Pending'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, leaveId);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    private static LeaveRequest extractLeaveRequest(ResultSet rs) throws SQLException {
        LeaveRequest request = new LeaveRequest();
        request.setId(rs.getInt("id"));
        request.setEmployeeId(rs.getInt("employee_id"));
        request.setLeaveType(rs.getString("leave_type"));
        request.setFromDate(rs.getString("from_date"));
        request.setToDate(rs.getString("to_date"));

        int noOfDays = rs.getInt("no_of_days");
        if (rs.wasNull() || noOfDays <= 0) {
            noOfDays = 1;
        }
        request.setNoOfDays(noOfDays);

        request.setStatus(rs.getString("status"));
        request.setAppliedOn(rs.getString("applied_on"));
        return request;
    }

    private static Leave extractLeave(ResultSet rs) throws SQLException {

        Leave l = new Leave();

        l.setId(rs.getInt("id"));
        l.setUserId(rs.getInt("user_id"));
        l.setStartDate(rs.getString("start_date"));
        l.setEndDate(rs.getString("end_date"));
        l.setLeaveType(rs.getString("leave_type"));
        l.setReason(rs.getString("reason"));
        l.setStatus(rs.getString("status"));
        try {
            l.setDays(rs.getInt("days"));
        } catch (SQLException ignore) {
            l.setDays(0);
        }

        try {
            l.setManagerComments(rs.getString("manager_comments"));
        } catch (SQLException ignore) {
            l.setManagerComments(null);
        }

        if (l.getDays() <= 0 && l.getStartDate() != null && l.getEndDate() != null) {
            try {
                LocalDate startDate = LocalDate.parse(l.getStartDate());
                LocalDate endDate = LocalDate.parse(l.getEndDate());
                l.setDays((int) Math.max(1, ChronoUnit.DAYS.between(startDate, endDate) + 1));
            } catch (Exception ignore) {
                l.setDays(1);
            }
        }

        return l;
    }
}
