package com.elms.service;

import com.elms.dao.LeaveBalanceDao;
import com.elms.dao.UserDao;
import com.elms.model.User;
import com.elms.util.PasswordUtil;

import java.sql.SQLException;
import java.util.Optional;

public class AuthService {
    private final UserDao userDao;
    private final LeaveBalanceDao leaveBalanceDao;

    public AuthService(UserDao userDao, LeaveBalanceDao leaveBalanceDao) {
        this.userDao = userDao;
        this.leaveBalanceDao = leaveBalanceDao;
    }

    public Optional<User> login(String username, String rawPassword) throws SQLException {
        Optional<User> user = userDao.findByUsername(username);
        if (user.isEmpty()) {
            return Optional.empty();
        }
        String hashed = PasswordUtil.sha256(rawPassword);
        if (!hashed.equals(user.get().getPasswordHash())) {
            return Optional.empty();
        }

        leaveBalanceDao.initializeDefaultBalances(user.get().getId());
        return user;
    }
}
