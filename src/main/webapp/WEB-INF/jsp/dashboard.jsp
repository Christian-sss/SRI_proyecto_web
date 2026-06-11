<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SRI Riego Inteligente - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="/css/dashboard.css">
</head>
<body>
<jsp:include page="components/sidebar.jsp">
    <jsp:param name="activePage" value="dashboard" />
</jsp:include>

<div class="app-shell">
    <main class="main-area">
        <jsp:include page="components/navbar.jsp">
            <jsp:param name="title" value="Dashboard" />
            <jsp:param name="subtitle" value="Monitoreo ambiental del sistema de riego" />
        </jsp:include>
        <jsp:include page="components/dashboard-main.jsp" />
</main>
</div>

<jsp:include page="components/scripts.jsp" />
</body>
</html>

