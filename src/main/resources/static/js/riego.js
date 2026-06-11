const riegoApiUrl = '/api/riego';
const cultivosApiUrl = '/api/cultivos/activos';

const switchModoOperacion = document.getElementById('switchModoOperacion');
const textoModoOperacion = document.getElementById('textoModoOperacion');
const alertaModoAutomatico = document.getElementById('alertaModoAutomatico');
const btnEncenderBomba = document.getElementById('btnEncenderBomba');
const btnApagarBomba = document.getElementById('btnApagarBomba');
const riegoAlert = document.getElementById('riegoAlert');
const selectProgramacionCultivo = document.getElementById('selectProgramacionCultivo');
const inputHoraRiego = document.getElementById('inputHoraRiego');
const btnProgramarRiego = document.getElementById('btnProgramarRiego');

let estadoRiegoActual = null;

function mostrarMensajeRiego(tipo, mensaje) {
    if (!riegoAlert) return;

    riegoAlert.className = `alert alert-${tipo} fw-bold border-0 rounded-4 shadow-sm`;
    riegoAlert.textContent = mensaje;
    riegoAlert.classList.remove('d-none');
}

function requestRiego(url, body) {
    return fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
    }).then(async response => {
        if (!response.ok) {
            const errorBody = await response.json().catch(() => ({}));
            throw new Error(errorBody.error || 'No se pudo completar la operacion.');
        }

        return response.json();
    });
}

function aplicarModo(automatico) {
    switchModoOperacion.checked = automatico;
    textoModoOperacion.textContent = automatico ? 'AUTOMATICO' : 'MANUAL';
    textoModoOperacion.classList.toggle('automatico', automatico);
    textoModoOperacion.classList.toggle('manual', !automatico);
    alertaModoAutomatico.classList.toggle('d-none', !automatico);
    btnEncenderBomba.disabled = automatico;
    btnApagarBomba.disabled = automatico;
    selectProgramacionCultivo.disabled = false;
    inputHoraRiego.disabled = !automatico;
    btnProgramarRiego.disabled = !automatico;
}

function aplicarProgramacion(data) {
    estadoRiegoActual = data;

    if (selectProgramacionCultivo) {
        selectProgramacionCultivo.value = data.cultivoActivoId || '';
    }

    if (inputHoraRiego) {
        inputHoraRiego.value = data.horaRiegoProgramada || '';
    }
}

function cargarCultivosProgramacion() {
    if (!selectProgramacionCultivo) return Promise.resolve();

    return fetch(cultivosApiUrl)
        .then(async response => {
            if (!response.ok) {
                throw new Error('No se pudieron cargar los cultivos.');
            }

            return response.json();
        })
        .then(cultivos => {
            selectProgramacionCultivo.innerHTML = '<option value="">Selecciona un cultivo</option>';

            cultivos.forEach(cultivo => {
                const option = document.createElement('option');
                option.value = cultivo.id;
                option.textContent = cultivo.nombre;
                selectProgramacionCultivo.appendChild(option);
            });

            if (estadoRiegoActual) {
                aplicarProgramacion(estadoRiegoActual);
            }
        });
}

function cargarEstadoRiego() {
    return fetch(`${riegoApiUrl}/estado`)
        .then(async response => {
            if (!response.ok) {
                throw new Error('No se pudo cargar el estado de riego.');
            }

            return response.json();
        })
        .then(data => {
            aplicarModo(data.automatico === true);
            aplicarProgramacion(data);
        })
        .catch(error => mostrarMensajeRiego('danger', error.message));
}

function actualizarModo(automatico) {
    const modo = automatico ? 'AUTOMATICO' : 'MANUAL';
    aplicarModo(automatico);

    requestRiego(`${riegoApiUrl}/modo`, { modo })
        .then(data => {
            aplicarModo(data.automatico === true);
            aplicarProgramacion(data);
            mostrarMensajeRiego('success', data.mensaje);
        })
        .catch(error => {
            mostrarMensajeRiego('danger', error.message);
            cargarEstadoRiego();
        });
}

function programarRiegoAutomatico() {
    const cultivoId = selectProgramacionCultivo.value;
    const horaRiego = inputHoraRiego.value;

    if (!cultivoId || !horaRiego) {
        mostrarMensajeRiego('warning', 'Selecciona un cultivo y una hora de riego.');
        return;
    }

    requestRiego(`${riegoApiUrl}/programacion`, {
        cultivoId: Number(cultivoId),
        horaRiego
    })
        .then(data => {
            aplicarProgramacion(data);
            mostrarMensajeRiego('success', data.mensaje);
        })
        .catch(error => mostrarMensajeRiego('danger', error.message));
}

function enviarOrdenManual(orden) {
    const cultivoId = selectProgramacionCultivo ? selectProgramacionCultivo.value : '';

    if (!cultivoId) {
        mostrarMensajeRiego('warning', 'Selecciona un cultivo antes de operar la bomba.');
        return;
    }

    requestRiego(`${riegoApiUrl}/manual`, {
        orden,
        cultivoId: Number(cultivoId)
    })
        .then(data => mostrarMensajeRiego('success', data.mensaje))
        .catch(error => mostrarMensajeRiego('danger', error.message));
}

if (switchModoOperacion) {
    switchModoOperacion.addEventListener('change', () => actualizarModo(switchModoOperacion.checked));
}

if (btnEncenderBomba) {
    btnEncenderBomba.addEventListener('click', () => enviarOrdenManual('ON'));
}

if (btnApagarBomba) {
    btnApagarBomba.addEventListener('click', () => enviarOrdenManual('OFF'));
}

if (btnProgramarRiego) {
    btnProgramarRiego.addEventListener('click', programarRiegoAutomatico);
}

window.addEventListener('load', () => {
    Promise.all([cargarCultivosProgramacion(), cargarEstadoRiego()])
        .catch(error => mostrarMensajeRiego('danger', error.message));
});
