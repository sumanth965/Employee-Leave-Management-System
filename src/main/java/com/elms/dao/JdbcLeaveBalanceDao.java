package com.elms.dao;

import com.elms.model.LeaveBalance;
import com.elms.model.LeaveType;
import com.elms.util.ConnectionFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class JdbcLeaveBalanceDao implements LeaveBalanceDao {
    private final ConnectionFactory connectionFactory;

    public JdbcLeaveBalanceDao(ConnectionFactory connectionFactory) {
        this.connectionFactory = connectionFactory;
    }

    @Override
    public List<LeaveBalance> findByUser(long userId) throws SQLException {
        String sql = "SELECT user_id, leave_type, total_leaves, used_leaves FROM leave_balance WHERE user_id = ?";
        List<LeaveBalance> balances = new ArrayList<>();
        try (Connection connection = connectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    LeaveBalance balance = new LeaveBalance();
                    balance.setUserId(rs.getLong("user_id"));
                    balance.setLeaveType(LeaveType.from(rs.getString("leave_type")));
                    balance.setTotalLeaves(rs.getInt("total_leaves"));
                    balance.setUsedLeaves(rs.getInt("used_leaves"));
                    balances.add(balance);
                }
            }
        }
        return balances;
    }

    @Override
    public void initializeDefaultBalances(long userId) throws SQLException {
        String sql = """
                INSERT IGNORE INTO leave_balance (user_id, leave_type, total_leaves, used_leaves)
                VALUES (?, 'SICK', 8, 0), (?, 'CASUAL', 12, 0), (?, 'PAID', 15, 0)
                """;
        try (Connection connection = connectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            statement.setLong(2, userId);
            statement.setLong(3, userId);
            statement.executeUpdate();
        }
    }
}
