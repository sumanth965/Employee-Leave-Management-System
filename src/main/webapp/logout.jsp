<%
    session.invalidate();   // destroy session
    response.sendRedirect("login.jsp");
%>
