package com.elms.service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.elms.dao.LeaveDAO;
import com.elms.model.Leave;
import com.elms.model.LeaveBalance;

public class EmployeeLeaveService {

    private static final Map<String, Integer> ALLOCATED_LEAVES = new LinkedHashMap<>();

    static {
        ALLOCATED_LEAVES.put("Paid Leave", 18);
        ALLOCATED_LEAVES.put("Casual Leave", 10);
        ALLOCATED_LEAVES.put("Sick Leave", 12);
    }

    public List<Leave> getLeaveHistory(int userId, String statusFilter) {
        return LeaveDAO.getLeavesByUserAndStatus(userId, statusFilter);
    }

    public List<LeaveBalance> getLeaveBalances(int userId) {
        return ALLOCATED_LEAVES.entrySet().stream()
                .map(entry -> new LeaveBalance(entry.getKey(), entry.getValue(),
                        LeaveDAO.getUsedLeaveDaysByType(userId, entry.getKey())))
                .toList();
    }

    public LeaveApplicationResult applyLeave(int userId, String leaveType, String startDateRaw, String endDateRaw, String reason) {
        if (isBlank(leaveType) || isBlank(startDateRaw) || isBlank(endDateRaw) || isBlank(reason)) {
            return new LeaveApplicationResult(false, "All fields are required.");
        }

        if (!ALLOCATED_LEAVES.containsKey(leaveType)) {
            return new LeaveApplicationResult(false, "Invalid leave type selected.");
        }

        LocalDate today = LocalDate.now();
        LocalDate startDate;
        LocalDate endDate;

        try {
            startDate = LocalDate.parse(startDateRaw);
            endDate = LocalDate.parse(endDateRaw);
        } catch (Exception ex) {
            return new LeaveApplicationResult(false, "Please select valid start and end dates.");
        }

        if (startDate.isBefore(today)) {
            return new LeaveApplicationResult(false, "Start date cannot be before today.");
        }

        if (endDate.isBefore(startDate)) {
            return new LeaveApplicationResult(false, "End date cannot be before start date.");
        }

        int days = (int) ChronoUnit.DAYS.between(startDate, endDate) + 1;

        boolean overlapExists = LeaveDAO.hasOverlappingLeave(userId, startDateRaw, endDateRaw);
        if (overlapExists) {
            return new LeaveApplicationResult(false, "Leave dates overlap with an existing pending/approved request.");
        }

        int allocated = ALLOCATED_LEAVES.get(leaveType);
        int used = LeaveDAO.getUsedLeaveDaysByType(userId, leaveType);
        int remaining = Math.max(0, allocated - used);

        if (days > remaining) {
            return new LeaveApplicationResult(false, "Insufficient " + leaveType + " balance. Remaining: " + remaining + " day(s).");
        }

        Leave leave = new Leave();
        leave.setUserId(userId);
        leave.setLeaveType(leaveType);
        leave.setStartDate(startDateRaw);
        leave.setEndDate(endDateRaw);
        leave.setReason(reason.trim());
        leave.setDays(days);

        boolean applied = LeaveDAO.applyLeave(leave);
        if (!applied) {
            return new LeaveApplicationResult(false, "Unable to submit leave request right now. Please try again.");
        }

        return new LeaveApplicationResult(true, "Leave request submitted successfully.");
    }

    public LeaveApplicationResult cancelPendingLeave(int userId, int leaveId) {
        boolean cancelled = LeaveDAO.cancelPendingLeave(userId, leaveId);
        if (!cancelled) {
            return new LeaveApplicationResult(false, "Only pending leave requests can be cancelled.");
        }
        return new LeaveApplicationResult(true, "Leave request cancelled successfully.");
    }

    public List<String> getSupportedStatuses() {
        return Arrays.asList("All", "Pending", "Approved", "Rejected", "Cancelled");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
