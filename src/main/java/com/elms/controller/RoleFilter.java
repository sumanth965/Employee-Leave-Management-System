package com.elms.controller;

import com.elms.model.Role;
import com.elms.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import java.util.Set;

@WebFilter(urlPatterns = {"/app/*"})
public class RoleFilter implements Filter {
    private static final Map<String, Set<Role>> RULES = Map.of(
            "/app/employee", Set.of(Role.EMPLOYEE, Role.MANAGER, Role.ADMIN),
            "/app/manager", Set.of(Role.MANAGER, Role.ADMIN),
            "/app/admin", Set.of(Role.ADMIN)
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            chain.doFilter(request, response);
            return;
        }

        String path = req.getRequestURI().substring(req.getContextPath().length());
        for (Map.Entry<String, Set<Role>> entry : RULES.entrySet()) {
            if (path.startsWith(entry.getKey()) && !entry.getValue().contains(user.getRole())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
