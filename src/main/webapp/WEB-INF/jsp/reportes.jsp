<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes - SRI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/estadisticas.css">
</head>
<body>
<jsp:include page="components/sidebar.jsp">
    <jsp:param name="activePage" value="reportes" />
</jsp:include>

<div class="app-shell">
    <main class="main-area">
        <jsp:include page="components/navbar.jsp">
            <jsp:param name="title" value="Reportes" />
            <jsp:param name="subtitle" value="Descarga de documentos PDF del sistema de riego" />
        </jsp:include>

        <section class="content-panel analytics-dashboard">
            <article class="industrial-chart-card">
                <div class="chart-heading">
                    <div>
                        <h3><i class="fa-solid fa-file-pdf me-2"></i>Reporte de modos de riego</h3>
                        <p>Eventos agrupados por modo manual y automatico</p>
                    </div>
                </div>

                <div class="row g-3 align-items-end">
                    <div class="col-12 col-md-3">
                        <label class="form-label fw-bold" for="fechaInicioReporte">Fecha inicio</label>
                        <input id="fechaInicioReporte" class="form-control" type="date">
                    </div>

                    <div class="col-12 col-md-3">
                        <label class="form-label fw-bold" for="fechaFinReporte">Fecha fin</label>
                        <input id="fechaFinReporte" class="form-control" type="date">
                    </div>

                    <div class="col-12 col-md-3">
                        <label class="form-label fw-bold" for="reporteCultivoId">Cultivo</label>
                        <select id="reporteCultivoId" class="form-select">
                            <option value="">Todos los cultivos</option>
                            <option value="mantenimiento">Solo Mantenimiento / Pruebas</option>
                        </select>
                    </div>

                    <div class="col-12 col-md-3 d-grid">
                        <button id="btnDescargarReportePdf" class="btn btn-success btn-lg" type="button">
                            <i class="fa-solid fa-download me-2"></i>
                            Descargar PDF
                        </button>
                    </div>
                </div>
            </article>

            <article class="industrial-chart-card mt-4">
                <div class="chart-heading">
                    <div>
                        <h3><i class="fa-solid fa-droplet me-2"></i>Reporte de consumo de agua</h3>
                        <p>Detalle de horarios y litros consumidos con caudal de 1.0 L/min</p>
                    </div>
                </div>

                <div class="row g-3 align-items-end">
                    <div class="col-12 col-md-3">
                        <label class="form-label fw-bold" for="fechaInicioConsumo">Fecha inicio</label>
                        <input id="fechaInicioConsumo" class="form-control" type="date">
                    </div>

                    <div class="col-12 col-md-3">
                        <label class="form-label fw-bold" for="fechaFinConsumo">Fecha fin</label>
                        <input id="fechaFinConsumo" class="form-control" type="date">
                    </div>

                    <div class="col-12 col-md-3">
                        <label class="form-label fw-bold" for="consumoCultivoId">Cultivo</label>
                        <select id="consumoCultivoId" class="form-select">
                            <option value="">Todos los cultivos</option>
                            <option value="mantenimiento">Solo Mantenimiento / Pruebas</option>
                        </select>
                    </div>

                    <div class="col-12 col-md-3 d-grid">
                        <button id="btnDescargarConsumoPdf" class="btn btn-primary btn-lg" type="button">
                            <i class="fa-solid fa-download me-2"></i>
                            Descargar consumo PDF
                        </button>
                    </div>
                </div>
            </article>
        </section>
    </main>
</div>

<jsp:include page="components/scripts.jsp" />
<script src="/js/reportes.js?v=20260611-1"></script>
</body>
</html>
