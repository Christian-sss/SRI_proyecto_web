const telemetriaApiUrl = '/api/estadisticas/telemetria';
const distribucionApiUrl = '/api/estadisticas/distribucion-modos';
const cultivosApiUrl = '/api/cultivos';
const consumoDetalleApiUrl = '/api/estadisticas/consumo-detalle';

let chartTelemetria = null;
let chartDistribucion = null;
let graficoConsumoAgua = null;
let solicitudDashboardActual = 0;

const coloresConsumo = ['#2563eb', '#16a34a', '#f59e0b', '#7c3aed', '#0891b2', '#dc2626'];

function setText(id, value) {
    const element = document.getElementById(id);
    if (element) {
        element.textContent = value;
    }
}

function formatoDecimal(value, decimals = 1) {
    const number = Number(value);
    return Number.isFinite(number) ? number.toFixed(decimals) : '--';
}

function actualizarKpis(telemetria, distribucion) {
    const ultimaLectura = telemetria.length ? telemetria[telemetria.length - 1] : null;

    setText('kpi-nivel-tanque', ultimaLectura ? `${formatoDecimal(ultimaLectura.distancia)} cm` : '--');
    setText('kpi-ultima-humedad', ultimaLectura ? `${ultimaLectura.humedad}%` : '--');
    setText('kpi-cultivo-activo', distribucion.cultivoActivo || 'Sin cultivo');
    setText('kpi-total-riegos', distribucion.total ?? 0);
}

function crearGradiente(ctx, color) {
    const gradient = ctx.createLinearGradient(0, 0, 0, 320);
    gradient.addColorStop(0, color);
    gradient.addColorStop(1, 'rgba(255, 255, 255, 0)');
    return gradient;
}

function unidadDataset(datasetLabel) {
    return datasetLabel.includes('Humedad') ? '%' : 'cm';
}

function pintarGraficoTelemetria(telemetria) {
    const canvas = document.getElementById('chartTelemetria');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');

    if (chartTelemetria) {
        chartTelemetria.destroy();
    }

    chartTelemetria = new Chart(ctx, {
        type: 'line',
        data: {
            labels: telemetria.map(item => item.etiqueta),
            datasets: [
                {
                    label: 'Humedad',
                    data: telemetria.map(item => item.humedad),
                    yAxisID: 'yHumedad',
                    borderColor: '#168aad',
                    backgroundColor: crearGradiente(ctx, 'rgba(22, 138, 173, 0.26)'),
                    pointBackgroundColor: '#ffffff',
                    pointBorderColor: '#168aad',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                },
                {
                    label: 'Distancia',
                    data: telemetria.map(item => item.distancia),
                    yAxisID: 'yDistancia',
                    borderColor: '#f59e0b',
                    backgroundColor: crearGradiente(ctx, 'rgba(245, 158, 11, 0.23)'),
                    pointBackgroundColor: '#ffffff',
                    pointBorderColor: '#f59e0b',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                mode: 'index',
                intersect: false
            },
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                        color: '#334155',
                        font: { weight: '700' },
                        usePointStyle: true
                    }
                },
                tooltip: {
                    callbacks: {
                        label: context => `${context.dataset.label}: ${context.parsed.y} ${unidadDataset(context.dataset.label)}`
                    }
                }
            },
            scales: {
                yHumedad: {
                    type: 'linear',
                    position: 'left',
                    min: 0,
                    max: 100,
                    title: {
                        display: true,
                        text: 'Humedad (%)',
                        color: '#475569'
                    },
                    grid: { color: 'rgba(0,0,0,0.05)' },
                    ticks: {
                        color: '#64748b',
                        callback: value => `${value}%`
                    }
                },
                yDistancia: {
                    type: 'linear',
                    position: 'right',
                    title: {
                        display: true,
                        text: 'Distancia (cm)',
                        color: '#475569'
                    },
                    grid: { drawOnChartArea: false },
                    ticks: {
                        color: '#64748b',
                        callback: value => `${value} cm`
                    }
                },
                x: {
                    grid: { color: 'rgba(0,0,0,0.05)' },
                    ticks: { color: '#64748b' }
                }
            }
        }
    });
}

function pintarGraficoDistribucion(distribucion) {
    const canvas = document.getElementById('chartDistribucionModos');
    if (!canvas) return;

    if (chartDistribucion) {
        chartDistribucion.destroy();
    }

    chartDistribucion = new Chart(canvas, {
        type: 'doughnut',
        data: {
            labels: ['Automático', 'Manual'],
            datasets: [{
                data: [distribucion.automatico || 0, distribucion.manual || 0],
                backgroundColor: ['#2563eb', '#14b8a6'],
                borderColor: '#ffffff',
                borderWidth: 5,
                hoverOffset: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        color: '#334155',
                        font: { weight: '700' },
                        padding: 18,
                        usePointStyle: true
                    }
                },
                tooltip: {
                    callbacks: {
                        label: context => `${context.label}: ${context.parsed} riegos`
                    }
                }
            },
            cutout: '68%'
        }
    });
}

