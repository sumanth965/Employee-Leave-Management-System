<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate,java.time.YearMonth,java.time.DayOfWeek,java.time.format.DateTimeFormatter,java.time.format.DateTimeParseException,java.time.temporal.TemporalAdjusters" %>
<%@ page import="java.util.List,java.util.Map,java.util.HashMap" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%!
    private String readString(Object bean, String methodName) {
        if (bean == null) return "";
        try {
            Method method = bean.getClass().getMethod(methodName);
            Object value = method.invoke(bean);
            return value == null ? "" : String.valueOf(value).trim();
        } catch (Exception ex) {
            return "";
        }
    }

    private LocalDate parseDate(String value) {
        if (value == null || value.isBlank()) return null;
        String normalized = value.trim();
        if (normalized.length() >= 10) {
            normalized = normalized.substring(0, 10);
        }
        try {
            return LocalDate.parse(normalized, DateTimeFormatter.ISO_LOCAL_DATE);
        } catch (DateTimeParseException ex) {
            return null;
        }
    }

    private int priority(String status) {
        if ("approved".equalsIgnoreCase(status)) return 2;
        if ("pending".equalsIgnoreCase(status)) return 1;
        return 0;
    }
%>

<%
    String monthParam = request.getParameter("month");
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

    String previousMonth = viewMonth.minusMonths(1).toString();
    String nextMonth = viewMonth.plusMonths(1).toString();

    List<?> leaves = (List<?>) request.getAttribute("calendarLeaves");
    Map<LocalDate, Map<String, String>> leaveByDay = new HashMap<>();

    if (leaves != null) {
        for (Object leave : leaves) {
            String status = readString(leave, "getStatus");
            String leaveType = readString(leave, "getLeaveType");
            LocalDate start = parseDate(readString(leave, "getStartDate"));
            LocalDate end = parseDate(readString(leave, "getEndDate"));

            if (start == null || end == null) continue;
            if (end.isBefore(start)) {
                LocalDate temp = start;
                start = end;
                end = temp;
            }

            LocalDate cursor = start;
            while (!cursor.isAfter(end)) {
                if (!cursor.isBefore(gridStart) && !cursor.isAfter(gridEnd)) {
                    Map<String, String> current = leaveByDay.get(cursor);
                    int existingPriority = current == null ? -1 : priority(current.get("status"));
                    if (current == null || priority(status) >= existingPriority) {
                        Map<String, String> info = new HashMap<>();
                        info.put("status", status);
                        info.put("type", (leaveType == null || leaveType.isBlank()) ? "Leave" : leaveType);
                        leaveByDay.put(cursor, info);
                    }
                }
                cursor = cursor.plusDays(1);
            }
        }
    }

    request.setAttribute("gridStart", gridStart);
    request.setAttribute("gridEnd", gridEnd);
    request.setAttribute("viewMonthLabel", viewMonth.format(DateTimeFormatter.ofPattern("MMMM yyyy")));
    request.setAttribute("previousMonth", previousMonth);
    request.setAttribute("nextMonth", nextMonth);
    request.setAttribute("leaveByDay", leaveByDay);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Premium Leave Calendar</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="min-h-screen bg-slate-950 text-slate-100 antialiased">
