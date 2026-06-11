const cultivosApiUrl = '/api/cultivos';
const formNuevoCultivo = document.getElementById('formNuevoCultivo');
const modalNuevoCultivoElement = document.getElementById('modalNuevoCultivo');
const modalNuevoCultivo = modalNuevoCultivoElement ? bootstrap.Modal.getOrCreateInstance(modalNuevoCultivoElement) : null;
const modalTitulo = document.getElementById('modalNuevoCultivoLabel');
const btnGuardarCultivo = document.getElementById('btnGuardarCultivo');
const cultivoAlert = document.getElementById('cultivoAlert');
const cultivoModalAlert = document.getElementById('cultivoModalAlert');
const inputBuscarCultivo = document.getElementById('inputBuscarCultivo');

let cultivoEditandoId = null;
let listaGlobalCultivos = [];
const filtroEstado = document.getElementById('filtroEstado');
const cultivosGrid = document.getElementById('cultivosGrid');
const emptyCultivos = document.getElementById('emptyCultivos');

function mostrarMensajeCultivo(tipo, mensaje) {
    if (!cultivoAlert) return;

    cultivoAlert.className = `alert alert-${tipo} fw-bold border-0 rounded-4 shadow-sm`;
    cultivoAlert.textContent = mensaje;
    cultivoAlert.classList.remove('d-none');
}

function mostrarMensajeModalCultivo(mensaje) {
    if (!cultivoModalAlert) return;

    cultivoModalAlert.textContent = mensaje;
    cultivoModalAlert.classList.remove('d-none');
}

function construirCultivoPayload(formData) {
    return {
        nombre: formData.get('nombre'),
        humedadMinOptima: Number(formData.get('humedadMinOptima')),
        humedadMaxOptima: Number(formData.get('humedadMaxOptima')),
        duracionRiegoMinutos: Number(formData.get('duracionRiegoMinutos')),
        tratoRecomendado: formData.get('tratoRecomendado') || null
    };
}

function validarNombreCultivo(nombre) {
    const nombreNormalizado = nombre.trim();

    if (!nombreNormalizado) {
        return 'El nombre del cultivo es obligatorio.';
    }

    if (/\d/.test(nombreNormalizado)) {
        return 'El nombre del cultivo no puede contener números.';
    }

    const nombreRepetido = listaGlobalCultivos.some(cultivo =>
        cultivo.id !== cultivoEditandoId
        && (cultivo.nombre || '').trim().toLocaleLowerCase('es') === nombreNormalizado.toLocaleLowerCase('es')
    );

    return nombreRepetido ? 'Ya existe un perfil de cultivo con ese nombre.' : null;
}

function enviarJson(url, opciones) {
    return fetch(url, {
        headers: {
            'Content-Type': 'application/json',
            ...(opciones.headers || {})
        },
        ...opciones
    }).then(async response => {
        if (!response.ok) {
            const body = await response.json().catch(() => ({}));
            throw new Error(body.error || 'No se pudo completar la operación.');
        }

        if (response.status === 204 || response.headers.get('content-length') === '0') {
            return null;
        }

        return response.json().catch(() => {
            throw new Error('El servidor no devolvió una respuesta JSON válida. Vuelve a iniciar sesión e inténtalo nuevamente.');
        });
    });
}

function resetearModalCultivo() {
    cultivoEditandoId = null;
    formNuevoCultivo.reset();
    cultivoModalAlert?.classList.add('d-none');
    modalTitulo.innerHTML = '<i class="fa-solid fa-seedling text-success me-2"></i>Nuevo perfil de cultivo';
    btnGuardarCultivo.innerHTML = '<i class="fa-solid fa-floppy-disk me-2"></i>Guardar';
}

function cargarCultivoParaEditar(id) {
    return fetch(`${cultivosApiUrl}/${id}`)
        .then(async response => {
            if (!response.ok) {
                const body = await response.json().catch(() => ({}));
                throw new Error(body.error || 'No se pudo cargar el perfil de cultivo.');
            }

            return response.json();
        });
}

function abrirModalEdicion(cultivo) {
    cultivoEditandoId = cultivo.id;

    formNuevoCultivo.elements.nombre.value = cultivo.nombre || '';
    formNuevoCultivo.elements.humedadMinOptima.value = cultivo.humedadMinOptima ?? '';
    formNuevoCultivo.elements.humedadMaxOptima.value = cultivo.humedadMaxOptima ?? '';
    formNuevoCultivo.elements.duracionRiegoMinutos.value = cultivo.duracionRiegoMinutos ?? '';
    formNuevoCultivo.elements.tratoRecomendado.value = cultivo.tratoRecomendado || '';

    modalTitulo.innerHTML = '<i class="fa-solid fa-pen text-success me-2"></i>Editar perfil de cultivo';
    btnGuardarCultivo.innerHTML = '<i class="fa-solid fa-floppy-disk me-2"></i>Actualizar';
    modalNuevoCultivo.show();
}

function cargarCultivos() {
    return enviarJson(cultivosApiUrl, { method: 'GET' })
        .then(function (data) {
            listaGlobalCultivos = data || [];
            renderizarTarjetas();
        })
        .catch(function (error) {
            mostrarMensajeCultivo('danger', error.message);
        });
}

