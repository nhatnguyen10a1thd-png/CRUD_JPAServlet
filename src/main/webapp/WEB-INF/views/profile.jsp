<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hồ sơ cá nhân</title>
</head>
<body>
    <!-- Page Header -->
    <div class="mb-4 page-header">
        <p class="text-muted text-uppercase small fw-semibold mb-1">Tài khoản</p>
        <h1>Hồ sơ cá nhân</h1>
        <p class="text-muted">Cập nhật thông tin cá nhân, số điện thoại và ảnh đại diện của bạn.</p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card overflow-hidden">

                <%-- Header with avatar and name --%>
                <div class="profile-header-bg">
                    <div class="d-flex align-items-center gap-3">
                        <div>
                            <c:choose>
                                <c:when test="${not empty profileUser.images}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(fn:toLowerCase(profileUser.images), 'http://') or fn:startsWith(fn:toLowerCase(profileUser.images), 'https://')}">
                                            <img src="<c:out value='${profileUser.images}'/>" alt="Avatar" class="profile-avatar">
                                        </c:when>
                                        <c:otherwise>
                                            <c:url value="/image" var="avatarUrl"><c:param name="fname" value="${profileUser.images}"/></c:url>
                                            <img src="<c:out value='${avatarUrl}'/>" alt="Avatar" class="profile-avatar">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <div class="profile-avatar-placeholder"><i class="fas fa-user"></i></div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div>
                            <h4 class="mb-0 fw-bold"><c:out value="${profileUser.fullname}" default="Chưa cập nhật"/></h4>
                            <p class="mb-1 opacity-75">@<c:out value="${profileUser.username}"/></p>
                            <c:choose>
                                <c:when test="${profileUser.admin}">
                                    <span class="badge bg-light bg-opacity-25 text-white"><i class="fas fa-shield-halved me-1"></i>Quản trị viên</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-light bg-opacity-25 text-white"><i class="fas fa-user me-1"></i>Thành viên</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <%-- Form body --%>
                <div class="card-body p-4">

                    <%-- Success message --%>
                    <c:if test="${not empty flashSuccess}">
                        <div class="alert alert-success d-flex align-items-center" role="status">
                            <i class="fas fa-check-circle me-2"></i>
                            <span><c:out value="${flashSuccess}"/></span>
                        </div>
                    </c:if>

                    <%-- Error messages --%>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger d-flex align-items-center" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <span><c:out value="${error}"/></span>
                        </div>
                    </c:if>

                    <form action="<c:url value='/profile/update'/>" method="post" enctype="multipart/form-data" id="profileForm">

                        <div class="row g-3">

                            <%-- Username (read-only) --%>
                            <div class="col-md-6">
                                <label class="form-label">Tên đăng nhập</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-at"></i></span>
                                    <input type="text" class="form-control" value="<c:out value='${profileUser.username}'/>" disabled readonly>
                                </div>
                            </div>

                            <%-- Email (read-only) --%>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                    <input type="email" class="form-control" value="<c:out value='${profileUser.email}'/>" disabled readonly>
                                </div>
                            </div>

                            <%-- Fullname --%>
                            <div class="col-md-6">
                                <label class="form-label" for="fullname">Họ và tên <span class="required">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control" id="fullname" name="fullname"
                                           value="<c:out value='${profileUser.fullname}'/>"
                                           placeholder="Nhập họ và tên" required maxlength="100">
                                </div>
                            </div>

                            <%-- Phone --%>
                            <div class="col-md-6">
                                <label class="form-label" for="phone">Số điện thoại</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                    <input type="tel" class="form-control" id="phone" name="phone"
                                           value="<c:out value='${profileUser.phone}'/>"
                                           placeholder="Nhập số điện thoại" maxlength="11"
                                           pattern="[0-9]{10,11}">
                                </div>
                            </div>

                            <%-- Avatar Upload --%>
                            <div class="col-12">
                                <label class="form-label">Ảnh đại diện</label>
                                <div class="avatar-upload-section" id="dropZone">
                                    <div class="d-flex align-items-start gap-3">
                                        <div class="avatar-preview-box flex-shrink-0" id="avatarPreview">
                                            <c:choose>
                                                <c:when test="${not empty profileUser.images}">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(fn:toLowerCase(profileUser.images), 'http://') or fn:startsWith(fn:toLowerCase(profileUser.images), 'https://')}">
                                                            <img id="previewImg" src="<c:out value='${profileUser.images}'/>" alt="Avatar hiện tại">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:url value="/image" var="currentAvatarUrl"><c:param name="fname" value="${profileUser.images}"/></c:url>
                                                            <img id="previewImg" src="<c:out value='${currentAvatarUrl}'/>" alt="Avatar hiện tại">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="avatar-preview-placeholder" id="previewPlaceholder"><i class="fas fa-image"></i></div>
                                                    <img id="previewImg" src="" alt="Preview" style="display:none">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div>
                                            <h6 class="mb-1 fw-semibold">Tải ảnh lên</h6>
                                            <p class="text-muted small mb-2">Chấp nhận JPG, PNG, GIF. Tối đa 5 MB.</p>
                                            <label class="btn btn-outline-secondary btn-sm" for="avatarInput">
                                                <i class="fas fa-cloud-upload-alt me-1"></i>Chọn ảnh
                                            </label>
                                            <input type="file" id="avatarInput" name="avatar" class="d-none"
                                                   accept="image/jpeg,image/png,image/gif">
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <%-- Form actions --%>
                        <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                            <a href="<c:url value='/home'/>" class="btn btn-secondary">
                                <i class="fas fa-times me-1"></i>Hủy
                            </a>
                            <button type="submit" class="btn btn-primary" id="btnSave">
                                <i class="fas fa-save me-1"></i>Lưu thay đổi
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>

<script>
    // Image preview on file select
    const avatarInput = document.getElementById('avatarInput');
    const previewImg = document.getElementById('previewImg');
    const previewPlaceholder = document.getElementById('previewPlaceholder');

    avatarInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(event) {
                previewImg.src = event.target.result;
                previewImg.style.display = 'block';
                if (previewPlaceholder) {
                    previewPlaceholder.style.display = 'none';
                }
            };
            reader.readAsDataURL(file);
        }
    });

    // Drag and drop support
    const dropZone = document.getElementById('dropZone');

    ['dragenter', 'dragover'].forEach(eventName => {
        dropZone.addEventListener(eventName, function(e) {
            e.preventDefault();
            dropZone.classList.add('dragover');
        });
    });

    ['dragleave', 'drop'].forEach(eventName => {
        dropZone.addEventListener(eventName, function(e) {
            e.preventDefault();
            dropZone.classList.remove('dragover');
        });
    });

    dropZone.addEventListener('drop', function(e) {
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            avatarInput.files = files;
            avatarInput.dispatchEvent(new Event('change'));
        }
    });
</script>

</body>
</html>
