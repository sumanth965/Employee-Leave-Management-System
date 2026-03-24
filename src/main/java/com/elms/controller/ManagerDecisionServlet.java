package com.elms.controller;

import com.elms.model.LeaveStatus;
import com.elms.model.User;
import com.elms.service.LeaveService;
import com.elms.util.FlashMessageUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/app/manager/decision")
public class ManagerDecisionServlet extends BaseServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User manager = currentUser(req);
        long leaveId = Long.parseLong(req.getParameter("leaveId"));
        String action = req.getParameter("action");
        String comments = req.getParameter("comments");

        LeaveStatus decision = "approve".equalsIgnoreCase(action) ? LeaveStatus.APPROVED : LeaveStatus.REJECTED;

        try {
            LeaveService.ValidationResult result = leaveService(req).managerDecision(leaveId, manager.getId(), decision, comments);
            if (result.success()) {
                FlashMessageUtil.success(req.getSession(), result.message());
            } else {
                FlashMessageUtil.error(req.getSession(), String.join(" ", result.errors()));
            }
        } catch (SQLException e) {
            FlashMessageUtil.error(req.getSession(), "Unable to process request.");
        }

        safeRedirect(req, resp, "/app/manager/dashboard");
    }
}
