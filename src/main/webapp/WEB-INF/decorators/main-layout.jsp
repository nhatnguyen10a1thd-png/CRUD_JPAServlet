<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/assets/css/product.css'/>">
    <sitemesh:write property='head'/>
</head>
<body>
<div class="admin-layout">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <a class="brand" href="<c:url value='/home'/>"><i class="fas fa-layer-group"></i><span>System Admin</span></a>
        </div>
        <nav class="sidebar-nav" aria-label="Điều hướng quản trị">
            <div class="nav-title">Tổng quan</div>
            <a class="admin-nav-item${pageContext.request.servletPath == '/home' ? ' active' : ''}"
               href="<c:url value='/home'/>"><i class="fas fa-chart-line"></i>Trang chủ</a>
            <a class="admin-nav-item${pageContext.request.servletPath == '/product' ? ' active' : ''}"
               href="<c:url value='/product'/>"><i class="fas fa-store"></i>Cửa hàng</a>
            <div class="nav-title" style="margin-top:22px">Quản lý</div>
            <a class="admin-nav-item${pageContext.request.servletPath.startsWith('/admin/categor') ? ' active' : ''}"
               href="<c:url value='/admin/categories'/>"><i class="fas fa-tags"></i>Danh mục</a>
            <a class="admin-nav-item${pageContext.request.servletPath.startsWith('/admin/product') ? ' active' : ''}"
               href="<c:url value='/admin/products'/>"><i class="fas fa-box"></i>Sản phẩm</a>
            <div class="nav-title" style="margin-top:22px">Tài khoản</div>
            <a class="admin-nav-item${pageContext.request.servletPath.startsWith('/profile') ? ' active' : ''}"
               href="<c:url value='/profile'/>"><i class="fas fa-user-circle"></i>Hồ sơ cá nhân</a>
        </nav>
    </aside>

    <div class="admin-main">
        <header class="admin-topbar">
            <span>Xin chào, <strong><c:out value="${sessionScope.loggedInFullname}" default="Administrator"/></strong></span>
            <a class="icon-action" href="<c:url value='/profile'/>" aria-label="Hồ sơ" title="Hồ sơ cá nhân"><i class="fas fa-user"></i></a>
            <a class="icon-action danger" href="<c:url value='/logout'/>" aria-label="Đăng xuất" title="Đăng xuất"><i class="fas fa-right-from-bracket"></i></a>
        </header>
        <main class="admin-content">
            <sitemesh:write property='body'/>
        </main>
    </div>
</div>
</body>
</html>
