package com.elms.service;

import com.elms.model.LeaveRequest;
import com.elms.model.User;

/**
 * Mock notification service. In production, this can send email via SMTP provider.
 */
public class NotificationService {

    public void notifyManagerForNewRequest(LeaveRequest request) {
        System.out.printf("[NOTIFY] New leave request %d from employee %d (%s)%n",
                request.getId(), request.getEmployeeId(), request.getLeaveType());
    }

    public void notifyEmployeeDecision(User employee, LeaveRequest request) {
        System.out.printf("[NOTIFY] Leave %d for %s is now %s%n",
                request.getId(), employee.getUsername(), request.getStatus());
    }
}
