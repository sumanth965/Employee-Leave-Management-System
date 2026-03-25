<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Leave Calendar</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-950 text-slate-100 p-6">
<div class="max-w-5xl mx-auto">
    <div class="flex items-center justify-between mb-4">
        <h1 class="text-2xl font-semibold">My Leave Calendar</h1>
        <a href="${pageContext.request.contextPath}/employee/leaves" class="px-3 py-2 bg-slate-800 rounded">Back</a>
    </div>

    <c:if test="${not empty flashSuccess}">
        <div class="mb-3 p-3 rounded bg-emerald-600/20 text-emerald-200">${flashSuccess}</div>
    </c:if>
    <c:if test="${not empty flashError}">
        <div class="mb-3 p-3 rounded bg-red-600/20 text-red-200">${flashError}</div>
    </c:if>

    <div class="grid gap-3">
        <c:forEach var="leave" items="${calendarLeaves}">
            <div class="p-4 rounded border border-slate-700 bg-slate-900">
                <p><strong>Type:</strong> ${empty leave.leaveType ? 'General' : leave.leaveType}</p>
                <p><strong>Status:</strong> ${empty leave.status ? 'Pending' : leave.status}</p>
                <p><strong>From:</strong> ${leave.startDate}</p>
                <p><strong>To:</strong> ${leave.endDate}</p>
                <p><strong>Reason:</strong> ${leave.reason}</p>
            </div>
        </c:forEach>

        <c:if test="${empty calendarLeaves}">
            <div class="p-4 rounded bg-slate-900 border border-slate-700 text-slate-400">No leave records found.</div>
        </c:if>
    </div>
</div>
</body>
</html>
