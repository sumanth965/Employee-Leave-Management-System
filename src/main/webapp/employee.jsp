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
        body {
            font-family: 'Inter', sans-serif;
        }
        
        /* Circular Progress */
        .circular-progress {
            width: 100px;
            height: 100px;
            position: relative;
            display: inline-block;
        }
        
        .circular-progress svg {
            transform: rotate(-90deg);
        }
        
        .circular-progress .circle-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
        }
        
        /* Smooth transitions */
        .transition-all {
            transition: all 0.3s ease;
        }
        
        /* Icon styling */
        .icon-box {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        
        /* Status badge */
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
        }
        
        .status-pending {
            color: #f59e0b;
        }
    </style>
</head>

<body class="bg-slate-950 text-slate-200 font-[Inter] min-h-screen flex">

<!-- ================= SIDEBAR ================= -->
<aside class="w-64 bg-slate-900 border-r border-slate-800 flex flex-col fixed h-screen left-0 top-0">
    <!-- Logo Section -->
    <div class="px-6 py-6 border-b border-slate-800">
        <div class="flex items-center gap-2 mb-2">
            <i class="fas fa-rectangle text-slate-500 text-sm"></i>
            <h1 class="text-xs font-semibold tracking-widest text-slate-400 uppercase">Dashboard</h1>
        </div>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 px-4 py-6 space-y-1 text-sm">
        <a href="#" class="flex items-center gap-3 px-4 py-3 rounded-lg bg-slate-800 text-white font-medium transition-all">
            <i class="fas fa-chart-pie w-4"></i>
            <span>Dashboard</span>
        </a>
        <a href="applyLeave.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-slate-800 text-slate-300 transition-all">
            <i class="fas fa-plus-circle w-4"></i>
            <span>Apply for Leave</span>
        </a>
        <a href="#" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-slate-800 text-slate-300 transition-all">
            <i class="fas fa-file-alt w-4"></i>
            <span>My Leave Requests</span>
        </a>
        <a href="#" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-slate-800 text-slate-300 transition-all">
            <i class="fas fa-user w-4"></i>
            <span>Profile</span>
        </a>
    </nav>

    <!-- User Info -->
    <div class="px-6 py-4 border-t border-slate-800">
        <p class="text-sm font-semibold text-white">John Doe</p>
        <p class="text-xs text-slate-400 mb-4">Employee</p>
        <a href="LogoutServlet" class="flex items-center justify-center gap-2 w-full px-4 py-2 bg-red-600 rounded-lg text-sm font-medium hover:bg-red-700 transition-all">
            <i class="fas fa-power-off w-4"></i>
            <span>Logout</span>
        </a>
    </div>
</aside>

