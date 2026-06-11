<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configuraci&oacute;n T&eacute;cnica MQTT - SRI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <style>
        .mqtt-card {
            border: 1px solid #deedd7;
            border-radius: 22px;
            background: #fffefa;
        }

        .mqtt-card .card-header {
            border-bottom: 1px solid #e2efdc;
            border-radius: 22px 22px 0 0;
            background: linear-gradient(135deg, #f7fcf4, #edf8e8);
            padding: 20px 22px;
        }

        .mqtt-card h3 {
            margin: 0;
            color: #2e6b2a;
            font-size: 1.08rem;
            font-weight: 800;
        }

        .mqtt-section-title {
            color: #49663f;
            font-size: 0.82rem;
            font-weight: 800;
            text-transform: uppercase;
        }

        .mqtt-state-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border-radius: 999px;
            padding: 8px 14px;
            font-size: 0.84rem;
            font-weight: 800;
        }

        .form-floating > .form-control {
            border: 1px solid #cfe3c5;
            border-radius: 16px;
            background: #fbfef9;
            color: #17351d;
            font-weight: 600;
        }

        .form-floating > label {
            color: #6f8a66;
            font-weight: 700;
        }

        .btn-connect,
        .btn-disconnect {
            min-height: 46px;
            border-radius: 15px;
            font-weight: 800;
        }
    </style>
</head>
<body>
<jsp:include page="components/sidebar.jsp">
    <jsp:param name="activePage" value="configuracion" />
</jsp:include>

<div class="app-shell">
    <main class="main-area">
        <jsp:include page="components/navbar.jsp">
            <jsp:param name="title" value="Configuraci&oacute;n T&eacute;cnica" />
            <jsp:param name="subtitle" value="Gesti&oacute;n de conexi&oacute;n MQTT del sistema IoT" />
        </jsp:include>

        <section class="content-panel">
            <c:if test="${not empty mensaje}">
                <div class="alert alert-success fw-bold border-0 rounded-4 shadow-sm">
                    <i class="fa-solid fa-circle-check me-2"></i>${mensaje}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger fw-bold border-0 rounded-4 shadow-sm">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>${error}
                </div>
            </c:if>

            <div class="card mqtt-card shadow-sm">
                <div class="card-header">
                    <h3>
                        <i class="fa-solid fa-satellite-dish me-2"></i>
                        Gesti&oacute;n de Conexi&oacute;n MQTT
                    </h3>
                </div>

                <div class="card-body p-4">
                    <div class="mb-4">
                        <div class="mqtt-section-title mb-2">Conexi&oacute;n</div>
                        <span id="badge-mqtt" class="badge bg-danger mqtt-state-pill">
                            Estado MQTT: Verificando...
                        </span>
                    </div>

                    <form id="form-conectar-mqtt" action="/mqtt/connect" method="post" autocomplete="off">
                        <div class="row g-3 align-items-end">
                            <div class="col-12 col-lg-4">
                                <div class="form-floating">
                                    <input type="text"
                                           class="form-control"
                                           id="mqtt-username"
                                           name="username"
                                           placeholder="Usuario MQTT"
                                           autocomplete="off"
                                           required>
                                    <label for="mqtt-username">Usuario MQTT</label>
                                </div>
                            </div>

                            <div class="col-12 col-lg-4">
                                <div class="form-floating">
                                    <input type="password"
                                           class="form-control"
                                           id="mqtt-password"
                                           name="password"
                                           placeholder="Contrase&ntilde;a MQTT"
                                           autocomplete="new-password"
                                           required>
                                    <label for="mqtt-password">Contrase&ntilde;a MQTT</label>
                                </div>
                            </div>

                            <div class="col-12 col-lg-2 d-grid">
                                <button id="btn-conectar-mqtt" class="btn btn-outline-success btn-connect" type="submit">
                                    <i class="fa-solid fa-plug-circle-bolt me-2"></i>
                                    Conectar
                                </button>
                            </div>

                            <div class="col-12 col-lg-2 d-grid">
                                <button id="btn-desconectar-mqtt"
                                        class="btn btn-outline-danger btn-disconnect"
                                        type="submit"
                                        form="form-desconectar-mqtt">
                                    <i class="fa-solid fa-plug-circle-xmark me-2"></i>
                                    Desconectar
                                </button>
                            </div>
                        </div>

                        <div class="form-text mt-2">
                            Las credenciales se usan solo para esta conexi&oacute;n y no se almacenan.
                        </div>
                    </form>

                    <form id="form-desconectar-mqtt" action="/mqtt/disconnect" method="post"></form>
                </div>
            </div>
        </section>
    </main>
</div>

<jsp:include page="components/scripts.jsp" />
<script>
    function actualizarEstadoMqtt(conectado) {
        const badge = document.getElementById('badge-mqtt');
        const botonConectar = document.getElementById('btn-conectar-mqtt');
        const botonDesconectar = document.getElementById('btn-desconectar-mqtt');
        const usuario = document.getElementById('mqtt-username');
        const password = document.getElementById('mqtt-password');

        if (!badge) return;

        badge.classList.toggle('bg-success', conectado);
        badge.classList.toggle('bg-danger', !conectado);
        badge.textContent = conectado ? 'Conectado' : 'Desconectado';

        if (botonConectar) botonConectar.disabled = conectado;
        if (botonDesconectar) botonDesconectar.disabled = !conectado;
        if (usuario) usuario.disabled = conectado;
        if (password) password.disabled = conectado;
    }

    function consultarEstadoMqtt() {
        fetch('/api/mqtt/status')
            .then(response => {
                if (!response.ok) throw new Error('No se pudo consultar MQTT');
                return response.json();
            })
            .then(data => actualizarEstadoMqtt(data.conectado === true))
            .catch(() => actualizarEstadoMqtt(false));
    }

    window.addEventListener('load', consultarEstadoMqtt);
    window.setInterval(consultarEstadoMqtt, 3000);
</script>
</body>
</html>
