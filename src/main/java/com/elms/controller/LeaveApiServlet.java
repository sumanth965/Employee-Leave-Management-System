package com.elms.controller;

import com.elms.model.LeaveRequest;
import com.elms.model.LeaveStatus;
import com.elms.model.User;
import com.elms.util.PagedResult;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.stream.Collectors;

@WebServlet("/app/api/v1/leaves")
public class LeaveApiServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = currentUser(req);
        try {
            PagedResult<LeaveRequest> result = leaveService(req)
                    .getEmployeeLeaves(user.getId(), parseStatus(req.getParameter("status")), null, null, 1, 50);

            resp.setContentType("application/json");
            String items = result.getItems().stream()
                    .map(l -> String.format("{\"id\":%d,\"type\":\"%s\",\"start\":\"%s\",\"end\":\"%s\",\"status\":\"%s\"}",
                            l.getId(), l.getLeaveType(), l.getStartDate(), l.getEndDate(), l.getStatus()))
                    .collect(Collectors.joining(","));
            resp.getWriter().write("{\"page\":" + result.getPage() + ",\"total\":" + result.getTotalRecords() + ",\"items\":[" + items + "]}");
        } catch (SQLException e) {
            resp.sendError(500, "Could not fetch leaves");
        }
    }
}