<div class="max-w-7xl mx-auto px-6 py-8">
    <header class="mb-8 rounded-2xl border border-slate-800 bg-slate-900/90 p-5 shadow-2xl shadow-black/30">
        <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
            <div>
                <h1 class="text-2xl md:text-3xl font-bold tracking-tight">Premium Visual Leave Calendar</h1>
                <p class="mt-1 text-slate-400">Month overview with approval status and leave types.</p>
            </div>
            <div class="flex flex-wrap gap-3">
                <a href="${pageContext.request.contextPath}/employee/calendar?month=${previousMonth}" class="rounded-lg border border-slate-700 px-4 py-2 text-sm font-medium text-slate-200 transition hover:border-slate-500 hover:bg-slate-800">
                    ← Previous Month
                </a>
                <a href="${pageContext.request.contextPath}/employee/calendar?month=${nextMonth}" class="rounded-lg border border-slate-700 px-4 py-2 text-sm font-medium text-slate-200 transition hover:border-slate-500 hover:bg-slate-800">
                    Next Month →
                </a>
                <a href="${pageContext.request.contextPath}/employee/leaves" class="rounded-lg bg-indigo-500 px-4 py-2 text-sm font-semibold text-white transition hover:bg-indigo-400">
                    Back to Dashboard
                </a>
            </div>
        </div>
    </header>

    <main class="grid gap-6 lg:grid-cols-[1fr_300px]">
        <section class="rounded-2xl border border-slate-800 bg-slate-900/80 p-5 shadow-xl shadow-black/25">
            <div class="mb-4 flex items-center justify-between">
                <h2 class="text-xl font-semibold"><c:out value="${viewMonthLabel}" /></h2>
                <span class="text-xs uppercase tracking-widest text-slate-400">Corporate View</span>
            </div>

            <div class="grid grid-cols-7 gap-2 text-center text-xs font-semibold uppercase tracking-wide text-slate-400 mb-2">
                <div>Mon</div><div>Tue</div><div>Wed</div><div>Thu</div><div>Fri</div><div>Sat</div><div>Sun</div>
            </div>

            <%
                LocalDate loopDay = (LocalDate) request.getAttribute("gridStart");
                LocalDate maxDay = (LocalDate) request.getAttribute("gridEnd");
                Map<LocalDate, Map<String, String>> viewLeaveByDay = (Map<LocalDate, Map<String, String>>) request.getAttribute("leaveByDay");
                while (!loopDay.isAfter(maxDay)) {
                    out.write("<div class='grid grid-cols-7 gap-2 mb-2'>");
                    for (int i = 0; i < 7; i++) {
                        Map<String, String> leaveInfo = viewLeaveByDay.get(loopDay);
                        boolean inCurrentMonth = loopDay.getMonthValue() == firstOfMonth.getMonthValue();
                        String status = leaveInfo == null ? "" : leaveInfo.getOrDefault("status", "");
                        String type = leaveInfo == null ? "" : leaveInfo.getOrDefault("type", "Leave");

                        String baseClass = "min-h-[110px] rounded-xl border p-3 text-left flex flex-col justify-between transition ";
                        if (!inCurrentMonth) {
                            baseClass += "bg-slate-900/35 border-slate-800 text-slate-600";
                        } else if ("approved".equalsIgnoreCase(status)) {
                            baseClass += "bg-[#EF4444]/25 border-[#EF4444] text-red-100";
                        } else if ("pending".equalsIgnoreCase(status)) {
                            baseClass += "bg-slate-900 border-amber-400/70 ring-1 ring-amber-400/50 text-slate-100";
                        } else {
                            baseClass += "bg-slate-900 border-slate-800 text-slate-100";
                        }

                        out.write("<article class='" + baseClass + "'>");
                        out.write("<div class='flex items-center justify-between'>");
                        out.write("<span class='text-sm font-semibold'>" + loopDay.getDayOfMonth() + "</span>");

                        if ("approved".equalsIgnoreCase(status)) {
                            out.write("<span class='text-[10px] rounded-full bg-red-500/25 px-2 py-0.5 font-semibold text-red-100'>Approved</span>");
                        } else if ("pending".equalsIgnoreCase(status)) {
                            out.write("<span class='text-[10px] rounded-full border border-amber-300/70 px-2 py-0.5 font-semibold text-amber-200'>Pending</span>");
                        }

                        out.write("</div>");
                        out.write("<div class='mt-3 text-xs'>");
                        if (leaveInfo != null) {
                            out.write("<div class='inline-flex items-center gap-1 rounded-md bg-slate-950/40 px-2 py-1'>");
                            out.write("<span>🗓️</span><span class='font-medium'>" + type + "</span>");
                            out.write("</div>");
                        } else {
                            out.write("<span class='text-slate-500'>Working day</span>");
                        }
                        out.write("</div>");
                        out.write("</article>");

                        loopDay = loopDay.plusDays(1);
                    }
                    out.write("</div>");
                }
            %>
        </section>

        <aside class="rounded-2xl border border-slate-800 bg-slate-900/85 p-5 shadow-xl shadow-black/20">
            <h3 class="text-lg font-semibold mb-4">Legend</h3>
            <div class="space-y-3 text-sm">
                <div class="flex items-center gap-3 rounded-lg border border-slate-800 bg-slate-950/40 p-3">
                    <span class="h-4 w-4 rounded bg-[#EF4444]"></span>
                    <div>
                        <p class="font-semibold">Red = Absent</p>
                        <p class="text-xs text-slate-400">Approved leave in effect.</p>
                    </div>
                </div>
                <div class="flex items-center gap-3 rounded-lg border border-amber-400/40 bg-slate-950/40 p-3">
                    <span class="h-4 w-4 rounded border border-amber-300 bg-amber-300/15"></span>
                    <div>
                        <p class="font-semibold">Amber = Pending Action</p>
                        <p class="text-xs text-slate-400">Request submitted, awaiting approval.</p>
                    </div>
                </div>
                <div class="flex items-center gap-3 rounded-lg border border-slate-800 bg-slate-950/40 p-3">
                    <span class="h-4 w-4 rounded bg-slate-700"></span>
                    <div>
                        <p class="font-semibold">Neutral = Working</p>
                        <p class="text-xs text-slate-400">No leave scheduled.</p>
                    </div>
                </div>
            </div>

            <c:if test="${empty calendarLeaves}">
                <p class="mt-5 rounded-lg border border-slate-800 bg-slate-950/40 p-3 text-xs text-slate-400">
                    No leave requests available for display in this period.
                </p>
            </c:if>
        </aside>
    </main>
</div>
</body>
</html>