function renderizarTarjetas() {
    if (!cultivosGrid) return;

    var filtro = filtroEstado ? filtroEstado.value : 'activos';
    var textoBusqueda = inputBuscarCultivo ? inputBuscarCultivo.value.trim().toLowerCase() : '';

    var datosFiltrados = listaGlobalCultivos.filter(function (c) {
        if (filtro === 'activos') return c.activo === true;
        if (filtro === 'inhabilitados') return c.activo === false;
        return true;
    });

    if (textoBusqueda !== '') {
        datosFiltrados = datosFiltrados.filter(function (c) {
            return (c.nombre || '').toLowerCase().includes(textoBusqueda);
        });
    }

    cultivosGrid.innerHTML = '';

    if (datosFiltrados.length === 0) {
        if (emptyCultivos) emptyCultivos.classList.remove('d-none');
        return;
    }

    if (emptyCultivos) emptyCultivos.classList.add('d-none');

    datosFiltrados.forEach(function (c) {
        var activo = c.activo === true;

        var borderClass = activo ? 'border-success' : 'border-secondary';
        var opacityClass = activo ? '' : 'opacity-75';
        var badgeHtml = activo ? '' : '<span class="badge bg-secondary ms-2">Inhabilitado</span>';
        var btnClass = activo ? 'btn-outline-warning' : 'btn-outline-success';
        var btnIcon = activo ? 'fa-ban' : 'fa-check';
        var btnTexto = activo ? 'Inhabilitar' : 'Habilitar';
        var trato = (c.tratoRecomendado && c.tratoRecomendado.trim() !== '') ? c.tratoRecomendado : 'Sin tratamiento recomendado registrado.';

        var col = document.createElement('div');
        col.className = 'col cultivo-item';
        col.dataset.id = c.id;
        col.dataset.nombre = c.nombre;
        col.dataset.activo = c.activo;

        col.innerHTML =
            '<article class="card cultivo-grid-card h-100 shadow-sm border-start ' + borderClass + ' border-4 ' + opacityClass + '">' +
                '<div class="card-body">' +
                    '<h5 class="card-title cultivo-title">' +
                        '<i class="fa-solid fa-leaf text-success me-2"></i>' +
                        c.nombre +
                        badgeHtml +
                    '</h5>' +
                    '<div class="cultivo-detail">' +
                        '<i class="fa-solid fa-droplet text-success"></i> ' +
                        'Humedad: ' + c.humedadMinOptima + '% - ' + c.humedadMaxOptima + '%' +
                    '</div>' +
                    '<div class="cultivo-detail">' +
                        '<i class="fa-solid fa-clock text-success"></i> ' +
                        'Duraci&oacute;n de riego: ' + c.duracionRiegoMinutos + ' min' +
                    '</div>' +
                    '<p class="cultivo-notes">' + trato + '</p>' +
                '</div>' +
                '<div class="card-footer bg-white border-0 d-flex flex-wrap gap-2">' +
                    '<button class="btn btn-sm btn-outline-success btn-editar" type="button" data-id="' + c.id + '">' +
                        '<i class="fa-solid fa-pen me-1"></i> Editar' +
                    '</button>' +
                    '<button class="btn btn-sm btn-toggle-estado ' + btnClass + '" type="button" data-id="' + c.id + '" data-activo="' + c.activo + '">' +
                        '<i class="fa-solid ' + btnIcon + ' me-1"></i> ' + btnTexto +
                    '</button>' +
                '</div>' +
            '</article>';

        cultivosGrid.appendChild(col);
    });
}

if (modalNuevoCultivoElement) {
    modalNuevoCultivoElement.addEventListener('hidden.bs.modal', resetearModalCultivo);
}

document.querySelectorAll('[data-bs-target="#modalNuevoCultivo"]').forEach(button => {
    button.addEventListener('click', resetearModalCultivo);
});

if (formNuevoCultivo) {
    formNuevoCultivo.addEventListener('submit', event => {
        event.preventDefault();

        const payload = construirCultivoPayload(new FormData(formNuevoCultivo));
        const errorNombre = validarNombreCultivo(payload.nombre);

        if (errorNombre) {
            mostrarMensajeModalCultivo(errorNombre);
            return;
        }

        const esEdicion = cultivoEditandoId !== null;
        const url = esEdicion ? `${cultivosApiUrl}/${cultivoEditandoId}` : cultivosApiUrl;
        const method = esEdicion ? 'PUT' : 'POST';

        enviarJson(url, {
            method,
            body: JSON.stringify(payload)
        })
            .then(function () {
                modalNuevoCultivo.hide();
                mostrarMensajeCultivo('success', esEdicion ? 'Perfil de cultivo actualizado correctamente.' : 'Perfil de cultivo guardado correctamente.');
                return cargarCultivos();
            })
            .catch(function (error) {
                mostrarMensajeModalCultivo(error.message);
            });
    });
}

function mostrarToast(icon, title) {
    if (typeof Swal === 'undefined') return;
    Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
    }).fire({ icon: icon, title: title });
}

document.addEventListener('click', function (e) {
    var btn = e.target.closest('.btn-toggle-estado');
    if (btn) {
        var id = btn.dataset.id;

        enviarJson(cultivosApiUrl + '/' + id + '/toggle-estado', { method: 'PUT' })
            .then(function () {
                mostrarToast('success', 'Estado actualizado');
                return cargarCultivos();
            })
            .catch(function () {
                mostrarToast('error', 'Error al actualizar estado');
            });
        return;
    }

    btn = e.target.closest('.btn-editar');
    if (btn) {
        var id = btn.dataset.id;

        cargarCultivoParaEditar(id)
            .then(abrirModalEdicion)
            .catch(function (error) {
                mostrarMensajeCultivo('danger', error.message);
            });
    }
});

if (filtroEstado) {
    filtroEstado.addEventListener('change', renderizarTarjetas);
}

if (inputBuscarCultivo) {
    inputBuscarCultivo.addEventListener('input', renderizarTarjetas);
}

cargarCultivos();
