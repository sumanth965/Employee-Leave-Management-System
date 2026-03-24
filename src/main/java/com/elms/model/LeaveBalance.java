package com.elms.model;

public class LeaveBalance {
    private long userId;
    private LeaveType leaveType;
    private int totalLeaves;
    private int usedLeaves;

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }
    public LeaveType getLeaveType() { return leaveType; }
    public void setLeaveType(LeaveType leaveType) { this.leaveType = leaveType; }
    public int getTotalLeaves() { return totalLeaves; }
    public void setTotalLeaves(int totalLeaves) { this.totalLeaves = totalLeaves; }
    public int getUsedLeaves() { return usedLeaves; }
    public void setUsedLeaves(int usedLeaves) { this.usedLeaves = usedLeaves; }

    public int getRemainingLeaves() {
        return Math.max(0, totalLeaves - usedLeaves);
    }
}
