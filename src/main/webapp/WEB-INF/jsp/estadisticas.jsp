<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Estadísticas - SRI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/estadisticas.css">
</head>
<body>
<jsp:include page="components/sidebar.jsp">
    <jsp:param name="activePage" value="estadisticas" />
</jsp:include>

<div class="app-shell">
    <main class="main-area">
        <jsp:include page="components/navbar.jsp">
            <jsp:param name="title" value="Estadísticas" />
            <jsp:param name="subtitle" value="Telemetría, riego y operación del sistema" />
        </jsp:include>

        <section class="content-panel analytics-dashboard">
            <div class="row g-3 mb-4">
                <div class="col-12 col-sm-6 col-xl-3">
                    <article class="industrial-kpi">
                        <div class="kpi-icon tank"><i class="fa-solid fa-water"></i></div>
                        <div class="kpi-copy">
                            <span>Nivel de tanque actual</span>
                            <strong id="kpi-nivel-tanque">--</strong>
                            <small>Distancia medida por sensor</small>
                        </div>
                    </article>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <article class="industrial-kpi">
                        <div class="kpi-icon moisture"><i class="fa-solid fa-droplet"></i></div>
                        <div class="kpi-copy">
                            <span>Última humedad registrada</span>
                            <strong id="kpi-ultima-humedad">--</strong>
                            <small>Lectura de suelo más reciente</small>
                        </div>
                    </article>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <article class="industrial-kpi">
                        <div class="kpi-icon crop"><i class="fa-solid fa-seedling"></i></div>
                        <div class="kpi-copy">
                            <span>Cultivo activo</span>
                            <strong id="kpi-cultivo-activo">--</strong>
                            <small>Perfil seleccionado para riego</small>
                        </div>
                    </article>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <article class="industrial-kpi">
                        <div class="kpi-icon irrigation"><i class="fa-solid fa-rotate"></i></div>
                        <div class="kpi-copy">
                            <span>Total de riegos del mes</span>
                            <strong id="kpi-total-riegos">--</strong>
                            <small>Automático + manual</small>
                        </div>
                    </article>
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-12 col-lg-5">
                    <label class="form-label fw-bold" for="filtroCultivo">Filtrar dashboard por cultivo</label>
                    <select id="filtroCultivo" class="form-select">
                        <option value="">General (Todos los datos)</option>
                        <option value="null_value">Pruebas / Mantenimiento (Sin Cultivo)</option>
                    </select>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-12 col-md-8">
                    <article class="industrial-chart-card">
                        <div class="chart-heading">
                            <div>
                                <h3><i class="fa-solid fa-chart-line me-2"></i>Telemetría de sensores</h3>
                                <p>Últimas 20 lecturas ordenadas cronológicamente</p>
                            </div>
                            <span class="chart-state"><i class="fa-solid fa-circle"></i> En vivo</span>
                        </div>
                        <div class="chart-frame">
                            <canvas id="chartTelemetria"></canvas>
                        </div>
                    </article>
                </div>

                <div class="col-12 col-md-4">
                    <article class="industrial-chart-card h-100">
                        <div class="chart-heading compact">
                            <div>
                                <h3><i class="fa-solid fa-chart-pie me-2"></i>Distribución de modos</h3>
                                <p>Riegos del mes actual</p>
                            </div>
                        </div>
                        <div class="chart-frame donut">
                            <canvas id="chartDistribucionModos"></canvas>
                        </div>
                    </article>
                </div>
            </div>

            <div class="row g-4 mt-1">
                <div class="col-12">
                    <article class="industrial-chart-card">
                        <div class="chart-heading">
                            <div>
                                <h3><i class="fa-solid fa-faucet-drip me-2"></i>Consumo de Agua Detallado</h3>
                                <p>Caudal calculado a 1.0 litro por minuto por cultivo y d&iacute;a</p>
                            </div>
                        </div>

                        <div class="chart-frame water-consumption-chart">
                            <canvas id="graficoConsumoAgua"></canvas>
                        </div>

                        <div class="table-responsive mt-4">
                            <table class="table table-hover align-middle consumption-table">
                                <thead>
                                <tr>
                                    <th>Fecha</th>
                                    <th>Cultivo</th>
                                    <th>Horario (Desde/Hasta)</th>
                                    <th class="text-end">Agua Consumida (L)</th>
                                </tr>
                                </thead>
                                <tbody id="tablaConsumoAguaBody">
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-4">Cargando consumo de agua...</td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </article>
                </div>
            </div>
        </section>
    </main>
</div>

<jsp:include page="components/scripts.jsp" />
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="/js/estadisticas.js?v=20260611-3"></script>
</body>
</html>
