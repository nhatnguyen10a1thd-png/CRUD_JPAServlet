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

<!-- Errors Alert -->
<c:if test="${not empty errors}">
    <div class="alert alert-danger" role="alert">
        <div class="d-flex align-items-center mb-1 fw-semibold">
            <i class="fas fa-circle-exclamation me-2"></i> Vui lòng kiểm tra các lỗi sau:
        </div>
        <ul class="mb-0 ps-3">
            <c:forEach var="err" items="${errors}">
                <li><c:out value="${err}"/></li>
            </c:forEach>
        </ul>
    </div>
</c:if>
<c:if test="${empty errors and not empty error}">
    <div class="alert alert-danger d-flex align-items-center" role="alert">
        <i class="fas fa-circle-exclamation me-2"></i> <c:out value="${error}"/>
    </div>
</c:if>

<!-- Form Card -->
<div class="card">
    <div class="card-header">Thông tin danh mục</div>
    <div class="card-body">
        <form action="<c:url value='/admin/category/insert'/>" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
            <div class="row g-3">
                <!-- Tên danh mục -->
                <div class="col-12">
                    <label class="form-label" for="categoryname">
                        Tên danh mục <span class="required text-danger">*</span>
                    </label>
                    <input class="form-control" id="categoryname" name="categoryname" type="text"
                           maxlength="255" required autofocus
                           value="<c:out value='${not empty cate.categoryname ? cate.categoryname : param.categoryname}'/>"
                           placeholder="Ví dụ: Điện tử, Thời trang">
                    <div class="invalid-feedback">Vui lòng nhập tên danh mục (tối đa 255 ký tự).</div>
                </div>

                <!-- Đường dẫn ảnh -->
                <div class="col-md-6">
                    <label class="form-label" for="images">Đường dẫn ảnh</label>
                    <input class="form-control" id="images" name="images" type="url" maxlength="255"
                           value="<c:out value='${not empty cate.images ? cate.images : param.images}'/>"
                           placeholder="https://example.com/image.jpg">
                    <span class="form-help text-muted small">Nhập URL HTTP/HTTPS hoặc tải tệp ảnh ở ô bên cạnh.</span>
                    <div class="invalid-feedback">URL ảnh không hợp lệ (phải bắt đầu bằng http:// hoặc https://).</div>
                </div>

                <!-- Tải ảnh lên -->
                <div class="col-md-6">
                    <label class="form-label" for="images1">Tải ảnh lên</label>
                    <input class="form-control" id="images1" name="images1" type="file"
                           accept="image/png,image/jpeg,image/gif" onchange="previewUpload(this)">
                    <span class="form-help text-muted small">Chấp nhận định dạng JPG, PNG, GIF (tối đa 5 MB).</span>
                    <div class="invalid-feedback">Chỉ chấp nhận tệp ảnh JPG, PNG, GIF và không vượt quá 5 MB.</div>
                    <div class="preview-box mt-2" id="imagePreview"><img alt="Xem trước ảnh danh mục" class="img-thumbnail" style="max-height: 120px;"></div>
                </div>

                <!-- Trạng thái -->
                <div class="col-md-6">
                    <label class="form-label" for="status">Trạng thái <span class="required text-danger">*</span></label>
                    <c:set var="currentStatus" value="${not empty cate.status ? cate.status : (not empty param.status ? param.status : 1)}"/>
                    <select class="form-select" id="status" name="status" required>
                        <option value="1" ${currentStatus == 1 ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="0" ${currentStatus == 0 ? 'selected' : ''}>Đã khóa</option>
                    </select>
                    <div class="invalid-feedback">Vui lòng chọn trạng thái danh mục.</div>
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
