<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý sản phẩm - Product Management</title>
</head>
<body>
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
</body>
</html>
