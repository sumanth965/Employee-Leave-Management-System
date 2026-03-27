package com.elms.service;

public class LeaveApplicationResult {
    private final boolean success;
    private final String message;

    public LeaveApplicationResult(boolean success, String message) {
        this.success = success;
        this.message = message;
    }

    public boolean isSuccess() {
        return success;
    }

    public String getMessage() {
        return message;
    }
}
