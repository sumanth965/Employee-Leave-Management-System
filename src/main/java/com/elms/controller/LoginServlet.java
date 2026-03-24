package com.elms.controller;

import com.elms.model.Role;
import com.elms.model.User;
import com.elms.service.AuthService;
import com.elms.util.FlashMessageUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        prepareFlash(req);
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        AuthService authService = (AuthService) req.getServletContext().getAttribute("authService");
        try {
            Optional<User> user = authService.login(username.trim(), password);
            if (user.isEmpty()) {
                req.setAttribute("error", "Invalid credentials.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.invalidate();
            session = req.getSession(true);
            session.setAttribute("currentUser", user.get());
            session.setMaxInactiveInterval(30 * 60);

            if (user.get().getRole() == Role.MANAGER || user.get().getRole() == Role.ADMIN) {
                resp.sendRedirect(req.getContextPath() + "/app/manager/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/app/employee/dashboard");
            }
        } catch (SQLException e) {
            req.setAttribute("error", "Unable to login right now. Please try again later.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}
