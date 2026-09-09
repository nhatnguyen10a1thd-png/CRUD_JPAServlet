<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<title><c:out value="${product.productName}" default="Chi tiết sản phẩm"/> - Cửa Hàng</title>

<div>
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="<c:url value='/home'/>" class="text-decoration-none">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="<c:url value='/product'/>" class="text-decoration-none">Sản phẩm</a></li>
            <li class="breadcrumb-item active" aria-current="page"><c:out value="${product.productName}" default="Chi tiết"/></li>
        </ol>
    </nav>

    <c:choose>
        <c:when test="${not empty product}">
            <div class="card shadow-sm border-0 rounded-3 overflow-hidden">
                <div class="row g-0">
                    <div class="col-md-5 p-4 d-flex align-items-center justify-content-center bg-light">
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
                                <img src="<c:out value='${productImageUrl}'/>" alt="Ảnh sản phẩm: <c:out value='${product.productName}'/>"
                                     class="img-fluid rounded-3 shadow-sm" style="max-height: 380px; object-fit: contain;">
                            </c:when>
                            <c:otherwise>
                                <div class="text-muted text-center p-5">
                                    <i class="far fa-image fa-4x mb-2"></i>
                                    <p class="small">Chưa có ảnh</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-7 p-4 p-lg-5 d-flex flex-column justify-content-between">
                        <div>
                            <span class="badge bg-primary-subtle text-primary mb-2 px-3 py-2 fs-7 rounded-pill">
                                <c:out value="${product.category.categoryname}" default="Chưa phân loại"/>
                            </span>
                            <h1 class="h3 fw-bold text-dark mb-3"><c:out value="${product.productName}"/></h1>
                            <div class="fs-3 fw-bold text-danger mb-4">
                                <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="2"/> ₫
                            </div>
                            <div class="text-secondary mb-4 lh-base">
                                <c:choose>
                                    <c:when test="${not empty product.description}"><c:out value="${product.description}"/></c:when>
                                    <c:otherwise><span class="text-muted fst-italic">Sản phẩm này chưa có mô tả.</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div>
                            <a class="btn btn-outline-secondary d-inline-flex align-items-center gap-2" href="<c:url value='/product'/>">
                                <i class="fas fa-arrow-left"></i>Quay lại danh sách
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="p-5 text-center bg-white rounded-3 shadow-sm">
                <i class="fas fa-circle-exclamation fa-3x text-danger mb-3"></i>
                <h5>Không tìm thấy sản phẩm</h5>
                <p class="text-muted small">Sản phẩm không tồn tại hoặc đã ngừng hiển thị.</p>
                <a class="btn btn-primary btn-sm" href="<c:url value='/product'/>">Xem sản phẩm khác</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
