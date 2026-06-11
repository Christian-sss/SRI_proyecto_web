<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
    <meta charset="UTF-8">
    <title>Inicio</title>
</head>
<body>

<h1>${mensaje}</h1>

<a href="/reportes/modos-riego" target="_blank" class="btn btn-primary">
    Ver Reporte de Riego (PDF)
</a>

<iframe src="/reportes/modos-riego" width="100%" height="600px"></iframe>


</body>
</html>
