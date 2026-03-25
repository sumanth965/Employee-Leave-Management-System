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

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #f5f7fb;
        }

        .header {
            background: linear-gradient(135deg, #0d6efd, #4e73df);
            color: white;
            padding: 20px;
            border-radius: 12px;
        }

        .leave-card {
            border: none;
            border-radius: 12px;
            transition: 0.3s;
        }

        .leave-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .badge-status {
            font-size: 12px;
            padding: 6px 10px;
            border-radius: 20px;
        }

        .status-approved {
            background: #d1fae5;
            color: #065f46;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }
    </style>
</head>

<body>

<div class="container py-4">

    <!-- Header -->
    <div class="header mb-4 d-flex justify-content-between align-items-center">
        <div>
            <h3 class="mb-0">My Leave Calendar</h3>
            <small>Track your leave history easily</small>
        </div>

        <div>
            <a href="<%= request.getContextPath() %>/app/employee/dashboard"
               class="btn btn-light btn-sm">
               <i class="bi bi-arrow-left"></i> Back
            </a>
        </div>
    </div>

    <!-- Alerts -->
    <% if (flashSuccess != null && !flashSuccess.trim().isEmpty()) { %>
        <div class="alert alert-success shadow-sm"><%= flashSuccess %></div>
    <% } %>

    <% if (flashError != null && !flashError.trim().isEmpty()) { %>
        <div class="alert alert-danger shadow-sm"><%= flashError %></div>
    <% } %>

    <!-- Leave Cards -->
    <div class="row g-3">
        <% if (calendarLeaves != null) {
               for (Leave leave : calendarLeaves) {
                   String status = leave.getStatus() == null ? "Pending" : leave.getStatus();
                   String statusClass = "status-pending";
                   if ("Approved".equalsIgnoreCase(status)) {
                       statusClass = "status-approved";
                   } else if ("Rejected".equalsIgnoreCase(status)) {
                       statusClass = "status-rejected";
                   }
        %>
            <div class="col-md-6 col-lg-4">
                <div class="card leave-card shadow-sm p-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h6 class="mb-0">
                            <i class="bi bi-calendar-event"></i>
                            <%= leave.getLeaveType() == null ? "Leave" : leave.getLeaveType() %>
                        </h6>

                        <span class="badge badge-status <%= statusClass %>">
                            <%= status %>
                        </span>
                    </div>

                    <p class="mb-1">
                        <i class="bi bi-calendar-date"></i>
                        <b>From:</b> <%= leave.getStartDate() %>
                    </p>

                    <p class="mb-1">
                        <i class="bi bi-calendar-check"></i>
                        <b>To:</b> <%= leave.getEndDate() %>
                    </p>

                    <p class="mb-0 text-muted">
                        <i class="bi bi-chat-left-text"></i>
                        <%= leave.getReason() %>
                    </p>

                </div>
            </div>
        <%     }
           }
        %>
    </div>

    <!-- Empty State -->
    <% if (calendarLeaves == null || calendarLeaves.isEmpty()) { %>
        <div class="text-center mt-5">
            <i class="bi bi-calendar-x" style="font-size: 40px; color: gray;"></i>
            <p class="mt-2 text-muted">No leave records found</p>
        </div>
    <% } %>

</div>

</body>
</html>
