<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>

<body class="bg-slate-950 text-slate-200 font-[Inter] min-h-screen flex">

<!-- ================= SIDEBAR ================= -->
<aside class="w-64 bg-slate-900 border-r border-slate-800 flex flex-col">
    <div class="px-6 py-6 border-b border-slate-800">
        <h1 class="text-lg font-semibold tracking-wide text-white">Employee Portal</h1>
        <p class="text-xs text-slate-400 mt-1">Leave Management System</p>
    </div>

    <nav class="flex-1 px-4 py-6 space-y-2 text-sm">
        <a href="#" class="block px-4 py-2 rounded-lg bg-slate-800 text-white font-medium">Dashboard</a>
        <a href="applyLeave.jsp" class="block px-4 py-2 rounded-lg hover:bg-slate-800 transition">Apply Leave</a>
        <a href="#" class="block px-4 py-2 rounded-lg hover:bg-slate-800 transition">My Requests</a>
        <a href="#" class="block px-4 py-2 rounded-lg hover:bg-slate-800 transition">Profile</a>
    </nav>

    <div class="px-6 py-4 border-t border-slate-800">
        <p class="text-sm font-medium text-white">John Doe</p>
        <p class="text-xs text-slate-400 mb-4">Employee</p>
        <a href="LogoutServlet" class="block text-center px-4 py-2 bg-red-600 rounded-lg text-sm font-medium hover:bg-red-700 transition">
            Logout
        </a>
    </div>
</aside>

<!-- ================= MAIN CONTENT ================= -->
<div class="flex-1 flex flex-col">

    <!-- HEADER -->
    <header class="bg-slate-900 border-b border-slate-800 px-10 py-6 flex justify-between items-center">
        <div>
            <h2 class="text-2xl font-semibold text-white">Dashboard Overview</h2>
            <p class="text-sm text-slate-400 mt-1">Track your leave and activity status</p>
        </div>
    </header>

    <!-- CONTENT -->
    <main class="p-10 flex-1 space-y-10">

        <!-- KPI CARDS -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

            <div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-lg">
                <p class="text-xs uppercase tracking-wide text-slate-400 mb-3">Leave Balance</p>
                <h3 class="text-4xl font-bold text-emerald-400">12</h3>
                <p class="text-xs text-slate-500 mt-2">Days remaining</p>
            </div>

            <div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-lg">
                <p class="text-xs uppercase tracking-wide text-slate-400 mb-3">Pending Requests</p>
                <h3 class="text-4xl font-bold text-amber-400">2</h3>
                <p class="text-xs text-slate-500 mt-2">Awaiting approval</p>
            </div>

            <div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-lg">
                <p class="text-xs uppercase tracking-wide text-slate-400 mb-3">Approved Leaves</p>
                <h3 class="text-4xl font-bold text-cyan-400">5</h3>
                <p class="text-xs text-slate-500 mt-2">This year</p>
            </div>

        </div>

        <!-- ACTION SECTION -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

            <a href="applyLeave.jsp" class="bg-slate-900 border border-slate-800 rounded-2xl p-8 hover:border-emerald-500 transition group shadow-lg">
                <h3 class="text-xl font-semibold text-white mb-2">Apply for Leave</h3>
                <p class="text-slate-400 mb-6 text-sm">Submit a new leave request quickly and efficiently.</p>
                <span class="text-sm text-emerald-400 font-medium group-hover:translate-x-2 inline-block transition-transform">
                    Request Leave →
                </span>
            </a>

            <a href="#" class="bg-slate-900 border border-slate-800 rounded-2xl p-8 hover:border-slate-600 transition shadow-lg">
                <h3 class="text-xl font-semibold text-white mb-2">View Leave History</h3>
                <p class="text-slate-400 mb-6 text-sm">Review your previous leave requests and statuses.</p>
                <span class="text-sm text-cyan-400 font-medium">
                    View History →
                </span>
            </a>

        </div>

        <!-- RECENT ACTIVITY TABLE -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-8 shadow-lg">
            <h3 class="text-lg font-semibold text-white mb-6">Recent Activity</h3>

            <div class="overflow-x-auto">
                <table class="w-full text-sm text-left">
                    <thead class="text-slate-400 border-b border-slate-800">
                        <tr>
                            <th class="pb-3">Type</th>
                            <th class="pb-3">Date</th>
                            <th class="pb-3">Status</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800">
                        <tr>
                            <td class="py-4">Leave Request</td>
                            <td class="py-4">Dec 5 - Dec 8</td>
                            <td class="py-4 text-emerald-400 font-medium">Approved</td>
                        </tr>
                        <tr>
                            <td class="py-4">Leave Request</td>
                            <td class="py-4">Jan 12 - Jan 14</td>
                            <td class="py-4 text-amber-400 font-medium">Pending</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

</body>
</html>