(() => {
const toggle = document.getElementById('sidebarToggle');
const chartPanel = document.getElementById('chartPanel');
const cards = Array.from(document.querySelectorAll('.metric-card'));
const canvas = document.getElementById('humidityChart');
const ctx = canvas ? canvas.getContext('2d') : null;
const mqttStatusBadge = document.getElementById('mqttStatusBadge');
const mqttStatusIcon = document.getElementById('mqttStatusIcon');
const mqttStatusText = document.getElementById('mqttStatusText');

const dataPoints = [];
const labels = [];
const yTicks = [0, 25, 50, 75, 100];
let ultimaLecturaProcesada = null;
let ultimaAlertaMostrada = sessionStorage.getItem('sriUltimaAlertaRiego');

if (toggle) {
    toggle.addEventListener('click', () => {
        if (window.innerWidth <= 780) {
            document.body.classList.toggle('sidebar-open');
            return;
        }
        document.body.classList.toggle('sidebar-collapsed');
    });
}

document.querySelectorAll('.nav-item-link').forEach(item => {
    item.addEventListener('click', () => {
        document.querySelectorAll('.nav-item-link').forEach(link => link.classList.remove('active'));
        item.classList.add('active');
    });
});

function setText(id, value) {
    const element = document.getElementById(id);
    if (element) element.textContent = value;
}

function resizeCanvas() {
    if (!canvas || !ctx) return;

    const rect = canvas.getBoundingClientRect();
    const ratio = window.devicePixelRatio || 1;
    canvas.width = rect.width * ratio;
    canvas.height = rect.height * ratio;
    ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
    drawChart();
}

function yFor(value, top, graphH) {
    return top + graphH - (value / 100) * graphH;
}

function drawChart() {
    if (!canvas || !ctx) return;

    const width = canvas.clientWidth;
    const height = canvas.clientHeight;
    if (!width || !height) return;

    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0, 0, width, height);

    const pad = { left: 54, right: 26, top: 18, bottom: 38 };
    const graphW = width - pad.left - pad.right;
    const graphH = height - pad.top - pad.bottom;

    ctx.strokeStyle = '#dcebd5';
    ctx.lineWidth = 1;
    ctx.font = '700 11px Inter, sans-serif';
    ctx.textBaseline = 'middle';

    yTicks.forEach(tick => {
        const y = yFor(tick, pad.top, graphH);
        ctx.beginPath();
        ctx.moveTo(pad.left, y);
        ctx.lineTo(width - pad.right, y);
        ctx.stroke();
        ctx.fillStyle = '#76966c';
        ctx.fillText(`${tick}%`, 14, y);
    });

    if (dataPoints.length === 0) {
        ctx.fillStyle = '#76966c';
        ctx.font = '700 14px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('Esperando lecturas del sensor', width / 2, height / 2);
        ctx.textAlign = 'start';
        return;
    }

    const step = dataPoints.length > 1 ? graphW / (dataPoints.length - 1) : 0;
    const points = dataPoints.map((value, index) => ({
        x: dataPoints.length > 1 ? pad.left + index * step : pad.left + graphW / 2,
        y: yFor(value, pad.top, graphH)
    }));

    if (points.length > 1) {
        const gradient = ctx.createLinearGradient(0, pad.top, 0, pad.top + graphH);
        gradient.addColorStop(0, 'rgba(79, 163, 66, 0.26)');
        gradient.addColorStop(1, 'rgba(79, 163, 66, 0.02)');

        ctx.beginPath();
        points.forEach((point, index) => index === 0 ? ctx.moveTo(point.x, point.y) : ctx.lineTo(point.x, point.y));
        ctx.lineTo(points[points.length - 1].x, pad.top + graphH);
        ctx.lineTo(points[0].x, pad.top + graphH);
        ctx.closePath();
        ctx.fillStyle = gradient;
        ctx.fill();
    }

    ctx.beginPath();
    points.forEach((point, index) => index === 0 ? ctx.moveTo(point.x, point.y) : ctx.lineTo(point.x, point.y));
    ctx.strokeStyle = '#3f9637';
    ctx.lineWidth = 3;
    ctx.lineJoin = 'round';
    ctx.lineCap = 'round';
    ctx.stroke();

    points.forEach(point => {
        ctx.beginPath();
        ctx.arc(point.x, point.y, 5, 0, Math.PI * 2);
        ctx.fillStyle = '#ffffff';
        ctx.fill();
        ctx.lineWidth = 3;
        ctx.strokeStyle = '#2f7d32';
        ctx.stroke();
    });

    ctx.font = '700 10px Inter, sans-serif';
    ctx.textBaseline = 'top';
    ctx.fillStyle = '#7d9d72';
    labels.forEach((label, index) => {
        if (labels.length > 10 && index % 2 !== 0) return;
        ctx.fillText(label, points[index].x - 14, pad.top + graphH + 13);
    });
}

function animateRefresh() {
    if (!chartPanel) return;
    chartPanel.classList.add('is-refreshing');
    cards.forEach(card => card.classList.add('is-refreshing'));
    window.setTimeout(() => {
        chartPanel.classList.remove('is-refreshing');
        cards.forEach(card => card.classList.remove('is-refreshing'));
    }, 650);
}

function pintarEstadoMqtt(tipo) {
    if (!mqttStatusBadge || !mqttStatusIcon || !mqttStatusText) return;

    mqttStatusBadge.classList.remove('bg-success', 'bg-danger', 'text-success');
    if (tipo === 'conectado') {
        mqttStatusBadge.classList.add('bg-success');
        mqttStatusIcon.className = 'fa-solid fa-cloud-arrow-up';
        mqttStatusText.textContent = 'MQTT Conectado';
    } else if (tipo === 'desconectado') {
        mqttStatusBadge.classList.add('bg-danger');
        mqttStatusIcon.className = 'fa-solid fa-triangle-exclamation';
        mqttStatusText.textContent = 'MQTT Desconectado';
    } else {
        mqttStatusBadge.classList.add('bg-danger');
        mqttStatusIcon.className = 'fa-solid fa-server';
        mqttStatusText.textContent = 'Servidor no disponible';
    }
}

function actualizarRiego(estado) {
    const modeElement = document.getElementById('irrigationMode');
    if (!modeElement || !estado) return;

    const automatico = estado.automatico === true;
    modeElement.classList.toggle('manual', !automatico);
    modeElement.innerHTML = automatico
        ? '<i class="fa-solid fa-robot"></i> Automatico'
        : '<i class="fa-solid fa-hand"></i> Manual';

    const cultivo = estado.cultivoActivoNombre || 'Sin cultivo seleccionado';
    const horario = estado.horaRiegoProgramada ? `, ${estado.horaRiegoProgramada}` : '';
    setText('modeLabel', automatico ? `${cultivo}${horario}` : `Control manual, ${cultivo}`);
}

function mostrarAlertaRiego(alerta) {
    if (!alerta || alerta.id === null || alerta.id === undefined) return;

    const alertaKey = `${alerta.id}-${alerta.fecha || ''}`;
    if (alertaKey === ultimaAlertaMostrada) return;

    const toastElement = document.getElementById('riegoToast');
    const toastHeader = document.getElementById('riegoToastHeader');
    const toastIcon = document.getElementById('riegoToastIcon');
    const closeButton = toastElement?.querySelector('[data-bs-dismiss="toast"]');
    if (!toastElement || !toastHeader || !toastIcon || typeof bootstrap === 'undefined') return;

    const esTanqueVacio = alerta.tipo === 'danger';
    toastHeader.classList.remove('bg-danger', 'bg-warning', 'text-dark');
    toastHeader.classList.add(esTanqueVacio ? 'bg-danger' : 'bg-warning');
    toastHeader.classList.toggle('text-dark', !esTanqueVacio);
    closeButton?.classList.toggle('btn-close-white', esTanqueVacio);
    toastIcon.className = esTanqueVacio
        ? 'fa-solid fa-droplet-slash me-2'
        : 'fa-solid fa-gauge-high me-2';

    setText('riegoToastTitle', alerta.titulo || 'Aviso del sistema');
    setText('riegoToastBody', alerta.mensaje || 'La bomba fue detenida automaticamente.');

    const fecha = alerta.fecha ? new Date(alerta.fecha) : new Date();
    setText('riegoToastTime', Number.isNaN(fecha.getTime())
        ? 'Ahora'
        : fecha.toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit' }));

    bootstrap.Toast.getOrCreateInstance(toastElement, {
        autohide: true,
        delay: esTanqueVacio ? 12000 : 9000
    }).show();

    ultimaAlertaMostrada = alertaKey;
    sessionStorage.setItem('sriUltimaAlertaRiego', alertaKey);
}

function actualizarEstadoVivo(estado) {
    pintarEstadoMqtt(estado.mqtt_activo === true ? 'conectado' : 'desconectado');
    mostrarAlertaRiego(estado.alerta);

    if (estado.humedad !== null && estado.humedad !== undefined && Number.isFinite(Number(estado.humedad))) {
        const humedad = Number(estado.humedad);
        setText('humidityValue', humedad);
        setText('humidityLabel', humedad < 30 ? 'Suelo seco' : humedad > 75 ? 'Suelo humedo' : 'Humedad adecuada');

        if (estado.lectura_timestamp && estado.lectura_timestamp !== ultimaLecturaProcesada) {
            const fechaLectura = new Date(estado.lectura_timestamp);
            dataPoints.push(humedad);
            labels.push(Number.isNaN(fechaLectura.getTime())
                ? '--:--'
                : fechaLectura.toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit' }));

            if (dataPoints.length > 20) {
                dataPoints.shift();
                labels.shift();
            }

            ultimaLecturaProcesada = estado.lectura_timestamp;
            drawChart();
        }
    }

    if (estado.distancia !== null && estado.distancia !== undefined && Number.isFinite(Number(estado.distancia))) {
        const distancia = Number(estado.distancia);
        setText('waterDistance', distancia.toFixed(1));
        setText('waterLabel', distancia <= 7 ? 'Tanque lleno' : distancia < 18 ? 'Nivel medio' : 'Tanque vacio');
    }

    const pumpState = document.getElementById('pumpState');
    if (pumpState) {
        const activa = estado.bomba_activa === true;
        pumpState.classList.toggle('manual', !activa);
        pumpState.textContent = activa ? 'Encendida' : 'Apagada';
        setText('pumpLabel', activa ? 'Riego actualmente en proceso' : 'Sin riego en proceso');
    }

    if (estado.timestamp) {
        const fecha = new Date(estado.timestamp);
        setText('dashboardLastUpdate', Number.isNaN(fecha.getTime())
            ? 'Actualizado ahora'
            : `Actualizado ${fecha.toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit', second: '2-digit' })}`);
    }
}

async function fetchJson(url) {
    return fetch(url, {
        cache: 'no-store',
        credentials: 'same-origin',
        headers: { 'Accept': 'application/json' }
    })
        .then(response => {
            const contentType = response.headers.get('content-type') || '';

            if (response.redirected || !contentType.includes('application/json')) {
                throw new Error(`La respuesta de ${url} no es JSON. Verifique la sesion.`);
            }

            if (!response.ok) {
                throw new Error(`Error ${response.status} consultando ${url}`);
            }

            return response.json();
        })
        .then(data => {
            console.log("Datos recibidos:", data);
            return data;
        })
        .catch(error => {
            console.error("Error en Fetch:", error);
            throw error;
        });
}

async function cargarDashboard() {
    const solicitudes = [fetchJson('/api/estado-vivo')];
    if (canvas) {
        solicitudes.push(fetchJson('/api/riego/estado'));
    }

    const resultados = await Promise.allSettled(solicitudes);
    if (canvas) {
        if (resultados[1].status === 'fulfilled') actualizarRiego(resultados[1].value);
        animateRefresh();
    }

    if (resultados[0].status === 'fulfilled') {
        actualizarEstadoVivo(resultados[0].value);
    } else {
        pintarEstadoMqtt('servidor-caido');
        setText('humidityLabel', 'Error consultando el sensor');
        setText('waterLabel', 'Revise la consola del navegador');
        setText('pumpLabel', 'Estado no disponible');
    }
}

window.addEventListener('resize', resizeCanvas);
window.addEventListener('load', () => {
    resizeCanvas();
    cargarDashboard();
    window.setInterval(cargarDashboard, 2000);
});
})();
