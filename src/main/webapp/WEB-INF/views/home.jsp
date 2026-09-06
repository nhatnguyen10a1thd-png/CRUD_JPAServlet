<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Product Management</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/assets/css/product.css'/>">
</head>
<body>
<div class="admin-layout">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <a class="brand" href="<c:url value='/home'/>"><i class="fas fa-layer-group"></i><span>System Admin</span></a>
        </div>
        <nav class="sidebar-nav" aria-label="Điều hướng quản trị">
            <div class="nav-title">Tổng quan</div>
            <a class="admin-nav-item active" href="<c:url value='/home'/>"><i class="fas fa-chart-line"></i>Trang chủ</a>
            <a class="admin-nav-item" href="<c:url value='/product'/>"><i class="fas fa-store"></i>Cửa hàng</a>
            <div class="nav-title" style="margin-top:22px">Quản lý</div>
            <a class="admin-nav-item" href="<c:url value='/admin/categories'/>"><i class="fas fa-tags"></i>Danh mục</a>
            <a class="admin-nav-item" href="<c:url value='/admin/products'/>"><i class="fas fa-box"></i>Sản phẩm</a>
        </nav>
    </aside>

    <div class="admin-main">
        <header class="admin-topbar">
            <span>Xin chào, <strong><c:out value="${sessionScope.loggedInFullname}" default="Administrator"/></strong></span>
            <a class="icon-action danger" href="<c:url value='/logout'/>" aria-label="Đăng xuất" title="Đăng xuất"><i class="fas fa-right-from-bracket"></i></a>
        </header>
        <main class="admin-content">
            <div class="admin-page-header">
                <div>
                    <p class="eyebrow">Dashboard</p>
                    <h1>Tổng quan hệ thống</h1>
                    <p>Quản lý danh mục, sản phẩm và theo dõi những sản phẩm vừa được thêm.</p>
                </div>
                <a class="btn btn-primary" href="<c:url value='/admin/product/add'/>"><i class="fas fa-plus"></i>Thêm sản phẩm</a>
            </div>

            <div class="product-grid" style="margin-bottom:38px">
                <article class="product-card">
                    <a class="product-card-link" href="<c:url value='/admin/categories'/>">
                        <div class="product-content">
                            <span class="product-category">Quản trị</span>
                            <h2 class="product-name"><i class="fas fa-tags" style="color:#2563eb;margin-right:8px"></i>Quản lý danh mục</h2>
                            <p style="color:#64748b">Tạo, cập nhật và sắp xếp các danh mục sản phẩm.</p>
                            <span class="view-link" style="margin-top:auto">Mở danh mục <i class="fas fa-arrow-right"></i></span>
                        </div>
                    </a>
                </article>
                <article class="product-card">
                    <a class="product-card-link" href="<c:url value='/admin/products'/>">
                        <div class="product-content">
                            <span class="product-category">Quản trị</span>
                            <h2 class="product-name"><i class="fas fa-box" style="color:#2563eb;margin-right:8px"></i>Quản lý sản phẩm</h2>
                            <p style="color:#64748b">Thêm, sửa, xóa và kiểm soát trạng thái sản phẩm.</p>
                            <span class="view-link" style="margin-top:auto">Mở sản phẩm <i class="fas fa-arrow-right"></i></span>
                        </div>
                    </a>
                </article>
                <article class="product-card">
                    <a class="product-card-link" href="<c:url value='/product'/>">
                        <div class="product-content">
                            <span class="product-category">Khách hàng</span>
                            <h2 class="product-name"><i class="fas fa-store" style="color:#2563eb;margin-right:8px"></i>Xem cửa hàng</h2>
                            <p style="color:#64748b">Duyệt toàn bộ sản phẩm theo từng trang.</p>
                            <span class="view-link" style="margin-top:auto">Đến cửa hàng <i class="fas fa-arrow-right"></i></span>
                        </div>
                    </a>
                </article>
            </div>

            <section aria-labelledby="newest-products-title">
                <div class="section-heading">
                    <div>
                        <h2 id="newest-products-title">10 sản phẩm mới nhất</h2>
                        <p>Các sản phẩm được sắp xếp theo thời gian tạo gần nhất.</p>
                    </div>
                    <a class="btn btn-secondary" href="<c:url value='/product'/>">Xem tất cả <i class="fas fa-arrow-right"></i></a>
                </div>

                <div class="product-grid">
                    <c:choose>
                        <c:when test="${not empty newestProducts}">
                            <c:forEach items="${newestProducts}" var="item">
                                <c:url value="/product/detail" var="detailUrl"><c:param name="id" value="${item.productId}"/></c:url>
                                <article class="product-card">
                                    <a class="product-card-link" href="<c:out value='${detailUrl}'/>">
                                        <div class="product-image">
                                            <c:choose>
                                                <c:when test="${not empty item.images}">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(fn:toLowerCase(item.images), 'http://') or fn:startsWith(fn:toLowerCase(item.images), 'https://')}">
                                                            <c:url value="${item.images}" var="productImageUrl"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:url value="/image" var="productImageUrl"><c:param name="fname" value="${item.images}"/></c:url>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <img src="<c:out value='${productImageUrl}'/>" alt="Ảnh sản phẩm: <c:out value='${item.productName}'/>" loading="lazy">
                                                </c:when>
                                                <c:otherwise><div class="image-placeholder"><i class="far fa-image"></i></div></c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="product-content">
                                            <span class="product-category"><c:out value="${item.category.categoryname}" default="Chưa phân loại"/></span>
                                            <h3 class="product-name"><c:out value="${item.productName}"/></h3>
                                            <div class="product-footer">
                                                <span class="product-price"><fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="2"/> ₫</span>
                                                <span class="view-link">Chi tiết <i class="fas fa-arrow-right"></i></span>
                                            </div>
                                        </div>
                                    </a>
                                </article>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state wide">
                                <i class="fas fa-box-open"></i><h3>Chưa có sản phẩm</h3>
                                <p>Hãy thêm sản phẩm đầu tiên để hiển thị tại đây.</p>
                                <a class="btn btn-primary" href="<c:url value='/admin/product/add'/>">Thêm sản phẩm</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </main>
    </div>
</div>
</body>
</html>
