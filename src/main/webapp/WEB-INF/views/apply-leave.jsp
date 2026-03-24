<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Apply Leave</title>
</head>
<body>
<h2>Apply Leave</h2>
<c:if test="${not empty errors}">
    <ul style="color:red;">
        <c:forEach items="${errors}" var="err"><li>${err}</li></c:forEach>
    </ul>
</c:if>
<form action="${pageContext.request.contextPath}/app/employee/apply" method="post">
    <label>Leave Type:</label>
    <select name="leaveType" required>
        <c:forEach items="${leaveTypes}" var="type">
            <option value="${type}">${type}</option>
        </c:forEach>
    </select><br/>

    <label>Start Date:</label>
    <input type="date" name="startDate" required /><br/>

    <label>End Date:</label>
    <input type="date" name="endDate" required /><br/>

    <label>Reason:</label>
    <textarea name="reason" required></textarea><br/>

    <button type="submit">Submit</button>
</form>
<a href="${pageContext.request.contextPath}/app/employee/dashboard">Back</a>
</body>
</html>
