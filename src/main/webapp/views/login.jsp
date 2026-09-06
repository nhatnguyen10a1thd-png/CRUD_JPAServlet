<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập</title>

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🔑</text></svg>">

    <style>
        :root {
            --bg-body: #f0f4ff;
            --bg-surface: #ffffff;
            --color-primary: #2563eb;
            --color-primary-hover: #1d4ed8;
            --color-primary-light: #eff6ff;
            --border-color: #e2e8f0;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --text-muted: #94a3b8;
            --color-error: #ef4444;
            --color-error-bg: #fef2f2;
            --color-error-border: #fecaca;
            --color-success: #22c55e;
            --color-success-bg: #f0fdf4;
            --color-success-border: #bbf7d0;
            --radius-md: 8px;
            --radius-lg: 16px;
            --shadow-lg: 0 20px 60px -12px rgb(37 99 235 / 0.15), 0 8px 24px -8px rgb(0 0 0 / 0.08);
        }

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: var(--bg-body);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background-image:
                radial-gradient(at 20% 80%, hsla(220, 90%, 60%, 0.08) 0px, transparent 50%),
                radial-gradient(at 80% 20%, hsla(220, 90%, 60%, 0.06) 0px, transparent 50%),
                radial-gradient(at 50% 50%, hsla(220, 90%, 90%, 0.1) 0px, transparent 70%);
        }

        .login-container {
            width: 100%;
            max-width: 440px;
            animation: slideUp 0.5s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-card {
            background: var(--bg-surface);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }

        .login-header {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            padding: 36px 40px 28px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .login-header::before {
            content: '';
            position: absolute;
            top: -40%;
            right: -20%;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.08);
        }

        .login-header::after {
            content: '';
            position: absolute;
            bottom: -30%;
            left: -10%;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.05);
        }

        .login-header .icon-circle {
            width: 56px;
            height: 56px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            backdrop-filter: blur(4px);
        }

        .login-header .icon-circle i {
            font-size: 24px;
            color: #ffffff;
        }

        .login-header h1 {
            color: #ffffff;
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 6px;
            position: relative;
        }

        .login-header p {
            color: rgba(255, 255, 255, 0.75);
            font-size: 14px;
            position: relative;
        }

        .login-body {
            padding: 36px 40px 40px;
        }

        /* Alert Messages */
        .alert {
            padding: 12px 16px;
            border-radius: var(--radius-md);
            font-size: 13px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-error {
            background: var(--color-error-bg);
            border: 1px solid var(--color-error-border);
            color: var(--color-error);
        }

        .alert-success {
            background: var(--color-success-bg);
            border: 1px solid var(--color-success-border);
            color: var(--color-success);
        }

        .alert i {
            font-size: 16px;
            flex-shrink: 0;
        }

        /* Form Groups */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 6px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i.input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 15px;
            transition: color 0.2s;
            pointer-events: none;
        }

        .input-wrapper input {
            width: 100%;
            padding: 11px 42px 11px 42px;
            border: 1.5px solid var(--border-color);
            border-radius: var(--radius-md);
            font-family: inherit;
            font-size: 14px;
            color: var(--text-primary);
            background: var(--bg-surface);
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .input-wrapper input:focus {
            outline: none;
            border-color: var(--color-primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .input-wrapper input:focus ~ i.input-icon {
            color: var(--color-primary);
        }

        .toggle-password {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            font-size: 15px;
            padding: 0;
            transition: color 0.2s;
        }

        .toggle-password:hover {
            color: var(--text-secondary);
        }

        /* Remember & Forgot */
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: var(--text-secondary);
            cursor: pointer;
        }

        .remember-me input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: var(--color-primary);
            cursor: pointer;
        }

        .forgot-link {
            font-size: 13px;
            color: var(--color-primary);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.2s;
        }

        .forgot-link:hover {
            color: var(--color-primary-hover);
            text-decoration: underline;
        }

        /* Submit Button */
        .btn-login {
            width: 100%;
            padding: 13px;
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: #ffffff;
            border: none;
            border-radius: var(--radius-md);
            font-family: inherit;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-login:hover {
            background: linear-gradient(135deg, #1d4ed8 0%, #1e3a8a 100%);
            transform: translateY(-1px);
            box-shadow: 0 8px 24px -4px rgba(37, 99, 235, 0.35);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        /* Footer Link */
        .login-footer {
            text-align: center;
            padding-top: 24px;
            border-top: 1px solid var(--border-color);
            margin-top: 24px;
        }

        .login-footer p {
            font-size: 14px;
            color: var(--text-secondary);
        }

        .login-footer a {
            color: var(--color-primary);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.2s;
        }

        .login-footer a:hover {
            color: var(--color-primary-hover);
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .login-body {
                padding: 28px 24px 32px;
            }
            .login-header {
                padding: 28px 24px 22px;
            }
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-card">

        <!-- Header -->
        <div class="login-header">
            <div class="icon-circle">
                <i class="fas fa-right-to-bracket"></i>
            </div>
            <h1>Đăng Nhập</h1>
            <p>Chào mừng bạn trở lại hệ thống</p>
        </div>

        <!-- Body -->
        <div class="login-body">

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <!-- Success Message (e.g. after password reset) -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${success}</span>
                </div>
            </c:if>

            <form action="<c:url value='/login'/>" method="post" autocomplete="off">

                <!-- Username -->
                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <div class="input-wrapper">
                        <input type="text" name="username" id="username"
                               placeholder="Nhập tên đăng nhập"
                               value="${username}" required>
                        <i class="fas fa-user input-icon"></i>
                    </div>
                </div>

                <!-- Password -->
                <div class="form-group">
                    <label>Mật khẩu</label>
                    <div class="input-wrapper">
                        <input type="password" name="password" id="password"
                               placeholder="Nhập mật khẩu" required>
                        <i class="fas fa-lock input-icon"></i>
                        <button type="button" class="toggle-password" id="togglePassword"
                                aria-label="Hiện/ẩn mật khẩu">
                            <i class="far fa-eye"></i>
                        </button>
                    </div>
                </div>

                <!-- Remember & Forgot -->
                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember">
                        Ghi nhớ đăng nhập
                    </label>
                    <a href="<c:url value='/forgot-password'/>" class="forgot-link">
                        Quên mật khẩu?
                    </a>
                </div>

                <!-- Submit -->
                <button type="submit" class="btn-login" id="btnLogin">
                    <i class="fas fa-right-to-bracket"></i>
                    Đăng Nhập
                </button>
            </form>

            <!-- Footer -->
            <div class="login-footer">
                <p>Chưa có tài khoản? <a href="<c:url value='/register'/>">Đăng ký ngay</a></p>
            </div>

        </div>
    </div>
</div>

<script>
    // Toggle password visibility
    const toggleBtn = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');

    toggleBtn.addEventListener('click', () => {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        toggleBtn.querySelector('i').classList.toggle('fa-eye');
        toggleBtn.querySelector('i').classList.toggle('fa-eye-slash');
    });
</script>

</body>
</html>
