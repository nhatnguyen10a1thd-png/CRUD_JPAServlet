<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<title>Sản phẩm - Cửa Hàng</title>

<div>
    <!-- Page Heading -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="h4 mb-1 fw-bold text-dark">
                <i class="fas fa-store text-primary me-2"></i>Tất cả sản phẩm
            </h2>
            <p class="text-muted small mb-0">
                <c:choose>
                    <c:when test="${totalItems > 0}">Có <strong><c:out value="${totalItems}"/></strong> sản phẩm trong danh sách</c:when>
                    <c:otherwise>Chưa có sản phẩm nào</c:otherwise>
                </c:choose>
            </p>
        </div>
        <div>
            <a href="<c:url value='/admin/products'/>" class="btn btn-outline-primary btn-sm">
                <i class="fas fa-gear me-1"></i>Quản trị sản phẩm
            </a>
        </div>
    </div>

    <!-- Product Grid -->
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
                                <h3 class="product-name fs-6 fw-bold"><c:out value="${item.productName}"/></h3>
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
                <div class="empty-state wide p-5 text-center bg-white rounded-3 shadow-sm">
                    <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                    <h5 class="text-dark">Chưa có sản phẩm</h5>
                    <p class="text-muted small">Danh sách sản phẩm hiện đang trống.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 0}">
        <nav class="pagination mt-4 justify-content-center" aria-label="Phân trang sản phẩm">
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
