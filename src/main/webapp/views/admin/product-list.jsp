<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm - Product Management</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/assets/css/product.css'/>">
</head>
<body>
<div class="admin-layout">
    <aside class="sidebar">
        <div class="sidebar-brand"><a class="brand" href="<c:url value='/home'/>"><i class="fas fa-layer-group"></i><span>System Admin</span></a></div>
        <nav class="sidebar-nav" aria-label="Điều hướng quản trị">
            <div class="nav-title">Tổng quan</div>
            <a class="admin-nav-item" href="<c:url value='/home'/>"><i class="fas fa-chart-line"></i>Trang chủ</a>
            <a class="admin-nav-item" href="<c:url value='/product'/>"><i class="fas fa-store"></i>Cửa hàng</a>
            <div class="nav-title" style="margin-top:22px">Quản lý</div>
            <a class="admin-nav-item" href="<c:url value='/admin/categories'/>"><i class="fas fa-tags"></i>Danh mục</a>
            <a class="admin-nav-item active" href="<c:url value='/admin/products'/>"><i class="fas fa-box"></i>Sản phẩm</a>
        </nav>
    </aside>

    <div class="admin-main">
        <header class="admin-topbar">
            <span><strong><c:out value="${sessionScope.loggedInFullname}" default="Administrator"/></strong></span>
            <a class="icon-action danger" href="<c:url value='/logout'/>" aria-label="Đăng xuất" title="Đăng xuất"><i class="fas fa-right-from-bracket"></i></a>
        </header>
        <main class="admin-content">
            <div class="breadcrumbs"><a href="<c:url value='/home'/>">Trang chủ</a><i class="fas fa-chevron-right"></i><span>Sản phẩm</span></div>
            <div class="admin-page-header">
                <div><h1>Quản lý sản phẩm</h1><p>Thêm, chỉnh sửa và kiểm soát toàn bộ sản phẩm trong hệ thống.</p></div>
                <a class="btn btn-primary" href="<c:url value='/admin/product/add'/>"><i class="fas fa-plus"></i>Thêm sản phẩm</a>
            </div>

            <c:set var="successMessage" value="${not empty requestScope.flashSuccess ? requestScope.flashSuccess : sessionScope.flashSuccess}"/>
            <c:set var="errorMessage" value="${not empty requestScope.flashError ? requestScope.flashError : sessionScope.flashError}"/>
            <c:if test="${not empty successMessage}"><div class="alert alert-success" role="status"><i class="fas fa-circle-check"></i> <c:out value="${successMessage}"/></div></c:if>
            <c:if test="${not empty errorMessage}"><div class="alert alert-error" role="alert"><i class="fas fa-circle-exclamation"></i> <c:out value="${errorMessage}"/></div></c:if>

            <section class="panel" aria-labelledby="all-products-heading">
                <div class="panel-heading" id="all-products-heading">Tất cả sản phẩm</div>
                <div class="table-wrap">
                    <table class="data-table">
                        <thead><tr><th>#</th><th>Ảnh</th><th>Tên sản phẩm</th><th>Giá</th><th>Danh mục</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty listProduct}">
                                <c:forEach items="${listProduct}" var="item" varStatus="row">
                                    <tr>
                                        <td><c:out value="${row.index + 1}"/></td>
                                        <td>
                                            <div class="thumb">
                                                <c:choose>
                                                    <c:when test="${not empty item.images}">
                                                        <c:choose>
                                                            <c:when test="${fn:startsWith(fn:toLowerCase(item.images), 'http://') or fn:startsWith(fn:toLowerCase(item.images), 'https://')}"><c:url value="${item.images}" var="productImageUrl"/></c:when>
                                                            <c:otherwise><c:url value="/image" var="productImageUrl"><c:param name="fname" value="${item.images}"/></c:url></c:otherwise>
                                                        </c:choose>
                                                        <img src="<c:out value='${productImageUrl}'/>" alt="Ảnh: <c:out value='${item.productName}'/>" loading="lazy">
                                                    </c:when>
                                                    <c:otherwise><div class="image-placeholder"><i class="far fa-image"></i></div></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td class="truncate"><strong><c:out value="${item.productName}"/></strong></td>
                                        <td style="white-space:nowrap"><fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="2"/> ₫</td>
                                        <td><c:out value="${item.category.categoryname}" default="Chưa phân loại"/></td>
                                        <td><c:choose><c:when test="${item.status == 1}"><span class="badge badge-success">Đang hoạt động</span></c:when><c:otherwise><span class="badge badge-danger">Đã khóa</span></c:otherwise></c:choose></td>
                                        <td>
                                            <div class="actions">
                                                <c:url value="/product/detail" var="detailUrl"><c:param name="id" value="${item.productId}"/></c:url>
                                                <c:url value="/admin/product/edit" var="editUrl"><c:param name="id" value="${item.productId}"/></c:url>
                                                <a class="icon-action" href="<c:out value='${detailUrl}'/>" aria-label="Xem chi tiết" title="Xem chi tiết"><i class="far fa-eye"></i></a>
                                                <a class="icon-action" href="<c:out value='${editUrl}'/>" aria-label="Sửa sản phẩm" title="Sửa"><i class="fas fa-pen"></i></a>
                                                <form class="inline-form" method="post" action="<c:url value='/admin/product/delete'/>" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">
                                                    <input type="hidden" name="id" value="<c:out value='${item.productId}'/>">
                                                    <button class="icon-action danger" type="submit" aria-label="Xóa sản phẩm" title="Xóa"><i class="fas fa-trash"></i></button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="7"><div class="empty-state"><i class="fas fa-box-open"></i><h3>Chưa có sản phẩm</h3><p>Hãy tạo sản phẩm đầu tiên trong hệ thống.</p><a class="btn btn-primary" href="<c:url value='/admin/product/add'/>">Thêm sản phẩm</a></div></td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>
</div>
</body>
</html>
