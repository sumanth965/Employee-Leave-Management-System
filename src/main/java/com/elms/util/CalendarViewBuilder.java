package com.elms.util;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.DayOfWeek;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.elms.model.Leave;

public class CalendarViewBuilder {

    public static Map<String, Object> buildMonthView(String monthParam, List<Leave> leaves) {
        YearMonth viewMonth;
        try {
            viewMonth = (monthParam == null || monthParam.isBlank())
                    ? YearMonth.now()
                    : YearMonth.parse(monthParam);
        } catch (Exception ex) {
            viewMonth = YearMonth.now();
        }

        LocalDate firstOfMonth = viewMonth.atDay(1);
        LocalDate lastOfMonth = viewMonth.atEndOfMonth();

        LocalDate gridStart = firstOfMonth.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate gridEnd = lastOfMonth.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));

        Map<LocalDate, DayInfo> leaveByDay = new HashMap<>();

        if (leaves != null) {
            for (Leave leave : leaves) {
                String status = leave.getStatus();
                String leaveType = leave.getLeaveType();
                LocalDate start = parseDate(leave.getStartDate());
                LocalDate end = parseDate(leave.getEndDate());

                if (start == null || end == null) continue;

                LocalDate cursor = start;
                while (!cursor.isAfter(end)) {
                    if (!cursor.isBefore(gridStart) && !cursor.isAfter(gridEnd)) {
                        DayInfo existing = leaveByDay.get(cursor);
                        if (existing == null || getPriority(status) >= getPriority(existing.getStatus())) {
                            leaveByDay.put(cursor, new DayInfo(status, leaveType));
                        }
                    }
                    cursor = cursor.plusDays(1);
                }
            }
        }

        List<List<CalendarDay>> rows = new ArrayList<>();
        LocalDate loopDay = gridStart;
        while (!loopDay.isAfter(gridEnd)) {
            List<CalendarDay> row = new ArrayList<>();
            for (int i = 0; i < 7; i++) {
                DayInfo info = leaveByDay.get(loopDay);
                boolean inMonth = loopDay.getMonthValue() == firstOfMonth.getMonthValue();
                row.add(new CalendarDay(loopDay, inMonth, info));
                loopDay = loopDay.plusDays(1);
            }
            rows.add(row);
        }

        // Count stats: only count unique approved/pending days within the current month
        long approvedCount = leaveByDay.entrySet().stream()
                .filter(e -> e.getKey().getMonthValue() == firstOfMonth.getMonthValue()
                          && e.getKey().getYear() == firstOfMonth.getYear()
                          && "approved".equalsIgnoreCase(e.getValue().getStatus()))
                .count();
        long pendingCount = leaveByDay.entrySet().stream()
                .filter(e -> e.getKey().getMonthValue() == firstOfMonth.getMonthValue()
                          && e.getKey().getYear() == firstOfMonth.getYear()
                          && "pending".equalsIgnoreCase(e.getValue().getStatus()))
                .count();

        Map<String, Object> model = new HashMap<>();
        model.put("rows", rows);
        model.put("viewMonthLabel", viewMonth.format(DateTimeFormatter.ofPattern("MMMM yyyy")));
        model.put("previousMonth", viewMonth.minusMonths(1).toString());
        model.put("nextMonth", viewMonth.plusMonths(1).toString());
        model.put("currentMonth", viewMonth.toString());
        model.put("approvedCount", approvedCount);
        model.put("pendingCount", pendingCount);

        return model;
    }

    private static LocalDate parseDate(String value) {
        if (value == null || value.isBlank()) return null;
        try {
            return LocalDate.parse(value.trim().substring(0, 10));
        } catch (Exception ex) {
            return null;
        }
    }

    private static int getPriority(String status) {
        if ("approved".equalsIgnoreCase(status)) return 2;
        if ("pending".equalsIgnoreCase(status)) return 1;
        return 0;
    }

    public static class CalendarDay {
        private final LocalDate date;
        private final boolean inMonth;
        private final DayInfo leaveInfo;

        public CalendarDay(LocalDate date, boolean inMonth, DayInfo leaveInfo) {
            this.date = date;
            this.inMonth = inMonth;
            this.leaveInfo = leaveInfo;
        }

        public int getDayOfMonth() { return date.getDayOfMonth(); }
        public boolean isInMonth() { return inMonth; }
        public DayInfo getLeaveInfo() { return leaveInfo; }
        public String getStatus() { return leaveInfo == null ? "" : leaveInfo.getStatus(); }
        public String getType() { return leaveInfo == null ? "" : leaveInfo.getType(); }
        public boolean isApproved() { return "approved".equalsIgnoreCase(getStatus()); }
        public boolean isPending() { return "pending".equalsIgnoreCase(getStatus()); }
        public boolean isHasLeave() { return leaveInfo != null; }
    }

    public static class DayInfo {
        private final String status;
        private final String type;

        public DayInfo(String status, String type) {
            this.status = status;
            this.type = (type == null || type.isBlank()) ? "Leave" : type;
        }

        public String getStatus() { return status; }
        public String getType() { return type; }
    }
}
