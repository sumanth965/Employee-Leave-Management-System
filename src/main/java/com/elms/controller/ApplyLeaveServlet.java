package com.elms.controller;

import com.elms.model.LeaveType;
import com.elms.model.User;
import com.elms.service.LeaveService;
import com.elms.util.FlashMessageUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

@WebServlet("/app/employee/apply")
public class ApplyLeaveServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("leaveTypes", LeaveType.values());
        req.getRequestDispatcher("/WEB-INF/views/apply-leave.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        User user = currentUser(req);
        String leaveTypeParam = req.getParameter("leaveType");
        LocalDate startDate = parseDate(req.getParameter("startDate"));
        LocalDate endDate = parseDate(req.getParameter("endDate"));
        String reason = req.getParameter("reason");

        try {
            LeaveType leaveType = LeaveType.from(leaveTypeParam);
            LeaveService.ValidationResult result = leaveService(req).applyLeave(user.getId(), leaveType, startDate, endDate, reason);
            if (!result.success()) {
                req.setAttribute("errors", result.errors());
                req.setAttribute("leaveTypes", LeaveType.values());
                req.getRequestDispatcher("/WEB-INF/views/apply-leave.jsp").forward(req, resp);
                return;
            }

            FlashMessageUtil.success(req.getSession(), result.message());
            safeRedirect(req, resp, "/app/employee/dashboard");
        } catch (IllegalArgumentException e) {
            req.setAttribute("errors", java.util.List.of("Invalid leave type selected."));
            req.setAttribute("leaveTypes", LeaveType.values());
            req.getRequestDispatcher("/WEB-INF/views/apply-leave.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("errors", java.util.List.of("Could not submit leave request."));
            req.setAttribute("leaveTypes", LeaveType.values());
            req.getRequestDispatcher("/WEB-INF/views/apply-leave.jsp").forward(req, resp);
        }
    }
}
