<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head><title>Employee Dashboard</title></head>
<body>
<h2>Employee Dashboard</h2>
<form action="${pageContext.request.contextPath}/logout" method="post"><button type="submit">Logout</button></form>

<c:if test="${not empty flashSuccess}"><p style="color:green">${flashSuccess}</p></c:if>
<c:if test="${not empty flashError}"><p style="color:red">${flashError}</p></c:if>

<h3>Leave Balances</h3>
<table border="1">
    <tr><th>Type</th><th>Total</th><th>Used</th><th>Remaining</th></tr>
    <c:forEach items="${balances}" var="balance">
        <tr>
            <td>${balance.leaveType}</td>
            <td>${balance.totalLeaves}</td>
            <td>${balance.usedLeaves}</td>
            <td>${balance.remainingLeaves}</td>
        </tr>
    </c:forEach>
</table>

<p><a href="${pageContext.request.contextPath}/app/employee/apply">Apply New Leave</a></p>
<p><a href="${pageContext.request.contextPath}/app/employee/calendar">View Leave Calendar</a></p>

<h3>Filter Leaves</h3>
<form method="get" action="${pageContext.request.contextPath}/app/employee/dashboard">
    <label>Status</label>
    <select name="status">
        <option value="">All</option>
        <option value="PENDING">Pending</option>
        <option value="APPROVED">Approved</option>
        <option value="REJECTED">Rejected</option>
        <option value="CANCELED">Canceled</option>
    </select>
    <label>From</label><input type="date" name="fromDate" value="${fromDate}" />
    <label>To</label><input type="date" name="toDate" value="${toDate}" />
    <button type="submit">Apply Filter</button>
</form>

<h3>My Leaves</h3>
<table border="1">
    <tr>
        <th>ID</th><th>Type</th><th>Start</th><th>End</th><th>Days</th><th>Status</th><th>Comments</th><th>Action</th>
    </tr>
    <c:forEach items="${result.items}" var="leave">
        <tr>
            <td>${leave.id}</td>
            <td>${leave.leaveType}</td>
            <td>${leave.startDate}</td>
            <td>${leave.endDate}</td>
            <td>${leave.days}</td>
            <td>${leave.status}</td>
            <td>${leave.managerComments}</td>
            <td>
                <c:if test="${leave.status eq 'PENDING'}">
                    <form action="${pageContext.request.contextPath}/app/employee/cancel" method="post">
                        <input type="hidden" name="leaveId" value="${leave.id}" />
                        <button type="submit">Cancel</button>
                    </form>
                </c:if>
            </td>
        </tr>
    </c:forEach>
</table>

<p>
    Page ${result.page} of ${result.totalPages} (Total ${result.totalRecords})
    <c:if test="${result.page > 1}">
        <a href="${pageContext.request.contextPath}/app/employee/dashboard?page=${result.page - 1}">Previous</a>
    </c:if>
    <c:if test="${result.page < result.totalPages}">
        <a href="${pageContext.request.contextPath}/app/employee/dashboard?page=${result.page + 1}">Next</a>
    </c:if>
</p>
</body>
</html>
