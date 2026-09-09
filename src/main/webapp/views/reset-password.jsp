<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="layout" value="auth" scope="request"/>

<title>Đặt Lại Mật Khẩu - System Admin</title>

<div class="auth-card">
    <!-- Header -->
    <div class="auth-header header-amber">
        <div class="auth-icon-circle">
            <i class="fas fa-lock-open"></i>
        </div>
        <h1>Đặt Lại Mật Khẩu</h1>
        <p>Nhập mật khẩu mới cho tài khoản của bạn</p>
    </div>

    <!-- Body -->
    <div class="auth-body">
        <c:if test="${not empty error}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3">
                <i class="fas fa-circle-exclamation"></i>
                <div>${error}</div>
            </div>
        </c:if>

        <form action="<c:url value='/reset-password'/>" method="post" autocomplete="off" id="resetForm">
            <!-- New Password -->
            <div class="mb-3">
                <label for="newPassword" class="form-label fw-semibold">Mật khẩu mới <span class="text-danger">*</span></label>
                <div class="input-icon-wrapper">
                    <input type="password" name="newPassword" id="newPassword" class="form-control"
                           placeholder="Nhập mật khẩu mới" required autofocus>
                    <i class="fas fa-lock input-icon"></i>
                    <button type="button" class="toggle-password" onclick="togglePass('newPassword', this)">
                        <i class="far fa-eye"></i>
                    </button>
                </div>
                <div class="form-text text-muted small mt-1">
                    <i class="fas fa-info-circle me-1"></i>Mật khẩu nên có ít nhất 6 ký tự
                </div>
            </div>

            <!-- Confirm Password -->
            <div class="mb-4">
                <label for="confirmPassword" class="form-label fw-semibold">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                <div class="input-icon-wrapper">
                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control"
                           placeholder="Nhập lại mật khẩu mới" required>
                    <i class="fas fa-lock input-icon"></i>
                    <button type="button" class="toggle-password" onclick="togglePass('confirmPassword', this)">
                        <i class="far fa-eye"></i>
                    </button>
                </div>
            </div>

            <button type="submit" class="btn btn-warning text-white w-100 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2" id="btnReset">
                <i class="fas fa-key"></i>
                Đặt Lại Mật Khẩu
            </button>
        </form>
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

    document.getElementById('resetForm').addEventListener('submit', function(e) {
        const newPass = document.getElementById('newPassword').value;
        const confirmPass = document.getElementById('confirmPassword').value;
        if (newPass !== confirmPass) {
            e.preventDefault();
            alert('Mật khẩu xác nhận không khớp!');
        }
    });
</script>
