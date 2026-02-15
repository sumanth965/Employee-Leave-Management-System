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
    <title>Manager Portal</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-slate-950 text-white">

<div class="flex h-screen overflow-hidden">

    <!-- SIDEBAR -->
    <aside class="w-64 bg-slate-900 border-r border-slate-700 flex flex-col">

        <div class="p-6 border-b border-slate-700">
            <h1 class="text-xl font-bold">Manager Portal</h1>
        </div>

        <nav class="flex-1 p-4 space-y-2">
            <a href="manager.jsp" class="block px-4 py-2 bg-emerald-500 rounded-lg font-semibold">Dashboard</a>
            <a href="register.jsp" class="block px-4 py-2 hover:bg-slate-800 rounded-lg">Add Employee</a>
        </nav>

        <div class="p-4 border-t border-slate-700">
            <div class="mb-3">
                <p class="font-semibold"><%= currentUser.getUsername() %></p>
                <p class="text-xs text-slate-400">Manager</p>
            </div>
            <a href="logout.jsp" class="block bg-red-600 text-center py-2 rounded-lg hover:bg-red-700">Logout</a>
        </div>

    </aside>

    <!-- MAIN CONTENT -->
    <div class="flex-1 flex flex-col overflow-hidden">

        <!-- HEADER -->
        <header class="bg-slate-900 border-b border-slate-700 px-8 py-6">
            <h1 class="text-2xl font-bold">Leave Management</h1>
        </header>

        <!-- CONTENT -->
        <main class="flex-1 overflow-y-auto p-8">

            <!-- KPI GRID -->
            <div class="grid md:grid-cols-3 gap-6 mb-8">

                <div class="bg-slate-800 p-6 rounded-lg">
                    <h3 class="text-slate-400 text-sm">Pending</h3>
                    <p class="text-3xl font-bold text-amber-400 mt-2"><%= pendingCount %></p>
                </div>

                <div class="bg-slate-800 p-6 rounded-lg">
                    <h3 class="text-slate-400 text-sm">Approved</h3>
                    <p class="text-3xl font-bold text-emerald-400 mt-2"><%= approvedCount %></p>
                </div>

                <div class="bg-slate-800 p-6 rounded-lg">
                    <h3 class="text-slate-400 text-sm">Rejected</h3>
                    <p class="text-3xl font-bold text-red-400 mt-2"><%= rejectedCount %></p>
                </div>

            </div>

            <!-- SEARCH + FILTER -->
            <form method="GET" class="mb-6 flex flex-col md:flex-row gap-4">

                <input type="text"
                       name="search"
                       value="<%= search %>"
                       placeholder="Search by Employee ID..."
                       class="px-4 py-2 bg-slate-800 border border-slate-600 rounded-lg w-full md:w-64">

                <select name="status"
                        class="px-4 py-2 bg-slate-800 border border-slate-600 rounded-lg">
                    <option value="All" <%= "All".equals(statusFilter) ? "selected" : "" %>>All</option>
                    <option value="Pending" <%= "Pending".equals(statusFilter) ? "selected" : "" %>>Pending</option>
                    <option value="Approved" <%= "Approved".equals(statusFilter) ? "selected" : "" %>>Approved</option>
                    <option value="Rejected" <%= "Rejected".equals(statusFilter) ? "selected" : "" %>>Rejected</option>
                </select>

                <button type="submit"
                        class="px-4 py-2 bg-emerald-500 hover:bg-emerald-600 rounded-lg">
                    Apply
                </button>

            </form>

            <!-- TABLE -->
            <div class="bg-slate-800 rounded-lg overflow-hidden">

                <% if (leaveList != null && !leaveList.isEmpty()) { %>

                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-slate-900">
                        <tr>
                            <th class="px-6 py-3 text-left">Employee ID</th>
                            <th class="px-6 py-3 text-left">Start</th>
                            <th class="px-6 py-3 text-left">End</th>
                            <th class="px-6 py-3 text-left">Reason</th>
                            <th class="px-6 py-3 text-left">Status</th>
                            <th class="px-6 py-3 text-center">Action</th>
                        </tr>
                        </thead>

                        <tbody class="divide-y divide-slate-700">

                        <% for (Leave l : leaveList) { %>

                            <tr class="hover:bg-slate-700">
                                <td class="px-6 py-4"><%= l.getUserId() %></td>
                                <td class="px-6 py-4"><%= l.getStartDate() %></td>
                                <td class="px-6 py-4"><%= l.getEndDate() %></td>
                                <td class="px-6 py-4"><%= l.getReason() %></td>
                                <td class="px-6 py-4">

                                    <%
                                        String status = l.getStatus();
                                        String badgeClass = "text-amber-400";
                                        if ("Approved".equalsIgnoreCase(status))
                                            badgeClass = "text-emerald-400";
                                        else if ("Rejected".equalsIgnoreCase(status))
                                            badgeClass = "text-red-400";
                                    %>

                                    <span class="<%= badgeClass %> font-semibold">
                                        <%= status %>
                                    </span>

                                </td>

                                <td class="px-6 py-4 text-center">

                          <% if ("Pending".equalsIgnoreCase(status)) { %>

    <div class="flex justify-center items-center gap-2">

        <form action="<%= request.getContextPath() %>/ApproveLeaveServlet" method="GET" class="inline">
            <input type="hidden" name="id" value="<%= l.getId() %>">
            <input type="hidden" name="action" value="Approved">
            <button type="submit"
                class="px-4 py-1.5 text-xs font-semibold bg-emerald-500 text-white rounded-md hover:bg-emerald-600 transition">
                Approve
            </button>
        </form>

        <form action="<%= request.getContextPath() %>/ApproveLeaveServlet" method="GET" class="inline">
            <input type="hidden" name="id" value="<%= l.getId() %>">
            <input type="hidden" name="action" value="Rejected">
            <button type="submit"
                class="px-4 py-1.5 text-xs font-semibold bg-red-600 text-white rounded-md hover:bg-red-700 transition">
                Reject
            </button>
        </form>

    </div>

<% }
 else { %>

                                    <span class="text-slate-400">Completed</span>

                                <% } %>

                                </td>
                            </tr>

                        <% } %>

                        </tbody>
                    </table>
                </div>

                <!-- PAGINATION -->
                <div class="px-6 py-4 bg-slate-900 flex justify-between items-center">

                    <p class="text-sm text-slate-400">
                        Page <%= pageNumber %> of <%= totalPages == 0 ? 1 : totalPages %>
                        | Total: <%= totalRecords %>
                    </p>

                    <div class="flex gap-3">

                        <% if (pageNumber > 1) { %>
                            <a href="?page=<%= pageNumber - 1 %>&search=<%= search %>&status=<%= statusFilter %>"
                               class="px-4 py-2 bg-slate-700 rounded">
                                ← Previous
                            </a>
                        <% } %>

                        <% if (pageNumber < totalPages) { %>
                            <a href="?page=<%= pageNumber + 1 %>&search=<%= search %>&status=<%= statusFilter %>"
                               class="px-4 py-2 bg-emerald-500 rounded">
                                Next →
                            </a>
                        <% } %>

                    </div>

                </div>

                <% } else { %>

                    <div class="p-10 text-center text-slate-400">
                        No leave requests found.
                    </div>

                <% } %>

            </div>

        </main>

    </div>

</div>

</body>
</html>
