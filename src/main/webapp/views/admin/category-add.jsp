<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thêm danh mục - Product Management</title>
</head>
<body>
<!-- Breadcrumb -->
<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="<c:url value='/home'/>">Trang chủ</a></li>
        <li class="breadcrumb-item"><a href="<c:url value='/admin/categories'/>">Danh mục</a></li>
        <li class="breadcrumb-item active" aria-current="page">Thêm mới</li>
    </ol>
</nav>

<!-- Page Header -->
<div class="mb-4 page-header">
    <h1>Thêm danh mục</h1>
    <p class="text-muted mb-0">Nhập thông tin để tạo một danh mục sản phẩm mới.</p>
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
        <form action="<c:url value='/admin/category/insert'/>" method="post" enctype="multipart/form-data">
            <div class="row g-3">
                <!-- Tên danh mục -->
                <div class="col-12">
                    <label class="form-label" for="categoryname">
                        Tên danh mục <span class="required">*</span>
                    </label>
                    <input class="form-control" id="categoryname" name="categoryname" type="text"
                           maxlength="255" required autofocus value="<c:out value='${param.categoryname}'/>"
                           placeholder="Ví dụ: Điện tử, Thời trang">
                </div>

                <!-- Đường dẫn ảnh -->
                <div class="col-md-6">
                    <label class="form-label" for="images">Đường dẫn ảnh</label>
                    <input class="form-control" id="images" name="images" type="url" maxlength="255"
                           value="<c:out value='${param.images}'/>" placeholder="https://example.com/image.jpg">
                    <span class="form-help">Nhập URL HTTP/HTTPS hoặc tải tệp ảnh ở ô bên cạnh.</span>
                </div>

                <!-- Tải ảnh lên -->
                <div class="col-md-6">
                    <label class="form-label" for="images1">Tải ảnh lên</label>
                    <input class="form-control" id="images1" name="images1" type="file"
                           accept="image/png,image/jpeg,image/gif" onchange="previewUpload(this)">
                    <span class="form-help">Nếu chọn tệp, tệp tải lên sẽ được ưu tiên.</span>
                    <div class="preview-box" id="imagePreview"><img alt="Xem trước ảnh danh mục"></div>
                </div>

                <!-- Trạng thái -->
                <div class="col-md-6">
                    <label class="form-label" for="status">Trạng thái <span class="required">*</span></label>
                    <select class="form-select" id="status" name="status" required>
                        <option value="1" selected>Đang hoạt động</option>
                        <option value="0">Đã khóa</option>
                    </select>
                </div>
            </div>

            <!-- Form Actions -->
            <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                <a class="btn btn-secondary" href="<c:url value='/admin/categories'/>">Hủy</a>
                <button class="btn btn-primary" type="submit">
                    <i class="fas fa-floppy-disk me-1"></i>Lưu danh mục
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
