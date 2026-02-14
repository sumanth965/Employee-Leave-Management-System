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
    List<Leave> leaveList = LeaveDAO.getLeavesPaginated(pageNumber, limit);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Portal - Leave Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        slate: {
                            950: '#0f172a',
                            900: '#0f1729',
                            850: '#172033',
                            800: '#1e293b',
                            700: '#334155',
                        },
                        emerald: {
                            500: '#10b981',
                            600: '#059669',
                        }
                    },
                    fontFamily: {
                        sans: ['Segoe UI', 'system-ui', '-apple-system', 'sans-serif'],
                    },
                    animation: {
                        'slide-in-left': 'slideInLeft 0.5s ease-out',
                        'slide-down': 'slideDown 0.6s ease-out',
                        'fade-in-up': 'fadeInUp 0.7s ease-out',
                    },
                    keyframes: {
                        slideInLeft: {
                            '0%': { transform: 'translateX(-100%)', opacity: '0' },
                            '100%': { transform: 'translateX(0)', opacity: '1' },
                        },
                        slideDown: {
                            '0%': { transform: 'translateY(-20px)', opacity: '0' },
                            '100%': { transform: 'translateY(0)', opacity: '1' },
                        },
                        fadeInUp: {
                            '0%': { transform: 'translateY(20px)', opacity: '0' },
                            '100%': { transform: 'translateY(0)', opacity: '1' },
                        },
                    },
                }
            }
        }
    </script>
    <style>
        [x-cloak] { display: none; }
        body { overflow: hidden; }
    </style>
