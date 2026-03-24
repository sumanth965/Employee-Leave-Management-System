package com.elms.config;

import com.elms.dao.*;
import com.elms.service.AuthService;
import com.elms.service.LeaveService;
import com.elms.service.NotificationService;
import com.elms.util.ConnectionFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class ApplicationContextListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ConnectionFactory connectionFactory = new ConnectionFactory();

        UserDao userDao = new JdbcUserDao(connectionFactory);
        LeaveDao leaveDao = new JdbcLeaveDao(connectionFactory);
        LeaveBalanceDao leaveBalanceDao = new JdbcLeaveBalanceDao(connectionFactory);

        AuthService authService = new AuthService(userDao, leaveBalanceDao);
        LeaveService leaveService = new LeaveService(leaveDao, leaveBalanceDao, userDao, new NotificationService());

        ServletContext context = sce.getServletContext();
        context.setAttribute("authService", authService);
        context.setAttribute("leaveService", leaveService);
    }
}
