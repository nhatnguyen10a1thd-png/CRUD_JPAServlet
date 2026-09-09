<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="layout" value="auth" scope="request"/>

<title>Đăng Ký Thành Công - System Admin</title>

<div class="auth-card text-center">
    <!-- Header -->
    <div class="auth-header header-success">
        <div class="checkmark-circle">
            <i class="fas fa-check"></i>
        </div>
        <h1>Đăng Ký Thành Công!</h1>
        <p>Tài khoản của bạn đã được kích hoạt</p>
    </div>

    <!-- Body -->
    <div class="auth-body">
        <div class="alert alert-success border-0 bg-success-subtle text-success-emphasis mb-4 text-start">
            <p class="mb-0">
                <strong>Chúc mừng!</strong> Tài khoản của bạn đã được xác thực và kích hoạt thành công.
                Bây giờ bạn có thể đăng nhập và sử dụng hệ thống.
            </p>
        </div>

        <a href="<c:url value='/login'/>" class="btn btn-primary w-100 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2 mb-2">
            <i class="fas fa-arrow-right-to-bracket"></i>
            Đăng Nhập Ngay
        </a>
        <a href="<c:url value='/'/>" class="btn btn-outline-secondary w-100 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2">
            <i class="fas fa-house"></i>
            Về Trang Chủ
        </a>
    </div>
</div>
