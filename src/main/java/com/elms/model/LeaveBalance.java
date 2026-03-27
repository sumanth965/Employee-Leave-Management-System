package com.elms.model;

public class LeaveBalance {
    private String type;
    private int allocated;
    private int used;
    private int remaining;

    public LeaveBalance(String type, int allocated, int used) {
        this.type = type;
        this.allocated = allocated;
        this.used = Math.max(0, used);
        this.remaining = Math.max(0, allocated - used);
    }

    public String getType() {
        return type;
    }

    public int getAllocated() {
        return allocated;
    }

    public int getUsed() {
        return used;
    }

    public int getRemaining() {
        return remaining;
    }

    public int getUsedPercent() {
        if (allocated <= 0) {
            return 0;
        }
        return Math.min(100, Math.round((used * 100f) / allocated));
    }
}
