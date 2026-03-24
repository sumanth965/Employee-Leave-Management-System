package com.elms.dao;

import com.elms.model.LeaveRequest;
import com.elms.model.LeaveStatus;
import com.elms.model.LeaveType;
import com.elms.util.ConnectionFactory;
import com.elms.util.PagedResult;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JdbcLeaveDao implements LeaveDao {
    private final ConnectionFactory connectionFactory;

    public JdbcLeaveDao(ConnectionFactory connectionFactory) {
        this.connectionFactory = connectionFactory;
    }

    @Override
    public long create(LeaveRequest request) throws SQLException {
        String sql = """
                INSERT INTO leaves (employee_id, leave_type, start_date, end_date, days, reason, status, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
                """;
        try (Connection connection = connectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setLong(1, request.getEmployeeId());
            statement.setString(2, request.getLeaveType().name());
            statement.setDate(3, Date.valueOf(request.getStartDate()));
            statement.setDate(4, Date.valueOf(request.getEndDate()));
            statement.setInt(5, request.getDays());
            statement.setString(6, request.getReason());
            statement.setString(7, request.getStatus().name());
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getLong(1);
                }
                throw new SQLException("No key generated for leave request");
            }
        }
    }

    @Override
    public Optional<LeaveRequest> findById(long leaveId) throws SQLException {
        String sql = """
                SELECT l.*, e.full_name employee_name, m.full_name approver_name
                FROM leaves l
                JOIN user e ON e.id = l.employee_id
                LEFT JOIN user m ON m.id = l.approved_by
                WHERE l.id = ?
                """;
        try (Connection connection = connectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, leaveId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapLeave(rs));
                }
                return Optional.empty();
            }
        }
    }

    @Override
    public PagedResult<LeaveRequest> findByEmployee(long employeeId, LeaveStatus status, LocalDate fromDate, LocalDate toDate, int page, int pageSize) throws SQLException {
        List<Object> params = new ArrayList<>();
        String where = buildFilterClause(status, fromDate, toDate, params, "l");
        params.add(0, employeeId);
        String base = " FROM leaves l LEFT JOIN user m ON m.id = l.approved_by WHERE l.employee_id = ? " + where;
        return findPaged(page, pageSize, params, base, true);
    }

    @Override
    public PagedResult<LeaveRequest> findForManager(LeaveStatus status, LocalDate fromDate, LocalDate toDate, int page, int pageSize) throws SQLException {
        List<Object> params = new ArrayList<>();
        String where = buildFilterClause(status, fromDate, toDate, params, "l");
        String base = " FROM leaves l JOIN user e ON e.id = l.employee_id LEFT JOIN user m ON m.id = l.approved_by WHERE 1=1 " + where;
        return findPaged(page, pageSize, params, base, false);
    }

    @Override
    public boolean hasOverlappingLeave(long employeeId, LocalDate startDate, LocalDate endDate) throws SQLException {
        String sql = """
                SELECT COUNT(*)
                FROM leaves
                WHERE employee_id = ?
                  AND status IN ('PENDING','APPROVED')
                  AND start_date <= ?
                  AND end_date >= ?
                """;
        try (Connection connection = connectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, employeeId);
            statement.setDate(2, Date.valueOf(endDate));
            statement.setDate(3, Date.valueOf(startDate));
            try (ResultSet rs = statement.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

    @Override
    public boolean updateStatus(long leaveId, LeaveStatus status, Long approvedBy, String comments) throws SQLException {
        String sql = """
                UPDATE leaves
                SET status = ?, approved_by = ?, approved_date = NOW(), manager_comments = ?, updated_at = NOW()
                WHERE id = ? AND status = 'PENDING'
                """;
        try (Connection connection = connectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status.name());
            if (approvedBy == null) {
                statement.setNull(2, Types.BIGINT);
            } else {
                statement.setLong(2, approvedBy);
            }
            statement.setString(3, comments);
            statement.setLong(4, leaveId);
            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean cancel(long leaveId, long employeeId) throws SQLException {
        String sql = "UPDATE leaves SET status = 'CANCELED', updated_at = NOW() WHERE id = ? AND employee_id = ? AND status = 'PENDING'";
        try (Connection connection = connectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, leaveId);
            statement.setLong(2, employeeId);
            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public int getApprovedDaysForType(long employeeId, LeaveType leaveType) throws SQLException {
        String sql = "SELECT COALESCE(SUM(days),0) FROM leaves WHERE employee_id = ? AND leave_type = ? AND status = 'APPROVED'";
        try (Connection connection = connectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, employeeId);
            statement.setString(2, leaveType.name());
            try (ResultSet rs = statement.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    private PagedResult<LeaveRequest> findPaged(int page, int pageSize, List<Object> params, String base, boolean employeeQuery) throws SQLException {
        String countSql = "SELECT COUNT(*)" + base;
        String selectSql = "SELECT l.*, " +
                (employeeQuery ? "NULL employee_name, " : "e.full_name employee_name, ") +
                "m.full_name approver_name" + base + " ORDER BY l.created_at DESC LIMIT ? OFFSET ?";

        try (Connection connection = connectionFactory.getConnection()) {
            int total = countRecords(connection, countSql, params);
            List<LeaveRequest> items = new ArrayList<>();
            try (PreparedStatement statement = connection.prepareStatement(selectSql)) {
                int index = bindParams(statement, params);
                statement.setInt(index++, pageSize);
                statement.setInt(index, (page - 1) * pageSize);
                try (ResultSet rs = statement.executeQuery()) {
                    while (rs.next()) {
                        items.add(mapLeave(rs));
                    }
                }
            }
            return new PagedResult<>(items, page, pageSize, total);
        }
    }

    private int countRecords(Connection connection, String sql, List<Object> params) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            bindParams(statement, params);
            try (ResultSet rs = statement.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    private int bindParams(PreparedStatement statement, List<Object> params) throws SQLException {
        int i = 1;
        for (Object param : params) {
            if (param instanceof LocalDate localDate) {
                statement.setDate(i++, Date.valueOf(localDate));
            } else if (param instanceof String str) {
                statement.setString(i++, str);
            } else if (param instanceof Long l) {
                statement.setLong(i++, l);
            } else {
                statement.setObject(i++, param);
            }
        }
        return i;
    }

    private String buildFilterClause(LeaveStatus status, LocalDate fromDate, LocalDate toDate, List<Object> params, String alias) {
        StringBuilder sql = new StringBuilder();
        if (status != null) {
            sql.append(" AND ").append(alias).append(".status = ?");
            params.add(status.name());
        }
        if (fromDate != null) {
            sql.append(" AND ").append(alias).append(".start_date >= ?");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append(" AND ").append(alias).append(".end_date <= ?");
            params.add(toDate);
        }
        return sql.toString();
    }

    private LeaveRequest mapLeave(ResultSet rs) throws SQLException {
        LeaveRequest leave = new LeaveRequest();
        leave.setId(rs.getLong("id"));
        leave.setEmployeeId(rs.getLong("employee_id"));
        leave.setEmployeeName(rs.getString("employee_name"));
        leave.setLeaveType(LeaveType.from(rs.getString("leave_type")));
        leave.setStartDate(rs.getDate("start_date").toLocalDate());
        leave.setEndDate(rs.getDate("end_date").toLocalDate());
        leave.setDays(rs.getInt("days"));
        leave.setReason(rs.getString("reason"));
        leave.setStatus(LeaveStatus.from(rs.getString("status")));

        long approvedBy = rs.getLong("approved_by");
        leave.setApprovedBy(rs.wasNull() ? null : approvedBy);
        leave.setApprovedByName(rs.getString("approver_name"));

        Timestamp approvedDate = rs.getTimestamp("approved_date");
        if (approvedDate != null) {
            leave.setApprovedDate(approvedDate.toLocalDateTime());
        }

        leave.setManagerComments(rs.getString("manager_comments"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            leave.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            leave.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return leave;
    }
}
