package com.elms.model;

public class LeaveBalance {
    private String leaveType;
    private int totalDays;
    private int usedDays;
    private int remainingDays;

    public LeaveBalance(String leaveType, int totalDays, int usedDays) {
        this.leaveType = leaveType;
        this.totalDays = Math.max(0, totalDays);
        this.usedDays = Math.max(0, usedDays);
        this.remainingDays = Math.max(0, this.totalDays - this.usedDays);
    }

    public String getLeaveType() {
        return leaveType;
    }

    public int getTotalDays() {
        return totalDays;
    }

    public int getUsedDays() {
        return usedDays;
    }

    public int getRemainingDays() {
        return remainingDays;
    }

    public int getUsedPercent() {
        if (totalDays <= 0) {
            return 0;
        }
        return Math.min(100, Math.round((usedDays * 100f) / totalDays));
    }

    public int getRemainingPercent() {
        if (totalDays <= 0) {
            return 0;
        }
        return Math.max(0, Math.min(100, Math.round((remainingDays * 100f) / totalDays)));
    }

    public String getUsageStatusClass() {
        int remainingPercent = getRemainingPercent();
        if (remainingPercent < 20) {
            return "danger";
        }
        if (remainingPercent <= 50) {
            return "warning";
        }
        return "healthy";
    }

    // Backward-compatible accessors for existing JSP usages.
    public String getType() {
        return getLeaveType();
    }

    public int getAllocated() {
        return getTotalDays();
    }

    public int getUsed() {
        return getUsedDays();
    }

    public int getRemaining() {
        return getRemainingDays();
    }
}
