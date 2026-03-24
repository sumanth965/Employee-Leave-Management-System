package com.elms.dao;

import com.elms.model.LeaveRequest;
import com.elms.model.LeaveStatus;
import com.elms.model.LeaveType;
import com.elms.util.PagedResult;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Optional;

public interface LeaveDao {
    long create(LeaveRequest request) throws SQLException;
    Optional<LeaveRequest> findById(long leaveId) throws SQLException;
    PagedResult<LeaveRequest> findByEmployee(long employeeId, LeaveStatus status, LocalDate fromDate, LocalDate toDate, int page, int pageSize) throws SQLException;
    PagedResult<LeaveRequest> findForManager(LeaveStatus status, LocalDate fromDate, LocalDate toDate, int page, int pageSize) throws SQLException;
    boolean hasOverlappingLeave(long employeeId, LocalDate startDate, LocalDate endDate) throws SQLException;
    boolean updateStatus(long leaveId, LeaveStatus status, Long approvedBy, String comments) throws SQLException;
    boolean cancel(long leaveId, long employeeId) throws SQLException;
    int getApprovedDaysForType(long employeeId, LeaveType leaveType) throws SQLException;
}
