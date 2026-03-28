package com.elms.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.elms.model.User;
import com.elms.service.EmployeeLeaveService;
import com.elms.service.LeaveApplicationResult;

@WebServlet({"/employee/leaves/cancel", "/employee/cancelLeave"})
public class CancelLeaveServlet extends HttpServlet {

    private final EmployeeLeaveService leaveService = new EmployeeLeaveService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        processCancel(req, res, "id");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        processCancel(req, res, "leaveId");
    }

    private void processCancel(HttpServletRequest req, HttpServletResponse res, String paramName)
            throws IOException {

        HttpSession session = req.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");

        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        if (!"employee".equalsIgnoreCase(currentUser.getRole())) {
            res.sendRedirect(req.getContextPath() + "/manager.jsp");
            return;
        }

        int leaveId;
        try {
            leaveId = Integer.parseInt(req.getParameter(paramName));
        } catch (Exception ex) {
            session.setAttribute("flashType", "danger");
            session.setAttribute("flashMessage", "Invalid leave request selected for cancellation.");
            res.sendRedirect(req.getContextPath() + "/employee/leaves");
            return;
        }

        LeaveApplicationResult result = leaveService.cancelPendingLeave(currentUser.getId(), leaveId);
        session.setAttribute("flashType", result.isSuccess() ? "success" : "danger");
        session.setAttribute("flashMessage", result.getMessage());

        res.sendRedirect(req.getContextPath() + "/employee/leaves");
    }
}
