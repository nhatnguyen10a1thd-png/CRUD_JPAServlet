<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/></title>

    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Google Fonts Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Custom Styles -->
    <link rel="stylesheet" href="<c:url value='/assets/css/custom.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/product.css'/>">

    <sitemesh:write property='head'/>
</head>
<body>

<c:set var="currentUri"
       value="${not empty requestScope['jakarta.servlet.forward.request_uri']
               ? requestScope['jakarta.servlet.forward.request_uri']
               : pageContext.request.requestURI}"/>

<c:set var="isAuthPage"
       value="${requestScope.layout eq 'auth'
               or fn:contains(currentUri, '/login')
               or fn:contains(currentUri, '/register')
               or fn:contains(currentUri, '/forgot-password')
               or fn:contains(currentUri, '/verify-otp')
               or fn:contains(currentUri, '/verify-reset-otp')
               or fn:contains(currentUri, '/reset-password')
               or fn:contains(currentUri, '/reset-success')
               or fn:contains(currentUri, '/register-success')}"/>

<c:choose>
    <%-- ==================== AUTHENTICATION & STANDALONE PAGES ==================== --%>
    <c:when test="${isAuthPage}">
        <div class="auth-wrapper">
            <sitemesh:write property='body'/>
        </div>
    </c:when>

    <%-- ==================== ADMIN & APPLICATION PAGES ==================== --%>
    <c:otherwise>
        <div id="wrapper">
            <!-- ========== Sidebar ========== -->
            <div class="bg-dark text-white" id="sidebar-wrapper">
                <div class="sidebar-heading border-bottom border-secondary p-3">
                    <a href="<c:url value='/home'/>">
                        <i class="fas fa-layer-group me-2"></i>System Admin
                    </a>
                </div>
                <div class="list-group list-group-flush">
                    <%-- Section: Tổng quan --%>
                    <span class="list-group-item bg-dark text-secondary nav-section-title text-uppercase pt-3">Tổng quan</span>
                    <a class="list-group-item list-group-item-action bg-dark text-white ${fn:endsWith(currentUri, '/home') ? 'active' : ''}"
                       href="<c:url value='/home'/>">
                        <i class="fas fa-chart-line me-2"></i>Trang chủ
                    </a>
                    <a class="list-group-item list-group-item-action bg-dark text-white ${fn:endsWith(currentUri, '/product') or fn:contains(currentUri, '/product/detail') ? 'active' : ''}"
                       href="<c:url value='/product'/>">
                        <i class="fas fa-store me-2"></i>Cửa hàng
                    </a>

                    <%-- Section: Quản lý --%>
                    <span class="list-group-item bg-dark text-secondary nav-section-title text-uppercase pt-3">Quản lý</span>
                    <a class="list-group-item list-group-item-action bg-dark text-white ${fn:contains(currentUri, '/admin/categor') ? 'active' : ''}"
                       href="<c:url value='/admin/categories'/>">
                        <i class="fas fa-tags me-2"></i>Danh mục
                    </a>
                    <a class="list-group-item list-group-item-action bg-dark text-white ${fn:contains(currentUri, '/admin/product') ? 'active' : ''}"
                       href="<c:url value='/admin/products'/>">
                        <i class="fas fa-box me-2"></i>Sản phẩm
                    </a>

                    <%-- Section: Tài khoản --%>
                    <span class="list-group-item bg-dark text-secondary nav-section-title text-uppercase pt-3">Tài khoản</span>
                    <a class="list-group-item list-group-item-action bg-dark text-white ${fn:contains(currentUri, '/profile') ? 'active' : ''}"
                       href="<c:url value='/profile'/>">
                        <i class="fas fa-user-circle me-2"></i>Hồ sơ cá nhân
                    </a>
                </div>
            </div>

            <!-- ========== Page Content ========== -->
            <div id="page-content-wrapper">
                <!-- Top Navbar -->
                <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm px-4 topbar">
                    <button class="btn btn-sm btn-outline-secondary" id="menu-toggle" type="button">
                        <i class="fas fa-bars"></i>
                    </button>
                    <div class="ms-auto d-flex align-items-center gap-3">
                        <span class="d-none d-md-inline">Xin chào,
                            <strong><c:out value="${sessionScope.loggedInFullname}" default="Administrator"/></strong>
                        </span>
                        <a class="btn btn-sm btn-outline-primary" href="<c:url value='/profile'/>" title="Hồ sơ cá nhân">
                            <i class="fas fa-user"></i>
                        </a>
                        <a class="btn btn-sm btn-outline-danger" href="<c:url value='/logout'/>" title="Đăng xuất">
                            <i class="fas fa-right-from-bracket"></i>
                        </a>
                    </div>
                </nav>

                <!-- Main Content Area -->
                <main class="container-fluid p-4">
                    <sitemesh:write property='body'/>
                </main>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<!-- Bootstrap 5.3 JS Bundle (includes Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Toggle sidebar if menu-toggle button exists
    document.getElementById("menu-toggle")?.addEventListener("click", function () {
        document.getElementById("wrapper")?.classList.toggle("toggled");
    });
</script>
</body>
</html>
