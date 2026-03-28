<%@ page import="java.util.List" %>
    <%@ page import="com.elms.model.Leave" %>
        <%@ page import="com.elms.model.User" %>
            <%@ page import="com.elms.dao.LeaveDAO" %>
                <% User currentUser=(User) session.getAttribute("user"); if (currentUser==null) {
                    response.sendRedirect("login.jsp"); return; } if
                    (!"manager".equalsIgnoreCase(currentUser.getRole())) { response.sendRedirect("employee.jsp");
                    return; } String search=request.getParameter("search"); String
                    statusFilter=request.getParameter("status"); if (search==null) search="" ; if (statusFilter==null)
                    statusFilter="All" ; int pageNumber=1; int limit=10; try { if (request.getParameter("page") !=null)
                    { pageNumber=Integer.parseInt(request.getParameter("page")); if (pageNumber < 1) pageNumber=1; } }
                    catch (Exception e) { pageNumber=1; } int totalRecords=LeaveDAO.getTotalLeaves(search,
                    statusFilter); int totalPages=(int) Math.ceil((double) totalRecords / limit); if (pageNumber>
                    totalPages && totalPages != 0) pageNumber = totalPages;

                    List<Leave> leaveList = LeaveDAO.getLeavesPaginated(pageNumber, limit, search, statusFilter);

                        int pendingCount = LeaveDAO.countByStatus("Pending");
                        int approvedCount = LeaveDAO.countByStatus("Approved");
                        int rejectedCount = LeaveDAO.countByStatus("Rejected");

                        String csrfToken = (String) session.getAttribute("csrfToken");
                        if (csrfToken == null) {
                        csrfToken = java.util.UUID.randomUUID().toString();
                        session.setAttribute("csrfToken", csrfToken);
                        }
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Manager Portal | ELMS</title>
                            <meta name="description"
                                content="Manager portal to review and approve employee leave requests.">
                            <link
                                href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                                rel="stylesheet">
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                                rel="stylesheet">
                            <link href="<%= request.getContextPath() %>/css/manager.css" rel="stylesheet">
                        </head>

                        <body>

                            <!-- SIDEBAR -->
                            <aside class="sidebar">
                                <div class="sidebar-brand">
                                    <div class="brand-row">
                                        <i class="bi bi-shield-check-fill"></i>
                                        <h1>MANAGER PORTAL</h1>
                                    </div>
                                    <p>Leave Management System</p>
                                </div>
                                <nav class="sidebar-nav">
                                    <a href="manager.jsp" class="nav-item active">
                                        <i class="bi bi-grid-1x2-fill"></i>
                                        <span>Dashboard</span>
                                    </a>
                                    <a href="register.jsp" class="nav-item">
                                        <i class="bi bi-person-plus-fill"></i>
                                        <span>Add Employee</span>
                                    </a>
                                    <a href="#leave-requests" class="nav-item">
                                        <i class="bi bi-file-earmark-arrow-down-fill"></i>
                                        <span>Leave Requests</span>
                                    </a>
                                </nav>
                                <div class="sidebar-footer">
                                    <div class="user-info">
                                        <img src="https://ui-avatars.com/api/?name=<%= currentUser.getUsername() %>&background=2563EB&color=fff"
                                            alt="avatar">
                                        <div>
                                            <div class="name">
                                                <%= currentUser.getUsername() %>
                                            </div>
                                            <div class="role">Manager</div>
                                        </div>
                                    </div>
                                    <a href="logout.jsp" class="btn-logout">
                                        <i class="bi bi-power"></i>
                                        <span>Logout</span>
                                    </a>
                                </div>
                            </aside>

                            <!-- MAIN WRAP -->
                            <div class="main-wrap">

                                <!-- TOPBAR -->
                                <header class="topbar">
                                    <div class="topbar-title">
                                        <h2>Leave Management</h2>
                                        <p>Monitor and approve employee leave requests</p>
                                    </div>
                                    <div class="topbar-right">
                                        <div class="bell-btn">
                                            <i class="bi bi-bell-fill"></i>
                                            <span class="bell-dot"></span>
                                        </div>
                                        <div class="topbar-user">
                                            <img src="https://ui-avatars.com/api/?name=<%= currentUser.getUsername() %>&background=2563EB&color=fff"
                                                alt="avatar">
                                            <div>
                                                <div class="name">
                                                    <%= currentUser.getUsername() %>
                                                </div>
                                                <div class="role">Manager</div>
                                            </div>
                                        </div>
                                    </div>
                                </header>

                                <main class="content">

                                    <!-- PAGE HEADING -->
                                    <div class="page-heading">
                                        <h2>Dashboard Overview</h2>
                                        <p>All leave requests at a glance — review, approve or reject with one click</p>
                                    </div>

                                    <!-- KPI CARDS -->
                                    <div class="kpi-grid">
                                        <div class="kpi-card pending">
                                            <div>
                                                <div class="kpi-label">Pending Requests</div>
                                                <div class="kpi-value">
                                                    <%= pendingCount %>
                                                </div>
                                                <div class="kpi-sub">Awaiting your action</div>
                                            </div>
                                            <div class="kpi-icon"><i class="bi bi-hourglass-split"></i></div>
                                        </div>
                                        <div class="kpi-card approved">
                                            <div>
                                                <div class="kpi-label">Approved</div>
                                                <div class="kpi-value">
                                                    <%= approvedCount %>
                                                </div>
                                                <div class="kpi-sub">This period</div>
                                            </div>
                                            <div class="kpi-icon"><i class="bi bi-check-circle-fill"></i></div>
                                        </div>
                                        <div class="kpi-card rejected">
                                            <div>
                                                <div class="kpi-label">Rejected</div>
                                                <div class="kpi-value">
                                                    <%= rejectedCount %>
                                                </div>
                                                <div class="kpi-sub">This period</div>
                                            </div>
                                            <div class="kpi-icon"><i class="bi bi-x-circle-fill"></i></div>
                                        </div>
                                    </div>

                                    <!-- SEARCH & FILTER -->
                                    <div class="filter-card">
                                        <form method="GET">
                                            <div class="form-group">
                                                <label for="searchInput"><i class="bi bi-search"></i> Search by Employee
                                                    ID</label>
                                                <input id="searchInput" type="text" name="search" class="form-control"
                                                    value="<%= search %>" placeholder="e.g. EMP001">
                                            </div>
                                            <div class="form-group">
                                                <label for="statusSelect"><i class="bi bi-funnel-fill"></i> Filter by
                                                    Status</label>
                                                <select id="statusSelect" name="status" class="form-control">
                                                    <option value="All" <%="All" .equals(statusFilter) ? "selected" : ""
                                                        %>>All Requests</option>
                                                    <option value="Pending" <%="Pending" .equals(statusFilter)
                                                        ? "selected" : "" %>>Pending</option>
                                                    <option value="Approved" <%="Approved" .equals(statusFilter)
                                                        ? "selected" : "" %>>Approved</option>
                                                    <option value="Rejected" <%="Rejected" .equals(statusFilter)
                                                        ? "selected" : "" %>>Rejected</option>
                                                </select>
                                            </div>
                                            <button type="submit" class="btn-filter">
                                                <i class="bi bi-search"></i> Apply Filter
                                            </button>
                                        </form>
                                    </div>

                                    <!-- LEAVE REQUESTS TABLE -->
                                    <div id="leave-requests" class="table-card">
                                        <div class="table-card-header">
                                            <h3><i class="bi bi-table"></i> Leave Requests</h3>
                                            <span class="record-badge">
                                                <%= totalRecords %> total records
                                            </span>
                                        </div>

                                        <% if (leaveList !=null && !leaveList.isEmpty()) { %>
                                            <div style="overflow-x:auto;">
                                                <table>
                                                    <thead>
                                                        <tr>
                                                            <th><i class="bi bi-person"></i> Employee ID</th>
                                                            <th><i class="bi bi-calendar-event"></i> Start Date</th>
                                                            <th><i class="bi bi-calendar-x"></i> End Date</th>
                                                            <th><i class="bi bi-chat-left-text"></i> Reason</th>
                                                            <th><i class="bi bi-info-circle"></i> Status</th>
                                                            <th style="text-align:center;"><i class="bi bi-gear"></i>
                                                                Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% for (Leave l : leaveList) { String status=l.getStatus();
                                                            String badgeClass, statusIcon; if
                                                            ("Approved".equalsIgnoreCase(status)) {
                                                            badgeClass="status-approved" ;
                                                            statusIcon="bi bi-check-circle-fill" ; } else if
                                                            ("Rejected".equalsIgnoreCase(status)) {
                                                            badgeClass="status-rejected" ;
                                                            statusIcon="bi bi-x-circle-fill" ; } else {
                                                            badgeClass="status-pending" ;
                                                            statusIcon="bi bi-hourglass-split" ; } %>
                                                            <tr>
                                                                <td><span class="employee-id">
                                                                        <%= l.getUserId() %>
                                                                    </span></td>
                                                                <td><span class="date-chip">
                                                                        <%= l.getStartDate() %>
                                                                    </span></td>
                                                                <td><span class="date-chip">
                                                                        <%= l.getEndDate() %>
                                                                    </span></td>
                                                                <td>
                                                                    <%= l.getReason() %>
                                                                </td>
                                                                <td>
                                                                    <span class="status-badge <%= badgeClass %>">
                                                                        <i class="<%= statusIcon %>"></i>
                                                                        <%= status %>
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <% if ("Pending".equalsIgnoreCase(status)) { %>
                                                                        <div class="action-group">
                                                                            <form
                                                                                action="<%= request.getContextPath() %>/ApproveLeaveServlet"
                                                                                method="GET" style="margin:0;">
                                                                                <input type="hidden" name="id"
                                                                                    value="<%= l.getId() %>">
                                                                                <input type="hidden" name="action"
                                                                                    value="Approved">
                                                                                <button type="submit"
                                                                                    class="btn-approve">
                                                                                    <i class="bi bi-check-lg"></i>
                                                                                    Approve
                                                                                </button>
                                                                            </form>
                                                                            <form
                                                                                action="<%= request.getContextPath() %>/ApproveLeaveServlet"
                                                                                method="GET" style="margin:0;">
                                                                                <input type="hidden" name="id"
                                                                                    value="<%= l.getId() %>">
                                                                                <input type="hidden" name="action"
                                                                                    value="Rejected">
                                                                                <button type="submit"
                                                                                    class="btn-reject">
                                                                                    <i class="bi bi-x-lg"></i> Reject
                                                                                </button>
                                                                            </form>
                                                                        </div>
                                                                        <% } else { %>
                                                                            <div
                                                                                style="display:flex;justify-content:center;">
                                                                                <span class="btn-done"><i
                                                                                        class="bi bi-check2-all"></i>
                                                                                    Completed</span>
                                                                            </div>
                                                                            <% } %>
                                                                </td>
                                                            </tr>
                                                            <% } %>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <!-- PAGINATION -->
                                            <div class="pagination-bar">
                                                <div class="pagination-info">
                                                    Page <strong>
                                                        <%= pageNumber %>
                                                    </strong> of
                                                    <strong>
                                                        <%= totalPages==0 ? 1 : totalPages %>
                                                    </strong>
                                                    &nbsp;&middot;&nbsp;
                                                    <strong>
                                                        <%= totalRecords %>
                                                    </strong> total requests
                                                </div>
                                                <div class="pagination-btns">
                                                    <% if (pageNumber> 1) { %>
                                                        <a class="btn-page prev"
                                                            href="?page=<%= pageNumber - 1 %>&search=<%= search %>&status=<%= statusFilter %>">
                                                            <i class="bi bi-arrow-left"></i> Previous
                                                        </a>
                                                        <% } %>
                                                            <% if (pageNumber < totalPages) { %>
                                                                <a class="btn-page next"
                                                                    href="?page=<%= pageNumber + 1 %>&search=<%= search %>&status=<%= statusFilter %>">
                                                                    Next <i class="bi bi-arrow-right"></i>
                                                                </a>
                                                                <% } %>
                                                </div>
                                            </div>

                                            <% } else { %>
                                                <div class="empty-state">
                                                    <div class="empty-icon"><i class="bi bi-inbox-fill"></i></div>
                                                    <h4>No Leave Requests Found</h4>
                                                    <p>Try adjusting your search or filter criteria.</p>
                                                </div>
                                                <% } %>
                                    </div>

                                </main>
                            </div>

                        </body>

                        </html>