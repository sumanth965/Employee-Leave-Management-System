package com.elms.controller;

import com.elms.model.LeaveStatus;
import com.elms.util.PagedResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/app/manager/dashboard")
public class ManagerDashboardServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int page = parseInt(req.getParameter("page"), 1);
        int size = parseInt(req.getParameter("size"), 10);

        LeaveStatus status = parseStatus(req.getParameter("status"));
        var fromDate = parseDate(req.getParameter("fromDate"));
        var toDate = parseDate(req.getParameter("toDate"));

        try {
            prepareFlash(req);
            PagedResult<?> leaves = leaveService(req).getManagerLeaves(status, fromDate, toDate, page, size);
            req.setAttribute("result", leaves);
            req.setAttribute("status", status);
            req.setAttribute("fromDate", fromDate);
            req.setAttribute("toDate", toDate);
            req.getRequestDispatcher("/WEB-INF/views/manager-dashboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Unable to load manager dashboard.");
            req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
        }
    }
}
