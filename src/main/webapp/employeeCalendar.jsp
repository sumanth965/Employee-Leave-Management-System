<%@ page import="java.util.List" %>
<%@ page import="model.Leave" %>
<%
    String flashSuccess = (String) request.getAttribute("flashSuccess");
    String flashError = (String) request.getAttribute("flashError");
    List<Leave> calendarLeaves = (List<Leave>) request.getAttribute("calendarLeaves");
%>

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
    <% if (flashSuccess != null && !flashSuccess.trim().isEmpty()) { %>
        <div class="alert alert-success"><%= flashSuccess %></div>
    <% } %>

    <% if (flashError != null && !flashError.trim().isEmpty()) { %>
        <div class="alert alert-danger"><%= flashError %></div>
    <% } %>

    <!-- Navigation -->
    <div class="mb-3">
        <a href="<%= request.getContextPath() %>/app/employee/dashboard" class="btn btn-secondary">
            Back
        </a>
    </div>

    <!-- Leave Data -->
    <% if (calendarLeaves != null) {
           for (Leave leave : calendarLeaves) {
               String status = leave.getStatus() == null ? "Pending" : leave.getStatus();
    %>
        <div class="card mb-2">
            <div class="card-body">
                <b>Type:</b> <%= leave.getLeaveType() == null ? "Leave" : leave.getLeaveType() %> <br>
                <b>Status:</b> <%= status %> <br>
                <b>From:</b> <%= leave.getStartDate() %> <br>
                <b>To:</b> <%= leave.getEndDate() %> <br>
                <b>Reason:</b> <%= leave.getReason() %>
            </div>
        </div>
    <%     }
       }
    %>

    <% if (calendarLeaves == null || calendarLeaves.isEmpty()) { %>
        <div class="alert alert-info">No leave records found.</div>
    <% } %>

</div>

</body>
</html>
