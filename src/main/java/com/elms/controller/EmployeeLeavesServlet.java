package com.elms.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.elms.model.Leave;
import com.elms.model.LeaveBalance;
import com.elms.model.LeaveRequest;
import com.elms.model.User;
import com.elms.service.EmployeeLeaveService;

@WebServlet({"/employee/leaves", "/employee", "/employee/"})
public class EmployeeLeavesServlet extends HttpServlet {

    private final EmployeeLeaveService leaveService = new EmployeeLeaveService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!"employee".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/manager.jsp");
            return;
        }

        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.trim().isEmpty()) {
            statusFilter = "All";
        }

        List<Leave> leaves = leaveService.getLeaveHistory(currentUser.getId(), statusFilter);
        List<LeaveBalance> leaveBalances = leaveService.getLeaveBalances(currentUser.getId());
        List<LeaveRequest> recentLeaveRequests = leaveService.getRecentLeaveRequests(currentUser.getId());

        request.setAttribute("leaves", leaves);
        request.setAttribute("recentLeaveRequests", recentLeaveRequests);
        request.setAttribute("leaveBalances", leaveBalances);
        request.setAttribute("balances", leaveBalances);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("statusOptions", leaveService.getSupportedStatuses());

        if (session != null) {
            request.setAttribute("flashType", session.getAttribute("flashType"));
            request.setAttribute("flashMessage", session.getAttribute("flashMessage"));
            session.removeAttribute("flashType");
            session.removeAttribute("flashMessage");
        }

        request.getRequestDispatcher("/WEB-INF/views/employee-leaves.jsp").forward(request, response);
    }
}
