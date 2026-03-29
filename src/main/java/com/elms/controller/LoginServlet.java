package com.elms.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.elms.dao.UserDAO;
import com.elms.model.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        System.out.println("USERNAME: " + username);
        System.out.println("PASSWORD: " + password);

        User user = UserDAO.validate(username, password);

        if (user == null) {
            System.out.println("❌ LOGIN FAILED: No user found with provided username and password.");
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // ✅ CREATE SESSION AND STORE USER
        HttpSession session = req.getSession();
        session.setAttribute("user", user);

        System.out.println("✅ LOGIN SUCCESS: User found!");
        System.out.println("DEBUG: Username from DB = [" + user.getUsername() + "]");
        System.out.println("DEBUG: Role from DB = [" + user.getRole() + "]");

        String role = user.getRole();

        if (role != null) {
            role = role.trim().toLowerCase();
        }

        System.out.println("NORMALIZED ROLE = [" + role + "]");

        if ("employee".equals(role)) {
            System.out.println("REDIRECTING TO EMPLOYEE");
            res.sendRedirect(req.getContextPath() + "/employee/leaves");
        } 
        else if ("manager".equals(role)) {
            System.out.println("REDIRECTING TO MANAGER");
            res.sendRedirect(req.getContextPath() + "/manager.jsp");
        } 
        else {
            System.out.println("ROLE NOT MATCHED, BACK TO LOGIN");
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }
}
