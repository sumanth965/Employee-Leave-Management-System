package com.elms.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.elms.dao.LeaveDAO;
import com.elms.model.User;

@WebServlet("/ApproveLeaveServlet")
public class ApproveLeaveServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");

        if (currentUser == null || !"manager".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Get leave ID from URL
            int leaveId = Integer.parseInt(request.getParameter("id"));

            // Get action (Approved / Rejected)
            String status = request.getParameter("action");
            if (!"Approved".equalsIgnoreCase(status) && !"Rejected".equalsIgnoreCase(status)) {
                response.sendRedirect(request.getContextPath() + "/manager.jsp");
                return;
            }

            // Update status in database
            LeaveDAO.updateStatus(leaveId, status);

            // Redirect back to manager dashboard
            response.sendRedirect(request.getContextPath() + "/manager.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating leave status.");
        }
    }
}
