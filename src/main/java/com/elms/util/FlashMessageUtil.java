package com.elms.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public final class FlashMessageUtil {
    private static final String FLASH_SUCCESS = "flashSuccess";
    private static final String FLASH_ERROR = "flashError";

    private FlashMessageUtil() {
    }

    public static void success(HttpSession session, String message) {
        session.setAttribute(FLASH_SUCCESS, message);
    }

    public static void error(HttpSession session, String message) {
        session.setAttribute(FLASH_ERROR, message);
    }

    public static void expose(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }

        Object success = session.getAttribute(FLASH_SUCCESS);
        Object error = session.getAttribute(FLASH_ERROR);

        if (success != null) {
            request.setAttribute(FLASH_SUCCESS, success);
            session.removeAttribute(FLASH_SUCCESS);
        }

        if (error != null) {
            request.setAttribute(FLASH_ERROR, error);
            session.removeAttribute(FLASH_ERROR);
        }
    }
}
