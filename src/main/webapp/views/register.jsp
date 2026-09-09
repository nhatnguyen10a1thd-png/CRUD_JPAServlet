<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="layout" value="auth" scope="request"/>

<title>Đăng Ký Tài Khoản - System Admin</title>

<div class="auth-card auth-card-wide">
    <!-- Header -->
    <div class="auth-header">
        <div class="auth-icon-circle">
            <i class="fas fa-user-plus"></i>
        </div>
        <h1>Tạo Tài Khoản Mới</h1>
        <p>Điền thông tin bên dưới để đăng ký tài khoản</p>
    </div>

    <!-- Body -->
    <div class="auth-body">
        <!-- Errors Alert -->
        <c:if test="${not empty errors}">
            <div class="alert alert-danger" role="alert">
                <div class="d-flex align-items-center mb-1 fw-semibold">
                    <i class="fas fa-circle-exclamation me-2"></i> Vui lòng kiểm tra các lỗi sau:
                </div>
                <ul class="mb-0 ps-3">
                    <c:forEach var="err" items="${errors}">
                        <li><c:out value="${err}"/></li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>
        <c:if test="${empty errors and not empty error}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3" role="alert">
                <i class="fas fa-circle-exclamation"></i>
                <div><c:out value="${error}"/></div>
            </div>
        </c:if>

        <form action="<c:url value='/register'/>" method="post" autocomplete="off" class="needs-validation" novalidate id="registerForm">
            <!-- Username & Fullname in 2 columns -->
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label for="username" class="form-label fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
                    <div class="input-icon-wrapper">
                        <input type="text" name="username" id="username" class="form-control"
                               placeholder="Nhập tên đăng nhập" value="<c:out value='${username}'/>"
                               pattern="^[a-zA-Z0-9_]{3,50}$" minlength="3" maxlength="50" required autofocus>
                        <i class="fas fa-user input-icon"></i>
                    </div>
                    <div class="invalid-feedback">Tên đăng nhập từ 3-50 ký tự, chỉ chứa chữ cái, số và gạch dưới.</div>
                </div>
                <div class="col-md-6">
                    <label for="fullname" class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                    <div class="input-icon-wrapper">
                        <input type="text" name="fullname" id="fullname" class="form-control"
                               placeholder="Nhập họ và tên" value="<c:out value='${fullname}'/>"
                               maxlength="100" required>
                        <i class="fas fa-id-card input-icon"></i>
                    </div>
                    <div class="invalid-feedback">Vui lòng nhập họ và tên (tối đa 100 ký tự).</div>
                </div>
            </div>

            <!-- Email & Phone in 2 columns -->
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label for="email" class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
                    <div class="input-icon-wrapper">
                        <input type="email" name="email" id="email" class="form-control"
                               placeholder="email@example.com" value="<c:out value='${email}'/>"
                               maxlength="100" required>
                        <i class="fas fa-envelope input-icon"></i>
                    </div>
                    <div class="invalid-feedback">Vui lòng nhập địa chỉ email hợp lệ.</div>
                </div>
                <div class="col-md-6">
                    <label for="phone" class="form-label fw-semibold">Số điện thoại</label>
                    <div class="input-icon-wrapper">
                        <input type="tel" name="phone" id="phone" class="form-control"
                               placeholder="0901234567" value="<c:out value='${phone}'/>"
                               pattern="^[0-9]{10,11}$">
                        <i class="fas fa-phone input-icon"></i>
                    </div>
                    <div class="invalid-feedback">Số điện thoại phải từ 10 đến 11 chữ số.</div>
                </div>
            </div>

            <!-- Password & Confirm Password in 2 columns -->
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label for="password" class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                    <div class="input-icon-wrapper">
                        <input type="password" name="password" id="password" class="form-control"
                               placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)" minlength="6" required>
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                    <div class="invalid-feedback">Mật khẩu phải có ít nhất 6 ký tự.</div>
                </div>
                <div class="col-md-6">
                    <label for="confirmPassword" class="form-label fw-semibold">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                    <div class="input-icon-wrapper">
                        <input type="password" name="confirmPassword" id="confirmPassword" class="form-control"
                               placeholder="Nhập lại mật khẩu" data-match="#password" required>
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                    <div class="invalid-feedback">Mật khẩu xác nhận không khớp.</div>
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2" id="btnRegister">
                <i class="fas fa-paper-plane"></i>
                Đăng Ký
            </button>
        </form>

        <!-- Footer -->
        <div class="text-center pt-4 mt-4 border-top">
            <p class="text-secondary small mb-0">
                Đã có tài khoản?
                <a href="<c:url value='/login'/>" class="text-primary fw-semibold text-decoration-none">
                    Đăng nhập ngay
                </a>
            </p>
        </div>
    </div>
</div>
