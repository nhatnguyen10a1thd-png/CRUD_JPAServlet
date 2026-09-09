<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý danh mục - Product Management</title>
</head>
<body>
<!-- Breadcrumb -->
<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="<c:url value='/home'/>">Trang chủ</a></li>
        <li class="breadcrumb-item active" aria-current="page">Danh mục</li>
    </ol>
</nav>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4 page-header">
    <div>
        <h1>Quản lý danh mục</h1>
        <p class="text-muted mb-0">Thêm, chỉnh sửa và kiểm soát các danh mục sản phẩm trong hệ thống.</p>
    </div>
    <a class="btn btn-primary" href="<c:url value='/admin/category/add'/>">
        <i class="fas fa-plus me-1"></i>Thêm danh mục
    </a>
</div>

<!-- Table Card -->
<div class="card">
    <div class="card-header">Tất cả danh mục</div>
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
            <tr>
                <th>#</th>
                <th>Ảnh</th>
                <th>Tên danh mục</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty listcate}">
                    <c:forEach items="${listcate}" var="cate" varStatus="row">
                        <tr>
                            <td><c:out value="${row.index + 1}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty cate.images}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(fn:toLowerCase(cate.images), 'http://') or fn:startsWith(fn:toLowerCase(cate.images), 'https://')}">
                                                <c:url value="${cate.images}" var="categoryImageUrl"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:url value="/image" var="categoryImageUrl">
                                                    <c:param name="fname" value="${cate.images}"/>
                                                </c:url>
                                            </c:otherwise>
                                        </c:choose>
                                        <img src="<c:out value='${categoryImageUrl}'/>"
                                             alt="Ảnh danh mục: <c:out value='${cate.categoryname}'/>"
                                             class="thumb-img" loading="lazy">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="thumb-placeholder"><i class="far fa-image"></i></div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><strong><c:out value="${cate.categoryname}"/></strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${cate.status == 1}">
                                        <span class="badge bg-success">Đang hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">Đã khóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="d-flex gap-1">
                                    <c:url value="/admin/category/edit" var="editUrl">
                                        <c:param name="id" value="${cate.categoryId}"/>
                                    </c:url>
                                    <c:url value="/admin/category/delete" var="deleteUrl">
                                        <c:param name="id" value="${cate.categoryId}"/>
                                    </c:url>
                                    <a class="action-btn" href="<c:out value='${editUrl}'/>"
                                       title="Sửa" aria-label="Sửa danh mục">
                                        <i class="fas fa-pen"></i>
                                    </a>
                                    <a class="action-btn danger" href="<c:out value='${deleteUrl}'/>"
                                       onclick="return confirm('Bạn có chắc muốn xóa danh mục này?');"
                                       title="Xóa" aria-label="Xóa danh mục">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5">
                            <div class="empty-state">
                                <i class="fas fa-tags"></i>
                                <h3>Chưa có danh mục</h3>
                                <p>Hãy tạo danh mục đầu tiên trong hệ thống.</p>
                                <a class="btn btn-primary" href="<c:url value='/admin/category/add'/>">Thêm danh mục</a>
                            </div>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
