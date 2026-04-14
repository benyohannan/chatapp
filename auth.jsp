<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>ChatApp - Auth</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            height: 100vh;
            margin: 0;
            background: radial-gradient(circle at 15% 20%, rgba(37, 211, 102, 0.22) 0%, rgba(37, 211, 102, 0) 34%),
                        radial-gradient(circle at 85% 85%, rgba(18, 140, 126, 0.18) 0%, rgba(18, 140, 126, 0) 32%),
                        linear-gradient(120deg, #f4f7fb, #e9eef4);
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.5s;
            font-family: 'Poppins', 'Segoe UI', Tahoma, sans-serif;
            position: relative;
            overflow: hidden;
        }

        body.dark {
            background: radial-gradient(circle at 15% 20%, rgba(37, 211, 102, 0.24) 0%, rgba(37, 211, 102, 0) 35%),
                        radial-gradient(circle at 85% 85%, rgba(83, 189, 235, 0.19) 0%, rgba(83, 189, 235, 0) 29%),
                        #0b141a;
        }

        .glass-card {
            width: 100%;
            max-width: 420px;
            min-height: 560px;
            padding: 30px;
            border-radius: 20px;
            backdrop-filter: blur(20px);
            background: rgba(255, 255, 255, 0.68);
            box-shadow: 0 18px 46px rgba(0, 0, 0, 0.13);
            color: #222;
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.42);
            z-index: 2;
            opacity: 1;
            transform: translateY(0) scale(1);
            transition: opacity 0.45s ease, transform 0.45s ease;
        }

        body.booting .glass-card,
        body.booting .theme-toggle {
            opacity: 0;
            transform: translateY(24px) scale(0.98);
            pointer-events: none;
        }

        body.auth-ready .glass-card,
        body.auth-ready .theme-toggle {
            opacity: 1;
            transform: translateY(0) scale(1);
        }

        .form-control {
            border-radius: 12px;
            background: rgba(236, 242, 251, 0.9);
            border: 1px solid rgba(170, 185, 206, 0.46);
            color: #222;
            font-weight: 500;
        }

        .form-control::placeholder {
            color: #667085;
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.92);
            color: #000;
            box-shadow: 0 0 0 3px rgba(37, 211, 102, 0.16);
            border-color: rgba(16, 128, 87, 0.35);
        }

        .btn-custom {
            border-radius: 25px;
            padding: 10px;
            font-weight: 700;
            transition: transform 0.25s ease;
        }

        .btn-custom:hover {
            transform: scale(1.02);
        }

        .toggle-text {
            cursor: pointer;
            text-decoration: underline;
        }

        .form-box {
            position: absolute;
            left: 30px;
            right: 30px;
            top: 30px;
            bottom: 120px;
            overflow-y: auto;
            padding-right: 4px;
            transition: opacity 0.35s ease, transform 0.35s ease;
        }

        .form-box::-webkit-scrollbar {
            width: 6px;
        }

        .form-box::-webkit-scrollbar-thumb {
            background: rgba(16, 80, 53, 0.25);
            border-radius: 999px;
        }

        .hidden {
            opacity: 0;
            transform: translateX(24px);
            pointer-events: none;
        }

        .active {
            opacity: 1;
            transform: translateX(0);
            pointer-events: auto;
            z-index: 2;
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 10px;
            cursor: pointer;
        }

        .strength {
            height: 5px;
            border-radius: 5px;
            margin-top: 5px;
        }

        .weak {
            background: red;
            width: 33%;
        }

        .medium {
            background: orange;
            width: 66%;
        }

        .strong {
            background: green;
            width: 100%;
        }

        .theme-toggle {
            position: absolute;
            top: 20px;
            right: 20px;
            cursor: pointer;
            font-size: 20px;
            z-index: 4;
            transition: opacity 0.45s ease, transform 0.45s ease;
        }

        .ambient-orb {
            position: absolute;
            border-radius: 999px;
            pointer-events: none;
            opacity: 0.5;
            animation: floatOrb 7s ease-in-out infinite;
        }

        .ambient-orb.one {
            width: 84px;
            height: 84px;
            right: -20px;
            bottom: 84px;
            background: radial-gradient(circle, rgba(16, 128, 87, 0.38), rgba(16, 128, 87, 0));
        }

        .ambient-orb.two {
            width: 60px;
            height: 60px;
            left: -12px;
            bottom: 110px;
            background: radial-gradient(circle, rgba(15, 157, 88, 0.35), rgba(15, 157, 88, 0));
            animation-delay: 1.5s;
        }

        .auth-features {
            position: absolute;
            left: 30px;
            right: 30px;
            bottom: 24px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            z-index: 1;
        }

        .feature-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .feature-pill {
            padding: 6px 11px;
            font-size: 11px;
            font-weight: 600;
            border-radius: 999px;
            letter-spacing: 0.03em;
            color: #0f5132;
            background: rgba(16, 128, 87, 0.13);
            border: 1px solid rgba(16, 128, 87, 0.24);
        }

        .feature-status {
            font-size: 12px;
            color: rgba(20, 20, 20, 0.75);
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #0f9d58;
            box-shadow: 0 0 0 0 rgba(15, 157, 88, 0.35);
            animation: pulseDot 1.9s ease-out infinite;
        }

        .auth-loader {
            position: fixed;
            inset: 0;
            z-index: 10;
            display: flex;
            align-items: center;
            justify-content: center;
            background: radial-gradient(circle at 15% 20%, #1f8d5f 0%, rgba(31, 141, 95, 0.06) 32%),
                        radial-gradient(circle at 85% 82%, #174d3d 0%, rgba(23, 77, 61, 0.04) 28%),
                        #f2f4f7;
            transition: opacity 0.8s ease, visibility 0.8s ease;
        }

        .auth-loader.hide {
            opacity: 0;
            visibility: hidden;
            pointer-events: none;
        }

        .loader-center {
            text-align: center;
            position: relative;
        }

        .brand-glow-burst {
            position: absolute;
            left: 50%;
            top: 42%;
            width: 56px;
            height: 56px;
            transform: translate(-50%, -50%) scale(0.2);
            border-radius: 50%;
            pointer-events: none;
            background:
                radial-gradient(circle, rgba(255, 255, 255, 0.95) 0%, rgba(255, 255, 255, 0.22) 28%, rgba(255, 255, 255, 0) 64%),
                radial-gradient(circle, rgba(31, 141, 95, 0.9) 0%, rgba(31, 141, 95, 0.15) 38%, rgba(31, 141, 95, 0) 70%);
            mix-blend-mode: screen;
            filter: blur(0.4px);
            opacity: 0;
            animation: glowBurst 1.05s ease-out 1.35s forwards;
        }

        .loader-ring {
            width: 170px;
            height: 170px;
            border-radius: 50%;
            margin: 0 auto 20px;
            border: 2px solid rgba(22, 101, 72, 0.16);
            border-top-color: rgba(22, 101, 72, 0.62);
            animation: spinRing 2.8s linear infinite, ringPulse 2.1s ease-in-out infinite;
        }

        .brand-title {
            margin: 0;
            font-size: 46px;
            font-weight: 700;
            letter-spacing: 0.02em;
            color: #0f5132;
            text-shadow: 0 10px 30px rgba(31, 141, 95, 0.2);
            animation: brandZoomOut 1.5s cubic-bezier(0.18, 0.7, 0.2, 1) forwards;
        }

        .brand-subtitle {
            margin-top: 10px;
            font-size: 13px;
            color: rgba(23, 36, 28, 0.72);
            letter-spacing: 0.07em;
            text-transform: uppercase;
            opacity: 0;
            transform: translateY(8px);
            animation: introFadeUp 0.75s ease 0.65s forwards;
        }

        .loader-line {
            margin: 16px auto 0;
            width: 220px;
            height: 4px;
            border-radius: 999px;
            background: rgba(22, 101, 72, 0.18);
            overflow: hidden;
            opacity: 0;
            transform: scaleX(0.88);
            transform-origin: center;
            animation: introFadeIn 0.7s ease 0.95s forwards;
        }

        .loader-line span {
            display: block;
            width: 40%;
            height: 100%;
            border-radius: inherit;
            background: linear-gradient(90deg, #0f9d58, #1f8d5f);
            animation: loaderSweep 1.05s ease-in-out infinite;
        }

        @keyframes loaderSweep {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(320%); }
        }

        @keyframes spinRing {
            to { transform: rotate(360deg); }
        }

        @keyframes ringPulse {
            0%, 100% {
                box-shadow: 0 0 0 0 rgba(15, 157, 88, 0.08);
            }
            50% {
                box-shadow: 0 0 0 16px rgba(15, 157, 88, 0);
            }
        }

        @keyframes brandZoomOut {
            0% {
                transform: scale(1.35);
                opacity: 0;
                filter: blur(10px);
            }
            45% {
                transform: scale(1.1);
                opacity: 1;
                filter: blur(0);
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }

        @keyframes introFadeUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes introFadeIn {
            to {
                opacity: 1;
                transform: scaleX(1);
            }
        }

        @keyframes glowBurst {
            0% {
                opacity: 0;
                transform: translate(-50%, -50%) scale(0.2);
            }
            25% {
                opacity: 1;
                transform: translate(-50%, -50%) scale(2.2);
            }
            100% {
                opacity: 0;
                transform: translate(-50%, -50%) scale(3.8);
            }
        }

        @keyframes floatOrb {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        @keyframes pulseDot {
            0% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(15, 157, 88, 0.3);
            }
            70% {
                transform: scale(1.05);
                box-shadow: 0 0 0 11px rgba(15, 157, 88, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(15, 157, 88, 0);
            }
        }

        body.dark .glass-card {
            background: rgba(17, 27, 33, 0.72);
            border-color: rgba(83, 189, 235, 0.12);
            color: #e9edef;
        }

        body.dark .form-control {
            background: rgba(255, 255, 255, 0.06);
            border-color: rgba(255, 255, 255, 0.12);
            color: #e9edef;
        }

        body.dark .form-control::placeholder {
            color: #aebac1;
        }

        body.dark .feature-pill {
            color: #bbf7d0;
            background: rgba(37, 211, 102, 0.14);
            border-color: rgba(37, 211, 102, 0.3);
        }

        body.dark .feature-status {
            color: rgba(233, 237, 239, 0.82);
        }

        body.dark .auth-loader {
            background: radial-gradient(circle at 15% 20%, rgba(31, 141, 95, 0.38) 0%, rgba(31, 141, 95, 0.05) 35%),
                        radial-gradient(circle at 85% 82%, rgba(83, 189, 235, 0.24) 0%, rgba(83, 189, 235, 0.04) 25%),
                        #0b141a;
        }

        body.dark .brand-title {
            color: #d1fae5;
        }

        body.dark .brand-subtitle {
            color: rgba(233, 237, 239, 0.78);
        }

        body.dark .brand-glow-burst {
            background:
                radial-gradient(circle, rgba(255, 255, 255, 0.85) 0%, rgba(255, 255, 255, 0.2) 30%, rgba(255, 255, 255, 0) 63%),
                radial-gradient(circle, rgba(83, 189, 235, 0.85) 0%, rgba(83, 189, 235, 0.18) 42%, rgba(83, 189, 235, 0) 74%);
        }

        @media (max-width: 576px) {
            .glass-card {
                min-height: 600px;
                padding: 22px;
            }

            .form-box {
                left: 22px;
                right: 22px;
                top: 22px;
                bottom: 134px;
            }

            .auth-features {
                left: 22px;
                right: 22px;
            }

            .loader-ring {
                width: 140px;
                height: 140px;
            }

            .brand-title {
                font-size: 38px;
            }

            .loader-line {
                width: 180px;
            }
        }
    </style>
</head>

<body class="booting">

<%
    String error = request.getParameter("error");
%>

<div id="authLoader" class="auth-loader" aria-live="polite" aria-label="Loading ZyncChat">
    <div class="loader-center">
        <div class="brand-glow-burst" aria-hidden="true"></div>
        <div class="loader-ring"></div>
        <h1 class="brand-title">ZyncChat</h1>
        <div class="brand-subtitle">Loading secure chat experience</div>
        <div class="loader-line"><span></span></div>
    </div>
</div>

<div class="theme-toggle" onclick="toggleTheme()">🌙</div>

<div class="glass-card">
    <div class="ambient-orb one"></div>
    <div class="ambient-orb two"></div>

    <div id="loginForm" class="form-box active">
        <h2 class="text-center mb-4">Login</h2>
        <% if ("invalid_credentials".equals(error)) { %>
            <div class="alert alert-danger" role="alert">Invalid username or password.</div>
        <% } else if ("server".equals(error)) { %>
            <div class="alert alert-danger" role="alert">Server error during login. Please try again.</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post" class="auth-submit-form" data-loader-text="Signing you in">
            <div class="mb-3">
                <input type="text" class="form-control" name="username" placeholder="Username or Email" required>
            </div>

            <div class="mb-3 position-relative">
                <input type="password" id="loginPass" class="form-control" name="password" placeholder="Password" required>
                <span class="password-toggle" onclick="togglePassword('loginPass')">👁️</span>
            </div>

            <button type="submit" class="btn btn-success w-100 btn-custom">Login</button>
        </form>

        <p class="text-center mt-3">
            New user? <span class="toggle-text" onclick="toggleForm()">Sign up</span>
        </p>
    </div>

    <div id="registerForm" class="form-box hidden">
        <h2 class="text-center mb-4">Register</h2>
        <form action="${pageContext.request.contextPath}/register" method="post" class="auth-submit-form" data-loader-text="Creating your account">
            <div class="mb-3">
                <input type="text" class="form-control" name="firstName" placeholder="First Name" required>
            </div>

            <div class="mb-3">
                <input type="text" class="form-control" name="lastName" placeholder="Last Name" required>
            </div>

            <div class="mb-3">
                <input type="text" class="form-control" name="username" placeholder="Username" required>
            </div>

            <div class="mb-3">
                <input type="email" class="form-control" name="email" placeholder="Email" required>
            </div>

            <div class="mb-3 position-relative">
                <input type="password" id="regPass" class="form-control" name="password" placeholder="Password" onkeyup="checkStrength()" required>
                <span class="password-toggle" onclick="togglePassword('regPass')">👁️</span>
                <div id="strengthBar" class="strength"></div>
            </div>

            <button type="submit" class="btn btn-primary w-100 btn-custom">Register</button>
        </form>

        <p class="text-center mt-3">
            Already have an account? <span class="toggle-text" onclick="toggleForm()">Login</span>
        </p>
    </div>

    <div class="auth-features" aria-hidden="true">
        <div class="feature-pills">
            <span class="feature-pill">Real-time Sync</span>
            <span class="feature-pill">Instant Rooms</span>
            <span class="feature-pill">Secure Login</span>
        </div>
        <div class="feature-status">
            <span class="status-dot"></span>
            Server connection ready for instant messaging
        </div>
    </div>
</div>

<script>
    let isAuthTransitionRunning = false;

    function runAuthIntro() {
        const loader = document.getElementById("authLoader");

        window.setTimeout(function() {
            document.body.classList.remove("booting");
            document.body.classList.add("auth-ready");

            if (loader) {
                loader.classList.add("hide");
                window.setTimeout(function() {
                    loader.style.display = "none";
                }, 820);
            }
        }, 2000);
    }

    function toggleForm() {
        if (isAuthTransitionRunning) {
            return;
        }

        const loginForm = document.getElementById("loginForm");
        const registerForm = document.getElementById("registerForm");
        const showingLogin = loginForm.classList.contains("active");

        isAuthTransitionRunning = true;

        if (showingLogin) {
            loginForm.classList.remove("active");
            loginForm.classList.add("hidden");
            registerForm.classList.remove("hidden");
            registerForm.classList.add("active");
        } else {
            registerForm.classList.remove("active");
            registerForm.classList.add("hidden");
            loginForm.classList.remove("hidden");
            loginForm.classList.add("active");
        }

        window.setTimeout(function() {
            isAuthTransitionRunning = false;
        }, 380);
    }

    function togglePassword(id) {
        const input = document.getElementById(id);
        input.type = input.type === "password" ? "text" : "password";
    }

    function checkStrength() {
        const pass = document.getElementById("regPass").value;
        const bar = document.getElementById("strengthBar");

        if (pass.length < 6) {
            bar.className = "strength weak";
        } else if (pass.match(/[A-Z]/) && pass.match(/[0-9]/)) {
            bar.className = "strength strong";
        } else {
            bar.className = "strength medium";
        }
    }

    function toggleTheme() {
        document.body.classList.toggle("dark");
    }

    document.addEventListener("DOMContentLoaded", function() {
        runAuthIntro();

        document.querySelectorAll('.auth-submit-form').forEach(function(form) {
            form.addEventListener('submit', function() {
                var loader = document.getElementById('authLoader');
                var subtitle = loader ? loader.querySelector('.brand-subtitle') : null;
                var customText = form.getAttribute('data-loader-text') || 'Loading secure chat experience';

                if (subtitle) {
                    subtitle.textContent = customText;
                }
                if (loader) {
                    loader.style.display = 'flex';
                    loader.classList.remove('hide');
                }
                document.body.classList.add('booting');
                document.body.classList.remove('auth-ready');
            });
        });
    });
</script>

</body>
</html>
