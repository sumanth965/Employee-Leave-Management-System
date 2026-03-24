package com.elms.dao;

import com.elms.model.LeaveBalance;

import java.sql.SQLException;
import java.util.List;

public interface LeaveBalanceDao {
    List<LeaveBalance> findByUser(long userId) throws SQLException;
    void initializeDefaultBalances(long userId) throws SQLException;
}
