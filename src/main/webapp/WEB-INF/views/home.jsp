<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Trang chủ - Product Management</title>
</head>
<body>
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4 page-header">
        <div>
            <p class="text-muted text-uppercase small fw-semibold mb-1">Dashboard</p>
            <h1>Tổng quan hệ thống</h1>
            <p class="text-muted">Quản lý danh mục, sản phẩm và theo dõi những sản phẩm vừa được thêm.</p>
        </div>
        <a class="btn btn-primary" href="<c:url value='/admin/product/add'/>">
            <i class="fas fa-plus me-1"></i>Thêm sản phẩm
        </a>
    </div>

    <!-- Stat Cards -->
    <div class="row row-cols-1 row-cols-md-3 g-4 mb-5">
        <div class="col">
            <div class="card h-100 stat-card">
                <div class="card-body">
                    <span class="badge bg-primary-subtle text-primary mb-2">Quản trị</span>
                    <h5 class="card-title"><i class="fas fa-tags text-primary me-2"></i>Quản lý danh mục</h5>
                    <p class="card-text text-muted">Tạo, cập nhật và sắp xếp các danh mục sản phẩm.</p>
                    <a class="view-link" href="<c:url value='/admin/categories'/>">
                        Mở danh mục <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card h-100 stat-card">
                <div class="card-body">
                    <span class="badge bg-primary-subtle text-primary mb-2">Quản trị</span>
                    <h5 class="card-title"><i class="fas fa-box text-primary me-2"></i>Quản lý sản phẩm</h5>
                    <p class="card-text text-muted">Thêm, sửa, xóa và kiểm soát trạng thái sản phẩm.</p>
                    <a class="view-link" href="<c:url value='/admin/products'/>">
                        Mở sản phẩm <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card h-100 stat-card">
                <div class="card-body">
                    <span class="badge bg-success-subtle text-success mb-2">Khách hàng</span>
                    <h5 class="card-title"><i class="fas fa-store text-primary me-2"></i>Xem cửa hàng</h5>
                    <p class="card-text text-muted">Duyệt toàn bộ sản phẩm theo từng trang.</p>
                    <a class="view-link" href="<c:url value='/product'/>">
                        Đến cửa hàng <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Newest Products Section -->
    <section aria-labelledby="newest-products-title">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
            <div>
                <h2 id="newest-products-title" class="h5 fw-bold">10 sản phẩm mới nhất</h2>
                <p class="text-muted small mb-0">Các sản phẩm được sắp xếp theo thời gian tạo gần nhất.</p>
            </div>
            <a class="btn btn-outline-secondary btn-sm" href="<c:url value='/product'/>">
                Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
            </a>
        </div>

        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-5 g-4">
            <c:choose>
                <c:when test="${not empty newestProducts}">
                    <c:forEach items="${newestProducts}" var="item">
                        <c:url value="/product/detail" var="detailUrl"><c:param name="id" value="${item.productId}"/></c:url>
                        <div class="col">
                            <div class="card h-100">
                                <a href="<c:out value='${detailUrl}'/>" class="text-decoration-none text-dark">
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
                                            <img src="<c:out value='${productImageUrl}'/>"
                                                 class="card-img-top product-card-img"
                                                 alt="Ảnh sản phẩm: <c:out value='${item.productName}'/>" loading="lazy">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="product-card-img-placeholder">
                                                <i class="far fa-image"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="card-body">
                                        <span class="badge bg-light text-muted mb-1"><c:out value="${item.category.categoryname}" default="Chưa phân loại"/></span>
                                        <h6 class="card-title mb-2"><c:out value="${item.productName}"/></h6>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="fw-bold text-primary">
                                                <fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="2"/> ₫
                                            </span>
                                            <span class="text-muted small">Chi tiết <i class="fas fa-arrow-right"></i></span>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="empty-state">
                            <i class="fas fa-box-open"></i>
                            <h3>Chưa có sản phẩm</h3>
                            <p>Hãy thêm sản phẩm đầu tiên để hiển thị tại đây.</p>
                            <a class="btn btn-primary" href="<c:url value='/admin/product/add'/>">Thêm sản phẩm</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</body>
</html>
