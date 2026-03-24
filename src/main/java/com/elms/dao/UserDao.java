package com.elms.dao;

import com.elms.model.User;

import java.sql.SQLException;
import java.util.Optional;

public interface UserDao {
    Optional<User> findByUsername(String username) throws SQLException;
    Optional<User> findById(long id) throws SQLException;
}
