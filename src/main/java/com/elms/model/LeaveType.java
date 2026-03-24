package com.elms.model;

public enum LeaveType {
    SICK,
    CASUAL,
    PAID;

    public static LeaveType from(String value) {
        return LeaveType.valueOf(value.toUpperCase());
    }
}
