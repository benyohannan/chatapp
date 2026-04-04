<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>ChatApp - Auth</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">

            <!-- Register Form -->
            <div class="card mb-4">
                <div class="card-body">
                    <h2 class="text-center">Register</h2>
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
                        <div class="mb-3">
                            <input type="password" class="form-control" name="password" placeholder="Password" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Register</button>
                    </form>
                </div>
            </div>

            <!-- Login Form -->
            <div class="card">
                <div class="card-body">
                    <h2 class="text-center">Login</h2>
                    <form action="login" method="post">
                        <div class="mb-3">
                            <input type="text" class="form-control" name="username" placeholder="Username" required>
                        </div>
                        <div class="mb-3">
                            <input type="password" class="form-control" name="password" placeholder="Password" required>
                        </div>
                        <button type="submit" class="btn btn-success w-100">Login</button>
                    </form>
                </div>
            </div>

        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>