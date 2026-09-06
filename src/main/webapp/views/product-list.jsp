<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm - Product Management</title>
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

<main>
    <section class="hero">
        <div class="container page-heading">
            <p class="eyebrow">Cửa hàng</p>
            <h1>Tất cả sản phẩm</h1>
            <p>Khám phá danh sách sản phẩm mới nhất. Mỗi trang hiển thị tối đa 6 sản phẩm.</p>
        </div>
    </section>

    <section class="section" aria-labelledby="product-list-title">
        <div class="container">
            <div class="section-heading">
                <div>
                    <h2 id="product-list-title">Danh sách sản phẩm</h2>
                    <p>
                        <c:choose>
                            <c:when test="${totalItems > 0}">Có <strong><c:out value="${totalItems}"/></strong> sản phẩm</c:when>
                            <c:otherwise>Chưa có sản phẩm nào</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>

            <div class="product-grid">
                <c:choose>
                    <c:when test="${not empty listProduct}">
                        <c:forEach items="${listProduct}" var="item">
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
                                        <h2 class="product-name"><c:out value="${item.productName}"/></h2>
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
                        <div class="empty-state wide"><i class="fas fa-box-open"></i><h3>Chưa có sản phẩm</h3><p>Danh sách sản phẩm hiện đang trống.</p></div>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${totalPages > 0}">
                <nav class="pagination" aria-label="Phân trang sản phẩm">
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <c:url value="/product" var="previousUrl"><c:param name="page" value="${currentPage - 1}"/></c:url>
                            <a class="page-link" href="<c:out value='${previousUrl}'/>" aria-label="Trang trước"><i class="fas fa-chevron-left"></i><span>&nbsp;Trước</span></a>
                        </c:when>
                        <c:otherwise><span class="page-link disabled" aria-disabled="true"><i class="fas fa-chevron-left"></i><span>&nbsp;Trước</span></span></c:otherwise>
                    </c:choose>

                    <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                        <c:url value="/product" var="pageUrl"><c:param name="page" value="${pageNumber}"/></c:url>
                        <c:choose>
                            <c:when test="${pageNumber == currentPage}"><a class="page-link active" href="<c:out value='${pageUrl}'/>" aria-current="page"><c:out value="${pageNumber}"/></a></c:when>
                            <c:otherwise><a class="page-link" href="<c:out value='${pageUrl}'/>"><c:out value="${pageNumber}"/></a></c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <c:url value="/product" var="nextUrl"><c:param name="page" value="${currentPage + 1}"/></c:url>
                            <a class="page-link" href="<c:out value='${nextUrl}'/>" aria-label="Trang sau"><span>Sau&nbsp;</span><i class="fas fa-chevron-right"></i></a>
                        </c:when>
                        <c:otherwise><span class="page-link disabled" aria-disabled="true"><span>Sau&nbsp;</span><i class="fas fa-chevron-right"></i></span></c:otherwise>
                    </c:choose>
                </nav>
            </c:if>
        </div>
    </section>
</main>
</body>
</html>
