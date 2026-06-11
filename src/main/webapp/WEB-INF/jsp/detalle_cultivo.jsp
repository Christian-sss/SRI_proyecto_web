<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Cultivo - SRI</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* 1. Fondo y tipografía general */
        body {
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background-color: #f0f4f1; /* Fondo verde muy pálido */
            margin: 0;
            padding: 40px 20px;
            color: #1b3b2b; /* Verde muy oscuro casi negro */
        }

        /* 2. Tarjeta principal (Imitando el diseño limpio) */
        .dashboard-card {
            background-color: #ffffff;
            max-width: 900px;
            margin: 0 auto;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.04);
            padding: 40px;
            box-sizing: border-box;
        }

        /* 3. Botón de volver gris plomo */
        .btn-volver {
            display: inline-block;
            background-color: #727c76;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 20px;
            transition: background 0.2s;
        }
        .btn-volver:hover { background-color: #5c6660; }

        /* 4. Título y meta-datos del cultivo */
        h1 {
            margin: 0 0 10px 0;
            font-size: 2.2rem;
            color: #123524;
            font-weight: 700;
        }

        .meta-datos {
            font-size: 1.1rem;
            color: #2c4c3b;
            margin-bottom: 25px;
        }
        .meta-datos strong { font-weight: 600; }

        .divider {
            border: 0;
            height: 1px;
            background-color: #123524; /* Línea divisoria oscura */
            margin: 20px 0 30px 0;
        }

        /* 5. Subtítulo del gráfico */
        .chart-header {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.4rem;
            font-weight: 700;
            color: #123524;
            margin-bottom: 20px;
        }
        .chart-header img { width: 24px; height: 24px; } /* Para el ícono de la gráfica */

        /* 6. Contenedor del gráfico Chart.js */
        .chart-container {
            position: relative;
            height: 350px;
            width: 100%;
            margin-bottom: 40px;
        }

        /* 7. Botón de Exportar Verde Brillante */
        .btn-exportar {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background-color: #3b9f4a; /* Verde brillante */
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-exportar:hover { background-color: #2e823a; }
    </style>
</head>
<body>

    <div class="dashboard-card">

        <a href="/perfiles" class="btn-volver">← Volver a perfiles</a>

        <h1>Cultivo de tomates</h1>

        <div class="meta-datos">
            <strong>Intervalo:</strong> 4 h &nbsp;|&nbsp;
            <strong>Riego:</strong> 30 seg <br>
            <strong>Humedad min/max:</strong> 40% / 80%
        </div>

        <hr class="divider">

        <div class="chart-header">
            📈 Historial de humedad y riegos
        </div>

        <div class="chart-container">
            <canvas id="humedadChart"></canvas>
        </div>

        <a href="/reportes/cultivo/pdf" target="_blank" class="btn-exportar">
            📄 Exportar a PDF
        </a>

    </div>

    <script>
        // Simulando datos que vendrían desde tu backend (Spring Boot -> JSP)
        // Ejemplo: const etiquetas = \${listaHorasJSP};
        const etiquetasHoras = [
            '08:22 PM', '09:22 PM', '10:22 PM', '11:22 PM', '12:22 AM',
            '01:22 AM', '02:22 AM', '03:22 AM', '04:22 AM', '05:22 AM',
            '06:22 AM', '07:22 AM', '08:22 AM', '09:22 AM', '10:22 AM',
            '11:22 AM', '12:22 PM'
        ];

        const datosHumedad = [
            65, 53, 47, 66, 70,
            69, 55, 49, 67, 60,
            70, 72, 69, 74, 48,
            53, 74
        ];

        const ctx = document.getElementById('humedadChart').getContext('2d');

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: etiquetasHoras,
                datasets: [
                    {
                        label: 'Humedad del suelo (%)',
                        data: datosHumedad,
                        borderColor: '#225536', // Verde oscuro de la línea
                        borderWidth: 3,
                        pointBackgroundColor: '#ffffff', // Centro del punto blanco
                        pointBorderColor: '#225536',     // Borde del punto verde oscuro
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6,
                        tension: 0.3, // Curva suave imitando la imagen
                        fill: false
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            color: '#1b3b2b',
                            font: { family: 'Segoe UI', size: 14, weight: '600' },
                            usePointStyle: true,
                            boxWidth: 20
                        }
                    },
                    tooltip: {
                        backgroundColor: '#1b3b2b',
                        padding: 12,
                        titleFont: { size: 13 },
                        bodyFont: { size: 14, weight: 'bold' }
                    }
                },
                scales: {
                    y: {
                        min: 40,
                        max: 80,
                        grid: {
                            color: '#e5e5e5', // Líneas horizontales grises muy suaves
                            drawBorder: false
                        },
                        ticks: {
                            color: '#727c76',
                            stepSize: 5
                        }
                    },
                    x: {
                        grid: {
                            color: '#e5e5e5', // Líneas verticales (como en tu imagen)
                            drawBorder: false
                        },
                        ticks: {
                            color: '#727c76',
                            maxRotation: 45, // Inclinación para que quepan las horas
                            minRotation: 45
                        }
                    }
                }
            }
        });
    </script>

</body>
</html>
