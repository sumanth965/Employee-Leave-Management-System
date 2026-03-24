<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - ELMS</title>
</head>
<body>
<h2>Employee Leave Management - Login</h2>
<c:if test="${not empty flashSuccess}"><p style="color: green">${flashSuccess}</p></c:if>
<c:if test="${not empty flashError}"><p style="color: red">${flashError}</p></c:if>
<c:if test="${not empty error}"><p style="color: red">${error}</p></c:if>

<form action="${pageContext.request.contextPath}/login" method="post">
    <label>Username</label>
    <input type="text" name="username" required />
    <br/>
    <label>Password</label>
    <input type="password" name="password" required />
    <br/>
    <button type="submit">Login</button>
</form>
</body>
</html>
