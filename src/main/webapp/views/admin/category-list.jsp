<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý danh mục - Product Management</title>
</head>
<body>
<div class="breadcrumbs">
    <a href="<c:url value='/home'/>">Trang chủ</a>
    <i class="fas fa-chevron-right"></i>
    <span>Danh mục</span>
</div>

<div class="admin-page-header">
    <div>
        <h1>Quản lý danh mục</h1>
        <p>Thêm, chỉnh sửa và kiểm soát các danh mục sản phẩm trong hệ thống.</p>
    </div>
    <a class="btn btn-primary" href="<c:url value='/admin/category/add'/>">
        <i class="fas fa-plus"></i>Thêm danh mục
    </a>
</div>

<section class="panel" aria-labelledby="all-categories-heading">
    <div class="panel-heading" id="all-categories-heading">Tất cả danh mục</div>
    <div class="table-wrap">
        <table class="data-table">
            <thead>
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
                                <div class="thumb">
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
                                                 loading="lazy">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="image-placeholder"><i class="far fa-image"></i></div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                            <td class="truncate"><strong><c:out value="${cate.categoryname}"/></strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${cate.status == 1}">
                                        <span class="badge badge-success">Đang hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">Đã khóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="actions">
                                    <c:url value="/admin/category/edit" var="editUrl">
                                        <c:param name="id" value="${cate.categoryId}"/>
                                    </c:url>
                                    <c:url value="/admin/category/delete" var="deleteUrl">
                                        <c:param name="id" value="${cate.categoryId}"/>
                                    </c:url>
                                    <a class="icon-action" href="<c:out value='${editUrl}'/>"
                                       aria-label="Sửa danh mục" title="Sửa">
                                        <i class="fas fa-pen"></i>
                                    </a>
                                    <a class="icon-action danger" href="<c:out value='${deleteUrl}'/>"
                                       onclick="return confirm('Bạn có chắc muốn xóa danh mục này?');"
                                       aria-label="Xóa danh mục" title="Xóa">
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
</section>
</body>
</html>
