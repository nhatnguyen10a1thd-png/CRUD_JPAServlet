<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Category - Management System</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>📋</text></svg>">
    
    <style>
        /* Base Enterprise Design System */
        :root {
            --bg-body: #f8fafc;
            --bg-surface: #ffffff;
            --color-primary: #2563eb;
            --color-primary-hover: #1d4ed8;
            --border-color: #e2e8f0;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --text-muted: #94a3b8;
            
            --sidebar-width: 260px;
            --header-height: 64px;
            --radius-md: 6px;
            --radius-lg: 8px;
            
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
        }

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, sans-serif;
            background-color: var(--bg-body);
            color: var(--text-primary);
            line-height: 1.5;
            font-size: 14px;
        }

        a { text-decoration: none; color: inherit; }

        /* Layout Structure */
        .app-layout { display: flex; min-height: 100vh; }

        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--bg-surface);
            border-right: 1px solid var(--border-color);
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            display: flex;
            flex-direction: column;
            z-index: 40;
        }

        .sidebar-header {
            height: var(--header-height);
            display: flex;
            align-items: center;
            padding: 0 24px;
            border-bottom: 1px solid var(--border-color);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 700;
            font-size: 16px;
        }

        .brand i { color: var(--color-primary); font-size: 20px; }

        .sidebar-nav { padding: 24px 16px; flex: 1; }

        .nav-group-title {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            margin-bottom: 8px;
            padding-left: 12px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 12px;
            border-radius: var(--radius-md);
            color: var(--text-secondary);
            font-weight: 500;
            transition: all 0.2s;
            margin-bottom: 4px;
        }

        .nav-item i { font-size: 16px; width: 20px; text-align: center; }
        .nav-item:hover { background-color: var(--bg-body); color: var(--text-primary); }
        .nav-item.active { background-color: #eff6ff; color: var(--color-primary); }

        .main-wrapper {
            flex: 1;
            margin-left: var(--sidebar-width);
            display: flex;
            flex-direction: column;
        }

        .top-header {
            height: var(--header-height);
            background-color: var(--bg-surface);
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            position: sticky;
            top: 0;
            z-index: 30;
        }

        .header-search { position: relative; width: 300px; }
        .header-search i { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted); }
        .header-search input {
            width: 100%;
            padding: 8px 12px 8px 36px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            background-color: var(--bg-body);
            font-family: inherit;
            font-size: 13px;
        }
        .header-search input:focus {
            outline: none;
            border-color: var(--color-primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .header-actions { display: flex; align-items: center; gap: 16px; }
        .icon-btn { background: none; border: none; color: var(--text-secondary); font-size: 18px; cursor: pointer; padding: 8px; border-radius: var(--radius-md); }
        .icon-btn:hover { background-color: var(--bg-body); color: var(--text-primary); }
        
        .user-profile { display: flex; align-items: center; gap: 12px; padding-left: 16px; border-left: 1px solid var(--border-color); cursor: pointer; }
        .avatar { width: 32px; height: 32px; border-radius: 50%; background-color: var(--color-primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 12px; }

        .page-content { padding: 32px; flex: 1; max-width: 900px; margin: 0 auto; width: 100%; }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 8px;
        }
        .breadcrumb a { color: var(--text-secondary); }
        .breadcrumb a:hover { color: var(--color-primary); }
        
        .page-header {
            margin-bottom: 24px;
        }

        .page-title h1 { font-size: 24px; font-weight: 600; color: var(--text-primary); margin-bottom: 4px; }
        .page-title p { color: var(--text-secondary); font-size: 14px; }

        /* Form Card Styles */
        .form-card {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            padding: 32px;
        }

        .form-section {
            margin-bottom: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-label span.required {
            color: #dc2626;
            margin-left: 4px;
        }

        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            font-family: inherit;
            font-size: 14px;
            color: var(--text-primary);
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--color-primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-control::placeholder {
            color: var(--text-muted);
        }

        .form-text {
            display: block;
            margin-top: 6px;
            font-size: 12.5px;
            color: var(--text-secondary);
        }

        /* Standard Radio Buttons */
        .radio-group {
            display: flex;
            gap: 24px;
            margin-top: 8px;
        }

        .radio-label {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            font-weight: 400;
            color: var(--text-secondary);
        }

        .radio-label input[type="radio"] {
            width: 16px;
            height: 16px;
            cursor: pointer;
            accent-color: var(--color-primary);
        }

        .image-preview {
            margin-top: 12px;
            display: none;
        }

        .image-preview img {
            max-width: 200px;
            max-height: 140px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-color);
            object-fit: cover;
        }

        .form-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            padding-top: 24px;
            border-top: 1px solid var(--border-color);
            margin-top: 32px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: var(--radius-md);
            font-weight: 500;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
            border: 1px solid transparent;
        }

        .btn-primary {
            background-color: var(--color-primary);
            color: white;
            box-shadow: var(--shadow-sm);
        }

        .btn-primary:hover {
            background-color: var(--color-primary-hover);
        }

        .btn-secondary {
            background-color: var(--bg-surface);
            color: var(--text-primary);
            border-color: var(--border-color);
            box-shadow: var(--shadow-sm);
        }

        .btn-secondary:hover {
            background-color: #f1f5f9;
        }

    </style>
</head>
<body>

    <div class="app-layout">
        
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="brand">
                    <i class="fas fa-layer-group"></i>
                    <span>System Admin</span>
                </div>
            </div>
            
            <nav class="sidebar-nav">
                <div class="nav-group-title">Overview</div>
                <a href="<c:url value='/home'/>" class="nav-item">
                    <i class="fas fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>
                <a href="<c:url value='/product'/>" class="nav-item">
                    <i class="fas fa-store"></i>
                    <span>Shop</span>
                </a>
                
                <div class="nav-group-title" style="margin-top: 24px;">Management</div>
                <a href="<c:url value='/admin/categories'/>" class="nav-item active">
                    <i class="fas fa-tags"></i>
                    <span>Categories</span>
                </a>
                <a href="<c:url value='/admin/products'/>" class="nav-item">
                    <i class="fas fa-box"></i>
                    <span>Products</span>
                </a>
            </nav>
        </aside>

        <!-- Main Wrapper -->
        <div class="main-wrapper">
            
            <!-- Header -->
            <header class="top-header">
                <div class="header-search">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Search categories..." aria-label="Search">
                </div>
                
                <div class="header-actions">
                    <div class="user-profile">
                        <div class="avatar">AD</div>
                        <span style="font-weight: 500; font-size: 14px;">Administrator</span>
                    </div>
                </div>
            </header>

            <!-- Page Content -->
            <main class="page-content">
                
                <div class="breadcrumb">
                    <a href="<c:url value='/home'/>">Dashboard</a>
                    <i class="fas fa-chevron-right" style="font-size: 10px;"></i>
                    <a href="<c:url value='/admin/categories'/>">Categories</a>
                    <i class="fas fa-chevron-right" style="font-size: 10px;"></i>
                    <span style="color: var(--text-primary); font-weight: 500;">Add New</span>
                </div>

                <div class="page-header">
                    <div class="page-title">
                        <h1>Create Category</h1>
                        <p>Fill in the details below to add a new category to the system.</p>
                    </div>
                </div>

                <!-- Form Card -->
                <div class="form-card">
                    <form action="<c:url value='/admin/category/insert'/>" method="post" enctype="multipart/form-data">
                        
                        <div class="form-section">
                            <div class="form-group">
                                <label for="categoryname" class="form-label">
                                    Category Name <span class="required" aria-hidden="true">*</span>
                                </label>
                                <input type="text" class="form-control" id="categoryname" name="categoryname" placeholder="e.g. Electronics, Clothing" required>
                            </div>

                            <div class="form-group">
                                <label for="images" class="form-label">Image URL</label>
                                <input type="url" class="form-control" id="images" name="images" placeholder="https://example.com/image.jpg">
                                <span class="form-text">Provide an external URL if you don't want to upload a file directly.</span>
                            </div>

                            <div class="form-group">
                                <label for="images1" class="form-label">Upload Image</label>
                                <input type="file" class="form-control" style="padding: 7px 12px;" id="images1" name="images1" accept="image/*" onchange="previewImage(this)">
                                <div class="image-preview" id="imagePreview">
                                    <img id="previewImg" src="" alt="Image preview">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Status</label>
                                <div class="radio-group">
                                    <label class="radio-label" for="ston">
                                        <input type="radio" id="ston" name="status" value="1" checked>
                                        Active
                                    </label>
                                    <label class="radio-label" for="stoff">
                                        <input type="radio" id="stoff" name="status" value="0">
                                        Locked
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">Save Category</button>
                            <a href="<c:url value='/admin/categories'/>" class="btn btn-secondary">Cancel</a>
                        </div>
                        
                    </form>
                </div>

            </main>
        </div>
    </div>

    <script>
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            const img = document.getElementById('previewImg');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    img.src = e.target.result;
                    preview.style.display = 'block';
                };
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.style.display = 'none';
                img.src = '';
            }
        }
    </script>
</body>
</html>
