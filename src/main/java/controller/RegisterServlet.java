package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.UserDAO;
import model.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        User user = new User();
        user.setUsername(username);
        user.setRole(role);

        boolean success = UserDAO.register(user, password);

        if(success){
            res.sendRedirect("login.jsp");
        } else {
            res.getWriter().println("Registration Failed");
        }
    }
}
