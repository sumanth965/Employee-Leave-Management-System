<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Leave Calendar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, minmax(0, 1fr));
            gap: 0.5rem;
        }
        .calendar-day {
            min-height: 110px;
            border: 1px solid #dee2e6;
            border-radius: 0.5rem;
            background: #fff;
            padding: 0.5rem;
            position: relative;
        }
        .calendar-day.outside-month {
            background: #f8f9fa;
            color: #6c757d;
        }
        .day-number {
            font-size: 0.875rem;
            font-weight: 600;
        }
        .leave-chip {
            display: block;
            font-size: 0.75rem;
            line-height: 1.1;
            margin-top: 0.2rem;
            padding: 0.15rem 0.35rem;
            border-radius: 0.35rem;
            color: #212529;
            cursor: pointer;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .status-APPROVED { background: #a7f3d0; }
        .status-PENDING { background: #fde68a; }
        .status-REJECTED { background: #fca5a5; }
        .today-outline {
            outline: 2px solid #0d6efd;
        }
        @media (max-width: 767px) {
            .calendar-grid { gap: 0.35rem; }
            .calendar-day { min-height: 90px; }
        }
    </style>
</head>
<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
        <h2 class="mb-0">My Leave Calendar</h2>
        <div class="d-flex gap-2">
            <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/app/employee/dashboard">Back to Dashboard</a>
            <form action="${pageContext.request.contextPath}/logout" method="post" class="m-0">
                <button type="submit" class="btn btn-outline-danger btn-sm">Logout</button>
            </form>
        </div>
    </div>

    <c:if test="${not empty flashSuccess}"><div class="alert alert-success">${flashSuccess}</div></c:if>
    <c:if test="${not empty flashError}"><div class="alert alert-danger">${flashError}</div></c:if>

    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div class="d-flex gap-2">
                    <a class="btn btn-outline-primary btn-sm"
                       href="${pageContext.request.contextPath}/app/employee/calendar?month=${previousMonth}&status=${statusFilter}">Previous</a>
                    <a class="btn btn-outline-primary btn-sm"
                       href="${pageContext.request.contextPath}/app/employee/calendar?month=${nextMonth}&status=${statusFilter}">Next</a>
                </div>
                <h4 class="mb-0" id="currentMonthLabel">${currentMonth}</h4>
                <form class="d-flex gap-2" method="get" action="${pageContext.request.contextPath}/app/employee/calendar">
                    <input type="month" class="form-control form-control-sm" name="month" value="${currentMonth}" aria-label="Choose month"/>
                    <select name="status" class="form-select form-select-sm" aria-label="Leave status filter">
                        <option value="" ${empty statusFilter ? 'selected' : ''}>All statuses</option>
                        <option value="APPROVED" ${statusFilter == 'APPROVED' ? 'selected' : ''}>Approved</option>
                        <option value="PENDING" ${statusFilter == 'PENDING' ? 'selected' : ''}>Pending</option>
                        <option value="REJECTED" ${statusFilter == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                    </select>
                    <button class="btn btn-primary btn-sm" type="submit">Go</button>
                </form>
            </div>
        </div>
    </div>

    <div class="d-flex gap-3 flex-wrap mb-3">
        <span class="badge text-dark status-APPROVED">Approved</span>
        <span class="badge text-dark status-PENDING">Pending</span>
        <span class="badge text-dark status-REJECTED">Rejected</span>
    </div>

    <div class="calendar-grid mb-2 text-center fw-semibold">
        <div>Sun</div><div>Mon</div><div>Tue</div><div>Wed</div><div>Thu</div><div>Fri</div><div>Sat</div>
    </div>
    <div id="calendarGrid" class="calendar-grid"></div>

    <div id="leaveRecordsData" class="d-none">
        <c:forEach items="${calendarLeaves}" var="leave">
            <div class="leave-data"
                 data-id="${leave.id}"
                 data-start="${leave.startDate}"
                 data-end="${leave.endDate}"
                 data-reason="${fn:escapeXml(leave.reason)}"
                 data-status="${leave.status}"
                 data-type="${leave.leaveType}">
            </div>
        </c:forEach>
    </div>
</div>

<script>
    (function () {
        const currentMonthIso = "${currentMonth}";
        const [year, month] = currentMonthIso.split("-").map(Number);
        const firstDay = new Date(year, month - 1, 1);
        const lastDay = new Date(year, month, 0);
        const calendarGrid = document.getElementById("calendarGrid");
        const todayIso = new Date().toISOString().slice(0, 10);

        document.getElementById("currentMonthLabel").textContent = firstDay.toLocaleDateString(undefined, {
            month: "long",
            year: "numeric"
        });

        const leaveRecords = Array.from(document.querySelectorAll(".leave-data")).map(el => ({
            id: Number(el.dataset.id),
            start: el.dataset.start,
            end: el.dataset.end,
            reason: el.dataset.reason || "No reason provided",
            status: el.dataset.status,
            leaveType: el.dataset.type
        }));

        const toIsoDate = (dateObj) => {
            const m = String(dateObj.getMonth() + 1).padStart(2, "0");
            const d = String(dateObj.getDate()).padStart(2, "0");
            return `${dateObj.getFullYear()}-${m}-${d}`;
        };

        const getStatusForDate = (isoDate) => leaveRecords.filter(record => record.start <= isoDate && record.end >= isoDate);

        const totalCells = 42;
        const leadingDays = firstDay.getDay();
        const monthDays = lastDay.getDate();

        for (let cellIndex = 0; cellIndex < totalCells; cellIndex++) {
            const dayOffset = cellIndex - leadingDays + 1;
            const currentDate = new Date(year, month - 1, dayOffset);
            const isoDate = toIsoDate(currentDate);
            const inCurrentMonth = dayOffset >= 1 && dayOffset <= monthDays;
            const leavesForDay = getStatusForDate(isoDate);

            const dayCell = document.createElement("div");
            dayCell.className = "calendar-day" + (inCurrentMonth ? "" : " outside-month") + (isoDate === todayIso ? " today-outline" : "");

            const dayNumber = document.createElement("div");
            dayNumber.className = "day-number";
            dayNumber.textContent = String(currentDate.getDate());
            dayCell.appendChild(dayNumber);

            leavesForDay.forEach(leave => {
                const chip = document.createElement("span");
                chip.className = "leave-chip status-" + leave.status;
                chip.title = `${leave.leaveType} | ${leave.status}\n${leave.start} to ${leave.end}\nReason: ${leave.reason}`;
                chip.textContent = leave.leaveType + " (" + leave.status + ")";
                chip.addEventListener("click", () => {
                    alert(
                        "Leave Details\n" +
                        "Type: " + leave.leaveType + "\n" +
                        "Status: " + leave.status + "\n" +
                        "Dates: " + leave.start + " to " + leave.end + "\n" +
                        "Reason: " + leave.reason
                    );
                });
                dayCell.appendChild(chip);
            });

            calendarGrid.appendChild(dayCell);
        }
    })();
</script>
</body>
</html>
