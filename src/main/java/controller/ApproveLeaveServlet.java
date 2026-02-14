package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import dao.LeaveDAO;

@WebServlet("/ApproveLeaveServlet")
public class ApproveLeaveServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get leave ID from URL
            int leaveId = Integer.parseInt(request.getParameter("id"));

            // Get action (Approved / Rejected)
            String status = request.getParameter("action");

            // Update status in database
            LeaveDAO.updateStatus(leaveId, status);

            // Redirect back to manager dashboard
            response.sendRedirect("manager.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating leave status.");
        }
    }
}
