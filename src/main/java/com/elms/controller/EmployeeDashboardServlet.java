package com.elms.controller;

import com.elms.model.LeaveStatus;
import com.elms.model.User;
import com.elms.util.PagedResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/app/employee/dashboard")
public class EmployeeDashboardServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = currentUser(req);

        int page = parseInt(req.getParameter("page"), 1);
        int size = parseInt(req.getParameter("size"), 5);

        LeaveStatus status = parseStatus(req.getParameter("status"));
        var fromDate = parseDate(req.getParameter("fromDate"));
        var toDate = parseDate(req.getParameter("toDate"));

        try {
            prepareFlash(req);
            req.setAttribute("balances", leaveService(req).getBalances(user.getId()));
            PagedResult<?> leaves = leaveService(req).getEmployeeLeaves(user.getId(), status, fromDate, toDate, page, size);
            req.setAttribute("result", leaves);
            req.setAttribute("status", status);
            req.setAttribute("fromDate", fromDate);
            req.setAttribute("toDate", toDate);
            req.getRequestDispatcher("/WEB-INF/views/employee-dashboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Unable to load dashboard right now.");
            req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
        }
    }
}
