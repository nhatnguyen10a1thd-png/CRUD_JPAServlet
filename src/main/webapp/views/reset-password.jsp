<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lại Mật Khẩu</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🔑</text></svg>">

    <style>
        :root {
            --bg-body: #f0f4ff;
            --bg-surface: #ffffff;
            --color-primary: #2563eb;
            --color-primary-hover: #1d4ed8;
            --border-color: #e2e8f0;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --text-muted: #94a3b8;
            --color-error: #ef4444;
            --color-error-bg: #fef2f2;
            --color-error-border: #fecaca;
            --color-amber: #f59e0b;
            --color-amber-dark: #d97706;
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
                radial-gradient(at 80% 20%, hsla(220, 90%, 60%, 0.06) 0px, transparent 50%);
        }

        .reset-container {
            width: 100%;
            max-width: 440px;
            animation: slideUp 0.5s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .reset-card {
            background: var(--bg-surface);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }

        .reset-header {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            padding: 36px 40px 28px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .reset-header::before {
            content: '';
            position: absolute;
            top: -40%;
            right: -20%;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.08);
        }

        .reset-header .icon-circle {
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

        .reset-header .icon-circle i {
            font-size: 24px;
            color: #ffffff;
        }

        .reset-header h1 {
            color: #ffffff;
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 6px;
            position: relative;
        }

        .reset-header p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 14px;
            position: relative;
            line-height: 1.5;
        }

        .reset-body {
            padding: 36px 40px 40px;
        }

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

        .alert i {
            font-size: 16px;
            flex-shrink: 0;
        }

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

        .form-group label .required {
            color: var(--color-error);
            margin-left: 2px;
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
            border-color: var(--color-amber);
            box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.1);
        }

        .input-wrapper input:focus ~ i.input-icon {
            color: var(--color-amber);
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

        /* Password strength indicator */
        .password-hint {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .password-hint i {
            font-size: 12px;
        }

        .btn-reset {
            width: 100%;
            padding: 13px;
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
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
            margin-top: 8px;
        }

        .btn-reset:hover {
            background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
            transform: translateY(-1px);
            box-shadow: 0 8px 24px -4px rgba(245, 158, 11, 0.35);
        }

        .btn-reset:active {
            transform: translateY(0);
        }

        @media (max-width: 480px) {
            .reset-body { padding: 28px 24px 32px; }
            .reset-header { padding: 28px 24px 22px; }
        }
    </style>
</head>
<body>

<div class="reset-container">
    <div class="reset-card">

        <!-- Header -->
        <div class="reset-header">
            <div class="icon-circle">
                <i class="fas fa-lock-open"></i>
            </div>
            <h1>Đặt Lại Mật Khẩu</h1>
            <p>Nhập mật khẩu mới cho tài khoản của bạn</p>
        </div>

        <!-- Body -->
        <div class="reset-body">

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <form action="<c:url value='/reset-password'/>" method="post" autocomplete="off" id="resetForm">

                <!-- New Password -->
                <div class="form-group">
                    <label>Mật khẩu mới <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <input type="password" name="newPassword" id="newPassword"
                               placeholder="Nhập mật khẩu mới" required>
                        <i class="fas fa-lock input-icon"></i>
                        <button type="button" class="toggle-password" onclick="togglePass('newPassword', this)">
                            <i class="far fa-eye"></i>
                        </button>
                    </div>
                    <p class="password-hint">
                        <i class="fas fa-info-circle"></i>
                        Mật khẩu nên có ít nhất 6 ký tự
                    </p>
                </div>

                <!-- Confirm Password -->
                <div class="form-group">
                    <label>Xác nhận mật khẩu <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <input type="password" name="confirmPassword" id="confirmPassword"
                               placeholder="Nhập lại mật khẩu mới" required>
                        <i class="fas fa-lock input-icon"></i>
                        <button type="button" class="toggle-password" onclick="togglePass('confirmPassword', this)">
                            <i class="far fa-eye"></i>
                        </button>
                    </div>
                </div>

                <button type="submit" class="btn-reset" id="btnReset">
                    <i class="fas fa-key"></i>
                    Đặt Lại Mật Khẩu
                </button>
            </form>

        </div>
    </div>
</div>

<script>
    function togglePass(inputId, btn) {
        const input = document.getElementById(inputId);
        const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
        input.setAttribute('type', type);
        btn.querySelector('i').classList.toggle('fa-eye');
        btn.querySelector('i').classList.toggle('fa-eye-slash');
    }

    // Client-side password match validation
    document.getElementById('resetForm').addEventListener('submit', function(e) {
        const newPass = document.getElementById('newPassword').value;
        const confirmPass = document.getElementById('confirmPassword').value;
        if (newPass !== confirmPass) {
            e.preventDefault();
            alert('Mật khẩu xác nhận không khớp!');
        }
    });
</script>

</body>
</html>
