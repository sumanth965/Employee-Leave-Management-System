<%@ page import="java.util.List" %>
<%@ page import="com.elms.model.Leave" %>
<%@ page import="com.elms.model.User" %>
<%@ page import="com.elms.dao.LeaveDAO" %>
<%
User currentUser = (User) session.getAttribute("user");
if (currentUser == null) {
    response.sendRedirect("login.jsp");
    return;
}
if (!"manager".equalsIgnoreCase(currentUser.getRole())) {
    response.sendRedirect("employee.jsp");
    return;
}
String search = request.getParameter("search");
String statusFilter = request.getParameter("status");
if (search == null) search = "";
if (statusFilter == null) statusFilter = "All";
int pageNumber = 1;
int limit = 10;
try {
    if (request.getParameter("page") != null) {
        pageNumber = Integer.parseInt(request.getParameter("page"));
        if (pageNumber < 1) pageNumber = 1;
    }
} catch (Exception e) {
    pageNumber = 1;
}
int totalRecords = LeaveDAO.getTotalLeaves(search, statusFilter);
int totalPages = (int) Math.ceil((double) totalRecords / limit);
if (pageNumber > totalPages && totalPages != 0) pageNumber = totalPages;
List<Leave> leaveList = LeaveDAO.getLeavesPaginated(pageNumber, limit, search, statusFilter);
int pendingCount = LeaveDAO.countByStatus("Pending");
int approvedCount = LeaveDAO.countByStatus("Approved");
int rejectedCount = LeaveDAO.countByStatus("Rejected");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard | ELMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/manager.css" rel="stylesheet">
</head>
<body>
    <aside class="sidebar p-3">
        <div class="pb-4 border-bottom border-secondary-subtle">
            <div class="d-flex align-items-center gap-2 text-white">
                <i class="bi bi-building text-primary"></i>
                <h1 class="h5 mb-0">ELMS Corporate</h1>
            </div>
            <p class="mb-0 text-secondary small mt-2">Manager Portal</p>
        </div>

        <nav class="nav flex-column mt-4 gap-1">
            <a class="nav-link active" href="manager.jsp"><i class="bi bi-house-door me-2"></i>Dashboard</a>
            <a class="nav-link" href="register.jsp"><i class="bi bi-person-plus me-2"></i>Add Employee</a>
            <a class="nav-link" href="#leave-requests"><i class="bi bi-clock-history me-2"></i>Leave Requests</a>
        </nav>

        <div class="mt-auto pt-3 border-top border-secondary-subtle text-white">
            <div class="d-flex align-items-center gap-2">
                <img src="https://ui-avatars.com/api/?name=<%= currentUser.getUsername() %>&background=2563EB&color=fff" class="rounded-circle" width="42" height="42" alt="avatar">
                <div>
                    <div class="fw-semibold"><%= currentUser.getUsername() %></div>
                    <div class="small text-secondary">Manager</div>
                </div>
            </div>
            <a class="btn btn-outline-light btn-sm mt-3 w-100" href="logout.jsp"><i class="bi bi-box-arrow-right me-1"></i>Logout</a>
        </div>
    </aside>

    <div class="main-wrap">
        <header class="topbar d-flex justify-content-between align-items-center">
            <div>
                <h2 class="mb-0 topbar-heading">Good Morning, <%= currentUser.getUsername() %></h2>
                <small class="text-secondary">Review and manage employee leave requests efficiently.</small>
            </div>
            <div class="d-flex align-items-center gap-3">
                <button class="btn btn-icon" type="button"><i class="bi bi-bell"></i></button>
                <div class="dropdown">
                    <button class="btn profile-dropdown dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown" type="button">
                        <img src="https://ui-avatars.com/api/?name=<%= currentUser.getUsername() %>&background=2563EB&color=fff" class="rounded-circle" width="32" height="32" alt="avatar">
                        <span><%= currentUser.getUsername() %></span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="logout.jsp"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <main class="content p-3 p-md-4">
            <div class="row g-3 mb-4">
                <div class="col-12 col-md-4">
                    <div class="glass-card kpi-card p-3 p-md-4 h-100">
                        <div>
                            <p class="kpi-label mb-1">Pending</p>
                            <h3 class="kpi-value pending mb-0"><%= pendingCount %></h3>
                        </div>
                        <i class="bi bi-hourglass-split kpi-icon pending"></i>
                    </div>
                </div>
                <div class="col-12 col-md-4">
                    <div class="glass-card kpi-card p-3 p-md-4 h-100">
                        <div>
                            <p class="kpi-label mb-1">Approved</p>
                            <h3 class="kpi-value approved mb-0"><%= approvedCount %></h3>
                        </div>
                        <i class="bi bi-check-circle kpi-icon approved"></i>
                    </div>
                </div>
                <div class="col-12 col-md-4">
                    <div class="glass-card kpi-card p-3 p-md-4 h-100">
                        <div>
                            <p class="kpi-label mb-1">Rejected</p>
                            <h3 class="kpi-value rejected mb-0"><%= rejectedCount %></h3>
                        </div>
                        <i class="bi bi-x-circle kpi-icon rejected"></i>
                    </div>
                </div>
            </div>

            <div class="glass-card p-3 p-md-4 mb-4">
                <form method="GET" class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label class="form-label">Search by Employee ID</label>
                        <input type="text" name="search" class="form-control" value="<%= search %>" placeholder="e.g. EMP001">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Status</label>
                        <select name="status" class="form-select">
                            <option value="All" <%= "All".equals(statusFilter) ? "selected" : "" %>>All Requests</option>
                            <option value="Pending" <%= "Pending".equals(statusFilter) ? "selected" : "" %>>Pending</option>
                            <option value="Approved" <%= "Approved".equals(statusFilter) ? "selected" : "" %>>Approved</option>
                            <option value="Rejected" <%= "Rejected".equals(statusFilter) ? "selected" : "" %>>Rejected</option>
                        </select>
                    </div>
                    <div class="col-md-3 d-grid">
                        <button type="submit" class="btn btn-brand"><i class="bi bi-search me-1"></i>Apply Filter</button>
                    </div>
                </form>
            </div>

            <section id="leave-requests" class="glass-card p-3 p-md-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="mb-0">Leave Requests</h4>
                    <span class="badge rounded-pill text-bg-light"><%= totalRecords %> records</span>
                </div>

