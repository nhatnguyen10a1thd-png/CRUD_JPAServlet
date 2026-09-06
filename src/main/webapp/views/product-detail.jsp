<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${product.productName}" default="Chi tiết sản phẩm"/> - Product Store</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/assets/css/product.css'/>">
</head>
<body>
<header class="site-header">
    <div class="container site-header-inner">
        <a class="brand" href="<c:url value='/home'/>"><i class="fas fa-box-open"></i><span>Product Store</span></a>
        <nav class="site-nav" aria-label="Điều hướng chính">
            <a href="<c:url value='/home'/>">Trang chủ</a>
            <a class="active" href="<c:url value='/product'/>">Sản phẩm</a>
            <a href="<c:url value='/admin/products'/>">Quản trị</a>
        </nav>
    </div>
</header>

<main class="detail-shell">
    <div class="container">
        <div class="breadcrumbs">
            <a href="<c:url value='/home'/>">Trang chủ</a><i class="fas fa-chevron-right"></i>
            <a href="<c:url value='/product'/>">Sản phẩm</a><i class="fas fa-chevron-right"></i>
            <span><c:out value="${product.productName}" default="Chi tiết"/></span>
        </div>

        <c:choose>
            <c:when test="${not empty product}">
                <article class="detail-card">
                    <div class="detail-media">
                        <c:choose>
                            <c:when test="${not empty product.images}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(fn:toLowerCase(product.images), 'http://') or fn:startsWith(fn:toLowerCase(product.images), 'https://')}">
                                        <c:url value="${product.images}" var="productImageUrl"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url value="/image" var="productImageUrl"><c:param name="fname" value="${product.images}"/></c:url>
                                    </c:otherwise>
                                </c:choose>
                                <img src="<c:out value='${productImageUrl}'/>" alt="Ảnh sản phẩm: <c:out value='${product.productName}'/>">
                            </c:when>
                            <c:otherwise><div class="image-placeholder"><i class="far fa-image"></i></div></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="detail-info">
                        <span class="product-category"><c:out value="${product.category.categoryname}" default="Chưa phân loại"/></span>
                        <h1><c:out value="${product.productName}"/></h1>
                        <div class="detail-price"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="2"/> ₫</div>
                        <div class="detail-description">
                            <c:choose>
                                <c:when test="${not empty product.description}"><c:out value="${product.description}"/></c:when>
                                <c:otherwise>Sản phẩm này chưa có mô tả.</c:otherwise>
                            </c:choose>
                        </div>
                        <a class="btn btn-secondary" href="<c:url value='/product'/>"><i class="fas fa-arrow-left"></i>Quay lại danh sách</a>
                    </div>
                </article>
            </c:when>
            <c:otherwise>
                <div class="empty-state wide"><i class="fas fa-circle-exclamation"></i><h3>Không tìm thấy sản phẩm</h3><p>Sản phẩm không tồn tại hoặc đã ngừng hiển thị.</p><a class="btn btn-primary" href="<c:url value='/product'/>">Xem sản phẩm khác</a></div>
            </c:otherwise>
        </c:choose>
    </div>
</main>
</body>
</html>
