
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Advanced Login Form</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 flex items-center justify-center min-h-screen p-4 font-sans overflow-hidden">
    
    <!-- Decorative elements -->
    <div class="fixed inset-0 overflow-hidden pointer-events-none">
        <div class="absolute -top-40 -right-40 w-80 h-80 bg-blue-500 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob"></div>
        <div class="absolute -bottom-40 -left-40 w-80 h-80 bg-purple-500 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob animation-delay-2000"></div>
        <div class="absolute top-1/2 left-1/2 w-80 h-80 bg-pink-500 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob animation-delay-4000"></div>
    </div>

    <form action="LoginServlet" method="post"
          class="relative bg-white/10 backdrop-blur-xl p-8 md:p-10 rounded-2xl shadow-2xl w-full max-w-md border border-white/20 hover:border-white/40 transition-all duration-300 group">

        <!-- Glow effect on hover -->
        <div class="absolute inset-0 rounded-2xl bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 opacity-0 group-hover:opacity-20 blur transition-opacity duration-300 -z-10"></div>

        <h2 class="text-3xl md:text-4xl font-bold mb-2 text-center bg-gradient-to-r from-blue-400 via-purple-400 to-pink-400 bg-clip-text text-transparent">
            Login
        </h2>
        <p class="text-center text-gray-300 text-sm mb-8 font-light">Welcome back! Please enter your details</p>

        <div class="space-y-5">
            <!-- Username input -->
            <div class="relative group/input">
                <input type="text" 
                       name="username"
                       placeholder="Username"
                       class="w-full px-4 py-3 bg-white/5 border border-white/20 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:border-blue-400 focus:bg-white/10 transition-all duration-300 backdrop-blur-sm"
                       required>
                <div class="absolute inset-0 rounded-lg bg-gradient-to-r from-blue-500 to-purple-500 opacity-0 group-hover/input:opacity-10 blur transition-opacity duration-300 -z-10 group-focus-within/input:opacity-20"></div>
            </div>

            <!-- Password input -->
            <div class="relative group/input">
                <input type="password" 
                       name="password"
                       placeholder="Password"
                       class="w-full px-4 py-3 bg-white/5 border border-white/20 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:border-blue-400 focus:bg-white/10 transition-all duration-300 backdrop-blur-sm"
                       required>
                <div class="absolute inset-0 rounded-lg bg-gradient-to-r from-purple-500 to-pink-500 opacity-0 group-hover/input:opacity-10 blur transition-opacity duration-300 -z-10 group-focus-within/input:opacity-20"></div>
            </div>
        </div>

        <!-- Remember me & Forgot password -->
        <div class="flex items-center justify-between mt-6 text-sm">
            <label class="flex items-center space-x-2 cursor-pointer group/checkbox">
                <input type="checkbox" class="w-4 h-4 rounded bg-white/10 border border-white/20 checked:bg-blue-500 checked:border-blue-500 cursor-pointer transition-all">
                <span class="text-gray-300 group-hover/checkbox:text-white transition-colors">Remember me</span>
            </label>
            <a href="#" class="text-gray-400 hover:text-blue-400 transition-colors font-medium">Forgot password?</a>
        </div>

        <!-- Submit button -->
        <button type="submit"
                class="w-full mt-8 px-4 py-3 bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 text-white font-semibold rounded-lg hover:from-blue-600 hover:via-purple-600 hover:to-pink-600 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2 focus:ring-offset-slate-900 transition-all duration-300 transform hover:scale-105 active:scale-95 shadow-lg hover:shadow-2xl">
            Sign In
        </button>

        <!-- Sign up link -->
        <p class="text-center text-gray-400 text-sm mt-6">
            Don't have an account? 
            <a href="#" class="text-blue-400 hover:text-blue-300 font-semibold transition-colors">Sign up</a>
        </p>

    </form>

    <style>
        @keyframes blob {
            0%, 100% {
                transform: translate(0, 0) scale(1);
            }
            33% {
                transform: translate(30px, -50px) scale(1.1);
            }
            66% {
                transform: translate(-20px, 20px) scale(0.9);
            }
        }

        .animate-blob {
            animation: blob 7s infinite;
        }

        .animation-delay-2000 {
            animation-delay: 2s;
        }

        .animation-delay-4000 {
            animation-delay: 4s;
        }
    </style>

</body>
</html>