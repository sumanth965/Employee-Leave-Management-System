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
import com.elms.model.User;
import com.elms.service.EmployeeLeaveService;

@WebServlet("/employee/calendar")
public class CalendarServlet extends HttpServlet {

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

        // Fetch all leaves to display on the calendar (Approved, Pending, Refused)
        List<Leave> leaves = leaveService.getLeaveHistory(currentUser.getId(), "All");
        
        request.setAttribute("calendarLeaves", leaves);

        request.getRequestDispatcher("/WEB-INF/views/calendar.jsp").forward(request, response);
    }
}
