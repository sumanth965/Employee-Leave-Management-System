package com.elms.service;

import com.elms.dao.LeaveBalanceDao;
import com.elms.dao.LeaveDao;
import com.elms.dao.UserDao;
import com.elms.model.*;
import com.elms.util.PagedResult;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;

public class LeaveService {
    private final LeaveDao leaveDao;
    private final LeaveBalanceDao leaveBalanceDao;
    private final UserDao userDao;
    private final NotificationService notificationService;

    public LeaveService(LeaveDao leaveDao,
                        LeaveBalanceDao leaveBalanceDao,
                        UserDao userDao,
                        NotificationService notificationService) {
        this.leaveDao = leaveDao;
        this.leaveBalanceDao = leaveBalanceDao;
        this.userDao = userDao;
        this.notificationService = notificationService;
    }

    public ValidationResult applyLeave(long employeeId, LeaveType leaveType, LocalDate startDate, LocalDate endDate, String reason) throws SQLException {
        List<String> errors = validateLeaveRequest(employeeId, leaveType, startDate, endDate);
        if (!errors.isEmpty()) {
            return ValidationResult.failure(errors);
        }

        LeaveRequest request = new LeaveRequest();
        request.setEmployeeId(employeeId);
        request.setLeaveType(leaveType);
        request.setStartDate(startDate);
        request.setEndDate(endDate);
        request.setDays(calculateLeaveDays(startDate, endDate));
        request.setReason(reason);
        request.setStatus(LeaveStatus.PENDING);

        long leaveId = leaveDao.create(request);
        request.setId(leaveId);

        notificationService.notifyManagerForNewRequest(request);

        return ValidationResult.success("Leave request submitted successfully.");
    }

    public ValidationResult managerDecision(long leaveId, long managerId, LeaveStatus decision, String comments) throws SQLException {
        if (!(decision == LeaveStatus.APPROVED || decision == LeaveStatus.REJECTED)) {
            return ValidationResult.failure(List.of("Invalid decision."));
        }

        boolean updated = leaveDao.updateStatus(leaveId, decision, managerId, comments);
        if (!updated) {
            return ValidationResult.failure(List.of("Unable to update leave. It may already be processed."));
        }

        LeaveRequest request = leaveDao.findById(leaveId).orElseThrow();
        Optional<User> employee = userDao.findById(request.getEmployeeId());
        employee.ifPresent(user -> notificationService.notifyEmployeeDecision(user, request));

        return ValidationResult.success("Leave request updated successfully.");
    }

    public boolean cancelPendingLeave(long leaveId, long employeeId) throws SQLException {
        return leaveDao.cancel(leaveId, employeeId);
    }

    public PagedResult<LeaveRequest> getEmployeeLeaves(long employeeId, LeaveStatus status, LocalDate fromDate, LocalDate toDate, int page, int pageSize) throws SQLException {
        return leaveDao.findByEmployee(employeeId, status, fromDate, toDate, page, pageSize);
    }

    public PagedResult<LeaveRequest> getManagerLeaves(LeaveStatus status, LocalDate fromDate, LocalDate toDate, int page, int pageSize) throws SQLException {
        return leaveDao.findForManager(status, fromDate, toDate, page, pageSize);
    }

    public List<LeaveBalance> getBalances(long employeeId) throws SQLException {
        List<LeaveBalance> balances = leaveBalanceDao.findByUser(employeeId);
        for (LeaveBalance balance : balances) {
            int approvedDays = leaveDao.getApprovedDaysForType(employeeId, balance.getLeaveType());
            balance.setUsedLeaves(approvedDays);
        }
        return balances;
    }

    private List<String> validateLeaveRequest(long employeeId, LeaveType leaveType, LocalDate startDate, LocalDate endDate) throws SQLException {
        List<String> errors = new ArrayList<>();

        if (startDate == null || endDate == null) {
            errors.add("Start date and end date are required.");
            return errors;
        }

        LocalDate today = LocalDate.now();
        if (startDate.isBefore(today)) {
            errors.add("Start date cannot be in the past.");
        }

        if (endDate.isBefore(startDate)) {
            errors.add("End date must be on or after start date.");
        }

        if (leaveDao.hasOverlappingLeave(employeeId, startDate, endDate)) {
            errors.add("You already have an overlapping leave request.");
        }

        int requestedDays = calculateLeaveDays(startDate, endDate);
        Map<LeaveType, LeaveBalance> balanceMap = new EnumMap<>(LeaveType.class);
        for (LeaveBalance b : getBalances(employeeId)) {
            balanceMap.put(b.getLeaveType(), b);
        }

        LeaveBalance selectedTypeBalance = balanceMap.get(leaveType);
        if (selectedTypeBalance == null) {
            errors.add("Leave balance is not configured for type " + leaveType);
        } else if (requestedDays > selectedTypeBalance.getRemainingLeaves()) {
            errors.add("Requested days exceed available leave balance for " + leaveType + ".");
        }

        return errors;
    }

    public int calculateLeaveDays(LocalDate startDate, LocalDate endDate) {
        return (int) ChronoUnit.DAYS.between(startDate, endDate) + 1;
    }

    public record ValidationResult(boolean success, String message, List<String> errors) {
        public static ValidationResult success(String message) {
            return new ValidationResult(true, message, List.of());
        }

        public static ValidationResult failure(List<String> errors) {
            return new ValidationResult(false, null, errors);
        }
    }
}
