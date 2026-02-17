<%@ page import="java.util.List" %>
<%@ page import="model.Leave" %>
<%@ page import="model.User" %>
<%@ page import="dao.LeaveDAO" %>

<%
    // ================= SESSION + ROLE VALIDATION =================
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"manager".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("employee.jsp");
        return;
    }

    // ================= FILTERS =================
    String search = request.getParameter("search");
    String statusFilter = request.getParameter("status");

    if (search == null) search = "";
    if (statusFilter == null) statusFilter = "All";

    // ================= PAGINATION =================
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

    if (pageNumber > totalPages && totalPages != 0) {
        pageNumber = totalPages;
    }

    List<Leave> leaveList = LeaveDAO.getLeavesPaginated(pageNumber, limit, search, statusFilter);

    // ================= KPI COUNTS =================
    int pendingCount = LeaveDAO.countByStatus("Pending");
    int approvedCount = LeaveDAO.countByStatus("Approved");
    int rejectedCount = LeaveDAO.countByStatus("Rejected");

    // ================= CSRF TOKEN =================
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
    <title>Manager Portal - Leave Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 13px;
        }

        .status-pending {
            color: #f59e0b;
            background-color: rgba(245, 158, 11, 0.1);
        }

        .status-approved {
            color: #10b981;
            background-color: rgba(16, 185, 129, 0.1);
        }

        .status-rejected {
            color: #ef4444;
            background-color: rgba(239, 68, 68, 0.1);
        }

        .kpi-card {
            transition: all 0.3s ease;
        }

        .kpi-card:hover {
            transform: translateY(-2px);
            border-color: rgba(255, 255, 255, 0.1);
        }

        .action-btn {
            transition: all 0.2s ease;
        }

        .action-btn:hover {
            transform: translateY(-1px);
        }

        /* Table row hover effect */
        tbody tr {
            transition: all 0.2s ease;
        }

        tbody tr:hover {
            background-color: rgba(100, 116, 139, 0.3);
        }

        /* Sidebar animation */
        aside {
            animation: slideIn 0.3s ease;
        }

        @keyframes slideIn {
            from {
                transform: translateX(-20px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        /* Icon styling */
        .icon-box {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .input-focus:focus {
            border-color: #10b981;
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            box-shadow: 0 8px 16px rgba(16, 185, 129, 0.3);
            transform: translateY(-2px);
        }
    </style>
</head>

<body class="bg-slate-950 text-slate-200">

<div class="flex h-screen overflow-hidden">

    <!-- ================= SIDEBAR ================= -->
    <aside class="w-64 bg-slate-900 border-r border-slate-800 flex flex-col fixed h-screen left-0 top-0 z-50">

        <!-- Logo Section -->
        <div class="px-6 py-6 border-b border-slate-800">
            <div class="flex items-center gap-2 mb-2">
                <i class="fas fa-shield-alt text-emerald-500 text-lg"></i>
                <h1 class="text-sm font-bold tracking-widest text-white">MANAGER PORTAL</h1>
            </div>
            <p class="text-xs text-slate-400">Leave Management System</p>
        </div>

        <!-- Navigation -->
        <nav class="flex-1 px-4 py-6 space-y-1">
            <a href="manager.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg bg-emerald-500 bg-opacity-20 text-emerald-400 font-medium transition-all border border-emerald-500 border-opacity-30">
                <i class="fas fa-chart-bar w-5"></i>
                <span>Dashboard</span>
            </a>
            <a href="register.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-slate-800 text-slate-300 font-medium transition-all">
                <i class="fas fa-user-plus w-5"></i>
                <span>Add Employee</span>
            </a>
            <a href="#" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-slate-800 text-slate-300 font-medium transition-all">
                <i class="fas fa-file-export w-5"></i>
                <span>Export Report</span>
            </a>
        </nav>

        <!-- User Info -->
        <div class="px-6 py-4 border-t border-slate-800">
            <div class="flex items-center gap-3 mb-4">
                <img src="https://ui-avatars.com/api/?name=<%= currentUser.getUsername() %>&background=10b981&color=fff" 
                     alt="Avatar" class="w-10 h-10 rounded-full">
                <div>
                    <p class="text-sm font-semibold text-white"><%= currentUser.getUsername() %></p>
                    <p class="text-xs text-slate-400">Manager</p>
                </div>
            </div>
            <a href="logout.jsp" class="flex items-center justify-center gap-2 w-full px-4 py-2 bg-red-600 hover:bg-red-700 rounded-lg text-sm font-medium transition-all">
                <i class="fas fa-power-off w-4"></i>
                <span>Logout</span>
            </a>
        </div>

    </aside>

    <!-- ================= MAIN CONTENT ================= -->
    <div class="flex-1 ml-64 flex flex-col overflow-hidden">

        <!-- TOP HEADER -->
        <header class="bg-slate-900 border-b border-slate-800 px-10 py-6 flex justify-between items-center shadow-lg">
            <div>
                <h1 class="text-2xl font-bold text-white">Leave Management System</h1>
                <p class="text-sm text-slate-400 mt-1">Monitor and approve employee leave requests</p>
            </div>
            <div class="flex items-center gap-6">
                <button class="relative text-slate-400 hover:text-white transition-all">
                    <i class="fas fa-bell text-xl"></i>
                    <span class="absolute top-0 right-0 w-2 h-2 bg-red-500 rounded-full"></span>
                </button>
                <div class="h-10 w-px bg-slate-700"></div>
                <div class="text-right">
                    <p class="text-sm font-medium text-white"><%= currentUser.getUsername() %></p>
                    <p class="text-xs text-slate-400">Manager</p>
                </div>
            </div>
        </header>

        <!-- PAGE CONTENT -->
        <main class="flex-1 overflow-y-auto p-10 space-y-8">

            <!-- PAGE TITLE -->
            <div>
                <h2 class="text-3xl font-bold text-white mb-2">Dashboard</h2>
                <p class="text-slate-400">Overview of all leave requests</p>
            </div>

            <!-- KPI GRID -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

                <!-- Pending KPI Card -->
                <div class="kpi-card bg-slate-800 border border-slate-700 rounded-2xl p-8 shadow-lg">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-xs uppercase tracking-widest text-slate-400 font-semibold mb-3">Pending Requests</p>
                            <h3 class="text-5xl font-bold text-amber-400 mb-2"><%= pendingCount %></h3>
                            <p class="text-sm text-slate-400">Awaiting your action</p>
                        </div>
                        <div class="icon-box bg-amber-500 bg-opacity-20">
                            <i class="fas fa-hourglass-end text-amber-400"></i>
                        </div>
                    </div>
                </div>

                <!-- Approved KPI Card -->
                <div class="kpi-card bg-slate-800 border border-slate-700 rounded-2xl p-8 shadow-lg">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-xs uppercase tracking-widest text-slate-400 font-semibold mb-3">Approved</p>
                            <h3 class="text-5xl font-bold text-emerald-400 mb-2"><%= approvedCount %></h3>
                            <p class="text-sm text-slate-400">This period</p>
                        </div>
                        <div class="icon-box bg-emerald-500 bg-opacity-20">
                            <i class="fas fa-check-circle text-emerald-400"></i>
                        </div>
                    </div>
                </div>

                <!-- Rejected KPI Card -->
                <div class="kpi-card bg-slate-800 border border-slate-700 rounded-2xl p-8 shadow-lg">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-xs uppercase tracking-widest text-slate-400 font-semibold mb-3">Rejected</p>
                            <h3 class="text-5xl font-bold text-red-400 mb-2"><%= rejectedCount %></h3>
                            <p class="text-sm text-slate-400">This period</p>
                        </div>
                        <div class="icon-box bg-red-500 bg-opacity-20">
                            <i class="fas fa-times-circle text-red-400"></i>
                        </div>
                    </div>
                </div>

            </div>

            <!-- SEARCH & FILTER SECTION -->
            <div class="bg-slate-800 border border-slate-700 rounded-2xl p-6 shadow-lg">
                <form method="GET" class="flex flex-col md:flex-row gap-4 items-end">

                    <div class="flex-1">
                        <label class="block text-sm font-medium text-slate-300 mb-2">
                            <i class="fas fa-search mr-2"></i>Search by Employee ID
                        </label>
                        <input type="text"
                               name="search"
                               value="<%= search %>"
                               placeholder="e.g., EMP001"
                               class="w-full px-4 py-2.5 bg-slate-900 border border-slate-600 rounded-lg text-slate-200 placeholder-slate-500 input-focus">
                    </div>

                    <div class="flex-1">
                        <label class="block text-sm font-medium text-slate-300 mb-2">
                            <i class="fas fa-filter mr-2"></i>Filter by Status
                        </label>
                        <select name="status"
                                class="w-full px-4 py-2.5 bg-slate-900 border border-slate-600 rounded-lg text-slate-200 input-focus">
                            <option value="All" <%= "All".equals(statusFilter) ? "selected" : "" %>>
                                <i class="fas fa-tasks"></i> All Requests
                            </option>
                            <option value="Pending" <%= "Pending".equals(statusFilter) ? "selected" : "" %>>
                                <i class="fas fa-hourglass-end"></i> Pending
                            </option>
                            <option value="Approved" <%= "Approved".equals(statusFilter) ? "selected" : "" %>>
                                <i class="fas fa-check-circle"></i> Approved
                            </option>
                            <option value="Rejected" <%= "Rejected".equals(statusFilter) ? "selected" : "" %>>
                                <i class="fas fa-times-circle"></i> Rejected
                            </option>
                        </select>
                    </div>

                    <button type="submit"
                            class="btn-primary px-6 py-2.5 text-white rounded-lg font-medium flex items-center gap-2">
                        <i class="fas fa-search"></i>
                        <span>Apply Filter</span>
                    </button>

                </form>
            </div>

            <!-- LEAVE REQUESTS TABLE -->
            <div class="bg-slate-800 border border-slate-700 rounded-2xl shadow-lg overflow-hidden">

                <% if (leaveList != null && !leaveList.isEmpty()) { %>

                <div class="overflow-x-auto">
                    <table class="w-full text-sm">
                        <thead class="bg-slate-900 border-b border-slate-700">
                        <tr>
                            <th class="px-6 py-4 text-left font-semibold text-slate-300">
                                <i class="fas fa-user mr-2"></i>Employee ID
                            </th>
                            <th class="px-6 py-4 text-left font-semibold text-slate-300">
                                <i class="fas fa-calendar-check mr-2"></i>Start Date
                            </th>
                            <th class="px-6 py-4 text-left font-semibold text-slate-300">
                                <i class="fas fa-calendar-times mr-2"></i>End Date
                            </th>
                            <th class="px-6 py-4 text-left font-semibold text-slate-300">
                                <i class="fas fa-comment mr-2"></i>Reason
                            </th>
                            <th class="px-6 py-4 text-left font-semibold text-slate-300">
                                <i class="fas fa-info-circle mr-2"></i>Status
                            </th>
                            <th class="px-6 py-4 text-center font-semibold text-slate-300">
                                <i class="fas fa-cogs mr-2"></i>Action
                            </th>
                        </tr>
                        </thead>

                        <tbody class="divide-y divide-slate-700">

                        <% for (Leave l : leaveList) { %>

                            <tr>
                                <td class="px-6 py-4 text-slate-200 font-medium"><%= l.getUserId() %></td>
                                <td class="px-6 py-4 text-slate-300">
                                    <span class="bg-slate-700 px-3 py-1 rounded-full text-xs">
                                        <%= l.getStartDate() %>
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-slate-300">
                                    <span class="bg-slate-700 px-3 py-1 rounded-full text-xs">
                                        <%= l.getEndDate() %>
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-slate-300"><%= l.getReason() %></td>
                                <td class="px-6 py-4">

                                    <%
                                        String status = l.getStatus();
                                        String badgeClass = "status-pending";
                                        String statusIcon = "fas fa-hourglass-end";

                                        if ("Approved".equalsIgnoreCase(status)) {
                                            badgeClass = "status-approved";
                                            statusIcon = "fas fa-check-circle";
                                        } else if ("Rejected".equalsIgnoreCase(status)) {
                                            badgeClass = "status-rejected";
                                            statusIcon = "fas fa-times-circle";
                                        }
                                    %>

                                    <span class="status-badge <%= badgeClass %>">
                                        <i class="<%= statusIcon %>"></i>
                                        <%= status %>
                                    </span>

                                </td>

                                <td class="px-6 py-4 text-center">

                                    <% if ("Pending".equalsIgnoreCase(status)) { %>

                                        <div class="flex justify-center items-center gap-2">

                                            <form action="<%= request.getContextPath() %>/ApproveLeaveServlet" method="GET" class="inline" style="margin: 0;">
                                                <input type="hidden" name="id" value="<%= l.getId() %>">
                                                <input type="hidden" name="action" value="Approved">
                                                <button type="submit"
                                                        class="action-btn px-3 py-1.5 text-xs font-semibold bg-emerald-600 hover:bg-emerald-700 text-white rounded-md transition-all flex items-center gap-1">
                                                    <i class="fas fa-check w-3"></i>
                                                    <span>Approve</span>
                                                </button>
                                            </form>

                                            <form action="<%= request.getContextPath() %>/ApproveLeaveServlet" method="GET" class="inline" style="margin: 0;">
                                                <input type="hidden" name="id" value="<%= l.getId() %>">
                                                <input type="hidden" name="action" value="Rejected">
                                                <button type="submit"
                                                        class="action-btn px-3 py-1.5 text-xs font-semibold bg-red-600 hover:bg-red-700 text-white rounded-md transition-all flex items-center gap-1">
                                                    <i class="fas fa-times w-3"></i>
                                                    <span>Reject</span>
                                                </button>
                                            </form>

                                        </div>

                                    <% } else { %>

                                        <span class="inline-flex items-center gap-1 px-3 py-1 bg-slate-700 text-slate-400 rounded-md text-xs font-medium">
                                            <i class="fas fa-check-double"></i>
                                            Completed
                                        </span>

                                    <% } %>

                                </td>
                            </tr>

                        <% } %>

                        </tbody>
                    </table>
                </div>

                <!-- PAGINATION -->
                <div class="px-6 py-5 bg-slate-900 border-t border-slate-700 flex justify-between items-center">

                    <div class="text-sm text-slate-400">
                        <span class="font-semibold text-slate-200">Page <%= pageNumber %> of <%= totalPages == 0 ? 1 : totalPages %></span>
                        <span class="mx-2">•</span>
                        <span><strong><%= totalRecords %></strong> total requests</span>
                    </div>

                    <div class="flex gap-3">

                        <% if (pageNumber > 1) { %>
                            <a href="?page=<%= pageNumber - 1 %>&search=<%= search %>&status=<%= statusFilter %>"
                               class="action-btn px-4 py-2 bg-slate-700 hover:bg-slate-600 rounded-lg text-sm font-medium transition-all flex items-center gap-2">
                                <i class="fas fa-arrow-left"></i>
                                <span>Previous</span>
                            </a>
                        <% } %>

                        <% if (pageNumber < totalPages) { %>
                            <a href="?page=<%= pageNumber + 1 %>&search=<%= search %>&status=<%= statusFilter %>"
                               class="action-btn btn-primary px-4 py-2 text-white rounded-lg text-sm font-medium flex items-center gap-2">
                                <span>Next</span>
                                <i class="fas fa-arrow-right"></i>
                            </a>
                        <% } %>

                    </div>

                </div>

                <% } else { %>

                    <div class="p-12 text-center">
                        <div class="flex justify-center mb-4">
                            <div class="icon-box bg-slate-700">
                                <i class="fas fa-inbox text-3xl text-slate-400"></i>
                            </div>
                        </div>
                        <p class="text-slate-400 text-lg font-medium">No leave requests found</p>
                        <p class="text-slate-500 text-sm mt-2">Try adjusting your search or filter criteria</p>
                    </div>

                <% } %>

            </div>

        </main>

    </div>

</div>

</body>
</html>
