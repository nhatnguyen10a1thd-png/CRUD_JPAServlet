<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="layout" value="auth" scope="request"/>

<title>Đăng Nhập - System Admin</title>

<div class="auth-card">
    <!-- Header -->
    <div class="auth-header">
        <div class="auth-icon-circle">
            <i class="fas fa-right-to-bracket"></i>
        </div>
        <h1>Đăng Nhập</h1>
        <p>Chào mừng bạn trở lại hệ thống</p>
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

        <form action="<c:url value='/login'/>" method="post" autocomplete="off" class="needs-validation" novalidate>
            <!-- Username -->
            <div class="mb-3">
                <label for="username" class="form-label fw-semibold">Tên đăng nhập</label>
                <div class="input-icon-wrapper">
                    <input type="text" name="username" id="username" class="form-control"
                           maxlength="50" placeholder="Nhập tên đăng nhập" value="<c:out value='${username}'/>" required autofocus>
                    <i class="fas fa-user input-icon"></i>
                </div>
                <div class="invalid-feedback">Vui lòng nhập tên đăng nhập (tối đa 50 ký tự).</div>
            </div>

            <!-- Password -->
            <div class="mb-3">
                <label for="password" class="form-label fw-semibold">Mật khẩu</label>
                <div class="input-icon-wrapper">
                    <input type="password" name="password" id="password" class="form-control"
                           placeholder="Nhập mật khẩu" required>
                    <i class="fas fa-lock input-icon"></i>
                    <button type="button" class="toggle-password" id="togglePasswordBtn" title="Hiện/ẩn mật khẩu">
                        <i class="far fa-eye" id="togglePasswordIcon"></i>
                    </button>
                </div>
                <div class="invalid-feedback">Vui lòng nhập mật khẩu.</div>
            </div>

            <!-- Options -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="remember" id="remember" value="true">
                    <label class="form-check-label text-secondary small" for="remember">
                        Ghi nhớ đăng nhập
                    </label>
                </div>
                <a href="<c:url value='/forgot-password'/>" class="text-primary small text-decoration-none fw-semibold">
                    Quên mật khẩu?
                </a>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2">
                <i class="fas fa-arrow-right-to-bracket"></i>
                Đăng Nhập
            </button>
        </form>

        <!-- Footer -->
        <div class="text-center pt-4 mt-4 border-top">
            <p class="text-secondary small mb-0">
                Chưa có tài khoản?
                <a href="<c:url value='/register'/>" class="text-primary fw-semibold text-decoration-none">
                    Đăng ký ngay
                </a>
            </p>
        </div>
    </div>
</div>

<script>
    document.getElementById("togglePasswordBtn")?.addEventListener("click", function () {
        const passwordInput = document.getElementById("password");
        const icon = document.getElementById("togglePasswordIcon");
        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            icon.classList.replace("fa-eye", "fa-eye-slash");
        } else {
            passwordInput.type = "password";
            icon.classList.replace("fa-eye-slash", "fa-eye");
        }
    });
</script>
