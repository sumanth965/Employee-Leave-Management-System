# Employee Leave Management System (Refactored MVC)

Professional JSP/Servlet/JDBC project for student-friendly but industry-style leave management.

## ✅ Architecture

- **Controller layer** (`com.elms.controller`): Handles all HTTP requests and session-aware flow.
- **Service layer** (`com.elms.service`): Contains business rules (validation, day count, approval workflow).
- **DAO layer** (`com.elms.dao`): Reusable non-static database logic using `PreparedStatement`.
- **Model layer** (`com.elms.model`): JavaBeans + enums (`Role`, `LeaveType`, `LeaveStatus`).
- **View layer** (`/WEB-INF/views/*.jsp`): Pure JSP + JSTL/EL (no Java business logic).

## ✅ Major Improvements Included

1. Business logic removed from JSP and moved to `LeaveService` and Servlets.
2. Correct leave day calculation using inclusive date difference (`startDate` to `endDate`).
3. Full leave validation:
   - start date not in past
   - end date on/after start date
   - no overlapping pending/approved leave
   - enforce leave balance per leave type
4. Leave types: **Sick, Casual, Paid**.
5. Cancel leave support (only pending requests).
6. Approval workflow with:
   - approve/reject
   - approvedBy
   - approvedDate
   - manager comments
7. Filtering by status/date range and pagination on dashboards.
8. Role-based access filter for Employee/Manager/Admin.
9. Session handling with timeout and protected routes.
10. Flash success/error messages for better UX.
11. Mock notification service (email-ready extension point).
12. Basic REST-style endpoint (`/app/api/v1/leaves`) for future upgrades.

## Project Structure

```text
src/main/java/com/elms
├── config
├── controller
├── dao
├── model
├── service
└── util

src/main/webapp/WEB-INF/views
├── login.jsp
├── employee-dashboard.jsp
├── manager-dashboard.jsp
├── apply-leave.jsp
└── error.jsp
```

## Database Schema (MySQL)

```sql
CREATE DATABASE IF NOT EXISTS leave_management;
USE leave_management;

CREATE TABLE user (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash VARCHAR(64) NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  role VARCHAR(20) NOT NULL
);

CREATE TABLE leave_balance (
  user_id BIGINT NOT NULL,
  leave_type VARCHAR(20) NOT NULL,
  total_leaves INT NOT NULL,
  used_leaves INT NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, leave_type),
  CONSTRAINT fk_lb_user FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE leaves (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  employee_id BIGINT NOT NULL,
  leave_type VARCHAR(20) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  days INT NOT NULL,
  reason TEXT NOT NULL,
  status VARCHAR(20) NOT NULL,
  approved_by BIGINT NULL,
  approved_date DATETIME NULL,
  manager_comments VARCHAR(500) NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  CONSTRAINT fk_leave_employee FOREIGN KEY (employee_id) REFERENCES user(id),
  CONSTRAINT fk_leave_approver FOREIGN KEY (approved_by) REFERENCES user(id)
);
```

### Sample User Insert (password = `password123` using SHA-256)

```sql
INSERT INTO user (username, password_hash, full_name, role) VALUES
('emp1', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Employee One', 'EMPLOYEE'),
('manager1', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Manager One', 'MANAGER'),
('admin1', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Admin One', 'ADMIN');
```

## Run

```bash
mvn clean package
```

Deploy generated `target/elms.war` to Tomcat.

## Spring Boot Migration Path

1. Replace Servlets with Spring MVC Controllers.
2. Replace JDBC DAO with Spring Data JPA repositories.
3. Move session + role checks to Spring Security.
4. Convert JSP pages to Thymeleaf (or keep JSP).
5. Convert mock notification to async mail service.
6. Keep existing service classes; annotate with `@Service`.

