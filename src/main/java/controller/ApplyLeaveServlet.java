package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.LeaveDAO;
import model.Leave;
import model.User;

@WebServlet("/ApplyLeaveServlet")
public class ApplyLeaveServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Get existing session (do not create new one)
        HttpSession session = req.getSession(false);

        // If session expired
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // If user not found in session
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        if (!"employee".equalsIgnoreCase(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/manager.jsp");
            return;
        }

        // Now safe to use user
        Leave leave = new Leave();
        leave.setUserId(user.getId());
        leave.setStartDate(req.getParameter("start"));
        leave.setEndDate(req.getParameter("end"));
        leave.setLeaveType(req.getParameter("leaveType"));
        leave.setReason(req.getParameter("reason"));

        LeaveDAO.applyLeave(leave);

        res.sendRedirect(req.getContextPath() + "/employee/leaves");
    }
}
