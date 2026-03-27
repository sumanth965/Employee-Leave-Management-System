<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Leave Calendar | ELMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
    <style>
        :root {
            --brand-navy:   #0A1628;
            --brand-blue:   #2563EB;
            --brand-blue-l: #3B82F6;
            --bg:           #060E1E;
            --surface:      #0d1b30;
            --border:       #1e3050;
        }

        * { font-family: 'Inter', sans-serif; box-sizing: border-box; }

        body { background: var(--bg); color: #e2e8f0; margin: 0; }

        /* ── SIDEBAR ── */
        .sidebar {
            width: 255px;
            min-height: 100vh;
            background: var(--brand-navy);
            position: fixed;
            left: 0; top: 0;
            display: flex;
            flex-direction: column;
            border-right: 1px solid var(--border);
            z-index: 100;
        }
        .sidebar-brand { padding: 1.4rem 1.2rem 1rem; border-bottom: 1px solid var(--border); }
        .sidebar-brand .logo { font-size: 1.1rem; font-weight: 700; color: #fff; letter-spacing: -.3px; }
        .sidebar-brand .sub  { font-size: .72rem; color: #64748b; margin-top: 2px; }

        nav.s-nav { padding: .8rem .75rem; flex: 1; }
        nav.s-nav a, nav.s-nav button.s-btn {
            display: flex;
            align-items: center;
            gap: .65rem;
            padding: .7rem .9rem;
            border-radius: .6rem;
            color: #94a3b8;
            font-size: .83rem;
            font-weight: 500;
            text-decoration: none;
            border: none;
            background: transparent;
            width: 100%;
            cursor: pointer;
            transition: all .2s;
            margin-bottom: 2px;
        }
        nav.s-nav a:hover, nav.s-nav button.s-btn:hover { color: #fff; background: rgba(37,99,235,.15); }
        nav.s-nav a.active { color: #fff; background: rgba(37,99,235,.22); border-left: 3px solid var(--brand-blue); padding-left: calc(.9rem - 3px); }
        nav.s-nav .s-icon { font-size: 1rem; flex-shrink: 0; }

        .sidebar-user { padding: 1rem 1.2rem; border-top: 1px solid var(--border); }
        .sidebar-user img { width: 38px; height: 38px; border-radius: 50%; flex-shrink: 0; }
        .sidebar-user .u-name { font-size: .83rem; font-weight: 600; color: #f1f5f9; }
        .sidebar-user .u-role { font-size: .72rem; color: #64748b; }

        /* ── MAIN ── */
        .main-wrap { margin-left: 255px; min-height: 100vh; display: flex; flex-direction: column; }

        /* ── TOPBAR ── */
        .topbar {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            padding: .9rem 1.8rem;
            position: sticky; top: 0; z-index: 50;
            display: flex; align-items: center; justify-content: space-between;
        }
        .topbar h1 { font-size: 1.2rem; font-weight: 700; color: #f8fafc; margin: 0; }
        .topbar small { font-size: .73rem; color: #64748b; }

        /* ── CONTENT ── */
        .content { padding: 1.6rem; flex: 1; }

        /* ── MONTH HEADER ── */
        .month-header {
            display: flex; align-items: center; justify-content: space-between;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: .9rem;
            padding: 1rem 1.4rem;
            margin-bottom: 1.4rem;
        }
        .month-header h2 { font-size: 1.45rem; font-weight: 800; color: #f8fafc; margin: 0; }
        .month-header .badge-view { font-size: .65rem; letter-spacing: .1em; color: #475569; text-transform: uppercase; }

        /* ── CALENDAR GRID ── */
        .cal-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: .45rem; }
        .cal-dow-row { display: contents; }
        .cal-dow { text-align: center; font-size: .65rem; font-weight: 700; letter-spacing: .09em; color: #475569; text-transform: uppercase; padding-bottom: .35rem; }

        .cal-day {
            border-radius: .65rem;
            border: 1px solid var(--border);
            background: var(--surface);
            min-height: 90px;
            padding: .5rem .55rem;
            display: flex; flex-direction: column; justify-content: space-between;
            transition: border-color .2s, background .2s, transform .15s;
            position: relative;
            overflow: hidden;
        }
        .cal-day:hover { transform: translateY(-2px); border-color: #2d4a7a; }

        .cal-day.out-month { background: transparent; border-color: transparent; opacity: .25; pointer-events: none; }

        .cal-day.approved {
            background: rgba(239,68,68,.18);
            border-color: rgba(239,68,68,.55);
            box-shadow: 0 0 14px rgba(239,68,68,.12);
        }
        .cal-day.approved::before {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(135deg, rgba(239,68,68,.08) 0%, transparent 60%);
            pointer-events: none;
        }
        .cal-day.pending {
            background: rgba(245,158,11,.12);
            border-color: rgba(245,158,11,.4);
            border-style: dashed;
        }

        .cal-day .day-num { font-size: .8rem; font-weight: 700; color: #cbd5e1; }
        .cal-day.approved .day-num { color: #fca5a5; }
        .cal-day.pending  .day-num { color: #fcd34d; }

        .cal-day .day-tag {
            font-size: .62rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .06em;
            padding: .18rem .45rem;
            border-radius: 999px;
            align-self: flex-start;
        }
        .cal-day.approved .day-tag { background: rgba(239,68,68,.3); color: #fca5a5; }
        .cal-day.pending  .day-tag { background: rgba(245,158,11,.25); color: #fcd34d; }

        .cal-day .day-icon { font-size: .75rem; color: #475569; }
        .cal-day.approved .day-icon { color: #f87171; }
        .cal-day.pending  .day-icon { color: #fbbf24; }

        /* ── LEGEND ── */
        .legend-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: .9rem;
            padding: 1.2rem;
            position: sticky; top: 80px;
        }
        .legend-title { font-size: .68rem; font-weight: 700; letter-spacing: .12em; color: #475569; text-transform: uppercase; margin-bottom: .9rem; }
        .legend-item {
            display: flex; align-items: center; gap: .65rem;
            padding: .65rem .8rem;
            border-radius: .55rem;
            border: 1px solid transparent;
            margin-bottom: .5rem;
        }
        .legend-item.l-approved { background: rgba(239,68,68,.1); border-color: rgba(239,68,68,.25); }
        .legend-item.l-pending  { background: rgba(245,158,11,.1); border-color: rgba(245,158,11,.25); }
        .legend-item.l-working  { background: rgba(30,48,80,.5);   border-color: var(--border); }
        .legend-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
        .legend-item.l-approved .legend-dot { background: #ef4444; }
        .legend-item.l-pending  .legend-dot { background: #f59e0b; }
        .legend-item.l-working  .legend-dot { background: #334155; }
        .legend-item .l-label { font-size: .78rem; font-weight: 600; color: #e2e8f0; }
        .legend-item .l-sub   { font-size: .68rem; color: #64748b; margin-top: 1px; }

        /* ── STATS ── */
        .stat-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: .9rem;
            padding: 1rem 1.2rem;
            margin-bottom: .8rem;
            text-align: center;
        }
        .stat-card .stat-num { font-size: 2rem; font-weight: 800; line-height: 1; }
        .stat-card .stat-lbl { font-size: .7rem; color: #64748b; margin-top: 4px; text-transform: uppercase; letter-spacing: .08em; }
        .stat-approved .stat-num { color: #f87171; }
        .stat-pending  .stat-num { color: #fbbf24; }

        /* ── RESPONSIVE ── */
        @media (max-width: 992px) {
            .sidebar { display: none; }
            .main-wrap { margin-left: 0; }
        }

        /* ── ANIMATION ── */
        .fade-up { animation: fadeUp .5s ease both; }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(14px); }
            to   { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<%-- ══ SIDEBAR ══ --%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="d-flex align-items-center gap-2">
            <i class="bi bi-building-fill text-primary"></i>
            <span class="logo">ELMS Corporate</span>
        </div>
        <div class="sub">Employee Portal</div>
    </div>

    <nav class="s-nav">
        <a href="${pageContext.request.contextPath}/employee/leaves">
            <i class="bi bi-speedometer2 s-icon"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/employee/calendar" class="active">
            <i class="bi bi-calendar3 s-icon"></i> Leave Calendar
        </a>
        <a href="${pageContext.request.contextPath}/employee/leaves">
            <i class="bi bi-clock-history s-icon"></i> Leave History
        </a>
    </nav>

    <div class="sidebar-user d-flex align-items-center gap-2">
        <img src="https://ui-avatars.com/api/?name=${sessionScope.user.username}&background=1e3a8a&color=93c5fd&bold=true" alt="avatar"/>
        <div>
            <div class="u-name">${sessionScope.user.username}</div>
            <div class="u-role">Employee</div>
        </div>
    </div>
</aside>

<%-- ══ MAIN AREA ══ --%>
<div class="main-wrap">

    <%-- TOPBAR --%>
    <header class="topbar">
        <div>
            <h1><i class="bi bi-calendar-week me-2 text-primary"></i>Leave Visualizer</h1>
            <small>Your monthly leave overview at a glance</small>
        </div>
        <div class="d-flex gap-2 align-items-center">
            <div class="btn-group btn-group-sm">
                <a href="${pageContext.request.contextPath}/employee/calendar?month=${previousMonth}"
                   class="btn btn-outline-secondary"><i class="bi bi-chevron-left"></i> Prev</a>
                <a href="${pageContext.request.contextPath}/employee/calendar?month=${nextMonth}"
                   class="btn btn-outline-secondary">Next <i class="bi bi-chevron-right"></i></a>
            </div>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="btn btn-sm btn-danger px-3"><i class="bi bi-power"></i></a>
        </div>
    </header>

    <div class="content fade-up">
        <div class="row g-4">

            <%-- ── LEFT: CALENDAR ── --%>
            <div class="col-12 col-xl-9">

                <%-- Month Header --%>
                <div class="month-header">
                    <div>
                        <h2>${viewMonthLabel}</h2>
                        <div class="badge-view">Corporate View</div>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/employee/calendar?month=${previousMonth}"
                           class="btn btn-outline-secondary btn-sm px-3">
                            <i class="bi bi-arrow-left me-1"></i>Previous
                        </a>
                        <a href="${pageContext.request.contextPath}/employee/calendar?month=${nextMonth}"
                           class="btn btn-primary btn-sm px-3">
                            Next<i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>

                <%-- Grid --%>
                <div class="cal-grid">
                    <%-- Day-of-week headers --%>
                    <div class="cal-dow">MON</div>
                    <div class="cal-dow">TUE</div>
                    <div class="cal-dow">WED</div>
                    <div class="cal-dow">THU</div>
                    <div class="cal-dow">FRI</div>
                    <div class="cal-dow">SAT</div>
                    <div class="cal-dow">SUN</div>

                    <%-- Calendar days --%>
                    <c:forEach var="row" items="${rows}">
                        <c:forEach var="day" items="${row}">

                            <c:set var="dayClass" value="cal-day"/>
                            <c:if test="${!day.inMonth}">
                                <c:set var="dayClass" value="cal-day out-month"/>
                            </c:if>
                            <c:if test="${day.inMonth and day.approved}">
                                <c:set var="dayClass" value="cal-day approved"/>
                            </c:if>
                            <c:if test="${day.inMonth and day.pending}">
                                <c:set var="dayClass" value="cal-day pending"/>
                            </c:if>

                            <div class="${dayClass}">
                                <div class="d-flex justify-content-between align-items-start">
                                    <span class="day-num">${day.dayOfMonth}</span>
                                    <c:choose>
                                        <c:when test="${day.approved}">
                                            <i class="bi bi-check-circle-fill day-icon"></i>
                                        </c:when>
                                        <c:when test="${day.pending}">
                                            <i class="bi bi-hourglass-split day-icon"></i>
                                        </c:when>
                                    </c:choose>
                                </div>
                                <div>
                                    <c:if test="${day.hasLeave and day.inMonth}">
                                        <span class="day-tag">${day.type}</span>
                                    </c:if>
                                </div>
                            </div>

                        </c:forEach>
                    </c:forEach>
                </div>

            </div>

            <%-- ── RIGHT: LEGEND + STATS ── --%>
            <div class="col-12 col-xl-3">

                <%-- Stats cards --%>
                <div class="stat-card stat-approved">
                    <div class="stat-num">${approvedCount}</div>
                    <div class="stat-lbl">Approved Leaves</div>
                </div>
                <div class="stat-card stat-pending">
                    <div class="stat-num">${pendingCount}</div>
                    <div class="stat-lbl">Pending Requests</div>
                </div>

                <%-- Legend --%>
                <div class="legend-card">
                    <div class="legend-title">Legend</div>

                    <div class="legend-item l-approved">
                        <div class="legend-dot"></div>
                        <div>
                            <div class="l-label">Approved Leave</div>
                            <div class="l-sub">Absent — leave confirmed</div>
                        </div>
                    </div>

                    <div class="legend-item l-pending">
                        <div class="legend-dot"></div>
                        <div>
                            <div class="l-label">Pending Approval</div>
                            <div class="l-sub">Submitted, awaiting manager</div>
                        </div>
                    </div>

                    <div class="legend-item l-working">
                        <div class="legend-dot"></div>
                        <div>
                            <div class="l-label">Working Day</div>
                            <div class="l-sub">No leave scheduled</div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