<% if (leaveList != null && !leaveList.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Employee ID</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Reason</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
<% for (Leave l : leaveList) {
String status = l.getStatus();
String badgeClass = "status-pending";
if ("Approved".equalsIgnoreCase(status)) badgeClass = "status-approved";
else if ("Rejected".equalsIgnoreCase(status)) badgeClass = "status-rejected";
%>
                            <tr>
                                <td class="fw-semibold"><%= l.getUserId() %></td>
                                <td><%= l.getStartDate() %></td>
                                <td><%= l.getEndDate() %></td>
                                <td><%= l.getReason() %></td>
                                <td><span class="status-badge <%= badgeClass %>"><%= status %></span></td>
                                <td class="text-center">
<% if ("Pending".equalsIgnoreCase(status)) { %>
                                    <div class="d-flex gap-2 justify-content-center">
                                        <form action="<%= request.getContextPath() %>/ApproveLeaveServlet" method="GET" class="m-0">
                                            <input type="hidden" name="id" value="<%= l.getId() %>">
                                            <input type="hidden" name="action" value="Approved">
                                            <button type="submit" class="btn btn-sm btn-success">Approve</button>
                                        </form>
                                        <form action="<%= request.getContextPath() %>/ApproveLeaveServlet" method="GET" class="m-0">
                                            <input type="hidden" name="id" value="<%= l.getId() %>">
                                            <input type="hidden" name="action" value="Rejected">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">Reject</button>
                                        </form>
                                    </div>
<% } else { %>
                                    <span class="text-muted small">Completed</span>
<% } %>
                                </td>
                            </tr>
<% } %>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mt-3">
                    <small class="text-muted">Page <strong><%= pageNumber %></strong> of <strong><%= totalPages == 0 ? 1 : totalPages %></strong></small>
                    <div class="d-flex gap-2">
<% if (pageNumber > 1) { %>
                        <a class="btn btn-outline-secondary btn-sm" href="?page=<%= pageNumber - 1 %>&search=<%= search %>&status=<%= statusFilter %>">Previous</a>
<% } %>
<% if (pageNumber < totalPages) { %>
                        <a class="btn btn-brand btn-sm" href="?page=<%= pageNumber + 1 %>&search=<%= search %>&status=<%= statusFilter %>">Next</a>
<% } %>
                    </div>
                </div>
<% } else { %>
                <div class="text-center py-5">
                    <i class="bi bi-inbox fs-2 text-secondary"></i>
                    <h5 class="mt-3 mb-1">No Leave Requests Found</h5>
                    <p class="text-muted mb-0">Try adjusting your search or status filter.</p>
                </div>
<% } %>
            </section>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