</head>
<body class="bg-slate-950 text-slate-100">
    <div class="flex h-screen overflow-hidden">
        <!-- SIDEBAR -->
        <aside class="w-64 bg-gradient-to-b from-slate-900 via-slate-900 to-slate-800 border-r border-slate-700 flex flex-col shadow-2xl animate-slide-in-left">
            <!-- Logo -->
            <div class="p-6 border-b border-slate-700">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-gradient-to-br from-emerald-500 to-emerald-600 rounded-lg flex items-center justify-center">
                        <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" />
                        </svg>
                    </div>
                    <div>
                        <h1 class="text-xl font-bold text-white">Manager</h1>
                        <p class="text-xs text-slate-400">Portal</p>
                    </div>
                </div>
            </div>

            <!-- Navigation Menu -->
            <nav class="flex-1 px-4 py-6 space-y-2 overflow-y-auto">
                <a href="dashboard.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg bg-gradient-to-r from-emerald-500 to-emerald-600 text-white font-semibold transition-all duration-300 hover:shadow-lg hover:shadow-emerald-500/20 group">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                    </svg>
                    <span>Dashboard</span>
                </a>

                <a href="register.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800 font-medium transition-all duration-300 group">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    <span>Add Employee</span>
                </a>

                <a href="leave-management.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800 font-medium transition-all duration-300 group">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                    <span>Leave Management</span>
                </a>
            </nav>

            <!-- User Section -->
            <div class="p-4 border-t border-slate-700 space-y-4">
                <div class="flex items-center gap-3 p-3 bg-slate-800/50 rounded-lg">
                    <div class="w-10 h-10 rounded-full bg-gradient-to-br from-emerald-500 to-emerald-600 flex items-center justify-center font-bold text-white">
                        <%= currentUser.getUsername().charAt(0) %>
                    </div>
                    <div class="flex-1 min-w-0">
                        <p class="text-sm font-semibold text-white truncate"><%= currentUser.getUsername() %></p>
                        <p class="text-xs text-slate-400">Manager</p>
                    </div>
                </div>

                <button onclick="logout()" class="w-full px-4 py-2 bg-red-600 hover:bg-red-700 text-white font-semibold rounded-lg transition-all duration-300 hover:shadow-lg active:scale-95">
                    <span class="flex items-center justify-center gap-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                        </svg>
                        Logout
                    </span>
                </button>
            </div>
        </aside>

        <!-- MAIN CONTENT -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <!-- HEADER -->
            <header class="bg-gradient-to-r from-slate-900 via-slate-900 to-slate-800 border-b border-slate-700 px-8 py-6 shadow-lg animate-slide-down">
                <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                    <div>
                        <h1 class="text-3xl font-bold text-white">Leave Management</h1>
                        <p class="text-slate-400 text-sm mt-1">Review and manage leave requests from your team members</p>
                    </div>
                </div>
            </header>

            <!-- SCROLLABLE CONTENT -->
            <main class="flex-1 overflow-y-auto bg-slate-950 px-8 py-8 animate-fade-in-up">
                <div class="max-w-7xl mx-auto">
                    <!-- STATS GRID -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        <!-- Pending Card -->
                        <div class="bg-gradient-to-br from-slate-800 to-slate-900 border border-slate-700 rounded-xl p-6 hover:border-slate-600 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="text-slate-400 text-sm font-semibold uppercase tracking-wider">Pending Requests</h3>
                                <div class="w-12 h-12 bg-amber-500/20 rounded-lg flex items-center justify-center">
                                    <svg class="w-6 h-6 text-amber-500" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v2a1 1 0 001 1h1v2H3a1 1 0 00-1 1v2a2 2 0 002 2h1v1a1 1 0 102 0v-1h8v1a1 1 0 102 0v-1h1a2 2 0 002-2v-2a1 1 0 00-1-1h-1v-2h1a1 1 0 001-1V6a2 2 0 00-2-2h-1V3a1 1 0 00-1-1H6zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                            </div>
                            <p class="text-4xl font-bold text-white mb-2">5</p>
                            <p class="text-xs text-emerald-400 font-semibold">↑ 2 new this week</p>
                        </div>

                        <!-- Approved Card -->
                        <div class="bg-gradient-to-br from-slate-800 to-slate-900 border border-slate-700 rounded-xl p-6 hover:border-slate-600 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="text-slate-400 text-sm font-semibold uppercase tracking-wider">Approved</h3>
                                <div class="w-12 h-12 bg-emerald-500/20 rounded-lg flex items-center justify-center">
                                    <svg class="w-6 h-6 text-emerald-500" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                            </div>
                            <p class="text-4xl font-bold text-white mb-2">24</p>
                            <p class="text-xs text-slate-400 font-semibold">This month</p>
                        </div>

                        <!-- Rejected Card -->
                        <div class="bg-gradient-to-br from-slate-800 to-slate-900 border border-slate-700 rounded-xl p-6 hover:border-slate-600 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="text-slate-400 text-sm font-semibold uppercase tracking-wider">Rejected</h3>
                                <div class="w-12 h-12 bg-red-500/20 rounded-lg flex items-center justify-center">
                                    <svg class="w-6 h-6 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                            </div>
                            <p class="text-4xl font-bold text-white mb-2">2</p>
                            <p class="text-xs text-slate-400 font-semibold">This month</p>
                        </div>
                    </div>

                    <!-- TABLE SECTION -->
                    <div class="mb-8">
                        <div class="flex items-center gap-3 mb-6">
                            <div class="w-1 h-6 bg-gradient-to-b from-emerald-500 to-emerald-600 rounded-full"></div>
                            <h2 class="text-2xl font-bold text-white">Recent Leave Requests</h2>
                        </div>

                        <!-- TABLE CONTAINER -->
                        <div class="bg-gradient-to-br from-slate-800 to-slate-900 border border-slate-700 rounded-xl shadow-xl overflow-hidden">
                            <% if (leaveList != null && !leaveList.isEmpty()) { %>
                                <div class="overflow-x-auto">
                                    <table class="w-full">
                                        <thead>
                                            <tr class="bg-gradient-to-r from-slate-900 via-slate-800 to-slate-900 border-b-2 border-emerald-500">
                                                <th class="px-6 py-4 text-left text-xs font-bold text-emerald-400 uppercase tracking-wider">Employee ID</th>
                                                <th class="px-6 py-4 text-left text-xs font-bold text-emerald-400 uppercase tracking-wider">Start Date</th>
                                                <th class="px-6 py-4 text-left text-xs font-bold text-emerald-400 uppercase tracking-wider">End Date</th>
                                                <th class="px-6 py-4 text-left text-xs font-bold text-emerald-400 uppercase tracking-wider">Reason</th>
                                                <th class="px-6 py-4 text-left text-xs font-bold text-emerald-400 uppercase tracking-wider">Status</th>
                                                <th class="px-6 py-4 text-center text-xs font-bold text-emerald-400 uppercase tracking-wider">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-slate-700">
                                            <% for (Leave l : leaveList) { %>
                                                <tr class="hover:bg-slate-700/50 transition-colors duration-200 border-l-4 border-transparent hover:border-emerald-500">
                                                    <td class="px-6 py-4">
                                                        <span class="text-sm font-semibold text-white"><%= l.getUserId() %></span>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <span class="text-sm text-slate-300"><%= l.getStartDate() %></span>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <span class="text-sm text-slate-300"><%= l.getEndDate() %></span>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <span class="text-sm text-slate-300"><%= l.getReason() %></span>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <% String status = l.getStatus();
                                                           String badgeClass = "bg-amber-500/20 text-amber-400";
                                                           if ("Approved".equalsIgnoreCase(status)) {
                                                               badgeClass = "bg-emerald-500/20 text-emerald-400";
                                                           } else if ("Rejected".equalsIgnoreCase(status)) {
                                                               badgeClass = "bg-red-500/20 text-red-400";
                                                           }
                                                        %>
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold <%= badgeClass %>">
                                                            <%= status %>
                                                        </span>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <% if ("Pending".equalsIgnoreCase(l.getStatus())) { %>
                                                            <div class="flex items-center justify-center gap-2">
                                                                <form action="approve-leave.jsp" method="POST" class="inline">
                                                                    <input type="hidden" name="leaveId" value="<%= l.getId() %>">
                                                                    <button type="submit" class="px-3 py-2 bg-emerald-500 hover:bg-emerald-600 text-white text-xs font-bold rounded-lg transition-all duration-200 active:scale-95">
                                                                        Approve
                                                                    </button>
                                                                </form>
                                                                <form action="reject-leave.jsp" method="POST" class="inline">
                                                                    <input type="hidden" name="leaveId" value="<%= l.getId() %>">
                                                                    <button type="submit" class="px-3 py-2 bg-red-600 hover:bg-red-700 text-white text-xs font-bold rounded-lg transition-all duration-200 active:scale-95">
                                                                        Reject
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        <% } else { %>
                                                            <div class="flex items-center justify-center">
                                                                <span class="inline-flex items-center px-2 py-1 bg-slate-700/50 text-slate-400 text-xs font-semibold rounded">
                                                                    <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                                        <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                                                                    </svg>
                                                                    Completed
                                                                </span>
                                                            </div>
                                                        <% } %>
                                                    </td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- PAGINATION -->
                                <div class="bg-slate-900/50 px-6 py-4 border-t border-slate-700 flex flex-col sm:flex-row items-center justify-between gap-4">
                                    <p class="text-sm text-slate-400 font-semibold">
                                        Page <span class="text-emerald-400"><%= pageNumber %></span> | Showing <%= leaveList.size() %> requests
                                    </p>
                                    <div class="flex gap-3">
                                        <% if (pageNumber > 1) { %>
                                            <a href="?page=<%= pageNumber - 1 %>" class="px-4 py-2 bg-slate-700 hover:bg-slate-600 text-slate-200 font-semibold text-sm rounded-lg transition-all duration-200 active:scale-95">
                                                ← Previous
                                            </a>
                                        <% } %>
                                        <a href="?page=<%= pageNumber + 1 %>" class="px-4 py-2 bg-emerald-500 hover:bg-emerald-600 text-white font-semibold text-sm rounded-lg transition-all duration-200 active:scale-95">
                                            Next →
                                        </a>
                                    </div>
                                </div>

                            <% } else { %>
                                <!-- EMPTY STATE -->
                                <div class="py-16 px-6 text-center">
                                    <div class="mb-4 flex justify-center">
                                        <div class="w-20 h-20 bg-slate-700/50 rounded-full flex items-center justify-center">
                                            <svg class="w-10 h-10 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                                            </svg>
                                        </div>
                                    </div>
                                    <h3 class="text-xl font-bold text-white mb-2">No Leave Requests</h3>
                                    <p class="text-slate-400 text-sm">All leave requests have been processed. Check back later for new submissions.</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = 'logout.jsp';
            }
        }

        // Smooth page transitions
        document.addEventListener('DOMContentLoaded', function() {
            // Stagger animation for table rows
            const rows = document.querySelectorAll('tbody tr');
            rows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.animation = `fadeInUp 0.5s ease-out forwards`;
                row.style.animationDelay = (index * 50) + 'ms';
            });
        });

        // Add keyboard shortcut for logout (Ctrl+Q)
        document.addEventListener('keydown', function(event) {
            if (event.ctrlKey && event.key === 'q') {
                event.preventDefault();
                logout();
            }
        });
    </script>
</body>
</html>
