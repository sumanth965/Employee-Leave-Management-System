<%@ page import="com.elms.model.User" %>
    <% User currentUser=(User) session.getAttribute("user"); if (currentUser==null) {
        response.sendRedirect("login.jsp"); return; } if (!"manager".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("employee.jsp"); return; } %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Add Employee | ELMS</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
            <link href="<%= request.getContextPath() %>/css/manager.css" rel="stylesheet">
        </head>

        <body>
            <aside class="sidebar p-3">
                <div class="pb-4 border-bottom border-secondary-subtle">
                    <div class="d-flex align-items-center gap-2 text-white">
                        <i class="bi bi-building text-primary"></i>
                        <h1 class="h5 mb-0">ELMS Corporate</h1>
                    </div>
                    <p class="mb-0 text-secondary small mt-2">Manager Portal</p>
                </div>

                <nav class="nav flex-column mt-4 gap-1">
                    <a class="nav-link" href="manager.jsp"><i class="bi bi-house-door me-2"></i>Dashboard</a>
                    <a class="nav-link active" href="register.jsp"><i class="bi bi-person-plus me-2"></i>Add
                        Employee</a>
                    <a class="nav-link" href="manager.jsp#leave-requests"><i class="bi bi-clock-history me-2"></i>Leave
                        Requests</a>
                </nav>

                <div class="mt-auto pt-3 border-top border-secondary-subtle text-white">
                    <div class="d-flex align-items-center gap-2">
                        <img src="https://ui-avatars.com/api/?name=<%= currentUser.getUsername() %>&background=2563EB&color=fff"
                            class="rounded-circle" width="42" height="42" alt="avatar">
                        <div>
                            <div class="fw-semibold">
                                <%= currentUser.getUsername() %>
                            </div>
                            <div class="small text-secondary">Manager</div>
                        </div>
                    </div>
                    <a class="btn btn-outline-light btn-sm mt-3 w-100" href="logout.jsp"><i
                            class="bi bi-box-arrow-right me-1"></i>Logout</a>
                </div>
            </aside>

            <div class="main-wrap">
                <header class="topbar d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-0 topbar-heading">
                            <% int regHour=java.util.Calendar.getInstance().get(java.util.Calendar.HOUR_OF_DAY); String
                                regGreeting=regHour < 12 ? "Good Morning" : regHour < 17 ? "Good Afternoon"
                                : "Good Evening" ; %>
                                <%= regGreeting %>, <%= currentUser.getUsername() %>
                        </h2>
                        <small class="text-secondary">Create a new employee account from the manager portal.</small>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <button class="btn btn-icon" type="button"><i class="bi bi-bell"></i></button>
                        <div class="dropdown">
                            <button class="btn profile-dropdown dropdown-toggle d-flex align-items-center gap-2"
                                data-bs-toggle="dropdown" type="button">
                                <img src="https://ui-avatars.com/api/?name=<%= currentUser.getUsername() %>&background=2563EB&color=fff"
                                    class="rounded-circle" width="32" height="32" alt="avatar">
                                <span>
                                    <%= currentUser.getUsername() %>
                                </span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="logout.jsp"><i
                                            class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                            </ul>
                        </div>
                    </div>
                </header>

                <main class="content p-3 p-md-4 d-flex justify-content-center align-items-start">
                    <div class="glass-card p-4 register-card w-100">
                        <h4 class="mb-1">Add Employee</h4>
                        <p class="text-muted mb-4">Fill out the details below to create a user account.</p>

                        <form action="RegisterServlet" method="post" class="row g-3">
                            <div class="col-12">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="nameInput" name="username"
                                        placeholder="Name" required>
                                    <label for="nameInput">Name</label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-floating">
                                    <input type="email" class="form-control" id="emailInput" name="email"
                                        placeholder="Email" required>
                                    <label for="emailInput">Email</label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-floating">
                                    <input type="password" class="form-control" id="passwordInput" name="password"
                                        placeholder="Password" required>
                                    <label for="passwordInput">Password</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <select class="form-select" id="roleInput" name="role" required>
                                        <option value="employee">Employee</option>
                                        <option value="manager">Manager</option>
                                    </select>
                                    <label for="roleInput">Role</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="departmentInput" name="department"
                                        placeholder="Department" required>
                                    <label for="departmentInput">Department</label>
                                </div>
                            </div>
                            <div class="col-12 d-grid mt-2">
                                <button type="submit" class="btn btn-brand btn-lg">Create Employee</button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>