package com.elms.model;

public enum LeaveStatus {
    PENDING,
    APPROVED,
    REJECTED,
    CANCELED;

    public static LeaveStatus from(String value) {
        return LeaveStatus.valueOf(value.toUpperCase());
    }
}
