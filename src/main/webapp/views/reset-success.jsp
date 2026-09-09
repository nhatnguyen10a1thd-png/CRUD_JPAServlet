<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="layout" value="auth" scope="request"/>

<title>Đổi Mật Khẩu Thành Công - System Admin</title>

<div class="auth-card text-center">
    <!-- Header -->
    <div class="auth-header header-success">
        <div class="checkmark-circle">
            <i class="fas fa-check"></i>
        </div>
        <h1>Đổi Mật Khẩu Thành Công!</h1>
        <p>Mật khẩu của bạn đã được cập nhật</p>
    </div>

    <!-- Body -->
    <div class="auth-body">
        <div class="alert alert-success border-0 bg-success-subtle text-success-emphasis mb-4 text-start">
            <p class="mb-0">
                <strong>Hoàn tất!</strong> Mật khẩu tài khoản của bạn đã được đổi thành công.
                Bây giờ bạn có thể đăng nhập bằng mật khẩu mới.
            </p>
        </div>

        <a href="<c:url value='/login'/>" class="btn btn-primary w-100 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2">
            <i class="fas fa-arrow-right-to-bracket"></i>
            Đăng Nhập Ngay
        </a>
    </div>
</div>
