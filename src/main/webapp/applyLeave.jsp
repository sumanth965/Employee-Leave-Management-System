<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Apply Leave</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="relative min-h-screen bg-slate-950 flex items-center justify-center font-sans overflow-hidden">

  <!-- ===== Subtle Corporate Wave Background ===== -->
  <div class="absolute inset-0 -z-10 overflow-hidden">

    <!-- Back Soft Wave -->
    <svg class="absolute bottom-0 w-full h-64" viewBox="0 0 1440 320">
      <path fill="#e2e8f0" opacity="0.6">
        <animate attributeName="d"
          dur="14s"
          repeatCount="indefinite"
          values="
          M0,220C360,180,1080,260,1440,220L1440,320L0,320Z;
          M0,260C360,220,1080,180,1440,240L1440,320L0,320Z;
          M0,220C360,180,1080,260,1440,220L1440,320L0,320Z">
        </animate>
      </path>
    </svg>

    <!-- Front Soft Wave -->
    <svg class="absolute bottom-0 w-full h-56" viewBox="0 0 1440 320">
      <path fill="#cbd5e1" opacity="0.8">
        <animate attributeName="d"
          dur="10s"
          repeatCount="indefinite"
          values="
          M0,240C400,280,1000,180,1440,230L1440,320L0,320Z;
          M0,260C400,200,1000,260,1440,210L1440,320L0,320Z;
          M0,240C400,280,1000,180,1440,230L1440,320L0,320Z">
        </animate>
      </path>
    </svg>

  </div>
  <!-- ===== End Background ===== -->


  <!-- ===== Corporate Leave Card ===== -->
  <form action="ApplyLeaveServlet" method="post"
        class="relative bg-white w-full max-w-md p-12 border border-slate-200 rounded-lg shadow-sm">

    <!-- Header -->
    <div class="mb-12 text-center">
      <h1 class="text-xl font-semibold text-slate-800 tracking-wide">
        Leave Application
      </h1>
      <p class="text-xs text-slate-500 mt-2 uppercase tracking-widest">
        Submit Leave Request
      </p>
    </div>

    <div class="space-y-8">

      <!-- Start Date -->
      <div>
        <label class="block text-xs font-medium text-slate-500 uppercase tracking-widest mb-3">
          Start Date
        </label>
        <input type="date" name="start" required
          class="w-full bg-transparent border-b border-slate-300 py-2
                 focus:border-slate-800 focus:outline-none
                 transition-colors duration-200">
      </div>

      <!-- End Date -->
      <div>
        <label class="block text-xs font-medium text-slate-500 uppercase tracking-widest mb-3">
          End Date
        </label>
        <input type="date" name="end" required
          class="w-full bg-transparent border-b border-slate-300 py-2
                 focus:border-slate-800 focus:outline-none
                 transition-colors duration-200">
      </div>

      <!-- Reason -->
      <div>
        <label class="block text-xs font-medium text-slate-500 uppercase tracking-widest mb-3">
          Reason
        </label>
        <textarea name="reason" rows="3" required
          class="w-full bg-transparent border-b border-slate-300 py-2
                 focus:border-slate-800 focus:outline-none
                 transition-colors duration-200 resize-none"
          placeholder="Enter reason for leave">
        </textarea>
      </div>

    </div>

    <!-- Buttons -->
    <div class="flex gap-4 mt-12">

      <a href="employee.jsp"
         class="w-1/2 text-center border border-slate-300 py-3 rounded-md
                text-slate-700 hover:bg-slate-100 transition">
        Cancel
      </a>

      <button type="submit"
        class="w-1/2 bg-slate-800 hover:bg-slate-900
               text-white py-3 rounded-md
               font-medium tracking-wide
               transition duration-200">
        Submit
      </button>

    </div>

  </form>
  <!-- ===== End Card ===== -->

</body>
</html>
