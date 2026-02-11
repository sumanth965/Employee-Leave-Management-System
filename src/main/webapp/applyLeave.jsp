<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply for Leave</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;600;700&family=Crimson+Text:ital@0;1&display=swap" rel="stylesheet">
</head>
<body style="font-family: 'Sora', sans-serif;" class="bg-gradient-to-br from-slate-950 via-indigo-900 to-slate-900 min-h-screen relative overflow-auto">
    
    <!-- Animated background orbs -->
    <div class="fixed inset-0 overflow-hidden pointer-events-none">
        <div class="absolute -top-72 -left-32 w-96 h-96 bg-indigo-500/20 rounded-full blur-3xl animate-pulse"></div>
        <div class="absolute -bottom-72 right-0 w-96 h-96 bg-cyan-500/15 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>
        <div class="absolute top-1/3 right-1/4 w-64 h-64 bg-purple-500/10 rounded-full blur-2xl"></div>
    </div>

    <!-- Navigation back -->
    <nav class="relative z-40 backdrop-blur-xl bg-white/5 border-b border-white/10 sticky top-0">
        <div class="max-w-2xl mx-auto px-6 py-4">
            <a href="dashboard.jsp" class="inline-flex items-center space-x-2 text-gray-400 hover:text-white transition-colors group">
                <svg class="w-5 h-5 group-hover:-translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                </svg>
                <span class="font-medium">Back to Dashboard</span>
            </a>
        </div>
    </nav>

    <!-- Main container -->
    <main class="relative z-20 flex items-center justify-center min-h-[calc(100vh-80px)] px-6 py-12">
        <div class="w-full max-w-2xl">
            
            <!-- Form card -->
            <div class="group relative">
                <!-- Glow background -->
                <div class="absolute inset-0 bg-gradient-to-r from-indigo-500 via-purple-500 to-cyan-500 rounded-3xl blur-2xl opacity-0 group-hover:opacity-30 transition-opacity duration-500"></div>
                
                <!-- Form container -->
                <form action="ApplyLeaveServlet" method="post" class="relative bg-white/10 backdrop-blur-2xl rounded-3xl p-8 md:p-12 border border-white/20 hover:border-white/40 transition-all duration-300">
                    
                    <!-- Header -->
                    <div class="mb-12 text-center">
                        <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-indigo-400 to-purple-500 rounded-2xl mb-6 group-hover:scale-110 transition-transform duration-300">
                            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h18M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                            </svg>
                        </div>
                        <h1 style="font-family: 'Crimson Text', serif;" class="text-4xl md:text-5xl font-bold text-white mb-2">Leave Request</h1>
                        <p class="text-gray-400 text-lg">Plan your time off with ease</p>
                    </div>

                    <!-- Form fields -->
                    <div class="space-y-8">

                        <!-- Start Date Field -->
                        <div class="group/field relative">
                            <label class="block text-gray-300 font-semibold mb-3 text-sm tracking-wide uppercase">
                                <span class="bg-gradient-to-r from-indigo-400 to-cyan-400 bg-clip-text text-transparent">Start Date</span>
                            </label>
                            <div class="relative">
                                <input 
									    type="date" 
									    name="start" 
									    required
									    class="w-full px-5 py-4 bg-white/5 border border-white/20 
									           rounded-xl text-white placeholder-gray-400 
									           focus:outline-none focus:border-indigo-400 
									           focus:bg-white/10 transition-all duration-300 
									           backdrop-blur-sm [color-scheme:dark]">

                                <div class="absolute inset-0 rounded-xl bg-gradient-to-r from-indigo-500 to-cyan-500 opacity-0 group-focus-within/field:opacity-20 blur transition-opacity duration-300 -z-10"></div>
                            </div>
                            <p class="text-gray-500 text-xs mt-2">Select your departure date</p>
                        </div>

                        <!-- End Date Field -->
                        <div class="group/field relative">
                            <label class="block text-gray-300 font-semibold mb-3 text-sm tracking-wide uppercase">
                                <span class="bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">End Date</span>
                            </label>
                            <div class="relative">
                                <input 
                                    type="date" 
                                    name="end" 
                                    required
                                    class="w-full px-5 py-4 bg-white/5 border border-white/20 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 focus:bg-white/10 transition-all duration-300 backdrop-blur-sm [color-scheme:dark]"
                                >
                                <div class="absolute inset-0 rounded-xl bg-gradient-to-r from-purple-500 to-pink-500 opacity-0 group-focus-within/field:opacity-20 blur transition-opacity duration-300 -z-10"></div>
                            </div>
                            <p class="text-gray-500 text-xs mt-2">Select your return date</p>
                        </div>

                        <!-- Reason Field -->
                        <div class="group/field relative">
                            <label class="block text-gray-300 font-semibold mb-3 text-sm tracking-wide uppercase">
                                <span class="bg-gradient-to-r from-orange-400 to-amber-400 bg-clip-text text-transparent">Reason</span>
                            </label>
                            <div class="relative">
                                <textarea 
                                    name="reason" 
                                    required
                                    rows="4"
                                    placeholder="Tell us why you're taking leave (e.g., Personal, Medical, Vacation, Family matters)"
                                    class="w-full px-5 py-4 bg-white/5 border border-white/20 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-orange-400 focus:bg-white/10 transition-all duration-300 backdrop-blur-sm resize-none"
                                ></textarea>
                                <div class="absolute inset-0 rounded-xl bg-gradient-to-r from-orange-500 to-amber-500 opacity-0 group-focus-within/field:opacity-20 blur transition-opacity duration-300 -z-10"></div>
                            </div>
                            <p class="text-gray-500 text-xs mt-2">Provide details about your leave request</p>
                        </div>

                        <!-- Leave balance info -->
                        <div class="relative bg-white/5 backdrop-blur-xl rounded-2xl p-6 border border-white/20 hover:border-white/30 transition-all">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center space-x-4">
                                    <div class="w-12 h-12 bg-gradient-to-br from-green-400 to-emerald-500 rounded-lg flex items-center justify-center">
                                        <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                                        </svg>
                                    </div>
                                    <div>
                                        <p class="text-gray-300 font-semibold">Available Leave Balance</p>
                                        <p class="text-gray-500 text-sm">You have 12 days remaining</p>
                                    </div>
                                </div>
                                <div class="text-3xl font-bold text-green-400">12</div>
                            </div>
                        </div>

                    </div>

                    <!-- Action buttons -->
                    <div class="flex gap-4 mt-12">
                        <a href="dashboard.jsp" class="flex-1 px-6 py-4 bg-white/10 border border-white/20 text-white font-semibold rounded-xl hover:bg-white/20 hover:border-white/40 transition-all duration-300 text-center group-hover:scale-105">
                            Cancel
                        </a>
                        <button 
                            type="submit" 
                            class="flex-1 px-6 py-4 bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 text-white font-bold rounded-xl hover:from-indigo-600 hover:via-purple-600 hover:to-pink-600 focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:ring-offset-2 focus:ring-offset-slate-950 transition-all duration-300 transform hover:scale-105 active:scale-95 shadow-lg hover:shadow-2xl flex items-center justify-center space-x-2 group-hover:scale-110"
                        >
                            <span>Submit Leave Request</span>
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path>
                            </svg>
                        </button>
                    </div>

                    <!-- Additional info -->
                    <div class="mt-8 p-4 bg-white/5 rounded-lg border border-white/10">
                        <p class="text-gray-400 text-sm text-center">
                            <span class="text-gray-500">📋</span> Your leave request will be reviewed by your manager within 24 hours. You'll receive a notification once it's processed.
                        </p>
                    </div>

                </form>
            </div>

        </div>
    </main>

    <style>
        /* Hide number input spinners for date fields */
        input[type="date"]::-webkit-calendar-picker-indicator {
            cursor: pointer;
            filter: invert(0.8);
        }

        /* Smooth transitions for all inputs */
        input, textarea {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* Focus states */
        input:focus, textarea:focus {
            box-shadow: 0 0 20px rgba(99, 102, 241, 0.2);
        }
    </style>

</body>
</html>