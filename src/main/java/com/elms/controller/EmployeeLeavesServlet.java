package com.elms.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.elms.dao.LeaveDAO;
import com.elms.model.Leave;
import com.elms.model.User;

@WebServlet("/employee/leaves")
public class EmployeeLeavesServlet extends HttpServlet {

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

        List<Leave> leaves = LeaveDAO.getLeavesByUser(currentUser.getId());
        request.setAttribute("leaves", leaves);

        request.getRequestDispatcher("/WEB-INF/views/employee-leaves.jsp").forward(request, response);
    }
}
