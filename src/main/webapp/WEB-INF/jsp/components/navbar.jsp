<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<header class="topbar">
    <div class="d-flex align-items-center gap-3">
        <button class="sidebar-toggle" id="sidebarToggle" type="button" aria-label="Alternar barra lateral">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="page-title">
            <h2>${param.title}</h2>
            <p>${param.subtitle}</p>
        </div>
    </div>

    <div class="profile-area">
        <div id="mqttStatusBadge" class="status-badge bg-success">
            <i id="mqttStatusIcon" class="fa-solid fa-cloud-arrow-up"></i>
            <span id="mqttStatusText">MQTT Conectado</span>
        </div>

        <div class="admin-badge d-flex align-items-center gap-2">
            <c:choose>
                <c:when test="${not empty sessionScope.usuarioLogueado.pictureUrl}">
                    <img src="${sessionScope.usuarioLogueado.pictureUrl}" alt="Profile" class="rounded-circle" width="32" height="32" referrerpolicy="no-referrer">
                </c:when>
                <c:otherwise>
                    <div class="rounded-circle bg-success text-white d-flex align-items-center justify-content-center fw-bold" style="width: 32px; height: 32px; font-size: 14px;">
                        ${not empty sessionScope.usuarioLogueado.nombre ? fn:substring(sessionScope.usuarioLogueado.nombre, 0, 1) : 'U'}
                    </div>
                </c:otherwise>
            </c:choose>
            <span class="fw-bold">${not empty sessionScope.usuarioLogueado.nombre ? sessionScope.usuarioLogueado.nombre : 'Usuario'}</span>
        </div>
    </div>
</header>
