<%@ page import="java.util.List" %>
<%@ page import="model.Leave" %>
<%@ page import="dao.LeaveDAO" %>

<%
    // 🔐 Session Validation (VERY IMPORTANT)
    if(session.getAttribute("user") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    List<Leave> leaveList = LeaveDAO.getAllLeaves();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard - Leave Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
</head>
<body style="font-family: 'Sora', sans-serif;" class="bg-gradient-to-br from-slate-950 via-slate-900 to-slate-950 min-h-screen relative overflow-auto">
    
    <!-- Animated background elements -->
    <div class="fixed inset-0 overflow-hidden pointer-events-none">
        <div class="absolute -top-96 right-1/4 w-96 h-96 bg-green-500/15 rounded-full blur-3xl animate-pulse"></div>
        <div class="absolute -bottom-96 left-0 w-96 h-96 bg-blue-500/15 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>
        <div class="absolute top-1/2 right-0 w-64 h-64 bg-cyan-500/10 rounded-full blur-2xl"></div>
    </div>

    <!-- Navigation bar -->
    <nav class="relative z-40 backdrop-blur-xl bg-white/5 border-b border-white/10 sticky top-0">
        <div class="max-w-7xl mx-auto px-6 py-4">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-4">
                    <div class="w-11 h-11 bg-gradient-to-br from-green-400 to-emerald-500 rounded-lg flex items-center justify-center">
                        <span class="text-white font-bold text-lg">M</span>
                    </div>
                    <div>
                        <h1 style="font-family: 'Playfair Display', serif;" class="text-2xl font-bold text-white">Manager Portal</h1>
                        <p class="text-gray-400 text-xs">Leave Management System</p>
                    </div>
                </div>
                <div class="flex items-center space-x-6">
                    <div class="text-right">
                        <p class="text-gray-300 text-sm font-semibold">John Manager</p>
                        <p class="text-gray-500 text-xs">HR Department</p>
                    </div>
                    <a href="LogoutServlet" class="px-4 py-2 bg-red-500/20 border border-red-500/50 text-red-400 rounded-lg hover:bg-red-500/30 hover:border-red-500 transition-all text-sm font-medium">
                        Logout
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main content -->
    <main class="relative z-20 max-w-7xl mx-auto px-6 py-12">
        
        <!-- Header section -->
        <div class="mb-8 animate-fadeIn">
            <h2 style="font-family: 'Playfair Display', serif;" class="text-5xl font-bold text-white mb-3">
                Leave Requests
            </h2>
            <p class="text-gray-400 text-lg">Review and approve employee leave applications</p>
        </div>

        <!-- Stats row -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
            <div class="group relative bg-white/10 backdrop-blur-xl rounded-xl p-4 border border-white/20 hover:border-white/40 transition-all">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-400 text-sm mb-1">Total Requests</p>
                        <p class="text-2xl font-bold text-white"><%= leaveList != null ? leaveList.size() : 0 %></p>
                    </div>
                    <div class="w-10 h-10 bg-gradient-to-br from-blue-400 to-blue-600 rounded-lg flex items-center justify-center opacity-20 group-hover:opacity-100 transition-opacity">
                        <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M3 1a1 1 0 000 2h1.22l.305 1.222a.997.997 0 00.01.042l1.358 5.43-.893.892C3.74 11.846 4.632 14 6.414 14H15a1 1 0 000-2H6.414l1-1H14a1 1 0 00.894-.553l3-6A1 1 0 0017 6H6.28l-.31-1.243A1 1 0 005 3H3z"></path>
                        </svg>
                    </div>
                </div>
            </div>

            <div class="group relative bg-white/10 backdrop-blur-xl rounded-xl p-4 border border-white/20 hover:border-white/40 transition-all">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-400 text-sm mb-1">Pending</p>
                        <p class="text-2xl font-bold text-yellow-400">
                            <%= leaveList != null ? leaveList.stream().filter(l -> "Pending".equalsIgnoreCase(l.getStatus())).count() : 0 %>
                        </p>
                    </div>
                    <div class="w-10 h-10 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-lg flex items-center justify-center opacity-20 group-hover:opacity-100 transition-opacity">
                        <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 102 0V6z" clip-rule="evenodd"></path>
                        </svg>
                    </div>
                </div>
            </div>

            <div class="group relative bg-white/10 backdrop-blur-xl rounded-xl p-4 border border-white/20 hover:border-white/40 transition-all">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-400 text-sm mb-1">Approved</p>
                        <p class="text-2xl font-bold text-green-400">
                            <%= leaveList != null ? leaveList.stream().filter(l -> "Approved".equalsIgnoreCase(l.getStatus())).count() : 0 %>
                        </p>
                    </div>
                    <div class="w-10 h-10 bg-gradient-to-br from-green-400 to-emerald-600 rounded-lg flex items-center justify-center opacity-20 group-hover:opacity-100 transition-opacity">
                        <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                        </svg>
                    </div>
                </div>
            </div>

            <div class="group relative bg-white/10 backdrop-blur-xl rounded-xl p-4 border border-white/20 hover:border-white/40 transition-all">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-400 text-sm mb-1">Rejected</p>
                        <p class="text-2xl font-bold text-red-400">
                            <%= leaveList != null ? leaveList.stream().filter(l -> "Rejected".equalsIgnoreCase(l.getStatus())).count() : 0 %>
                        </p>
                    </div>
                    <div class="w-10 h-10 bg-gradient-to-br from-red-400 to-red-600 rounded-lg flex items-center justify-center opacity-20 group-hover:opacity-100 transition-opacity">
                        <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
                        </svg>
                    </div>
                </div>
            </div>
        </div>

        <!-- Table container -->
        <div class="group relative">
            <div class="absolute inset-0 bg-gradient-to-r from-green-500 via-cyan-500 to-blue-500 rounded-2xl blur-2xl opacity-0 group-hover:opacity-20 transition-opacity duration-500"></div>
            
            <div class="relative bg-white/10 backdrop-blur-xl rounded-2xl border border-white/20 hover:border-white/40 transition-all duration-300 overflow-hidden">
                
                <!-- Table -->
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead>
                            <tr class="border-b border-white/10 bg-white/5">
                                <th class="px-6 py-4 text-left text-gray-300 font-semibold text-sm tracking-wider">Employee ID</th>
                                <th class="px-6 py-4 text-left text-gray-300 font-semibold text-sm tracking-wider">Start Date</th>
                                <th class="px-6 py-4 text-left text-gray-300 font-semibold text-sm tracking-wider">End Date</th>
                                <th class="px-6 py-4 text-left text-gray-300 font-semibold text-sm tracking-wider">Reason</th>
                                <th class="px-6 py-4 text-center text-gray-300 font-semibold text-sm tracking-wider">Status</th>
                                <th class="px-6 py-4 text-center text-gray-300 font-semibold text-sm tracking-wider">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (leaveList != null && !leaveList.isEmpty()) {
                                for (Leave l : leaveList) {
                            %>
                            <tr class="border-b border-white/5 hover:bg-white/5 transition-colors duration-200 group/row">
                                <td class="px-6 py-4 text-white font-medium"><%= l.getUserId() %></td>
                                <td class="px-6 py-4 text-gray-300"><%= l.getStartDate() %></td>
                                <td class="px-6 py-4 text-gray-300"><%= l.getEndDate() %></td>
                                <td class="px-6 py-4 text-gray-300 max-w-xs truncate"><%= l.getReason() %></td>
                                
                                <!-- Status badge -->
                                <td class="px-6 py-4 text-center">
                                    <% if ("Pending".equalsIgnoreCase(l.getStatus())) { %>
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-yellow-500/20 text-yellow-300 border border-yellow-500/30">
                                            <span class="w-2 h-2 bg-yellow-400 rounded-full mr-2 animate-pulse"></span>
                                            Pending Review
                                        </span>
                                    <% } else if ("Approved".equalsIgnoreCase(l.getStatus())) { %>
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-green-500/20 text-green-300 border border-green-500/30">
                                            <span class="w-2 h-2 bg-green-400 rounded-full mr-2"></span>
                                            Approved
                                        </span>
                                    <% } else { %>
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-red-500/20 text-red-300 border border-red-500/30">
                                            <span class="w-2 h-2 bg-red-400 rounded-full mr-2"></span>
                                            Rejected
                                        </span>
                                    <% } %>
                                </td>

                                <!-- Action buttons -->
                                <td class="px-6 py-4 text-center">
                                    <% if ("Pending".equalsIgnoreCase(l.getStatus())) { %>
                                        <div class="flex justify-center items-center gap-2 opacity-0 group-hover/row:opacity-100 transition-opacity duration-200">
                                            <a href="<%= request.getContextPath() %>/ApproveLeaveServlet?id=<%= l.getId() %>&action=Approved" 
                                               class="px-3 py-2 bg-green-500/20 border border-green-500/50 text-green-400 rounded-lg hover:bg-green-500/30 hover:border-green-500 transition-all text-xs font-semibold group/btn">
                                                <span class="group-hover/btn:scale-110 transition-transform inline-block">✓</span> Approve
                                            </a>
                                            <a href="<%= request.getContextPath() %>/ApproveLeaveServlet?id=<%= l.getId() %>&action=Rejected" 
                                               class="px-3 py-2 bg-red-500/20 border border-red-500/50 text-red-400 rounded-lg hover:bg-red-500/30 hover:border-red-500 transition-all text-xs font-semibold group/btn">
                                                <span class="group-hover/btn:scale-110 transition-transform inline-block">✕</span> Reject
                                            </a>
                                        </div>
                                        <% if ("Pending".equalsIgnoreCase(l.getStatus())) { %>
                                            <span class="text-gray-500 text-xs group-hover/row:hidden">Hover for actions</span>
                                        <% } %>
                                    <% } else { %>
                                        <span class="text-gray-500 text-xs">Completed</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% }
                            } else { %>
                            <tr>
                                <td colspan="6" class="px-6 py-12 text-center">
                                    <div class="flex flex-col items-center justify-center space-y-3">
                                        <svg class="w-12 h-12 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
                                        </svg>
                                        <p class="text-gray-400 text-lg font-medium">No leave requests found</p>
                                        <p class="text-gray-500 text-sm">All applications have been processed</p>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Table footer -->
                <div class="px-6 py-4 bg-white/5 border-t border-white/10 flex items-center justify-between text-sm text-gray-400">
                    <p>Showing <strong><%= leaveList != null ? leaveList.size() : 0 %></strong> leave requests</p>
                    <p>Last updated: <strong><%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(new java.util.Date()) %></strong></p>
                </div>

            </div>
        </div>

        <!-- Info banner -->
        <div class="mt-8 bg-white/5 backdrop-blur-xl rounded-xl p-6 border border-white/20">
            <div class="flex items-start space-x-4">
                <div class="w-10 h-10 bg-blue-500/20 rounded-lg flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-blue-400" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M18 5v8a2 2 0 01-2 2h-5l-5 4v-4H4a2 2 0 01-2-2V5a2 2 0 012-2h12a2 2 0 012 2zm-11-1a1 1 0 100 2h2a1 1 0 100-2H7zm0 4a1 1 0 100 2h6a1 1 0 100-2H7z" clip-rule="evenodd"></path>
                    </svg>
                </div>
                <div>
                    <h3 class="text-white font-semibold mb-1">Quick Tips</h3>
                    <p class="text-gray-400 text-sm">Hover over table rows to reveal action buttons. Approved and rejected requests are archived automatically. Ensure you review all pending requests within 24 hours.</p>
                </div>
            </div>
        </div>

    </main>

    <style>
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .animate-fadeIn {
            animation: fadeIn 0.8s ease-out forwards;
        }

        /* Smooth table interactions */
        tbody tr {
            transition: background-color 0.2s ease;
        }
    </style>

</body>
</html>
