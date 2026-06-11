document.addEventListener('DOMContentLoaded', () => {
    const botonDescarga = document.getElementById('btnDescargarReportePdf');
    const inputFechaInicio = document.getElementById('fechaInicioReporte');
    const inputFechaFin = document.getElementById('fechaFinReporte');
    const selectCultivo = document.getElementById('reporteCultivoId');
    const botonConsumo = document.getElementById('btnDescargarConsumoPdf');
    const inputFechaInicioConsumo = document.getElementById('fechaInicioConsumo');
    const inputFechaFinConsumo = document.getElementById('fechaFinConsumo');
    const selectCultivoConsumo = document.getElementById('consumoCultivoId');

    cargarCultivosReporte(selectCultivo);
    cargarCultivosReporte(selectCultivoConsumo);

    if (!botonDescarga) {
        return;
    }

    botonDescarga.addEventListener('click', () => {
        descargarReporte('/api/reportes/descargar-pdf', inputFechaInicio, inputFechaFin, selectCultivo);
    });

    if (botonConsumo) {
        botonConsumo.addEventListener('click', () => {
            descargarReporte(
                '/api/reportes/consumo-agua',
                inputFechaInicioConsumo,
                inputFechaFinConsumo,
                selectCultivoConsumo
            );
        });
    }
});

function descargarReporte(endpoint, inputFechaInicio, inputFechaFin, selectCultivo) {
    const parametros = new URLSearchParams();

    if (inputFechaInicio && inputFechaInicio.value) {
        parametros.append('fechaInicio', inputFechaInicio.value);
    }

    if (inputFechaFin && inputFechaFin.value) {
        parametros.append('fechaFin', inputFechaFin.value);
    }

    if (selectCultivo && selectCultivo.value) {
        parametros.append('cultivoId', selectCultivo.value);
    }

    const queryString = parametros.toString();
    window.location.href = queryString ? `${endpoint}?${queryString}` : endpoint;
}

async function cargarCultivosReporte(selectCultivo) {
    if (!selectCultivo) {
        return;
    }

    try {
        const response = await fetch('/api/cultivos');
        if (!response.ok) {
            throw new Error('No se pudieron cargar los cultivos.');
        }

        const cultivos = await response.json();
        cultivos.forEach(cultivo => {
            if (selectCultivo.querySelector(`option[value="${cultivo.id}"]`)) {
                return;
            }

            const option = document.createElement('option');
            option.value = cultivo.id;
            option.textContent = cultivo.nombre;
            selectCultivo.appendChild(option);
        });
    } catch (error) {
        console.error(error);
    }
}
