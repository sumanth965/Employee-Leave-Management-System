<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Apply Leave</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-950 min-h-screen flex items-center justify-center p-4">
  <form action="${pageContext.request.contextPath}/ApplyLeaveServlet" method="post" class="bg-white text-slate-900 rounded-xl p-8 w-full max-w-lg shadow">
    <h1 class="text-xl font-bold mb-2">Apply for Leave</h1>
    <p class="text-sm text-slate-500 mb-6">Logged in as ${sessionScope.user.username}</p>

    <div class="space-y-4">
      <div>
        <label class="block text-sm mb-1">Leave Type</label>
        <select name="leaveType" class="w-full border rounded px-3 py-2" required>
          <option value="">Select leave type</option>
          <option value="Sick Leave">Sick Leave</option>
          <option value="Casual Leave">Casual Leave</option>
          <option value="Paid Leave">Paid Leave</option>
          <option value="Unpaid Leave">Unpaid Leave</option>
        </select>
      </div>

      <div>
        <label class="block text-sm mb-1">Start Date</label>
        <input type="date" name="start" required class="w-full border rounded px-3 py-2" />
      </div>

      <div>
        <label class="block text-sm mb-1">End Date</label>
        <input type="date" name="end" required class="w-full border rounded px-3 py-2" />
      </div>

      <div>
        <label class="block text-sm mb-1">Reason</label>
        <textarea name="reason" rows="4" required class="w-full border rounded px-3 py-2" placeholder="Provide a short reason"></textarea>
      </div>
    </div>

    <div class="flex gap-3 mt-6">
      <a href="${pageContext.request.contextPath}/employee/leaves" class="w-1/2 text-center border rounded px-4 py-2">Cancel</a>
      <button type="submit" class="w-1/2 bg-slate-900 text-white rounded px-4 py-2">Submit</button>
    </div>
  </form>
</body>
</html>
