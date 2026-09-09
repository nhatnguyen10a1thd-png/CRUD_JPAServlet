<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thêm sản phẩm - Product Management</title>
</head>
<body>
<c:set var="draft" value="${formProduct}"/>

<!-- Breadcrumb -->
<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="<c:url value='/home'/>">Trang chủ</a></li>
        <li class="breadcrumb-item"><a href="<c:url value='/admin/products'/>">Sản phẩm</a></li>
        <li class="breadcrumb-item active" aria-current="page">Thêm mới</li>
    </ol>
</nav>

<!-- Page Header -->
<div class="mb-4 page-header">
    <h1>Thêm sản phẩm</h1>
    <p class="text-muted mb-0">Nhập đầy đủ thông tin để tạo sản phẩm mới.</p>
</div>

<!-- Error Alerts -->
<c:if test="${not empty error}">
    <div class="alert alert-danger d-flex align-items-center" role="alert">
        <i class="fas fa-circle-exclamation me-2"></i> <c:out value="${error}"/>
    </div>
</c:if>
<c:if test="${empty categories}">
    <div class="alert alert-danger" role="alert">
        Chưa có danh mục để gán cho sản phẩm.
        <a href="<c:url value='/admin/category/add'/>" class="alert-link"><strong>Thêm danh mục trước</strong></a>.
    </div>
</c:if>

<!-- Form Card -->
<div class="card">
    <div class="card-header">Thông tin sản phẩm</div>
    <div class="card-body">
        <form action="<c:url value='/admin/product/insert'/>" method="post" enctype="multipart/form-data">
            <div class="row g-3">
                <!-- Tên sản phẩm -->
                <div class="col-md-6">
                    <label class="form-label" for="productName">Tên sản phẩm <span class="required">*</span></label>
                    <input class="form-control" id="productName" name="productName" type="text"
                           maxlength="255" required autofocus value="<c:out value='${draft.productName}'/>">
                </div>

                <!-- Giá bán -->
                <div class="col-md-6">
                    <label class="form-label" for="price">Giá bán <span class="required">*</span></label>
                    <c:set var="priceValue" value="${not empty submittedPrice ? submittedPrice : draft.price}"/>
                    <input class="form-control" id="price" name="price" type="number" min="0" step="0.01"
                           required inputmode="decimal" value="<c:out value='${priceValue}'/>">
                </div>

                <!-- Danh mục -->
                <div class="col-md-6">
                    <label class="form-label" for="categoryId">Danh mục <span class="required">*</span></label>
                    <select class="form-select" id="categoryId" name="categoryId" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach items="${categories}" var="cate">
                            <c:choose>
                                <c:when test="${(not empty draft.category and draft.category.categoryId == cate.categoryId) or (empty draft.category and param.categoryId == cate.categoryId)}">
                                    <option value="<c:out value='${cate.categoryId}'/>" selected><c:out value="${cate.categoryname}"/></option>
                                </c:when>
                                <c:otherwise>
                                    <option value="<c:out value='${cate.categoryId}'/>"><c:out value="${cate.categoryname}"/></option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </div>

                <!-- Trạng thái -->
                <div class="col-md-6">
                    <label class="form-label" for="status">Trạng thái <span class="required">*</span></label>
                    <select class="form-select" id="status" name="status" required>
                        <c:choose>
                            <c:when test="${empty formProduct or draft.status == 1}">
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

                <!-- Mô tả -->
                <div class="col-12">
                    <label class="form-label" for="description">Mô tả</label>
                    <textarea class="form-control" id="description" name="description" rows="4"
                              maxlength="4000" placeholder="Mô tả chi tiết sản phẩm..."><c:out value="${draft.description}"/></textarea>
                </div>

                <!-- Đường dẫn ảnh -->
                <div class="col-md-6">
                    <label class="form-label" for="images">Đường dẫn ảnh</label>
                    <c:set var="draftIsRemote" value="${not empty draft.images and (fn:startsWith(fn:toLowerCase(draft.images), 'http://') or fn:startsWith(fn:toLowerCase(draft.images), 'https://'))}"/>
                    <c:set var="imageUrlValue" value="${not empty submittedImageUrl ? submittedImageUrl : (draftIsRemote ? draft.images : '')}"/>
                    <input class="form-control" id="images" name="images" type="url" maxlength="255"
                           placeholder="https://example.com/product.jpg" value="<c:out value='${imageUrlValue}'/>">
                    <span class="form-help">Có thể nhập URL HTTP/HTTPS hoặc tải tệp ảnh ở ô bên cạnh.</span>
                </div>

                <!-- Tải ảnh lên -->
                <div class="col-md-6">
                    <label class="form-label" for="images1">Tải ảnh lên</label>
                    <input class="form-control" id="images1" name="images1" type="file"
                           accept="image/png,image/jpeg,image/gif" onchange="previewUpload(this)">
                    <span class="form-help">PNG, JPG hoặc GIF. Nếu chọn tệp, tệp sẽ được ưu tiên.</span>
                    <div class="preview-box" id="imagePreview"><img alt="Xem trước ảnh được chọn"></div>
                </div>
            </div>

            <!-- Form Actions -->
            <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                <a class="btn btn-secondary" href="<c:url value='/admin/products'/>">Hủy</a>
                <c:choose>
                    <c:when test="${empty categories}">
                        <button class="btn btn-primary" type="submit" disabled>
                            <i class="fas fa-floppy-disk me-1"></i>Lưu sản phẩm
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-primary" type="submit">
                            <i class="fas fa-floppy-disk me-1"></i>Lưu sản phẩm
                        </button>
                    </c:otherwise>
                </c:choose>
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
