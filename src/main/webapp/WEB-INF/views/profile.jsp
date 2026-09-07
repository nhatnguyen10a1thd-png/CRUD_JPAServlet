<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hồ sơ cá nhân</title>
    <style>
        .profile-container {
            max-width: 820px;
        }

        .profile-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, .06);
            overflow: hidden;
        }

        .profile-header {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            padding: 32px 36px;
            display: flex;
            align-items: center;
            gap: 24px;
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
            content: '';
            position: absolute;
            top: -60%;
            right: -10%;
            width: 250px;
            height: 250px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.07);
        }

        .profile-header::after {
            content: '';
            position: absolute;
            bottom: -40%;
            left: -5%;
            width: 180px;
            height: 180px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.05);
        }

        .profile-avatar-display {
            position: relative;
            z-index: 1;
            width: 90px;
            height: 90px;
            border-radius: 50%;
            overflow: hidden;
            border: 3px solid rgba(255, 255, 255, 0.4);
            background: rgba(255, 255, 255, 0.15);
            flex-shrink: 0;
        }

        .profile-avatar-display img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-avatar-display .avatar-placeholder {
            width: 100%;
            height: 100%;
            display: grid;
            place-items: center;
            color: rgba(255, 255, 255, 0.7);
            font-size: 36px;
        }

        .profile-header-info {
            position: relative;
            z-index: 1;
        }

        .profile-header-info h1 {
            color: #fff;
            font-size: 22px;
            font-weight: 700;
            margin: 0 0 4px;
        }

        .profile-header-info p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 14px;
            margin: 0;
        }

        .profile-header-info .badge-role {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            margin-top: 8px;
            padding: 4px 12px;
            background: rgba(255, 255, 255, 0.18);
            border-radius: 99px;
            color: #fff;
            font-size: 12px;
            font-weight: 600;
            backdrop-filter: blur(4px);
        }

        .profile-body {
            padding: 32px 36px;
        }

        /* Alert Messages */
        .profile-alert {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .profile-alert-success {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #166534;
        }

        .profile-alert-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
        }

        .profile-alert i {
            font-size: 16px;
            flex-shrink: 0;
        }

        /* Form Layout */
        .profile-form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 22px;
        }

        .profile-form-grid .full-width {
            grid-column: 1 / -1;
        }

        .profile-field {
            display: flex;
            flex-direction: column;
        }

        .profile-field label {
            font-size: 13px;
            font-weight: 650;
            color: var(--text);
            margin-bottom: 7px;
        }

        .profile-field label .required {
            color: #ef4444;
            margin-left: 2px;
        }

        .profile-input {
            position: relative;
        }

        .profile-input i.field-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 14px;
            pointer-events: none;
            transition: color 0.2s;
        }

        .profile-input input,
        .profile-input .readonly-value {
            width: 100%;
            padding: 11px 14px 11px 40px;
            border: 1.5px solid #e2e8f0;
            border-radius: 8px;
            font-family: inherit;
            font-size: 14px;
            color: var(--text);
            background: #fff;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .profile-input input:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .profile-input input:focus ~ i.field-icon {
            color: #2563eb;
        }

        .profile-input .readonly-value {
            background: #f8fafc;
            color: #64748b;
            cursor: not-allowed;
        }

        /* Avatar Upload Section */
        .avatar-upload-section {
            display: flex;
            align-items: flex-start;
            gap: 20px;
            padding: 20px;
            background: #f8fafc;
            border: 1.5px dashed #cbd5e1;
            border-radius: 10px;
            transition: border-color 0.2s, background 0.2s;
        }

        .avatar-upload-section:hover {
            border-color: #93c5fd;
            background: #eff6ff;
        }

        .avatar-upload-section.dragover {
            border-color: #2563eb;
            background: #dbeafe;
        }

        .avatar-preview {
            width: 100px;
            height: 100px;
            border-radius: 12px;
            overflow: hidden;
            border: 2px solid #e2e8f0;
            background: #fff;
            flex-shrink: 0;
        }

        .avatar-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .avatar-preview .preview-placeholder {
            width: 100%;
            height: 100%;
            display: grid;
            place-items: center;
            color: #94a3b8;
            font-size: 32px;
            background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
        }

        .avatar-upload-info {
            flex: 1;
        }

        .avatar-upload-info h4 {
            margin: 0 0 4px;
            font-size: 14px;
            font-weight: 650;
            color: var(--text);
        }

        .avatar-upload-info p {
            margin: 0 0 12px;
            font-size: 12px;
            color: #64748b;
        }

        .avatar-upload-info .upload-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            background: #fff;
            border: 1.5px solid #e2e8f0;
            border-radius: 7px;
            color: #334155;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .avatar-upload-info .upload-btn:hover {
            border-color: #2563eb;
            color: #2563eb;
            background: #eff6ff;
        }

        .avatar-upload-info input[type="file"] {
            display: none;
        }

        /* Form Actions */
        .profile-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding-top: 24px;
            margin-top: 24px;
            border-top: 1px solid #e2e8f0;
        }

        .btn-save {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 28px;
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-family: inherit;
            font-size: 14px;
            font-weight: 650;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-save:hover {
            background: linear-gradient(135deg, #1d4ed8 0%, #1e3a8a 100%);
            transform: translateY(-1px);
            box-shadow: 0 8px 24px -4px rgba(37, 99, 235, 0.35);
        }

        .btn-save:active {
            transform: translateY(0);
        }

        .btn-cancel {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 24px;
            background: #fff;
            color: #334155;
            border: 1.5px solid #e2e8f0;
            border-radius: 8px;
            font-family: inherit;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-cancel:hover {
            border-color: #94a3b8;
            background: #f8fafc;
        }

        @media (max-width: 620px) {
            .profile-header {
                flex-direction: column;
                text-align: center;
                padding: 28px 24px;
            }

            .profile-body {
                padding: 24px 20px;
            }

            .profile-form-grid {
                grid-template-columns: 1fr;
            }

            .avatar-upload-section {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .profile-actions {
                flex-direction: column;
            }

            .profile-actions .btn-save,
            .profile-actions .btn-cancel {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="admin-page-header">
        <div>
            <p class="eyebrow">Tài khoản</p>
            <h1>Hồ sơ cá nhân</h1>
            <p>Cập nhật thông tin cá nhân, số điện thoại và ảnh đại diện của bạn.</p>
        </div>
    </div>

    <div class="profile-container">
        <div class="profile-card">

            <%-- Header with avatar and name --%>
            <div class="profile-header">
                <div class="profile-avatar-display">
                    <c:choose>
                        <c:when test="${not empty profileUser.images}">
                            <c:choose>
                                <c:when test="${fn:startsWith(fn:toLowerCase(profileUser.images), 'http://') or fn:startsWith(fn:toLowerCase(profileUser.images), 'https://')}">
                                    <img src="<c:out value='${profileUser.images}'/>" alt="Avatar">
                                </c:when>
                                <c:otherwise>
                                    <c:url value="/image" var="avatarUrl"><c:param name="fname" value="${profileUser.images}"/></c:url>
                                    <img src="<c:out value='${avatarUrl}'/>" alt="Avatar">
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <div class="avatar-placeholder"><i class="fas fa-user"></i></div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="profile-header-info">
                    <h1><c:out value="${profileUser.fullname}" default="Chưa cập nhật"/></h1>
                    <p>@<c:out value="${profileUser.username}"/></p>
                    <c:choose>
                        <c:when test="${profileUser.admin}">
                            <span class="badge-role"><i class="fas fa-shield-halved"></i> Quản trị viên</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-role"><i class="fas fa-user"></i> Thành viên</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <%-- Form body --%>
            <div class="profile-body">

                <%-- Success message --%>
                <c:if test="${not empty flashSuccess}">
                    <div class="profile-alert profile-alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span><c:out value="${flashSuccess}"/></span>
                    </div>
                </c:if>

                <%-- Error messages --%>
                <c:if test="${not empty error}">
                    <div class="profile-alert profile-alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <span><c:out value="${error}"/></span>
                    </div>
                </c:if>

                <form action="<c:url value='/profile/update'/>" method="post" enctype="multipart/form-data" id="profileForm">

                    <div class="profile-form-grid">

                        <%-- Username (read-only) --%>
                        <div class="profile-field">
                            <label>Tên đăng nhập</label>
                            <div class="profile-input">
                                <div class="readonly-value"><c:out value="${profileUser.username}"/></div>
                                <i class="fas fa-at field-icon"></i>
                            </div>
                        </div>

                        <%-- Email (read-only) --%>
                        <div class="profile-field">
                            <label>Email</label>
                            <div class="profile-input">
                                <div class="readonly-value"><c:out value="${profileUser.email}"/></div>
                                <i class="fas fa-envelope field-icon"></i>
                            </div>
                        </div>

                        <%-- Fullname --%>
                        <div class="profile-field">
                            <label for="fullname">Họ và tên <span class="required">*</span></label>
                            <div class="profile-input">
                                <input type="text" id="fullname" name="fullname"
                                       value="<c:out value='${profileUser.fullname}'/>"
                                       placeholder="Nhập họ và tên" required maxlength="100">
                                <i class="fas fa-user field-icon"></i>
                            </div>
                        </div>

                        <%-- Phone --%>
                        <div class="profile-field">
                            <label for="phone">Số điện thoại</label>
                            <div class="profile-input">
                                <input type="tel" id="phone" name="phone"
                                       value="<c:out value='${profileUser.phone}'/>"
                                       placeholder="Nhập số điện thoại" maxlength="11"
                                       pattern="[0-9]{10,11}">
                                <i class="fas fa-phone field-icon"></i>
                            </div>
                        </div>

                        <%-- Avatar Upload --%>
                        <div class="profile-field full-width">
                            <label>Ảnh đại diện</label>
                            <div class="avatar-upload-section" id="dropZone">
                                <div class="avatar-preview" id="avatarPreview">
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
                                            <div class="preview-placeholder" id="previewPlaceholder"><i class="fas fa-image"></i></div>
                                            <img id="previewImg" src="" alt="Preview" style="display:none">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="avatar-upload-info">
                                    <h4>Tải ảnh lên</h4>
                                    <p>Chấp nhận JPG, PNG, GIF. Tối đa 5 MB.</p>
                                    <label class="upload-btn" for="avatarInput">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                        Chọn ảnh
                                    </label>
                                    <input type="file" id="avatarInput" name="avatar"
                                           accept="image/jpeg,image/png,image/gif">
                                </div>
                            </div>
                        </div>

                    </div>

                    <%-- Form actions --%>
                    <div class="profile-actions">
                        <a href="<c:url value='/home'/>" class="btn-cancel">
                            <i class="fas fa-times"></i> Hủy
                        </a>
                        <button type="submit" class="btn-save" id="btnSave">
                            <i class="fas fa-save"></i> Lưu thay đổi
                        </button>
                    </div>

                </form>
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
