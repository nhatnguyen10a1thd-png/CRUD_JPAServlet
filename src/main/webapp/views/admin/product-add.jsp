<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sản phẩm - Product Management</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/assets/css/product.css'/>">
</head>
<body>
<c:set var="draft" value="${formProduct}"/>
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
        <header class="admin-topbar"><strong><c:out value="${sessionScope.loggedInFullname}" default="Administrator"/></strong></header>
        <main class="admin-content">
            <div class="breadcrumbs"><a href="<c:url value='/home'/>">Trang chủ</a><i class="fas fa-chevron-right"></i><a href="<c:url value='/admin/products'/>">Sản phẩm</a><i class="fas fa-chevron-right"></i><span>Thêm mới</span></div>
            <div class="admin-page-header"><div><h1>Thêm sản phẩm</h1><p>Nhập đầy đủ thông tin để tạo sản phẩm mới.</p></div></div>

            <c:if test="${not empty error}"><div class="alert alert-error" role="alert"><i class="fas fa-circle-exclamation"></i> <c:out value="${error}"/></div></c:if>
            <c:if test="${empty categories}"><div class="alert alert-error" role="alert">Chưa có danh mục để gán cho sản phẩm. <a href="<c:url value='/admin/category/add'/>"><strong>Thêm danh mục trước</strong></a>.</div></c:if>

            <section class="panel form-panel">
                <div class="panel-heading">Thông tin sản phẩm</div>
                <form class="form-body" action="<c:url value='/admin/product/insert'/>" method="post" enctype="multipart/form-data">
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label" for="productName">Tên sản phẩm <span class="required">*</span></label>
                            <input class="form-control" id="productName" name="productName" type="text" maxlength="255" required autofocus value="<c:out value='${draft.productName}'/>">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="price">Giá bán <span class="required">*</span></label>
                            <c:set var="priceValue" value="${not empty submittedPrice ? submittedPrice : draft.price}"/>
                            <input class="form-control" id="price" name="price" type="number" min="0" step="0.01" required inputmode="decimal" value="<c:out value='${priceValue}'/>">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="categoryId">Danh mục <span class="required">*</span></label>
                            <select class="form-control" id="categoryId" name="categoryId" required>
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach items="${categories}" var="cate">
                                    <c:choose>
                                        <c:when test="${(not empty draft.category and draft.category.categoryId == cate.categoryId) or (empty draft.category and param.categoryId == cate.categoryId)}"><option value="<c:out value='${cate.categoryId}'/>" selected><c:out value="${cate.categoryname}"/></option></c:when>
                                        <c:otherwise><option value="<c:out value='${cate.categoryId}'/>"><c:out value="${cate.categoryname}"/></option></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="status">Trạng thái <span class="required">*</span></label>
                            <select class="form-control" id="status" name="status" required>
                                <c:choose>
                                    <c:when test="${empty formProduct or draft.status == 1}"><option value="1" selected>Đang hoạt động</option><option value="0">Đã khóa</option></c:when>
                                    <c:otherwise><option value="1">Đang hoạt động</option><option value="0" selected>Đã khóa</option></c:otherwise>
                                </c:choose>
                            </select>
                        </div>
                        <div class="form-group full">
                            <label class="form-label" for="description">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" maxlength="4000" placeholder="Mô tả chi tiết sản phẩm..."><c:out value="${draft.description}"/></textarea>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="images">Đường dẫn ảnh</label>
                            <c:set var="draftIsRemote" value="${not empty draft.images and (fn:startsWith(fn:toLowerCase(draft.images), 'http://') or fn:startsWith(fn:toLowerCase(draft.images), 'https://'))}"/>
                            <c:set var="imageUrlValue" value="${not empty submittedImageUrl ? submittedImageUrl : (draftIsRemote ? draft.images : '')}"/>
                            <input class="form-control" id="images" name="images" type="url" maxlength="255" placeholder="https://example.com/product.jpg" value="<c:out value='${imageUrlValue}'/>">
                            <span class="form-help">Có thể nhập URL HTTP/HTTPS hoặc tải tệp ảnh ở ô bên cạnh.</span>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="images1">Tải ảnh lên</label>
                            <input class="form-control" id="images1" name="images1" type="file" accept="image/png,image/jpeg,image/gif" onchange="previewUpload(this)">
                            <span class="form-help">PNG, JPG hoặc GIF. Nếu chọn tệp, tệp sẽ được ưu tiên.</span>
                            <div class="preview-box" id="imagePreview"><img alt="Xem trước ảnh được chọn"></div>
                        </div>
                    </div>
                    <div class="form-actions">
                        <a class="btn btn-secondary" href="<c:url value='/admin/products'/>">Hủy</a>
                        <c:choose>
                            <c:when test="${empty categories}"><button class="btn btn-primary" type="submit" disabled><i class="fas fa-floppy-disk"></i>Lưu sản phẩm</button></c:when>
                            <c:otherwise><button class="btn btn-primary" type="submit"><i class="fas fa-floppy-disk"></i>Lưu sản phẩm</button></c:otherwise>
                        </c:choose>
                    </div>
                </form>
            </section>
        </main>
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
