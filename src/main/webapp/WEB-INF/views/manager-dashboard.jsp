<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head><title>Manager Dashboard</title></head>
<body>
<h2>Manager Dashboard</h2>
<form action="${pageContext.request.contextPath}/logout" method="post"><button type="submit">Logout</button></form>

<c:if test="${not empty flashSuccess}"><p style="color:green">${flashSuccess}</p></c:if>
<c:if test="${not empty flashError}"><p style="color:red">${flashError}</p></c:if>

<form method="get" action="${pageContext.request.contextPath}/app/manager/dashboard">
    <label>Status:</label>
    <select name="status">
        <option value="">All</option>
        <option value="PENDING">Pending</option>
        <option value="APPROVED">Approved</option>
        <option value="REJECTED">Rejected</option>
        <option value="CANCELED">Canceled</option>
    </select>
    <label>From:</label><input type="date" name="fromDate" value="${fromDate}" />
    <label>To:</label><input type="date" name="toDate" value="${toDate}" />
    <button type="submit">Filter</button>
</form>

<table border="1">
    <tr>
        <th>ID</th><th>Employee</th><th>Type</th><th>Start</th><th>End</th><th>Days</th><th>Status</th><th>Action</th>
    </tr>
    <c:forEach items="${result.items}" var="leave">
        <tr>
            <td>${leave.id}</td>
            <td>${leave.employeeName}</td>
            <td>${leave.leaveType}</td>
            <td>${leave.startDate}</td>
            <td>${leave.endDate}</td>
            <td>${leave.days}</td>
            <td>${leave.status}</td>
            <td>
                <c:if test="${leave.status eq 'PENDING'}">
                    <form action="${pageContext.request.contextPath}/app/manager/decision" method="post">
                        <input type="hidden" name="leaveId" value="${leave.id}" />
                        <input type="text" name="comments" placeholder="comments" />
                        <button type="submit" name="action" value="approve">Approve</button>
                        <button type="submit" name="action" value="reject">Reject</button>
                    </form>
                </c:if>
                <c:if test="${leave.status ne 'PENDING'}">
                    By ${leave.approvedByName} on ${leave.approvedDate}<br/>
                    ${leave.managerComments}
                </c:if>
            </td>
        </tr>
    </c:forEach>
</table>

<p>
    Page ${result.page} of ${result.totalPages} (Total ${result.totalRecords})
    <c:if test="${result.page > 1}">
        <a href="${pageContext.request.contextPath}/app/manager/dashboard?page=${result.page - 1}">Previous</a>
    </c:if>
    <c:if test="${result.page < result.totalPages}">
        <a href="${pageContext.request.contextPath}/app/manager/dashboard?page=${result.page + 1}">Next</a>
    </c:if>
</p>
</body>
</html>
