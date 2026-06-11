<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riego - SRI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/riego.css">
</head>
<body>
<jsp:include page="components/sidebar.jsp">
    <jsp:param name="activePage" value="riego" />
</jsp:include>

<div class="app-shell">
    <main class="main-area">
        <jsp:include page="components/navbar.jsp">
            <jsp:param name="title" value="Riego" />
            <jsp:param name="subtitle" value="Sala de control manual y automático del sistema IoT" />
        </jsp:include>

        <section class="content-panel">
            <div id="riegoAlert" class="alert d-none fw-bold border-0 rounded-4 shadow-sm" role="alert"></div>

            <article class="card riego-control-card shadow-sm">
                <div class="card-header">
                    <h3>
                        <i class="fa-solid fa-faucet-drip me-2"></i>
                        Centro de Control de Riego
                    </h3>
                    <p>Orquesta el modo de operación y las órdenes directas de bomba.</p>
                </div>

                <div class="card-body p-4">
                    <section class="operation-mode">
                        <span class="section-label">Modo de Operación</span>

                        <div class="mode-switch-wrapper">
                            <span class="mode-caption">MANUAL</span>
                            <div class="form-check form-switch form-switch-xl">
                                <input class="form-check-input" type="checkbox" role="switch" id="switchModoOperacion">
                            </div>
                            <span id="textoModoOperacion" class="mode-status manual">MANUAL</span>
                        </div>
                    </section>

                    <div id="alertaModoAutomatico" class="alert alert-info mt-4 d-none">
                        <i class="fa-solid fa-circle-info me-2"></i>
                        El riego está siendo controlado por el Perfil de Cultivo activo.
                    </div>

                    <section>
                        <span class="section-label">Controles Manuales</span>
                        <div class="manual-actions mt-3">
                            <button id="btnEncenderBomba" class="btn btn-success btn-lg" type="button">
                                <i class="fa-solid fa-power-off me-2"></i>
                                Encender Bomba
                            </button>
                            <button id="btnApagarBomba" class="btn btn-danger btn-lg" type="button">
                                <i class="fa-solid fa-ban me-2"></i>
                                Apagar Bomba
                            </button>
                        </div>
                    </section>
                </div>
            </article>

            <article class="card riego-control-card shadow-sm mt-4">
                <div class="card-header">
                    <h3>
                        <i class="fa-solid fa-clock me-2"></i>
                        Programación Automática
                    </h3>
                    <p>Define qué cultivo gobierna el motor automático y a qué hora debe evaluar el riego.</p>
                </div>

                <div class="card-body p-4">
                    <div class="row g-3 align-items-end">
                        <div class="col-12 col-lg-5">
                            <label class="form-label fw-bold text-success" for="selectProgramacionCultivo">Seleccionar Cultivo</label>
                            <select id="selectProgramacionCultivo" class="form-select profile-select">
                                <option value="">Cargando cultivos...</option>
                            </select>
                        </div>

                        <div class="col-12 col-lg-4">
                            <label class="form-label fw-bold text-success" for="inputHoraRiego">Hora de Riego</label>
                            <input id="inputHoraRiego" type="time" class="form-control schedule-input">
                        </div>

                        <div class="col-12 col-lg-3 d-grid">
                            <button id="btnProgramarRiego" class="btn btn-success btn-lg schedule-button" type="button">
                                <i class="fa-solid fa-calendar-check me-2"></i>
                                Programar Riego
                            </button>
                        </div>
                    </div>
                </div>
            </article>
        </section>
    </main>
</div>

<jsp:include page="components/scripts.jsp" />
<script src="/js/riego.js?v=4"></script>
</body>
</html>
