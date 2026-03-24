<%@ page import="java.util.List" %>
<%@ page import="model.Leave" %>
<%@ page import="model.User" %>
<%@ page import="dao.LeaveDAO" %>

<%
    // Session and role guard for coherent navigation flow.
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"employee".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("manager.jsp");
        return;
    }

    List<Leave> myLeaves = LeaveDAO.getLeavesByUser(currentUser.getId());

    int pendingCount = 0;
    int approvedCount = 0;
    for (Leave leave : myLeaves) {
        if ("Pending".equalsIgnoreCase(leave.getStatus())) {
            pendingCount++;
        } else if ("Approved".equalsIgnoreCase(leave.getStatus())) {
            approvedCount++;
        }
    }

    // Default yearly allocation for dashboard visual.
    int totalAllocation = 20;
    int usedDays = approvedCount;
    int remainingDays = Math.max(totalAllocation - usedDays, 0);
    int progress = (int) Math.round((remainingDays * 100.0) / totalAllocation);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'Inter', sans-serif; }
        .transition-all { transition: all 0.3s ease; }
        .icon-box {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 14px;
        }
        .status-approved {
            color: #10b981;
            background-color: rgba(16, 185, 129, 0.1);
        }
        .status-pending {
            color: #f59e0b;
            background-color: rgba(245, 158, 11, 0.1);
        }
        .status-rejected {
            color: #ef4444;
            background-color: rgba(239, 68, 68, 0.1);
        }
    </style>
</head>

<body class="bg-slate-950 text-slate-200 font-[Inter] min-h-screen">

<!-- Mobile toggle button -->
<button id="toggleBtn" class="lg:hidden fixed top-4 left-4 z-[70] bg-slate-800 text-white p-3 rounded-lg border border-slate-700" aria-label="Toggle sidebar">
    <i class="fas fa-bars"></i>
</button>

