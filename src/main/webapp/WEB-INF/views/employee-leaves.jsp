<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Leaves</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-950 text-slate-100 p-6">
<div class="max-w-6xl mx-auto space-y-6">
    <div class="flex items-center justify-between">
        <div>
            <h1 class="text-2xl font-bold">My Leave Requests</h1>
            <p class="text-slate-400 text-sm">Welcome, ${sessionScope.user.username}</p>
        </div>
        <div class="flex gap-2">
            <a href="${pageContext.request.contextPath}/employee/apply" class="px-4 py-2 rounded bg-blue-600 hover:bg-blue-700">Apply Leave</a>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="px-4 py-2 rounded bg-red-600 hover:bg-red-700">Logout</a>
        </div>
    </div>

    <div class="bg-slate-900 border border-slate-800 rounded-xl overflow-hidden">
        <table class="w-full text-left">
            <thead class="bg-slate-800 text-slate-200">
                <tr>
                    <th class="px-4 py-3">Type</th>
                    <th class="px-4 py-3">Start Date</th>
                    <th class="px-4 py-3">End Date</th>
                    <th class="px-4 py-3">Reason</th>
                    <th class="px-4 py-3">Status</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="leave" items="${leaves}">
                    <tr class="border-t border-slate-800">
                        <td class="px-4 py-3">${empty leave.leaveType ? 'General' : leave.leaveType}</td>
                        <td class="px-4 py-3">${leave.startDate}</td>
                        <td class="px-4 py-3">${leave.endDate}</td>
                        <td class="px-4 py-3">${leave.reason}</td>
                        <td class="px-4 py-3">
                            <span class="px-2 py-1 rounded text-xs bg-slate-700">${empty leave.status ? 'Pending' : leave.status}</span>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty leaves}">
            <p class="p-6 text-slate-400">No leave requests found.</p>
        </c:if>
    </div>
</div>
</body>
</html>
