<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>ChatApp - Auth</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            height: 100vh;
            background: linear-gradient(120deg, rgba(255,255,255,0.2), rgba(200,200,200,0.1));
            background-size: cover;
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.5s;
        }

        body.dark {
            background: #0f2027;
        }

        @keyframes gradientBG {
            0% {background-position: 0% 50%;}
            50% {background-position: 100% 50%;}
            100% {background-position: 0% 50%;}
        }

        .glass-card {
            width: 100%;
            max-width: 420px;
            padding: 30px;
            border-radius: 20px;
            backdrop-filter: blur(20px);
            background: rgba(255, 255, 255, 0.35);
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            color: #222;
        }

        .form-control {
            border-radius: 12px;
            background: rgba(255,255,255,0.6);
            border: 1px solid rgba(255,255,255,0.4);
            color: #222;
            font-weight: 500;
        }

        .form-control::placeholder { color: #666; }

        .form-control:focus {
            background: rgba(255,255,255,0.85);
            color: #000;
            box-shadow: 0 0 5px rgba(0,0,0,0.1);
        }

        .btn-custom {
            border-radius: 25px;
            padding: 10px;
            font-weight: bold;
            transition: 0.3s;
        }

        .btn-custom:hover { transform: scale(1.05); }

        .toggle-text {
            cursor: pointer;
            text-decoration: underline;
        }

        .form-box { transition: all 0.6s ease-in-out; }

        .hidden {
            opacity: 0;
            transform: translateX(50px);
            position: absolute;
            pointer-events: none;
        }

        .active {
            opacity: 1;
            transform: translateX(0);
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

        .weak { background: red; width: 33%; }
        .medium { background: orange; width: 66%; }
        .strong { background: green; width: 100%; }

        .theme-toggle {
            position: absolute;
            top: 20px;
            right: 20px;
            cursor: pointer;
            font-size: 20px;
        }
    </style>
</head>

<body>

<div class="theme-toggle" onclick="toggleTheme()">🌙</div>

<div class="glass-card">

    <!-- LOGIN -->
    <div id="loginForm" class="form-box active">
        <h2 class="text-center mb-4">Login</h2>
        <form action="login" method="post">
            <div class="mb-3">
                <input type="text" class="form-control" name="username" placeholder="Username" required>
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

    <!-- REGISTER -->
    <div id="registerForm" class="form-box hidden">
        <h2 class="text-center mb-4">Register</h2>
        <form action="register" method="post">
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

</div>

<script>
    function toggleForm() {
        document.getElementById("loginForm").classList.toggle("hidden");
        document.getElementById("loginForm").classList.toggle("active");
        document.getElementById("registerForm").classList.toggle("hidden");
        document.getElementById("registerForm").classList.toggle("active");
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
</script>

</body>
</html>
