<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head><title>Error</title></head>
<body>
<h2>Something went wrong</h2>
<p>${error}</p>
<a href="${pageContext.request.contextPath}/login">Back to login</a>
</body>
</html>