<!-- ================= MAIN CONTENT ================= -->
<div class="flex-1 ml-64 flex flex-col">

    <!-- TOP HEADER -->
    <header class="bg-slate-900 border-b border-slate-800 px-10 py-6 flex justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-white">Employee Leave Management</h1>
        </div>
        <div class="flex items-center gap-6">
            <!-- Notification Icon -->
            <button class="relative text-slate-400 hover:text-white transition-all">
                <i class="fas fa-bell text-xl"></i>
                <span class="absolute top-0 right-0 w-2 h-2 bg-red-500 rounded-full"></span>
            </button>
            
            <!-- User Profile Dropdown -->
            <div class="flex items-center gap-3 cursor-pointer hover:opacity-80 transition-all">
                <img src="https://ui-avatars.com/api/?name=John+Doe&background=0d8abc&color=fff" alt="Profile" class="w-10 h-10 rounded-full">
                <div>
                    <p class="text-sm font-medium text-white">John Doe</p>
                    <p class="text-xs text-slate-400">View profile</p>
                </div>
                <i class="fas fa-chevron-down text-slate-400 text-xs"></i>
            </div>
        </div>
    </header>

    <!-- PAGE CONTENT -->
    <main class="p-10 flex-1 space-y-8 overflow-y-auto">

        <!-- Page Title -->
        <div>
            <h2 class="text-3xl font-bold text-white mb-2">Dashboard Overview</h2>
            <p class="text-slate-400">Track your leave balances and activity</p>
        </div>

        <!-- KPI CARDS -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

            <!-- Leave Balance Card -->
            <div class="bg-slate-800 border border-slate-700 rounded-2xl p-8 shadow-lg hover:border-slate-600 transition-all">
                <p class="text-xs uppercase tracking-widest text-slate-400 font-semibold mb-6">Leave Balance</p>
                <div class="flex items-center gap-6">
                    <!-- Circular Progress -->
                    <div class="circular-progress">
                        <svg width="100" height="100" viewBox="0 0 100 100">
                            <!-- Background circle -->
                            <circle cx="50" cy="50" r="45" fill="none" stroke="#334155" stroke-width="8"></circle>
                            <!-- Progress circle (70% = 252 degrees) -->
                            <circle cx="50" cy="50" r="45" fill="none" stroke="#10b981" stroke-width="8" 
                                    stroke-dasharray="141.3 201.1" stroke-linecap="round"></circle>
                        </svg>
                        <div class="circle-text">
                            <div class="text-2xl font-bold text-emerald-400">12</div>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-4xl font-bold text-emerald-400">12</h3>
                        <p class="text-sm text-slate-400 mt-2">Days remaining</p>
                    </div>
                </div>
            </div>

            <!-- Pending Requests Card -->
            <div class="bg-slate-800 border border-slate-700 rounded-2xl p-8 shadow-lg hover:border-slate-600 transition-all">
                <p class="text-xs uppercase tracking-widest text-slate-400 font-semibold mb-6">Pending Requests</p>
                <h3 class="text-6xl font-bold text-amber-400 mb-2">2</h3>
                <p class="text-sm text-slate-400">Awaiting approval</p>
            </div>

            <!-- Approved Leaves Card -->
            <div class="bg-slate-800 border border-slate-700 rounded-2xl p-8 shadow-lg hover:border-slate-600 transition-all">
                <p class="text-xs uppercase tracking-widest text-slate-400 font-semibold mb-6">Approved Leaves</p>
                <h3 class="text-6xl font-bold text-cyan-400 mb-2">5</h3>
                <p class="text-sm text-slate-400">This year</p>
            </div>

        </div>

        <!-- ACTION CARDS -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

            <!-- Apply for Leave Card -->
            <div class="bg-slate-800 border border-slate-700 rounded-2xl p-8 hover:border-emerald-500 hover:shadow-lg transition-all group cursor-pointer">
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

            <!-- View Leave History Card -->
            <div class="bg-slate-800 border border-slate-700 rounded-2xl p-8 hover:border-cyan-500 hover:shadow-lg transition-all group cursor-pointer">
                <div class="flex items-start gap-4 mb-6">
                    <div class="icon-box bg-cyan-500 bg-opacity-20">
                        <i class="fas fa-history text-cyan-400"></i>
                    </div>
                    <div class="flex-1">
                        <h3 class="text-xl font-semibold text-white mb-2">View Leave History</h3>
                        <p class="text-slate-400 text-sm">Review your previous leave requests and statuses.</p>
                    </div>
                </div>
                <a href="#" class="inline-flex items-center gap-2 px-6 py-3 bg-cyan-600 hover:bg-cyan-700 text-white rounded-lg font-medium transition-all">
                    <span>View History</span>
                    <i class="fas fa-arrow-right text-sm"></i>
                </a>
            </div>

        </div>

        <!-- RECENT ACTIVITY TABLE -->
        <div class="bg-slate-800 border border-slate-700 rounded-2xl p-8 shadow-lg">
            <div class="flex justify-between items-center mb-6">
                <h3 class="text-lg font-semibold text-white">Recent Activity</h3>
                <a href="#" class="text-cyan-400 hover:text-cyan-300 font-medium text-sm flex items-center gap-1 transition-all">
                    <span>View All</span>
                    <i class="fas fa-arrow-right"></i>
                </a>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-sm">
                    <thead class="text-slate-400 border-b border-slate-700">
                        <tr>
                            <th class="text-left pb-4 font-semibold">Type</th>
                            <th class="text-left pb-4 font-semibold">Date</th>
                            <th class="text-left pb-4 font-semibold">Status</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-700">
                        <tr class="hover:bg-slate-700 transition-all">
                            <td class="py-4 text-slate-300">Leave Request</td>
                            <td class="py-4 text-slate-300">Dec 5 - Dec 8</td>
                            <td class="py-4">
                                <span class="status-badge status-approved">
                                    <i class="fas fa-check-circle"></i>
                                    Approved
                                </span>
                            </td>
                        </tr>
                        <tr class="hover:bg-slate-700 transition-all">
                            <td class="py-4 text-slate-300">Leave Request</td>
                            <td class="py-4 text-slate-300">Jan 12 - Jan 14</td>
                            <td class="py-4">
                                <span class="status-badge status-pending">
                                    <i class="fas fa-clock"></i>
                                    Pending
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

</body>
</html>