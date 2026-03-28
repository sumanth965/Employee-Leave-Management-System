<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Dashboard | ELMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --brand-navy: #0A1628;
            --brand-blue: #2563EB;
            --content-bg: #F4F6F9;
        }

        * { font-family: 'Inter', sans-serif; }

        body {
            background: var(--content-bg);
            margin: 0;
            color: #1f2937;
        }

        .sidebar {
            width: 260px;
            min-height: 100vh;
            background: var(--brand-navy);
            position: fixed;
            left: 0;
            top: 0;
            display: flex;
            flex-direction: column;
            z-index: 1030;
        }

        .sidebar .nav-link {
            color: #cbd5e1;
            border-left: 3px solid transparent;
            padding: .85rem 1rem;
            border-radius: .5rem;
            transition: all .25s ease;
        }

        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            color: #fff;
            border-left-color: var(--brand-blue);
            background: rgba(37, 99, 235, 0.18);
            transform: translateX(2px);
        }

        .main-wrap {
            margin-left: 260px;
            min-height: 100vh;
        }

        .topbar {
            background: var(--brand-navy);
            color: #fff;
            padding: 1rem 1.5rem;
            position: sticky;
            top: 0;
            z-index: 1020;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.82);
            backdrop-filter: blur(12px);
            border-radius: 1rem;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.4);
            animation: fadeSlide .55s ease both;
        }

        .leave-balance-card .metric-label {
            font-size: 12px;
            color: #64748b;
        }

        .leave-balance-card .metric-value {
            font-weight: 600;
            font-size: 15px;
            color: #0f172a;
        }

        .leave-progress-track {
            background: #e2e8f0;
            height: 12px;
            border-radius: 999px;
            overflow: hidden;
        }

        .leave-progress-bar {
            height: 100%;
            border-radius: 999px;
            transition: width .25s ease;
        }

        .leave-progress-bar.healthy { background: #22c55e; }
        .leave-progress-bar.warning { background: #f59e0b; }
        .leave-progress-bar.danger { background: #ef4444; }

        .leave-progress-caption {
            font-size: 12px;
            color: #64748b;
        }

        .table thead th {
            font-size: 13px;
            color: #64748b;
            border-bottom-width: 1px;
        }

        .table tbody td {
            font-size: 13px;
            vertical-align: middle;
        }

        .table tbody tr:nth-child(odd) { background-color: #f8fafc; }
        .table tbody tr:hover { background-color: #eaf2ff; transition: .2s ease; }


        .tracker-table th,
        .tracker-table td {
            white-space: nowrap;
        }

        .tracker-table td.actions-col,
        .tracker-table th.actions-col {
            min-width: 110px;
        }

        .status-badge {
            border-radius: 999px;
            padding: .35rem .75rem;
            font-size: 12px;
            font-weight: 600;
        }

        .status-pending { background: #FEF3C7; color: #92400E; }
        .status-approved { background: #DCFCE7; color: #166534; }
        .status-rejected { background: #FEE2E2; color: #991B1B; }
        .status-cancelled { background: #E5E7EB; color: #374151; }

        .btn-primary,
        .btn-outline-danger {
            transition: transform .2s ease, box-shadow .2s ease;
        }

        .btn-primary:hover,
        .btn-outline-danger:hover {
            transform: scale(1.02);
        }

        .btn-brand {
            background: var(--brand-blue);
            border-color: var(--brand-blue);
            color: #fff;
        }

        .btn-brand:hover { background: #1d4ed8; border-color: #1d4ed8; color: #fff; }

        .fade-in { animation: fadeSlide .7s ease both; }

        @keyframes fadeSlide {
            from { opacity: 0; transform: translateY(18px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 991px) {
            .sidebar { position: static; width: 100%; min-height: auto; }
            .main-wrap { margin-left: 0; }
        }
    </style>
</head>
<body>
<div class="sidebar p-3">
    <div class="pb-4 border-bottom border-secondary-subtle">
        <div class="d-flex align-items-center gap-2 text-white">
            <i class="bi bi-building text-primary"></i>
            <h1 class="h5 mb-0">ELMS Corporate</h1>
        </div>
        <p class="mb-0 text-secondary small mt-2">Employee Portal</p>
    </div>

    <nav class="nav flex-column mt-4 gap-1">
        <a class="nav-link active" href="${pageContext.request.contextPath}/employee/leaves"><i class="bi bi-house-door me-2"></i>Dashboard Home</a>
        <button class="nav-link text-start border-0 bg-transparent" data-bs-toggle="offcanvas" data-bs-target="#applyLeaveDrawer"><i class="bi bi-calendar-plus me-2"></i>Apply Leave</button>
        <a class="nav-link" href="${pageContext.request.contextPath}/employee/calendar"><i class="bi bi-calendar3 me-2"></i>Leave Calendar</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/employee/leaves"><i class="bi bi-clock-history me-2"></i>My Leave History</a>
        <a class="nav-link" href="#"><i class="bi bi-person me-2"></i>Profile</a>
    </nav>

    <div class="mt-auto pt-3 border-top border-secondary-subtle text-white">
        <div class="d-flex align-items-center gap-2">
            <img src="https://ui-avatars.com/api/?name=${sessionScope.user.username}&background=2563EB&color=fff" class="rounded-circle" width="42" height="42" alt="avatar">
            <div>
                <div class="fw-semibold">${sessionScope.user.username}</div>
                <div class="small text-secondary">Employee</div>
            </div>
        </div>
    </div>
</div>

<div class="main-wrap">
    <header class="topbar d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0" style="font-size:24px;">Good Morning, ${sessionScope.user.username}</h2>
            <small class="text-secondary">Welcome back to your leave dashboard</small>
        </div>
        <div class="d-flex align-items-center gap-3">
            <button class="btn btn-sm btn-outline-light rounded-circle"><i class="bi bi-bell"></i></button>
            <div class="dropdown">
                <button class="btn btn-sm btn-outline-light dropdown-toggle" data-bs-toggle="dropdown">Profile</button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout.jsp">Logout</a></li>
                </ul>
            </div>
        </div>
    </header>

    <main class="p-4">
        <c:if test="${not empty flashMessage}">
            <div class="alert alert-${flashType} alert-dismissible fade show fade-in" role="alert">
                ${flashMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-3 mb-4 fade-in">
            <c:forEach var="balance" items="${leaveBalances}">
                <div class="col-12 col-md-6 col-xl-4">
                    <div class="glass-card p-3 h-100 leave-balance-card">
                        <h3 class="h6 mb-3">${balance.leaveType}</h3>

                        <div class="row g-2 mb-3">
                            <div class="col-4">
                                <div class="metric-label">Total</div>
                                <div class="metric-value">${balance.totalDays}</div>
                            </div>
                            <div class="col-4">
                                <div class="metric-label">Used</div>
                                <div class="metric-value">${balance.usedDays}</div>
                            </div>
                            <div class="col-4">
                                <div class="metric-label">Remaining</div>
                                <div class="metric-value">${balance.remainingDays}</div>
                            </div>
                        </div>

                        <div class="leave-progress-track">
                            <c:set var="usedWidth" value="${balance.totalDays > 0 ? balance.usedPercent : 0}" />
                            <div class="leave-progress-bar ${balance.usageStatusClass}" style="width:${usedWidth}%"></div>
                        </div>
                        <div class="d-flex justify-content-between mt-2 leave-progress-caption">
                            <span>Used: ${usedWidth}%</span>
                            <span>Remaining: ${balance.remainingPercent}%</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>


        <div class="glass-card p-3 p-md-4 mb-4 fade-in">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                <h3 class="mb-0" style="font-size:24px;">My Leave Requests</h3>
                <small class="text-muted">Recent requests and current status</small>
            </div>

            <c:if test="${empty recentLeaveRequests}">
                <div class="alert alert-light border text-muted mb-0">No requests found.</div>
            </c:if>

            <c:if test="${not empty recentLeaveRequests}">
                <div class="table-responsive">
                    <table class="table align-middle mb-0 tracker-table">
                        <thead>
                        <tr>
                            <th>Leave Type</th>
                            <th>From Date → To Date</th>
                            <th>Number of Days</th>
                            <th>Status</th>
                            <th class="text-end actions-col">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="req" items="${recentLeaveRequests}">
                            <c:set var="normalizedStatus" value="${fn:toUpperCase(req.status)}" />
                            <tr>
                                <td>${req.leaveType}</td>
                                <td>${req.fromDate} → ${req.toDate}</td>
                                <td>${req.noOfDays}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${normalizedStatus eq 'APPROVED'}">
                                            <span class="status-badge status-approved">🟢 Approved</span>
                                        </c:when>
                                        <c:when test="${normalizedStatus eq 'REJECTED'}">
                                            <span class="status-badge status-rejected">🔴 Rejected</span>
                                        </c:when>
                                        <c:when test="${normalizedStatus eq 'CANCELLED'}">
                                            <span class="status-badge status-cancelled">Cancelled</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-pending">🟡 Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end actions-col">
                                    <c:if test="${normalizedStatus eq 'PENDING'}">
                                        <a class="btn btn-sm btn-outline-danger"
                                           href="${pageContext.request.contextPath}/employee/cancelLeave?id=${req.id}"
                                           onclick="return confirm('Are you sure you want to cancel this pending leave request?');">Cancel</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>

        <div class="glass-card p-3 p-md-4 fade-in">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                <h3 class="mb-0" style="font-size:24px;">Leave History</h3>
                <form method="get" action="${pageContext.request.contextPath}/employee/leaves" class="d-flex gap-2 align-items-center">
                    <label class="small text-muted">Status</label>
                    <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                        <c:forEach var="status" items="${statusOptions}">
                            <option value="${status}" ${status == statusFilter ? 'selected' : ''}>${status}</option>
                        </c:forEach>
                    </select>
                </form>
            </div>

            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead>
                    <tr>
                        <th>Leave Type</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Days</th>
                        <th>Reason</th>
                        <th>Status</th>
                        <th>Manager Comments</th>
                        <th class="text-end">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty leaves}">
                            <c:forEach var="leave" items="${leaves}">
                                <tr>
                                    <td>${leave.leaveType}</td>
                                    <td>${leave.startDate}</td>
                                    <td>${leave.endDate}</td>
                                    <td>${leave.days}</td>
                                    <td>${leave.reason}</td>
                                    <td>
                                        <c:set var="leaveStatusUpper" value="${fn:toUpperCase(leave.status)}" />
                                        <span class="status-badge ${leaveStatusUpper eq 'APPROVED' ? 'status-approved' : (leaveStatusUpper eq 'REJECTED' ? 'status-rejected' : (leaveStatusUpper eq 'CANCELLED' ? 'status-cancelled' : 'status-pending'))}">${leave.status}</span>
                                    </td>
                                    <td>${empty leave.managerComments ? '-' : leave.managerComments}</td>
                                    <td class="text-end">
                                        <c:if test="${fn:toUpperCase(leave.status) eq 'PENDING'}">
                                            <form method="post" action="${pageContext.request.contextPath}/employee/leaves/cancel" class="d-inline" onsubmit="return confirm('Are you sure you want to cancel this pending leave request?');">
                                                <input type="hidden" name="leaveId" value="${leave.id}">
                                                <button class="btn btn-sm btn-outline-danger" type="submit">Cancel</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="text-center text-muted py-4">No leave requests found for the selected status.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<div class="offcanvas offcanvas-end" tabindex="-1" id="applyLeaveDrawer" aria-labelledby="applyLeaveDrawerLabel">
    <div class="offcanvas-header">
        <h5 id="applyLeaveDrawerLabel" class="mb-0">Apply for Leave</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <form method="post" action="${pageContext.request.contextPath}/employee/leaves/apply" class="d-grid gap-3" id="applyLeaveForm">
            <div class="form-floating">
                <select name="leaveType" id="leaveType" class="form-select" required>
                    <option value="">Select</option>
                    <option value="Paid Leave">Paid Leave</option>
                    <option value="Casual Leave">Casual Leave</option>
                    <option value="Sick Leave">Sick Leave</option>
                </select>
                <label for="leaveType">Leave Type</label>
            </div>

            <div class="form-floating">
                <input type="date" class="form-control" id="startDate" name="start" required>
                <label for="startDate">Start Date</label>
            </div>

            <div class="form-floating">
                <input type="date" class="form-control" id="endDate" name="end" required>
                <label for="endDate">End Date</label>
            </div>

            <div>
                <span class="badge text-bg-primary" id="dayCounter">0 day(s)</span>
            </div>

            <div class="form-floating">
                <textarea class="form-control" placeholder="Reason" id="reason" name="reason" style="height:120px" required></textarea>
                <label for="reason">Reason</label>
            </div>

            <div class="d-flex justify-content-end gap-2">
                <button type="button" class="btn btn-light" data-bs-dismiss="offcanvas">Close</button>
                <button class="btn btn-brand" type="submit">Submit Leave</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const startDateEl = document.getElementById('startDate');
    const endDateEl = document.getElementById('endDate');
    const dayCounter = document.getElementById('dayCounter');

    function updateDayCounter() {
        const start = new Date(startDateEl.value);
        const end = new Date(endDateEl.value);

        if (!startDateEl.value || !endDateEl.value || end < start) {
            dayCounter.textContent = '0 day(s)';
            dayCounter.className = 'badge text-bg-secondary';
            return;
        }

        const diffMs = end.getTime() - start.getTime();
        const days = Math.floor(diffMs / (1000 * 60 * 60 * 24)) + 1;
        dayCounter.textContent = `${days} day(s)`;
        dayCounter.className = 'badge text-bg-primary';
    }

    startDateEl.addEventListener('change', updateDayCounter);
    endDateEl.addEventListener('change', updateDayCounter);
</script>
</body>
</html>
