<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="layout" value="auth" scope="request"/>

<title>Xác Thực OTP - System Admin</title>

<div class="auth-card">
    <!-- Header -->
    <div class="auth-header">
        <div class="auth-icon-circle">
            <i class="fas fa-shield-halved"></i>
        </div>
        <h1>Xác Thực Email</h1>
        <p>
            Chúng tôi đã gửi mã OTP 6 chữ số đến<br>
            <strong class="text-warning"><c:out value="${sessionScope.otpEmail}"/></strong>
        </p>
    </div>

    <!-- Body -->
    <div class="auth-body">
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3">
                <i class="fas fa-circle-exclamation"></i>
                <div>${error}</div>
            </div>
        </c:if>

        <!-- Success Message -->
        <c:if test="${not empty success}">
            <div class="alert alert-success d-flex align-items-center gap-2 mb-3">
                <i class="fas fa-circle-check"></i>
                <div>${success}</div>
            </div>
        </c:if>

        <form action="<c:url value='/verify-otp'/>" method="post" id="otpForm">
            <!-- 6 OTP Input Boxes -->
            <div class="otp-input-group">
                <input type="text" name="otp1" id="otp1" maxlength="1" autocomplete="off" autofocus required>
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
            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2" id="btnVerify">
                <i class="fas fa-check-circle"></i>
                Xác Thực
            </button>
        </form>

        <!-- Resend Section -->
        <div class="resend-section">
            <p class="mb-2">Chưa nhận được mã?</p>
            <form action="<c:url value='/resend-otp'/>" method="post" class="d-inline">
                <button type="submit" class="btn btn-outline-secondary btn-sm" id="btnResend" disabled>
                    <i class="fas fa-rotate-right"></i>
                    Gửi lại mã (<span id="resendCountdown">60</span>s)
                </button>
            </form>
        </div>

        <div class="text-center pt-4 mt-4 border-top">
            <a href="<c:url value='/register'/>" class="text-secondary small text-decoration-none fw-semibold">
                <i class="fas fa-arrow-left me-1"></i> Quay lại đăng ký
            </a>
        </div>
    </div>
</div>

<script>
    // ===== OTP Input Auto-Focus Logic =====
    const otpInputs = document.querySelectorAll('.otp-input-group input');

    otpInputs.forEach((input, index) => {
        input.addEventListener('input', (e) => {
            const value = e.target.value;
            e.target.value = value.replace(/[^0-9]/g, '');

            if (e.target.value.length === 1) {
                e.target.classList.add('filled');
                if (index < otpInputs.length - 1) {
                    otpInputs[index + 1].focus();
                }
            } else {
                e.target.classList.remove('filled');
            }
        });

        input.addEventListener('keydown', (e) => {
            if (e.key === 'Backspace' && !e.target.value && index > 0) {
                otpInputs[index - 1].focus();
                otpInputs[index - 1].value = '';
                otpInputs[index - 1].classList.remove('filled');
            }
        });

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

    // ===== Countdown Timer =====
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
            timerTextEl.innerHTML = '<span class="text-danger fw-semibold"><i class="fas fa-clock me-1"></i> Mã OTP đã hết hạn!</span>';
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

    // ===== Resend Button Cooldown (60s) =====
    let resendCooldown = 60;
    const btnResend = document.getElementById('btnResend');
    const resendCountdownEl = document.getElementById('resendCountdown');

    function updateResendCooldown() {
        if (resendCooldown <= 0) {
            btnResend.disabled = false;
            btnResend.innerHTML = '<i class="fas fa-rotate-right me-1"></i> Gửi lại mã OTP';
            return;
        }

        resendCountdownEl.textContent = resendCooldown;
        resendCooldown--;
        setTimeout(updateResendCooldown, 1000);
    }

    updateResendCooldown();
</script>