function pintarGraficoConsumoAgua(datos) {
    const canvas = document.getElementById('graficoConsumoAgua');
    if (!canvas) return;

    const fechas = [...new Set(datos.map(item => item.fecha))].sort();
    const cultivos = [...new Set(datos.map(item => item.cultivo))];
    const totales = new Map();

    datos.forEach(item => {
        const clave = `${item.fecha}|${item.cultivo}`;
        totales.set(clave, (totales.get(clave) || 0) + Number(item.litrosConsumidos || 0));
    });

    if (graficoConsumoAgua) {
        graficoConsumoAgua.destroy();
    }

    graficoConsumoAgua = new Chart(canvas, {
        type: 'bar',
        data: {
            labels: fechas,
            datasets: cultivos.map((cultivo, index) => ({
                label: cultivo,
                data: fechas.map(fecha => Number((totales.get(`${fecha}|${cultivo}`) || 0).toFixed(2))),
                backgroundColor: coloresConsumo[index % coloresConsumo.length],
                borderRadius: 5
            }))
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: { mode: 'index', intersect: false },
            plugins: {
                legend: { position: 'top' },
                tooltip: {
                    callbacks: {
                        label: context => `${context.dataset.label}: ${context.parsed.y.toFixed(2)} L`
                    }
                }
            },
            scales: {
                x: { title: { display: true, text: 'Día' } },
                y: {
                    beginAtZero: true,
                    title: { display: true, text: 'Litros consumidos' },
                    ticks: { callback: value => `${value} L` }
                }
            }
        }
    });
}

function pintarTablaConsumoAgua(datos) {
    const tbody = document.getElementById('tablaConsumoAguaBody');
    if (!tbody) return;

    tbody.replaceChildren();

    if (!datos.length) {
        const fila = tbody.insertRow();
        const celda = fila.insertCell();
        celda.colSpan = 4;
        celda.className = 'text-center text-muted py-4';
        celda.textContent = 'No hay eventos de riego completados.';
        return;
    }

    datos.forEach(item => {
        const fila = tbody.insertRow();
        fila.insertCell().textContent = item.fecha;
        fila.insertCell().textContent = item.cultivo;
        fila.insertCell().textContent = `${item.horaInicio} - ${item.horaFin}`;

        const consumo = fila.insertCell();
        consumo.className = 'text-end fw-bold';
        consumo.textContent = Number(item.litrosConsumidos || 0).toFixed(2);
    });
}

function obtenerFiltroCultivo() {
    const filtro = document.getElementById('filtroCultivo');
    return filtro ? filtro.value : '';
}

function construirUrlConFiltro(baseUrl, cultivoId) {
    if (!cultivoId) {
        return baseUrl;
    }

    const parametros = new URLSearchParams();
    parametros.append('cultivoId', cultivoId);
    return `${baseUrl}?${parametros.toString()}`;
}

async function cargarFiltroCultivos() {
    const select = document.getElementById('filtroCultivo');
    if (!select) return;

    try {
        const response = await fetch(cultivosApiUrl);
        if (!response.ok) {
            throw new Error('No se pudieron cargar los cultivos.');
        }

        const cultivos = await response.json();
        cultivos.forEach(cultivo => {
            if (select.querySelector(`option[value="${cultivo.id}"]`)) {
                return;
            }

            const option = document.createElement('option');
            option.value = cultivo.id;
            option.textContent = cultivo.nombre;
            select.appendChild(option);
        });
    } catch (error) {
        console.error(error);
    }
}

async function actualizarDashboard(cultivoId = '') {
    const numeroSolicitud = ++solicitudDashboardActual;
    try {
        const [telemetriaResponse, distribucionResponse, consumoResponse] = await Promise.all([
            fetch(construirUrlConFiltro(telemetriaApiUrl, cultivoId)),
            fetch(construirUrlConFiltro(distribucionApiUrl, cultivoId)),
            fetch(construirUrlConFiltro(consumoDetalleApiUrl, cultivoId))
        ]);

        if (!telemetriaResponse.ok || !distribucionResponse.ok || !consumoResponse.ok) {
            throw new Error('No se pudieron cargar las estadísticas.');
        }

        const [telemetria, distribucion, consumo] = await Promise.all([
            telemetriaResponse.json(),
            distribucionResponse.json(),
            consumoResponse.json()
        ]);

        if (numeroSolicitud !== solicitudDashboardActual) {
            return;
        }

        actualizarKpis(telemetria, distribucion);
        pintarGraficoTelemetria(telemetria);
        pintarGraficoDistribucion(distribucion);
        pintarGraficoConsumoAgua(consumo);
        pintarTablaConsumoAgua(consumo);
    } catch (error) {
        if (numeroSolicitud === solicitudDashboardActual) {
            console.error('Error al actualizar el dashboard:', error);
            pintarTablaConsumoAgua([]);
        }
    }
}

async function inicializarDashboardEstadisticas() {
    await cargarFiltroCultivos();

    const filtro = document.getElementById('filtroCultivo');
    if (filtro) {
        filtro.addEventListener('change', event => actualizarDashboard(event.target.value));
    }

    actualizarDashboard(obtenerFiltroCultivo());

    window.setInterval(() => {
        if (!document.hidden) {
            actualizarDashboard(obtenerFiltroCultivo());
        }
    }, 3000);
}

document.addEventListener('DOMContentLoaded', inicializarDashboardEstadisticas);
