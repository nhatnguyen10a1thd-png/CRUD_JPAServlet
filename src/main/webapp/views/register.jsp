<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản</title>

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>📝</text></svg>">

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
            --radius-md: 8px;
            --radius-lg: 16px;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
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

        .register-container {
            width: 100%;
            max-width: 520px;
            animation: slideUp 0.5s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .register-card {
            background: var(--bg-surface);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }

        .register-header {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            padding: 36px 40px 28px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .register-header::before {
            content: '';
            position: absolute;
            top: -40%;
            right: -20%;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.08);
        }

        .register-header::after {
            content: '';
            position: absolute;
            bottom: -30%;
            left: -10%;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.05);
        }

        .register-header .icon-circle {
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

        .register-header .icon-circle i {
            font-size: 24px;
            color: #ffffff;
        }

        .register-header h1 {
            color: #ffffff;
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 6px;
            position: relative;
        }

        .register-header p {
            color: rgba(255, 255, 255, 0.75);
            font-size: 14px;
            position: relative;
        }

        .register-body {
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

        .form-group label .required {
            color: var(--color-error);
            margin-left: 2px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 15px;
            transition: color 0.2s;
        }

        .input-wrapper input {
            width: 100%;
            padding: 11px 14px 11px 42px;
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

        .input-wrapper input:focus + i,
        .input-wrapper input:focus ~ i {
            color: var(--color-primary);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        /* Submit Button */
        .btn-register {
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
            margin-top: 8px;
        }

        .btn-register:hover {
            background: linear-gradient(135deg, #1d4ed8 0%, #1e3a8a 100%);
            transform: translateY(-1px);
            box-shadow: 0 8px 24px -4px rgba(37, 99, 235, 0.35);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        /* Footer Link */
        .register-footer {
            text-align: center;
            padding-top: 24px;
            border-top: 1px solid var(--border-color);
            margin-top: 24px;
        }

        .register-footer p {
            font-size: 14px;
            color: var(--text-secondary);
        }

        .register-footer a {
            color: var(--color-primary);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.2s;
        }

        .register-footer a:hover {
            color: var(--color-primary-hover);
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 560px) {
            .register-body {
                padding: 28px 24px 32px;
            }
            .register-header {
                padding: 28px 24px 22px;
            }
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="register-container">
    <div class="register-card">

        <!-- Header -->
        <div class="register-header">
            <div class="icon-circle">
                <i class="fas fa-user-plus"></i>
            </div>
            <h1>Tạo Tài Khoản Mới</h1>
            <p>Điền thông tin bên dưới để đăng ký</p>
        </div>

        <!-- Body -->
        <div class="register-body">

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <form action="<c:url value='/register'/>" method="post" autocomplete="off">

                <!-- Username -->
                <div class="form-group">
                    <label>Tên đăng nhập <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <input type="text" name="username" id="username"
                               placeholder="Nhập tên đăng nhập"
                               value="${username}" required>
                        <i class="fas fa-user" style="pointer-events: none;"></i>
                    </div>
                </div>

                <!-- Fullname -->
                <div class="form-group">
                    <label>Họ và tên <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <input type="text" name="fullname" id="fullname"
                               placeholder="Nhập họ và tên"
                               value="${fullname}" required>
                        <i class="fas fa-id-card" style="pointer-events: none;"></i>
                    </div>
                </div>

                <!-- Email & Phone -->
                <div class="form-row">
                    <div class="form-group">
                        <label>Email <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <input type="email" name="email" id="email"
                                   placeholder="email@example.com"
                                   value="${email}" required>
                            <i class="fas fa-envelope" style="pointer-events: none;"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <div class="input-wrapper">
                            <input type="tel" name="phone" id="phone"
                                   placeholder="0901234567"
                                   value="${phone}">
                            <i class="fas fa-phone" style="pointer-events: none;"></i>
                        </div>
                    </div>
                </div>

                <!-- Password & Confirm -->
                <div class="form-row">
                    <div class="form-group">
                        <label>Mật khẩu <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <input type="password" name="password" id="password"
                                   placeholder="Nhập mật khẩu" required>
                            <i class="fas fa-lock" style="pointer-events: none;"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Xác nhận mật khẩu <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <input type="password" name="confirmPassword" id="confirmPassword"
                                   placeholder="Nhập lại mật khẩu" required>
                            <i class="fas fa-lock" style="pointer-events: none;"></i>
                        </div>
                    </div>
                </div>

                <!-- Submit -->
                <button type="submit" class="btn-register" id="btnRegister">
                    <i class="fas fa-paper-plane"></i>
                    Đăng Ký
                </button>
            </form>

            <!-- Footer -->
            <div class="register-footer">
                <p>Đã có tài khoản? <a href="<c:url value='/'/>">Quay về trang chủ</a></p>
            </div>

        </div>
    </div>
</div>

</body>
</html>
