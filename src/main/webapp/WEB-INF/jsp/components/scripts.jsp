<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 1080; margin-top: 72px;">
    <div id="riegoToast" class="toast border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
        <div id="riegoToastHeader" class="toast-header text-white">
            <i id="riegoToastIcon" class="fa-solid fa-triangle-exclamation me-2"></i>
            <strong id="riegoToastTitle" class="me-auto">Aviso del sistema</strong>
            <small id="riegoToastTime">Ahora</small>
            <button type="button" class="btn-close btn-close-white ms-2 mb-1" data-bs-dismiss="toast" aria-label="Cerrar"></button>
        </div>
        <div id="riegoToastBody" class="toast-body bg-white fw-semibold text-dark"></div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="/js/dashboard.js?v=20260611-4"></script>
