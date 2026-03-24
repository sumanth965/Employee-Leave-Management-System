package com.elms.controller;

import com.elms.model.User;
import com.elms.util.FlashMessageUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/app/employee/cancel")
public class CancelLeaveServlet extends BaseServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = currentUser(req);
        long leaveId = Long.parseLong(req.getParameter("leaveId"));

        try {
            if (leaveService(req).cancelPendingLeave(leaveId, user.getId())) {
                FlashMessageUtil.success(req.getSession(), "Pending leave canceled.");
            } else {
                FlashMessageUtil.error(req.getSession(), "Only pending leaves can be canceled.");
            }
        } catch (SQLException e) {
            FlashMessageUtil.error(req.getSession(), "Unable to cancel leave right now.");
        }

        safeRedirect(req, resp, "/app/employee/dashboard");
    }
}
