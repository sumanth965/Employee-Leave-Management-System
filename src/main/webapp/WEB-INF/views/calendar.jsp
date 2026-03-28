<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Leave Calendar | ELMS</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet" />
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                rel="stylesheet" />
            <link href="${pageContext.request.contextPath}/css/calendar.css" rel="stylesheet" />
        </head>

        <body>

            <%-- ══ SIDEBAR ══ --%>
                <aside class="sidebar p-3">
                    <div class="pb-4 border-bottom border-secondary-subtle">
                        <div class="d-flex align-items-center gap-2 text-white">
                            <i class="bi bi-building text-primary"></i>
                            <h1 class="h5 mb-0">ELMS Corporate</h1>
                        </div>
                        <p class="mb-0 text-secondary small mt-2">Employee Portal</p>
                    </div>

                    <nav class="nav flex-column mt-4 gap-1">
                        <a class="nav-link" href="${pageContext.request.contextPath}/employee/leaves">
                            <i class="bi bi-house-door me-2"></i>Dashboard Home
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/employee/calendar">
                            <i class="bi bi-calendar3 me-2"></i>Leave Calendar
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/employee/leaves">
                            <i class="bi bi-clock-history me-2"></i>My Leave History
                        </a>
                    </nav>

                    <div class="mt-auto pt-3 border-top border-secondary-subtle text-white">
                        <div class="d-flex align-items-center gap-2">
                            <img src="https://ui-avatars.com/api/?name=${sessionScope.user.username}&background=2563EB&color=fff"
                                class="rounded-circle" width="42" height="42" alt="avatar">
                            <div>
                                <div class="fw-semibold">${sessionScope.user.username}</div>
                                <div class="small text-secondary">Employee</div>
                            </div>
                        </div>
                        <a class="btn btn-outline-light btn-sm mt-3 w-100"
                            href="${pageContext.request.contextPath}/logout.jsp">
                            <i class="bi bi-box-arrow-right me-1"></i>Logout
                        </a>
                    </div>
                </aside>

                <%-- ══ MAIN AREA ══ --%>
                    <div class="main-wrap">

                        <%-- TOPBAR --%>
                            <header class="topbar d-flex justify-content-between align-items-center">
                                <div>
                                    <h2 class="mb-0" style="font-size:24px;"><span id="greetingText"></span>,
                                        ${sessionScope.user.username}</h2>
                                    <script>
                                        (function () {
                                            var h = new Date().getHours();
                                            var g = h < 12 ? 'Good Morning' : h < 17 ? 'Good Afternoon' : 'Good Evening';
                                            document.getElementById('greetingText').textContent = g;
                                        })();
                                    </script>
                                    <small class="text-secondary text-dim">Visualize your leave schedule for the
                                        month</small>
                                </div>
                                <div class="d-flex align-items-center gap-3">
                                    <button class="btn btn-sm btn-outline-light rounded-circle"><i
                                            class="bi bi-bell"></i></button>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-outline-light dropdown-toggle"
                                            data-bs-toggle="dropdown">Profile</button>
                                        <ul class="dropdown-menu dropdown-menu-end">
                                            <li><a class="dropdown-item"
                                                    href="${pageContext.request.contextPath}/logout.jsp">Logout</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </header>

                            <main class="content p-4">
                                <div class="row g-4">

                                    <%-- LEFT COLUMN --%>
                                        <div class="col-12 col-xl-9">
                                            <div class="glass-card p-4 h-100">
                                                <div class="month-header">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <h2>${viewMonthLabel}</h2>
                                                        <span
                                                            class="badge text-bg-light border px-3 py-2 rounded-pill fw-semibold text-muted"
                                                            style="cursor:default">Corporate View</span>
                                                    </div>
                                                    <div class="btn-group shadow-sm">
                                                        <a href="${pageContext.request.contextPath}/employee/calendar?month=${previousMonth}"
                                                            class="btn btn-white btn-sm border px-3">
                                                            <i class="bi bi-chevron-left"></i> Previous
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/employee/calendar?month=${nextMonth}"
                                                            class="btn btn-white btn-sm border px-3">
                                                            Next <i class="bi bi-chevron-right"></i>
                                                        </a>
                                                    </div>
                                                </div>

                                                <div class="cal-grid">
                                                    <div class="cal-dow">Monday</div>
                                                    <div class="cal-dow">Tuesday</div>
                                                    <div class="cal-dow">Wednesday</div>
                                                    <div class="cal-dow">Thursday</div>
                                                    <div class="cal-dow">Friday</div>
                                                    <div class="cal-dow">Saturday</div>
                                                    <div class="cal-dow">Sunday</div>

                                                    <c:forEach var="row" items="${rows}">
                                                        <c:forEach var="day" items="${row}">
                                                            <c:set var="dayClass" value="cal-day" />
                                                            <c:if test="${!day.inMonth}">
                                                                <c:set var="dayClass" value="cal-day out-month" />
                                                            </c:if>
                                                            <c:if test="${day.inMonth and day.approved}">
                                                                <c:set var="dayClass" value="cal-day approved" />
                                                            </c:if>
                                                            <c:if test="${day.inMonth and day.pending}">
                                                                <c:set var="dayClass" value="cal-day pending" />
                                                            </c:if>

                                                            <div class="${dayClass}">
                                                                <div
                                                                    class="d-flex justify-content-between align-items-start">
                                                                    <span class="day-num">${day.dayOfMonth}</span>
                                                                    <c:choose>
                                                                        <c:when test="${day.approved}">
                                                                            <i
                                                                                class="bi bi-check-circle-fill day-icon"></i>
                                                                        </c:when>
                                                                        <c:when test="${day.pending}">
                                                                            <i
                                                                                class="bi bi-hourglass-split day-icon"></i>
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
                                        </div>

                                        <%-- RIGHT COLUMN --%>
                                            <div class="col-12 col-xl-3">
                                                <div class="stat-card stat-approved mb-3 shadow-sm border-0">
                                                    <div class="stat-num">${approvedCount}</div>
                                                    <div class="stat-lbl">Approved Leaves</div>
                                                </div>
                                                <div class="stat-card stat-pending mb-4 shadow-sm border-0">
                                                    <div class="stat-num">${pendingCount}</div>
                                                    <div class="stat-lbl">Pending Requests</div>
                                                </div>

                                                <div class="legend-card shadow-sm border-0">
                                                    <div class="legend-title">Legend</div>
                                                    <div class="legend-item l-approved">
                                                        <div class="legend-dot"></div>
                                                        <div>
                                                            <div class="l-label">Approved</div>
                                                            <div class="l-sub">Confirmed leave</div>
                                                        </div>
                                                    </div>
                                                    <div class="legend-item l-pending">
                                                        <div class="legend-dot"></div>
                                                        <div>
                                                            <div class="l-label">Pending</div>
                                                            <div class="l-sub">Awaiting approval</div>
                                                        </div>
                                                    </div>
                                                    <div class="legend-item l-working">
                                                        <div class="legend-dot"></div>
                                                        <div>
                                                            <div class="l-label">Normal</div>
                                                            <div class="l-sub">Working day</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                </div>
                            </main>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>