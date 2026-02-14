<%@ page import="model.User" %>

<%
    // 🔐 Session + Role Validation
    User currentUser = (User) session.getAttribute("user");

    if(currentUser == null){
        response.sendRedirect("login.jsp");
        return;
    }

    if(!"manager".equalsIgnoreCase(currentUser.getRole())){
        response.sendRedirect("employee.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Add New Employee</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="min-h-screen bg-slate-950 flex items-center justify-center font-sans relative overflow-hidden">

  <!-- ===== Subtle Corporate Wave Background ===== -->
  <div class="absolute inset-0 -z-10 overflow-hidden">

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

  <!-- ===== Add User Form ===== -->
  <form action="AddUserServlet" method="post"
        class="bg-white w-full max-w-md p-12 border border-slate-200 rounded-lg shadow-sm">

    <div class="mb-12 text-center">
      <h1 class="text-xl font-semibold text-slate-800 tracking-wide">
        Add Employee / Manager
      </h1>
      <p class="text-xs text-slate-500 mt-2 uppercase tracking-widest">
        Created by <%= currentUser.getUsername() %>
      </p>
    </div>

    <div class="space-y-8">

      <!-- Username -->
      <div>
        <label class="block text-xs font-medium text-slate-500 uppercase tracking-widest mb-3">
          Username
        </label>
        <input type="text" name="username" required
          class="w-full border-b border-slate-300 py-2 focus:border-slate-800 focus:outline-none">
      </div>

      <!-- Password -->
      <div>
        <label class="block text-xs font-medium text-slate-500 uppercase tracking-widest mb-3">
          Password
        </label>
        <input type="password" name="password" required
          class="w-full border-b border-slate-300 py-2 focus:border-slate-800 focus:outline-none">
      </div>

      <!-- Role -->
      <div>
        <label class="block text-xs font-medium text-slate-500 uppercase tracking-widest mb-3">
          Role
        </label>
        <select name="role" required
          class="w-full border-b border-slate-300 py-2 focus:border-slate-800 focus:outline-none">
          <option value="employee">Employee</option>
          <option value="manager">Manager</option>
        </select>
      </div>

    </div>

    <button type="submit"
      class="w-full mt-12 bg-slate-800 hover:bg-slate-900 text-white py-3 rounded-md font-medium tracking-wide">
      Create User
    </button>

    <p class="text-center text-xs text-slate-400 mt-8">
      <a href="manager.jsp" class="text-slate-600 hover:text-slate-800">
        ← Back to Dashboard
      </a>
    </p>

  </form>

</body>
</html>
