<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Riego Inteligente - Acceso</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <style>
        :root {
            --sri-green: #2f7d32;
            --sri-green-dark: #1f5f27;
            --sri-green-soft: #eaf6e6;
            --sri-border: #cfe3c5;
            --sri-text: #17351d;
        }

        * {
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            margin: 0;
            display: grid;
            place-items: center;
            padding: 24px;
            background:
                    radial-gradient(circle at 18% 18%, rgba(91, 175, 75, 0.22), transparent 30%),
                    linear-gradient(145deg, #eff7eb 0%, #cde8c4 52%, #f7fbf4 100%);
            color: var(--sri-text);
            font-family: 'Inter', sans-serif;
        }

        .login-shell {
            width: min(420px, 100%);
        }

        .login-card {
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(198, 224, 188, 0.92);
            border-radius: 28px;
            background: rgba(255, 255, 255, 0.92);
            box-shadow: 0 26px 70px rgba(38, 86, 43, 0.18);
            padding: 34px;
            backdrop-filter: blur(14px);
        }

        .login-card::before {
            content: "";
            position: absolute;
            inset: 0 0 auto;
            height: 5px;
            background: linear-gradient(90deg, #2f7d32, #78bd63, #2f7d32);
        }

        .brand-icon {
            width: 68px;
            height: 68px;
            display: grid;
            place-items: center;
            margin: 0 auto 14px;
            border-radius: 22px;
            background: linear-gradient(145deg, #eef9e9, #d4efc9);
            color: var(--sri-green);
            box-shadow: inset 0 0 0 1px #c5e3ba, 0 10px 28px rgba(47, 125, 50, 0.18);
            font-size: 2rem;
        }

        h1 {
            margin: 0;
            color: var(--sri-green-dark);
            font-size: 1.55rem;
            font-weight: 800;
            letter-spacing: 0;
            text-align: center;
        }

        .subtitle {
            margin: 8px 0 26px;
            color: #63835b;
            font-size: 0.9rem;
            font-weight: 600;
            text-align: center;
        }

        .form-label {
            color: #3d6138;
            font-size: 0.82rem;
            font-weight: 700;
        }

        .input-wrap {
            position: relative;
        }

        .input-wrap i {
            position: absolute;
            left: 16px;
            top: 50%;
            color: #7ca66f;
            transform: translateY(-50%);
            transition: color 0.25s ease, transform 0.25s ease;
        }

        .form-control {
            min-height: 48px;
            border: 1px solid var(--sri-border);
            border-radius: 16px;
            padding-left: 46px;
            color: var(--sri-text);
            font-weight: 600;
            transition: border-color 0.25s ease, box-shadow 0.25s ease, transform 0.25s ease;
        }

        .form-control:focus {
            border-color: #68ad55;
            box-shadow: 0 0 0 4px rgba(104, 173, 85, 0.18);
            transform: translateY(-1px);
        }

        .input-wrap:focus-within i {
            color: var(--sri-green);
            transform: translateY(-50%) scale(1.08);
        }

        .captcha-row {
            display: grid;
            grid-template-columns: 132px 1fr;
            gap: 10px;
        }

        .captcha-box {
            min-height: 48px;
            display: grid;
            place-items: center;
            border: 1px solid #bedcaf;
            border-radius: 16px;
            background: repeating-linear-gradient(-18deg, #eef9ea 0 8px, #e2f2db 8px 16px);
            color: var(--sri-green-dark);
            font-weight: 800;
            letter-spacing: 0.18rem;
            user-select: none;
        }

        #captcha {
            padding-left: 16px;
            text-transform: uppercase;
        }

        .btn-login {
            position: relative;
            min-height: 48px;
            border: 0;
            border-radius: 16px;
            background: linear-gradient(135deg, #2f7d32, #4fa342);
            box-shadow: 0 14px 26px rgba(47, 125, 50, 0.28);
            color: #fff;
            font-weight: 800;
            overflow: hidden;
            animation: buttonPulse 2.5s ease-in-out infinite;
        }

        .btn-login:hover {
            background: linear-gradient(135deg, #276b2c, #44933a);
            color: #fff;
            transform: translateY(-1px);
        }
        
        .btn-register {
            position: relative;
            min-height: 48px;
            border: 2px solid var(--sri-green);
            border-radius: 16px;
            background: transparent;
            color: var(--sri-green);
            font-weight: 800;
            transition: all 0.25s ease;
        }

        .btn-register:hover {
            background: var(--sri-green-soft);
            color: var(--sri-green-dark);
            transform: translateY(-1px);
        }

        @keyframes buttonPulse {
            0%, 100% { box-shadow: 0 14px 26px rgba(47, 125, 50, 0.24); }
            50% { box-shadow: 0 14px 34px rgba(47, 125, 50, 0.42); }
        }

        .error-msg {
            display: flex;
            align-items: center;
            gap: 9px;
            max-height: 0;
            opacity: 0;
            margin-top: 0;
            border: 1px solid #f0b8b8;
            border-radius: 14px;
            background: #fff2f2;
            color: #b42323;
            font-size: 0.84rem;
            font-weight: 700;
            overflow: hidden;
            transition: max-height 0.28s ease, opacity 0.28s ease, margin-top 0.28s ease, padding 0.28s ease;
        }

        .error-msg.is-visible {
            max-height: 58px;
            opacity: 1;
            margin-top: 16px;
            padding: 11px 13px;
        }
        
        .success-msg {
            display: flex;
            align-items: center;
            gap: 9px;
            max-height: 0;
            opacity: 0;
            margin-top: 0;
            margin-bottom: 0;
            border: 1px solid #a8d5a2;
            border-radius: 14px;
            background: #eaf6e6;
            color: #1f5f27;
            font-size: 0.84rem;
            font-weight: 700;
            overflow: hidden;
            transition: max-height 0.28s ease, opacity 0.28s ease, margin-bottom 0.28s ease, padding 0.28s ease;
        }

        .success-msg.is-visible {
            max-height: 58px;
            opacity: 1;
            margin-bottom: 16px;
            padding: 11px 13px;
        }

        @media (max-width: 420px) {
            .login-card {
                padding: 26px;
                border-radius: 22px;
            }

            .captcha-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<main class="login-shell">
    <section class="login-card">
        <div class="brand-icon">
            <i class="fa-solid fa-leaf"></i>
        </div>
        <h1>Sistema de Riego Inteligente</h1>
        <p class="subtitle">Acceso autorizado</p>
        
        <div id="registerSuccess" class="success-msg ${not empty mensajeExito ? 'is-visible' : ''}">
            <i class="fa-solid fa-circle-check"></i>
            <span>${not empty mensajeExito ? mensajeExito : '¡Registro exitoso! Ya puedes ingresar.'}</span>
        </div>

        <form method="post" action="/login" autocomplete="on">
            <div class="mb-3">
                <label for="username" class="form-label">Usuario</label>
                <div class="input-wrap">
                    <i class="fa-solid fa-user"></i>
                    <input type="text" id="username" name="username" class="form-control" placeholder="admin@sri.com" required autofocus>
                </div>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Contraseña</label>
                <div class="input-wrap">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" id="password" name="password" class="form-control" placeholder="••••••" required>
                </div>
            </div>

            <div class="mb-4">
                <label for="captcha" class="form-label">Captcha</label>
                <div class="captcha-row">
                    <div class="captcha-box">${captchaTexto}</div>
                    <input type="text" id="captcha" name="captcha" class="form-control" placeholder="Letras" maxlength="5" required>
                </div>
            </div>

            <button type="submit" class="btn btn-login w-100 mb-3">
                Ingresar
            </button>
            
            <a href="/registro" target="_blank" class="btn btn-register w-100 mb-3 d-flex align-items-center justify-content-center text-decoration-none">
                Registrarse
            </a>
            
            <div class="d-flex align-items-center my-3">
                <hr class="flex-grow-1" style="border-color: var(--sri-border);">
                <span class="mx-3 text-muted fw-bold" style="font-size: 0.85rem;">O</span>
                <hr class="flex-grow-1" style="border-color: var(--sri-border);">
            </div>
            
            <div id="g_id_onload"
                 data-client_id="571504675373-b3dthv13b7i5khpi4p4dvnq09icbfe4n.apps.googleusercontent.com"
                 data-context="signin"
                 data-ux_mode="popup"
                 data-login_uri="https://sriproyectoweb-production.up.railway.app/login/google"
                 data-auto_prompt="false">
            </div>

            <div class="g_id_signin d-flex justify-content-center mb-3"
                 data-type="standard"
                 data-shape="pill"
                 data-theme="outline"
                 data-text="signin_with"
                 data-size="large"
                 data-logo_alignment="left">
            </div>
            
            
        </form>

        <div id="loginError" class="error-msg ${not empty error ? 'is-visible' : ''}">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span>${not empty error ? error : 'Usuario o contraseña incorrectos'}</span>
        </div>
    </section>
</main>

<script>
    const errorBox = document.getElementById('loginError');
    const demoError = new URLSearchParams(window.location.search).get('demoError') === 'true';

    if (demoError) {
        setTimeout(() => {
            errorBox.classList.add('is-visible');
        }, 650);
    }
    
    function mostrarNotificacionExito() {
        const successBox = document.getElementById('registerSuccess');
        successBox.classList.add('is-visible');
        setTimeout(() => {
            successBox.classList.remove('is-visible');
        }, 5000);
    }

    const successBox = document.getElementById('registerSuccess');
    const demoSuccess = new URLSearchParams(window.location.search).get('exito') === 'true';

    if (demoSuccess) {
        setTimeout(() => {
            successBox.classList.add('is-visible');
        }, 650);
    }
</script>
</body>
</html>
