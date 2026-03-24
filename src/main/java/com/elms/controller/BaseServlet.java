package com.elms.controller;

import com.elms.model.LeaveStatus;
import com.elms.model.User;
import com.elms.service.LeaveService;
import com.elms.util.FlashMessageUtil;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDate;

public abstract class BaseServlet extends HttpServlet {
    protected LeaveService leaveService(HttpServletRequest request) {
        return (LeaveService) request.getServletContext().getAttribute("leaveService");
    }

    protected User currentUser(HttpServletRequest request) {
        return (User) request.getSession().getAttribute("currentUser");
    }

    protected int parseInt(String value, int defaultValue) {
        try {
            return value == null || value.isBlank() ? defaultValue : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    protected LocalDate parseDate(String value) {
        try {
            return value == null || value.isBlank() ? null : LocalDate.parse(value);
        } catch (Exception e) {
            return null;
        }
    }

    protected LeaveStatus parseStatus(String value) {
        try {
            return value == null || value.isBlank() ? null : LeaveStatus.from(value);
        } catch (Exception e) {
            return null;
        }
    }

    protected void prepareFlash(HttpServletRequest request) {
        FlashMessageUtil.expose(request);
    }

    protected void safeRedirect(HttpServletRequest request, HttpServletResponse response, String path) throws java.io.IOException {
        response.sendRedirect(request.getContextPath() + path);
    }
}
