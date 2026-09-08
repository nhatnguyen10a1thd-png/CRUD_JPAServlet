<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thêm danh mục - Product Management</title>
</head>
<body>
<div class="breadcrumbs">
    <a href="<c:url value='/home'/>">Trang chủ</a>
    <i class="fas fa-chevron-right"></i>
    <a href="<c:url value='/admin/categories'/>">Danh mục</a>
    <i class="fas fa-chevron-right"></i>
    <span>Thêm mới</span>
</div>

<div class="admin-page-header">
    <div>
        <h1>Thêm danh mục</h1>
        <p>Nhập thông tin để tạo một danh mục sản phẩm mới.</p>
    </div>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-error" role="alert">
        <i class="fas fa-circle-exclamation"></i> <c:out value="${error}"/>
    </div>
</c:if>

<section class="panel form-panel">
    <div class="panel-heading">Thông tin danh mục</div>
    <form class="form-body" action="<c:url value='/admin/category/insert'/>"
          method="post" enctype="multipart/form-data">
        <div class="form-grid">
            <div class="form-group full">
                <label class="form-label" for="categoryname">
                    Tên danh mục <span class="required">*</span>
                </label>
                <input class="form-control" id="categoryname" name="categoryname" type="text"
                       maxlength="255" required autofocus value="<c:out value='${param.categoryname}'/>"
                       placeholder="Ví dụ: Điện tử, Thời trang">
            </div>

            <div class="form-group">
                <label class="form-label" for="images">Đường dẫn ảnh</label>
                <input class="form-control" id="images" name="images" type="url" maxlength="255"
                       value="<c:out value='${param.images}'/>" placeholder="https://example.com/image.jpg">
                <span class="form-help">Nhập URL HTTP/HTTPS hoặc tải tệp ảnh ở ô bên cạnh.</span>
            </div>

            <div class="form-group">
                <label class="form-label" for="images1">Tải ảnh lên</label>
                <input class="form-control" id="images1" name="images1" type="file"
                       accept="image/png,image/jpeg,image/gif" onchange="previewUpload(this)">
                <span class="form-help">Nếu chọn tệp, tệp tải lên sẽ được ưu tiên.</span>
                <div class="preview-box" id="imagePreview"><img alt="Xem trước ảnh danh mục"></div>
            </div>

            <div class="form-group">
                <label class="form-label" for="status">Trạng thái <span class="required">*</span></label>
                <select class="form-control" id="status" name="status" required>
                    <option value="1" selected>Đang hoạt động</option>
                    <option value="0">Đã khóa</option>
                </select>
            </div>
        </div>

        <div class="form-actions">
            <a class="btn btn-secondary" href="<c:url value='/admin/categories'/>">Hủy</a>
            <button class="btn btn-primary" type="submit">
                <i class="fas fa-floppy-disk"></i>Lưu danh mục
            </button>
        </div>
    </form>
</section>

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
