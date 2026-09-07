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
</body>
</html>
