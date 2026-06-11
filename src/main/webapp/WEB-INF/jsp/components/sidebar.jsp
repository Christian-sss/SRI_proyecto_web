<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<aside class="sidebar">
    <div class="sidebar-logo-mark" aria-hidden="true"></div>
    <div class="brand">
        <div class="brand-icon">
            <i class="fa-solid fa-leaf"></i>
        </div>
        <div class="brand-title">
            <h1>SRI Riego Inteligente</h1>
            <span>Control IoT agrícola</span>
        </div>
    </div>

    <nav class="side-nav" aria-label="Navegación principal">
        <a href="/dashboard" class="nav-item-link ${param.activePage == 'dashboard' ? 'active' : ''}" title="Dashboard">
            <i class="fa-solid fa-chart-line"></i>
            <span class="nav-label">Dashboard</span>
        </a>
        <a href="/riego" class="nav-item-link ${param.activePage == 'riego' ? 'active' : ''}" title="Riego">
            <i class="fa-solid fa-water"></i>
            <span class="nav-label">Riego</span>
        </a>
        <a href="/perfiles" class="nav-item-link ${param.activePage == 'cultivos' ? 'active' : ''}" title="Cultivos">
            <i class="fa-solid fa-seedling"></i>
            <span class="nav-label">Cultivos</span>
        </a>
        <a href="/estadisticas" class="nav-item-link ${param.activePage == 'estadisticas' ? 'active' : ''}" title="Estadísticas">
            <i class="fa-solid fa-chart-bar"></i>
            <span class="nav-label">Estadísticas</span>
        </a>
        <a href="/reportes" class="nav-item-link ${param.activePage == 'reportes' ? 'active' : ''}" title="Reportes">
            <i class="fa-solid fa-file-lines"></i>
            <span class="nav-label">Reportes</span>
        </a>
    </nav>

    <div class="sidebar-footer">
        <a href="/mqtt" class="settings-link ${param.activePage == 'configuracion' ? 'active' : ''}" title="Configuración Técnica">
            <i class="fa-solid fa-cog"></i>
            <span class="logout-label">Configuración Técnica</span>
        </a>
        <a href="/logout" class="logout-link" title="Cerrar Sesión">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span class="logout-label">Cerrar Sesión</span>
        </a>
    </div>
</aside>
