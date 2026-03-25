package com.elms.controller;

import com.elms.model.LeaveStatus;
import com.elms.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.YearMonth;

@WebServlet("/app/employee/calendar")
public class CalendarServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = currentUser(req);
        if (user == null) {
            safeRedirect(req, resp, "/login");
            return;
        }

        YearMonth currentMonth = parseMonth(req.getParameter("month"));
        LeaveStatus statusFilter = parseStatus(req.getParameter("status"));
        LocalDate monthStart = currentMonth.atDay(1);
        LocalDate monthEnd = currentMonth.atEndOfMonth();

        try {
            prepareFlash(req);
            req.setAttribute("calendarLeaves", leaveService(req).getEmployeeLeavesForCalendar(user.getId(), monthStart, monthEnd, statusFilter));
            req.setAttribute("currentMonth", currentMonth.toString());
            req.setAttribute("monthLabel", currentMonth.getMonth().name() + " " + currentMonth.getYear());
            req.setAttribute("previousMonth", currentMonth.minusMonths(1).toString());
            req.setAttribute("nextMonth", currentMonth.plusMonths(1).toString());
            req.setAttribute("statusFilter", statusFilter);
            req.getRequestDispatcher("/Calendar.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Unable to load calendar right now.");
            req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
        }
    }

    private YearMonth parseMonth(String monthParam) {
        try {
            return monthParam == null || monthParam.isBlank() ? YearMonth.now() : YearMonth.parse(monthParam);
        } catch (Exception e) {
            return YearMonth.now();
        }
    }
}
