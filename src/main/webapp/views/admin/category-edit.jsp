<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chỉnh sửa danh mục - Product Management</title>
</head>
<body>
<!-- Breadcrumb -->
<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="<c:url value='/home'/>">Trang chủ</a></li>
        <li class="breadcrumb-item"><a href="<c:url value='/admin/categories'/>">Danh mục</a></li>
        <li class="breadcrumb-item active" aria-current="page">Chỉnh sửa</li>
    </ol>
</nav>

<!-- Page Header -->
<div class="mb-4 page-header">
    <h1>Chỉnh sửa danh mục</h1>
    <p class="text-muted mb-0">Cập nhật thông tin danh mục #<c:out value="${cate.categoryId}"/>.</p>
</div>

<!-- Error Alert -->
<c:if test="${not empty error}">
    <div class="alert alert-danger d-flex align-items-center" role="alert">
        <i class="fas fa-circle-exclamation me-2"></i> <c:out value="${error}"/>
    </div>
</c:if>

<!-- Form Card -->
<div class="card">
    <div class="card-header">Thông tin danh mục</div>
    <div class="card-body">
        <form action="<c:url value='/admin/category/update'/>" method="post" enctype="multipart/form-data">
            <input type="hidden" name="categoryid" value="<c:out value='${cate.categoryId}'/>">

            <div class="row g-3">
                <!-- Tên danh mục -->
                <div class="col-12">
                    <label class="form-label" for="categoryname">
                        Tên danh mục <span class="required">*</span>
                    </label>
                    <input class="form-control" id="categoryname" name="categoryname" type="text"
                           maxlength="255" required autofocus value="<c:out value='${cate.categoryname}'/>">
                </div>

                <!-- Đường dẫn ảnh mới -->
                <div class="col-md-6">
                    <label class="form-label" for="images">Đường dẫn ảnh mới</label>
                    <c:set var="currentIsRemote" value="${not empty cate.images and (fn:startsWith(fn:toLowerCase(cate.images), 'http://') or fn:startsWith(fn:toLowerCase(cate.images), 'https://'))}"/>
                    <input class="form-control" id="images" name="images" type="url" maxlength="255"
                           value="<c:out value='${currentIsRemote ? cate.images : ""}'/>"
                           placeholder="https://example.com/image.jpg">
                    <span class="form-help">Để trống nếu muốn giữ ảnh hiện tại.</span>
                </div>

                <!-- Tải ảnh mới lên -->
                <div class="col-md-6">
                    <label class="form-label" for="images1">Tải ảnh mới lên</label>
                    <input class="form-control" id="images1" name="images1" type="file"
                           accept="image/png,image/jpeg,image/gif" onchange="previewUpload(this)">
                    <span class="form-help">Tệp tải lên được ưu tiên hơn đường dẫn ảnh.</span>
                    <div class="preview-box" id="imagePreview"><img alt="Xem trước ảnh mới"></div>
                </div>

                <!-- Trạng thái -->
                <div class="col-md-6">
                    <label class="form-label" for="status">Trạng thái <span class="required">*</span></label>
                    <select class="form-select" id="status" name="status" required>
                        <c:choose>
                            <c:when test="${cate.status == 1}">
                                <option value="1" selected>Đang hoạt động</option>
                                <option value="0">Đã khóa</option>
                            </c:when>
                            <c:otherwise>
                                <option value="1">Đang hoạt động</option>
                                <option value="0" selected>Đã khóa</option>
                            </c:otherwise>
                        </c:choose>
                    </select>
                </div>

                <!-- Ảnh hiện tại -->
                <c:if test="${not empty cate.images}">
                    <div class="col-12">
                        <label class="form-label">Ảnh hiện tại</label>
                        <div class="current-image">
                            <c:choose>
                                <c:when test="${currentIsRemote}">
                                    <c:url value="${cate.images}" var="currentImageUrl"/>
                                </c:when>
                                <c:otherwise>
                                    <c:url value="/image" var="currentImageUrl">
                                        <c:param name="fname" value="${cate.images}"/>
                                    </c:url>
                                </c:otherwise>
                            </c:choose>
                            <img src="<c:out value='${currentImageUrl}'/>"
                                 alt="Ảnh hiện tại của <c:out value='${cate.categoryname}'/>"
                                 class="thumb-img">
                            <span class="form-help mb-0">Ảnh này được giữ lại nếu bạn không chọn ảnh thay thế.</span>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Form Actions -->
            <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                <a class="btn btn-secondary" href="<c:url value='/admin/categories'/>">Hủy</a>
                <button class="btn btn-primary" type="submit">
                    <i class="fas fa-floppy-disk me-1"></i>Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function previewUpload(input) {
        const box = document.getElementById('imagePreview');
        const image = box.querySelector('img');
        if (!input.files || !input.files[0]) {
            box.classList.remove('visible');
            image.removeAttribute('src');
            return;
        }
        image.src = URL.createObjectURL(input.files[0]);
        image.onload = () => URL.revokeObjectURL(image.src);
        box.classList.add('visible');
    }
</script>
</body>
</html>