<div class="flex min-h-screen">
    <!-- Sidebar -->
    <aside id="sidebar" class="w-64 bg-slate-900 border-r border-slate-800 flex flex-col fixed h-screen left-0 top-0 z-50 transform -translate-x-full lg:translate-x-0 transition-all">
        <div class="px-6 py-6 border-b border-slate-800">
            <div class="flex items-center gap-2 mb-2">
                <i class="fas fa-rectangle text-slate-500 text-sm"></i>
                <h1 class="text-xs font-semibold tracking-widest text-slate-400 uppercase">Dashboard</h1>
            </div>
        </div>

        <nav class="flex-1 px-4 py-6 space-y-1 text-sm">
            <a href="employee.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg bg-slate-800 text-white font-medium transition-all">
                <i class="fas fa-chart-pie w-4"></i>
                <span>Dashboard</span>
            </a>
            <a href="applyLeave.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-slate-800 text-slate-300 transition-all">
                <i class="fas fa-plus-circle w-4"></i>
                <span>Apply for Leave</span>
            </a>
            <a href="#history" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-slate-800 text-slate-300 transition-all nav-link">
                <i class="fas fa-file-alt w-4"></i>
                <span>My Leave Requests</span>
            </a>
            <a href="#profile" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-slate-800 text-slate-300 transition-all nav-link">
                <i class="fas fa-user w-4"></i>
                <span>Profile</span>
            </a>
        </nav>

        <div class="px-6 py-4 border-t border-slate-800" id="profile">
            <p class="text-sm font-semibold text-white"><%= currentUser.getUsername() %></p>
            <p class="text-xs text-slate-400 mb-4">Employee</p>
            <a href="logout.jsp" class="flex items-center justify-center gap-2 w-full px-4 py-2 bg-red-600 rounded-lg text-sm font-medium hover:bg-red-700 transition-all">
                <i class="fas fa-power-off w-4"></i>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <!-- Main -->
    <div class="flex-1 lg:ml-64 flex flex-col w-full">
        <header class="bg-slate-900 border-b border-slate-800 px-6 lg:px-10 py-6 flex justify-between items-center">
            <div class="pl-12 lg:pl-0">
                <h1 class="text-2xl font-bold text-white">Employee Leave Management</h1>
            </div>
            <div class="flex items-center gap-3">
                <img src="https://ui-avatars.com/api/?name=<%= currentUser.getUsername() %>&background=0d8abc&color=fff" alt="Profile" class="w-10 h-10 rounded-full">
                <div>
                    <p class="text-sm font-medium text-white"><%= currentUser.getUsername() %></p>
                    <p class="text-xs text-slate-400">Employee</p>
                </div>
            </div>
        </header>

        <main class="p-6 lg:p-10 flex-1 space-y-8 overflow-y-auto">
            <div>
                <h2 class="text-3xl font-bold text-white mb-2">Dashboard Overview</h2>
                <p class="text-slate-400">Track your leave balances and activity</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="bg-slate-800 border border-slate-700 rounded-2xl p-8 shadow-lg hover:border-slate-600 transition-all">
                    <p class="text-xs uppercase tracking-widest text-slate-400 font-semibold mb-6">Leave Balance</p>
                    <h3 class="text-5xl font-bold text-emerald-400 mb-2"><%= remainingDays %></h3>
                    <p class="text-sm text-slate-400"><%= progress %>% of annual balance available</p>
                </div>

                <div class="bg-slate-800 border border-slate-700 rounded-2xl p-8 shadow-lg hover:border-slate-600 transition-all">
                    <p class="text-xs uppercase tracking-widest text-slate-400 font-semibold mb-6">Pending Requests</p>
                    <h3 class="text-6xl font-bold text-amber-400 mb-2"><%= pendingCount %></h3>
                    <p class="text-sm text-slate-400">Awaiting approval</p>
                </div>

                <div class="bg-slate-800 border border-slate-700 rounded-2xl p-8 shadow-lg hover:border-slate-600 transition-all">
                    <p class="text-xs uppercase tracking-widest text-slate-400 font-semibold mb-6">Approved Leaves</p>
                    <h3 class="text-6xl font-bold text-cyan-400 mb-2"><%= approvedCount %></h3>
                    <p class="text-sm text-slate-400">All time approved requests</p>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="bg-slate-800 border border-slate-700 rounded-2xl p-8 hover:border-emerald-500 hover:shadow-lg transition-all">
                    <div class="flex items-start gap-4 mb-6">
                        <div class="icon-box bg-blue-500 bg-opacity-20">
                            <i class="fas fa-paper-plane text-blue-400"></i>
                        </div>
                        <div class="flex-1">
                            <h3 class="text-xl font-semibold text-white mb-2">Apply for Leave</h3>
                            <p class="text-slate-400 text-sm">Submit a new leave request quickly and efficiently.</p>
                        </div>
                    </div>
                    <a href="applyLeave.jsp" class="inline-flex items-center gap-2 px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-medium transition-all">
                        <span>Request Leave</span>
                        <i class="fas fa-arrow-right text-sm"></i>
                    </a>
                </div>

                <div class="bg-slate-800 border border-slate-700 rounded-2xl p-8 hover:border-cyan-500 hover:shadow-lg transition-all">
                    <div class="flex items-start gap-4 mb-6">
                        <div class="icon-box bg-cyan-500 bg-opacity-20">
                            <i class="fas fa-history text-cyan-400"></i>
                        </div>
                        <div class="flex-1">
                            <h3 class="text-xl font-semibold text-white mb-2">View Leave History</h3>
                            <p class="text-slate-400 text-sm">Review your previous leave requests and statuses.</p>
                        </div>
                    </div>
                    <a href="#history" class="inline-flex items-center gap-2 px-6 py-3 bg-cyan-600 hover:bg-cyan-700 text-white rounded-lg font-medium transition-all nav-link">
                        <span>View History</span>
                        <i class="fas fa-arrow-right text-sm"></i>
                    </a>
                </div>
            </div>

            <div id="history" class="bg-slate-800 border border-slate-700 rounded-2xl p-8 shadow-lg scroll-mt-24">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-lg font-semibold text-white">Recent Activity</h3>
                    <span class="text-sm text-slate-400"><%= myLeaves.size() %> request(s)</span>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full text-sm">
                        <thead class="text-slate-400 border-b border-slate-700">
                            <tr>
                                <th class="text-left pb-4 font-semibold">Period</th>
                                <th class="text-left pb-4 font-semibold">Reason</th>
                                <th class="text-left pb-4 font-semibold">Status</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-700">
                            <%
                                if (myLeaves.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="3" class="py-6 text-slate-400 text-center">No leave requests yet.</td>
                            </tr>
                            <%
                                } else {
                                    for (Leave leave : myLeaves) {
                                        String status = leave.getStatus() == null ? "Pending" : leave.getStatus();
                                        String statusClass = "status-pending";
                                        String statusIcon = "fa-clock";

                                        if ("Approved".equalsIgnoreCase(status)) {
                                            statusClass = "status-approved";
                                            statusIcon = "fa-check-circle";
                                        } else if ("Rejected".equalsIgnoreCase(status)) {
                                            statusClass = "status-rejected";
                                            statusIcon = "fa-times-circle";
                                        }
                            %>
                            <tr class="hover:bg-slate-700 transition-all">
                                <td class="py-4 text-slate-300"><%= leave.getStartDate() %> to <%= leave.getEndDate() %></td>
                                <td class="py-4 text-slate-300"><%= leave.getReason() %></td>
                                <td class="py-4">
                                    <span class="status-badge <%= statusClass %>">
                                        <i class="fas <%= statusIcon %>"></i>
                                        <%= status %>
                                    </span>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    const toggleBtn = document.getElementById('toggleBtn');
    const sidebar = document.getElementById('sidebar');
    const navLinks = document.querySelectorAll('.nav-link');

    toggleBtn.addEventListener('click', function () {
        sidebar.classList.toggle('-translate-x-full');
    });

    navLinks.forEach(function (link) {
        link.addEventListener('click', function () {
            if (window.innerWidth < 1024) {
                sidebar.classList.add('-translate-x-full');
            }
        });
    });
</script>

</body>
</html>
