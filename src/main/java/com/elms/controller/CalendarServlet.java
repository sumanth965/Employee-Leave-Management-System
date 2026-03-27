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

import com.elms.util.CalendarViewBuilder;
import java.util.Map;

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

        String monthParam = request.getParameter("month");
        List<Leave> leaves = leaveService.getLeaveHistory(currentUser.getId(), "All");
        
        // Use the strategy pattern/utility to build the view model
        Map<String, Object> calendarData = CalendarViewBuilder.buildMonthView(monthParam, leaves);
        
        for (Map.Entry<String, Object> entry : calendarData.entrySet()) {
            request.setAttribute(entry.getKey(), entry.getValue());
        }

        request.getRequestDispatcher("/WEB-INF/views/calendar.jsp").forward(request, response);
    }
}
