<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>Leave Calendar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container mt-4">

    <h2>My Leave Calendar</h2>

    <!-- Messages -->
    <c:if test="${not empty flashSuccess}">
        <div class="alert alert-success">${flashSuccess}</div>
    </c:if>

    <c:if test="${not empty flashError}">
        <div class="alert alert-danger">${flashError}</div>
    </c:if>

    <!-- Navigation -->
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/app/employee/dashboard" class="btn btn-secondary">
            Back
        </a>
    </div>

    <!-- Leave Data -->
    <c:forEach items="${calendarLeaves}" var="leave">
        <div class="card mb-2">
            <div class="card-body">
                <b>Type:</b> ${leave.leaveType} <br>
                <b>Status:</b> ${leave.status} <br>
                <b>From:</b> ${leave.startDate} <br>
                <b>To:</b> ${leave.endDate} <br>
                <b>Reason:</b> ${leave.reason}
            </div>
        </div>
    </c:forEach>

</div>

</body>
</html>