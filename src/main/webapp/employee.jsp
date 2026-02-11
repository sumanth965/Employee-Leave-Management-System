<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
</head>
<body style="font-family: 'Sora', sans-serif;" class="bg-gradient-to-br from-slate-950 via-blue-900 to-slate-950 min-h-screen relative overflow-auto">
    
    <!-- Animated background elements -->
    <div class="fixed inset-0 overflow-hidden pointer-events-none">
        <div class="absolute -top-96 right-0 w-96 h-96 bg-blue-500/20 rounded-full blur-3xl animate-pulse"></div>
        <div class="absolute -bottom-96 left-1/3 w-96 h-96 bg-purple-500/20 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>
        <div class="absolute top-1/2 -right-32 w-64 h-64 bg-cyan-500/10 rounded-full blur-2xl"></div>
    </div>

    <!-- Navigation bar -->
    <nav class="relative z-40 backdrop-blur-xl bg-white/5 border-b border-white/10 sticky top-0">
        <div class="max-w-7xl mx-auto px-6 py-4">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 bg-gradient-to-br from-blue-400 to-cyan-500 rounded-lg flex items-center justify-center">
                        <span class="text-white font-bold text-lg">E</span>
                    </div>
                    <h1 style="font-family: 'Playfair Display', serif;" class="text-2xl font-bold text-white">Employee Portal</h1>
                </div>
                <div class="text-gray-300 text-sm">Welcome, <span class="text-cyan-400 font-semibold">John Doe</span></div>
            </div>
        </div>
    </nav>

    <!-- Main content -->
    <main class="relative z-20 max-w-7xl mx-auto px-6 py-12">
        
        <!-- Header section -->
        <div class="mb-12 animate-fadeIn">
            <h2 style="font-family: 'Playfair Display', serif;" class="text-5xl font-bold text-white mb-3">
                Dashboard
            </h2>
            <p class="text-gray-400 text-lg">Manage your work, leave requests, and profile</p>
        </div>

        <!-- Stats grid -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
            <!-- Stat card 1 -->
            <div class="group relative">
                <div class="absolute inset-0 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-2xl blur opacity-0 group-hover:opacity-30 transition-opacity duration-300"></div>
                <div class="relative bg-white/10 backdrop-blur-xl rounded-2xl p-6 border border-white/20 hover:border-white/40 transition-all duration-300">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-gray-400 text-sm font-medium mb-2">Leave Balance</p>
                            <h3 class="text-3xl font-bold text-white">12</h3>
                            <p class="text-gray-500 text-xs mt-2">Days remaining</p>
                        </div>
                        <div class="w-12 h-12 bg-gradient-to-br from-blue-400 to-cyan-500 rounded-lg flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h18M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Stat card 2 -->
            <div class="group relative">
                <div class="absolute inset-0 bg-gradient-to-r from-purple-500 to-pink-500 rounded-2xl blur opacity-0 group-hover:opacity-30 transition-opacity duration-300"></div>
                <div class="relative bg-white/10 backdrop-blur-xl rounded-2xl p-6 border border-white/20 hover:border-white/40 transition-all duration-300">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-gray-400 text-sm font-medium mb-2">Pending Tasks</p>
                            <h3 class="text-3xl font-bold text-white">5</h3>
                            <p class="text-gray-500 text-xs mt-2">This week</p>
                        </div>
                        <div class="w-12 h-12 bg-gradient-to-br from-purple-400 to-pink-500 rounded-lg flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Stat card 3 -->
            <div class="group relative">
                <div class="absolute inset-0 bg-gradient-to-r from-green-500 to-emerald-500 rounded-2xl blur opacity-0 group-hover:opacity-30 transition-opacity duration-300"></div>
                <div class="relative bg-white/10 backdrop-blur-xl rounded-2xl p-6 border border-white/20 hover:border-white/40 transition-all duration-300">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-gray-400 text-sm font-medium mb-2">Work Hours</p>
                            <h3 class="text-3xl font-bold text-white">38.5</h3>
                            <p class="text-gray-500 text-xs mt-2">This week</p>
                        </div>
                        <div class="w-12 h-12 bg-gradient-to-br from-green-400 to-emerald-500 rounded-lg flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Action cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Apply Leave Card -->
            <a href="applyLeave.jsp" class="group relative block">
                <div class="absolute inset-0 bg-gradient-to-br from-amber-500 to-orange-500 rounded-2xl blur opacity-0 group-hover:opacity-40 transition-opacity duration-300"></div>
                <div class="relative bg-white/10 backdrop-blur-xl rounded-2xl p-8 border border-white/20 hover:border-white/40 transition-all duration-300 transform hover:scale-105">
                    <div class="flex items-start justify-between mb-4">
                        <div class="w-16 h-16 bg-gradient-to-br from-amber-400 to-orange-500 rounded-xl flex items-center justify-center">
                            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8m0 8l-6-2m6 2l6-2"></path>
                            </svg>
                        </div>
                        <div class="w-2 h-2 bg-amber-400 rounded-full group-hover:scale-150 transition-transform"></div>
                    </div>
                    <h3 class="text-2xl font-bold text-white mb-2">Apply for Leave</h3>
                    <p class="text-gray-400 mb-6">Submit your leave request and manage your days off</p>
                    <div class="flex items-center text-amber-400 font-semibold group-hover:translate-x-2 transition-transform">
                        Request leave
                        <svg class="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </div>
                </div>
            </a>

            <!-- Logout Card -->
            <a href="logout.jsp" class="group relative block">
                <div class="absolute inset-0 bg-gradient-to-br from-red-500 to-rose-500 rounded-2xl blur opacity-0 group-hover:opacity-40 transition-opacity duration-300"></div>
                <div class="relative bg-white/10 backdrop-blur-xl rounded-2xl p-8 border border-white/20 hover:border-white/40 transition-all duration-300 transform hover:scale-105">
                    <div class="flex items-start justify-between mb-4">
                        <div class="w-16 h-16 bg-gradient-to-br from-red-400 to-rose-500 rounded-xl flex items-center justify-center">
                            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                            </svg>
                        </div>
                        <div class="w-2 h-2 bg-red-400 rounded-full group-hover:scale-150 transition-transform"></div>
                    </div>
                    <h3 class="text-2xl font-bold text-white mb-2">Logout</h3>
                    <p class="text-gray-400 mb-6">End your session and return to the login page</p>
                    <div class="flex items-center text-red-400 font-semibold group-hover:translate-x-2 transition-transform">
                        Sign out
                        <svg class="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </div>
                </div>
            </a>
        </div>

        <!-- Recent activity -->
        <div class="mt-12">
            <h3 class="text-xl font-bold text-white mb-6">Recent Activity</h3>
            <div class="space-y-4">
                <div class="group relative">
                    <div class="relative bg-white/5 backdrop-blur-xl rounded-xl p-4 border border-white/10 hover:border-white/20 transition-all duration-300">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-4">
                                <div class="w-10 h-10 bg-gradient-to-br from-blue-400 to-cyan-500 rounded-full flex items-center justify-center">
                                    <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path>
                                    </svg>
                                </div>
                                <div>
                                    <p class="text-white font-medium">Leave request approved</p>
                                    <p class="text-gray-500 text-sm">Dec 5-8, 2024</p>
                                </div>
                            </div>
                            <span class="text-green-400 text-sm font-semibold">Approved</span>
                        </div>
                    </div>
                </div>

                <div class="group relative">
                    <div class="relative bg-white/5 backdrop-blur-xl rounded-xl p-4 border border-white/10 hover:border-white/20 transition-all duration-300">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-4">
                                <div class="w-10 h-10 bg-gradient-to-br from-purple-400 to-pink-500 rounded-full flex items-center justify-center">
                                    <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                                        <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z"></path>
                                        <path fill-rule="evenodd" d="M4 5a2 2 0 012-2 1 1 0 000 2H3a3 3 0 00-3 3v10a3 3 0 003 3h14a3 3 0 003-3V8a3 3 0 00-3-3h-3a1 1 0 000-2 2 2 0 00-2 2H4zm0 0a1 1 0 000 2v10a1 1 0 001 1h12a1 1 0 001-1V7a1 1 0 00-1-1H4z" clip-rule="evenodd"></path>
                                    </svg>
                                </div>
                                <div>
                                    <p class="text-white font-medium">New project assignment</p>
                                    <p class="text-gray-500 text-sm">Dashboard Redesign</p>
                                </div>
                            </div>
                            <span class="text-blue-400 text-sm font-semibold">New</span>
                        </div>
                    </div>
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
    </style>

</body>
</html>