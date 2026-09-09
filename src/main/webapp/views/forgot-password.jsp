<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="layout" value="auth" scope="request"/>

<title>Quên Mật Khẩu - System Admin</title>

<div class="auth-card">
    <!-- Header -->
    <div class="auth-header header-amber">
        <div class="auth-icon-circle">
            <i class="fas fa-key"></i>
        </div>
        <h1>Quên Mật Khẩu</h1>
        <p>Nhập email để nhận mã xác thực OTP</p>
    </div>

    <!-- Body -->
    <div class="auth-body">
        <!-- Error -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3">
                <i class="fas fa-circle-exclamation"></i>
                <div>${error}</div>
            </div>
        </c:if>

        <div class="alert alert-info d-flex align-items-start gap-2 mb-4">
            <i class="fas fa-circle-info mt-1"></i>
            <div class="small">Chúng tôi sẽ gửi mã OTP 6 chữ số đến email đăng ký của bạn để xác nhận danh tính trước khi đặt lại mật khẩu.</div>
        </div>

        <form action="<c:url value='/forgot-password'/>" method="post" autocomplete="off">
            <div class="mb-4">
                <label for="email" class="form-label fw-semibold">Địa chỉ Email</label>
                <div class="input-icon-wrapper">
                    <input type="email" name="email" id="email" class="form-control"
                           placeholder="Nhập email đã đăng ký" value="${email}" required autofocus>
                    <i class="fas fa-envelope input-icon"></i>
                </div>
            </div>

            <button type="submit" class="btn btn-warning text-white w-100 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2" id="btnSubmit">
                <i class="fas fa-paper-plane"></i>
                Gửi Mã OTP
            </button>
        </form>

        <div class="text-center pt-4 mt-4 border-top">
            <a href="<c:url value='/login'/>" class="text-secondary small text-decoration-none fw-semibold">
                <i class="fas fa-arrow-left me-1"></i> Quay lại đăng nhập
            </a>
        </div>
    </div>
</div>
