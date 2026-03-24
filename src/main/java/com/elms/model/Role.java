package com.elms.model;

public enum Role {
    EMPLOYEE,
    MANAGER,
    ADMIN;

    public static Role from(String value) {
        return Role.valueOf(value.toUpperCase());
    }
}
