<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Xác Thực OTP</title>

            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

            <link rel="icon"
                href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🔐</text></svg>">

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
                    --color-success: #22c55e;
                    --color-success-bg: #f0fdf4;
                    --color-success-border: #bbf7d0;
                    --radius-md: 8px;
                    --radius-lg: 16px;
                    --shadow-lg: 0 20px 60px -12px rgb(37 99 235 / 0.15), 0 8px 24px -8px rgb(0 0 0 / 0.08);
                }

                *,
                *::before,
                *::after {
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

                .otp-container {
                    width: 100%;
                    max-width: 460px;
                    animation: slideUp 0.5s cubic-bezier(0.16, 1, 0.3, 1);
                }

                @keyframes slideUp {
                    from {
                        opacity: 0;
                        transform: translateY(24px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .otp-card {
                    background: var(--bg-surface);
                    border-radius: var(--radius-lg);
                    box-shadow: var(--shadow-lg);
                    overflow: hidden;
                }

                .otp-header {
                    background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
                    padding: 36px 40px 28px;
                    text-align: center;
                    position: relative;
                    overflow: hidden;
                }

                .otp-header::before {
                    content: '';
                    position: absolute;
                    top: -40%;
                    right: -20%;
                    width: 200px;
                    height: 200px;
                    border-radius: 50%;
                    background: rgba(255, 255, 255, 0.08);
                }

                .otp-header .icon-circle {
                    width: 64px;
                    height: 64px;
                    background: rgba(255, 255, 255, 0.15);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 16px;
                    backdrop-filter: blur(4px);
                }

                .otp-header .icon-circle i {
                    font-size: 28px;
                    color: #ffffff;
                }

                .otp-header h1 {
                    color: #ffffff;
                    font-size: 22px;
                    font-weight: 700;
                    margin-bottom: 6px;
                    position: relative;
                }

                .otp-header p {
                    color: rgba(255, 255, 255, 0.75);
                    font-size: 14px;
                    position: relative;
                    line-height: 1.5;
                }

                .otp-header .email-highlight {
                    color: #ffffff;
                    font-weight: 600;
                }

                .otp-body {
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

                /* OTP Input Group */
                .otp-input-group {
                    display: flex;
                    gap: 10px;
                    justify-content: center;
                    margin-bottom: 28px;
                }

                .otp-input-group input {
                    width: 52px;
                    height: 60px;
                    text-align: center;
                    font-size: 24px;
                    font-weight: 700;
                    font-family: 'Inter', monospace;
                    color: var(--text-primary);
                    border: 2px solid var(--border-color);
                    border-radius: 12px;
                    background: #f8fafc;
                    transition: all 0.2s ease;
                    caret-color: var(--color-primary);
                }

                .otp-input-group input:focus {
                    outline: none;
                    border-color: var(--color-primary);
                    background: #ffffff;
                    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
                    transform: scale(1.05);
                }

                .otp-input-group input.filled {
                    border-color: var(--color-primary);
                    background: var(--bg-surface);
                }

                /* Countdown Timer */
                .timer-section {
                    text-align: center;
                    margin-bottom: 24px;
                }

                .timer-text {
                    font-size: 14px;
                    color: var(--text-secondary);
                }

                .timer-text .countdown {
                    font-weight: 700;
                    color: var(--color-primary);
                    font-size: 16px;
                }

                .timer-text .expired {
                    color: var(--color-error);
                    font-weight: 600;
                }

                /* Buttons */
                .btn-verify {
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

                .btn-verify:hover {
                    background: linear-gradient(135deg, #1d4ed8 0%, #1e3a8a 100%);
                    transform: translateY(-1px);
                    box-shadow: 0 8px 24px -4px rgba(37, 99, 235, 0.35);
                }

                .btn-verify:active {
                    transform: translateY(0);
                }

                .btn-verify:disabled {
                    opacity: 0.5;
                    cursor: not-allowed;
                    transform: none;
                    box-shadow: none;
                }

                .resend-section {
                    text-align: center;
                    margin-top: 24px;
                    padding-top: 24px;
                    border-top: 1px solid var(--border-color);
                }

                .resend-section p {
                    font-size: 14px;
                    color: var(--text-secondary);
                    margin-bottom: 8px;
                }

                .btn-resend {
                    background: none;
                    border: none;
                    color: var(--color-primary);
                    font-family: inherit;
                    font-size: 14px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: color 0.2s;
                    padding: 4px 8px;
                }

                .btn-resend:hover:not(:disabled) {
                    color: var(--color-primary-hover);
                    text-decoration: underline;
                }

                .btn-resend:disabled {
                    color: var(--text-muted);
                    cursor: not-allowed;
                }

                .back-link {
                    display: block;
                    text-align: center;
                    margin-top: 16px;
                    font-size: 13px;
                    color: var(--text-muted);
                    text-decoration: none;
                    transition: color 0.2s;
                }

                .back-link:hover {
                    color: var(--text-secondary);
                }

                @media (max-width: 480px) {
                    .otp-body {
                        padding: 28px 20px 32px;
                    }

                    .otp-header {
                        padding: 28px 20px 22px;
                    }

                    .otp-input-group input {
                        width: 44px;
                        height: 52px;
                        font-size: 20px;
                    }

                    .otp-input-group {
                        gap: 6px;
                    }
                }
            </style>
        </head>

        <body>

            <div class="otp-container">
                <div class="otp-card">

                    <!-- Header -->
                    <div class="otp-header">
                        <div class="icon-circle">
                            <i class="fas fa-shield-halved"></i>
                        </div>
                        <h1>Xác Thực Email</h1>
                        <p>
                            Chúng tôi đã gửi mã OTP 6 chữ số đến<br>
                            <span class="email-highlight">${sessionScope.otpEmail}</span>
                        </p>
                    </div>

                    <!-- Body -->
                    <div class="otp-body">

                        <!-- Error Message -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-error">
                                <i class="fas fa-exclamation-circle"></i>
                                <span>${error}</span>
                            </div>
                        </c:if>

                        <!-- Success Message -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">
                                <i class="fas fa-check-circle"></i>
                                <span>${success}</span>
                            </div>
                        </c:if>

                        <form action="<c:url value='/verify-otp'/>" method="post" id="otpForm">

                            <!-- 6 OTP Input Boxes -->
                            <div class="otp-input-group">
                                <input type="text" name="otp1" id="otp1" maxlength="1" autocomplete="off" autofocus
                                    required>
                                <input type="text" name="otp2" id="otp2" maxlength="1" autocomplete="off" required>
                                <input type="text" name="otp3" id="otp3" maxlength="1" autocomplete="off" required>
                                <input type="text" name="otp4" id="otp4" maxlength="1" autocomplete="off" required>
                                <input type="text" name="otp5" id="otp5" maxlength="1" autocomplete="off" required>
                                <input type="text" name="otp6" id="otp6" maxlength="1" autocomplete="off" required>
                            </div>

                            <!-- Countdown Timer -->
                            <div class="timer-section">
                                <p class="timer-text" id="timerText">
                                    Mã OTP hết hạn sau <span class="countdown" id="countdown">05:00</span>
                                </p>
                            </div>

                            <!-- Verify Button -->
                            <button type="submit" class="btn-verify" id="btnVerify">
                                <i class="fas fa-check-circle"></i>
                                Xác Thực
                            </button>
                        </form>

                        <!-- Resend Section -->
                        <div class="resend-section">
                            <p>Chưa nhận được mã?</p>
                            <form action="<c:url value='/resend-otp'/>" method="post" style="display: inline;">
                                <button type="submit" class="btn-resend" id="btnResend" disabled>
                                    <i class="fas fa-rotate-right"></i>
                                    Gửi lại mã (<span id="resendCountdown">60</span>s)
                                </button>
                            </form>
                        </div>

                        <a href="<c:url value='/register'/>" class="back-link">
                            <i class="fas fa-arrow-left"></i> Quay lại đăng ký
                        </a>

                    </div>
                </div>
            </div>

            <script>
                // ===== OTP Input Auto-Focus Logic =====
                const otpInputs = document.querySelectorAll('.otp-input-group input');

                otpInputs.forEach((input, index) => {
                    // Chỉ cho phép nhập số
                    input.addEventListener('input', (e) => {
                        const value = e.target.value;
                        // Chỉ giữ lại ký tự số
                        e.target.value = value.replace(/[^0-9]/g, '');

                        if (e.target.value.length === 1) {
                            e.target.classList.add('filled');
                            // Auto-focus sang ô tiếp theo
                            if (index < otpInputs.length - 1) {
                                otpInputs[index + 1].focus();
                            }
                        } else {
                            e.target.classList.remove('filled');
                        }
                    });

                    // Xử lý phím Backspace
                    input.addEventListener('keydown', (e) => {
                        if (e.key === 'Backspace' && !e.target.value && index > 0) {
                            otpInputs[index - 1].focus();
                            otpInputs[index - 1].value = '';
                            otpInputs[index - 1].classList.remove('filled');
                        }
                    });

                    // Xử lý paste OTP
                    input.addEventListener('paste', (e) => {
                        e.preventDefault();
                        const pasteData = e.clipboardData.getData('text').replace(/[^0-9]/g, '');
                        for (let i = 0; i < Math.min(pasteData.length, otpInputs.length - index); i++) {
                            otpInputs[index + i].value = pasteData[i];
                            otpInputs[index + i].classList.add('filled');
                        }
                        const focusIndex = Math.min(index + pasteData.length, otpInputs.length - 1);
                        otpInputs[focusIndex].focus();
                    });
                });

    // ===== Countdown Timer (5 phút) =====
    <%
                    long otpExpiry = session.getAttribute("otpExpiry") != null
                        ? (long) session.getAttribute("otpExpiry")
            : System.currentTimeMillis();
        long remainingMs = otpExpiry - System.currentTimeMillis();
                if (remainingMs < 0) remainingMs = 0;
    %>
                    let remainingSeconds = Math.floor(<%= remainingMs %> / 1000);

                const countdownEl = document.getElementById('countdown');
                const timerTextEl = document.getElementById('timerText');
                const btnVerify = document.getElementById('btnVerify');

                function updateCountdown() {
                    if (remainingSeconds <= 0) {
                        timerTextEl.innerHTML = '<span class="expired"><i class="fas fa-clock"></i> Mã OTP đã hết hạn!</span>';
                        btnVerify.disabled = true;
                        return;
                    }

                    const minutes = Math.floor(remainingSeconds / 60);
                    const seconds = remainingSeconds % 60;
                    countdownEl.textContent =
                        String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');

                    remainingSeconds--;
                    setTimeout(updateCountdown, 1000);
                }

                updateCountdown();

                // ===== Resend Button Cooldown (60 giây) =====
                let resendCooldown = 60;
                const btnResend = document.getElementById('btnResend');
                const resendCountdownEl = document.getElementById('resendCountdown');

                function updateResendCooldown() {
                    if (resendCooldown <= 0) {
                        btnResend.disabled = false;
                        btnResend.innerHTML = '<i class="fas fa-rotate-right"></i> Gửi lại mã OTP';
                        return;
                    }

                    resendCountdownEl.textContent = resendCooldown;
                    resendCooldown--;
                    setTimeout(updateResendCooldown, 1000);
                }

                updateResendCooldown();
            </script>

        </body>

        </html>