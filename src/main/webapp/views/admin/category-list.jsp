<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories - Management System</title>
    
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

        .page-content { padding: 32px; flex: 1; }

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
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 24px;
        }

        .page-title h1 { font-size: 24px; font-weight: 600; color: var(--text-primary); margin-bottom: 4px; }
        .page-title p { color: var(--text-secondary); font-size: 14px; }

        .btn-primary {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background-color: var(--color-primary);
            color: white;
            padding: 10px 16px;
            border-radius: var(--radius-md);
            font-weight: 500;
            font-size: 14px;
            border: none;
            cursor: pointer;
            transition: background-color 0.2s;
            box-shadow: var(--shadow-sm);
        }
        .btn-primary:hover { background-color: var(--color-primary-hover); }

        /* Table Card Specific Styles */
        .table-card {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
        }

        .table-toolbar {
            padding: 16px 24px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-title { font-weight: 600; font-size: 15px; }

        .table-responsive { width: 100%; overflow-x: auto; }

        table { width: 100%; border-collapse: collapse; text-align: left; }
        
        thead { background-color: #f1f5f9; border-bottom: 1px solid var(--border-color); }
        th { 
            padding: 12px 24px; 
            font-size: 12px; 
            font-weight: 600; 
            color: var(--text-secondary); 
            text-transform: uppercase; 
            letter-spacing: 0.05em; 
            white-space: nowrap;
        }
        
        tbody tr { border-bottom: 1px solid var(--border-color); transition: background-color 0.2s; }
        tbody tr:hover { background-color: #f8fafc; }
        tbody tr:last-child { border-bottom: none; }
        
        td { padding: 16px 24px; vertical-align: middle; color: var(--text-primary); }

        .cell-stt { color: var(--text-secondary); font-variant-numeric: tabular-nums; }
        
        .cell-image img { 
            width: 80px; 
            height: 50px; 
            object-fit: cover; 
            border-radius: 4px; 
            border: 1px solid var(--border-color); 
        }

        .cell-name { font-weight: 500; }

        /* Status Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        .badge-success { background-color: #dcfce7; color: #16a34a; }
        .badge-danger { background-color: #fee2e2; color: #dc2626; }
        
        .badge .dot {
            width: 6px; height: 6px; border-radius: 50%; margin-right: 6px;
        }
        .badge-success .dot { background-color: #16a34a; }
        .badge-danger .dot { background-color: #dc2626; }

        /* Action Buttons */
        .action-group { display: flex; gap: 8px; }
        .btn-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-color);
            background-color: var(--bg-surface);
            color: var(--text-secondary);
            transition: all 0.2s;
            cursor: pointer;
        }
        .btn-action:hover { border-color: var(--text-muted); color: var(--text-primary); }
        
        .btn-action.edit:hover { border-color: #d97706; color: #d97706; background-color: #fef3c7; }
        .btn-action.delete:hover { border-color: #dc2626; color: #dc2626; background-color: #fee2e2; }
        
        .empty-state {
            padding: 48px 24px;
            text-align: center;
            color: var(--text-secondary);
        }
        .empty-state i { font-size: 32px; color: var(--text-muted); margin-bottom: 16px; }

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
                <a href="<c:url value='/'/>" class="nav-item">
                    <i class="fas fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>
                
                <div class="nav-group-title" style="margin-top: 24px;">Management</div>
                <a href="<c:url value='/admin/categories'/>" class="nav-item active">
                    <i class="fas fa-tags"></i>
                    <span>Categories</span>
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
                    <button class="icon-btn" aria-label="Notifications">
                        <i class="far fa-bell"></i>
                    </button>
                    <div class="user-profile">
                        <div class="avatar">AD</div>
                        <span style="font-weight: 500; font-size: 14px;">Administrator</span>
                    </div>
                </div>
            </header>

            <!-- Page Content -->
            <main class="page-content">
                
                <div class="breadcrumb">
                    <a href="<c:url value='/'/>">Dashboard</a>
                    <i class="fas fa-chevron-right" style="font-size: 10px;"></i>
                    <span style="color: var(--text-primary); font-weight: 500;">Categories</span>
                </div>

                <div class="page-header">
                    <div class="page-title">
                        <h1>Category Management</h1>
                        <p>Manage and organize all your product categories.</p>
                    </div>
                    <a class="btn-primary" href="<c:url value="/admin/category/add"/>">
                        <i class="fas fa-plus"></i>
                        Add Category
                    </a>
                </div>

                <!-- Table Card -->
                <div class="table-card">
                    <div class="table-toolbar">
                        <div class="table-title">All Categories</div>
                        <!-- Potential location for table filters/pagination -->
                    </div>
                    
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th style="width: 80px;">#</th>
                                    <th style="width: 120px;">Image</th>
                                    <th>Category Name</th>
                                    <th style="width: 150px;">Status</th>
                                    <th style="width: 120px; text-align: center;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty listcate}">
                                        <c:forEach items="${listcate}" var="cate" varStatus="STT">
                                            <tr>
                                                <td class="cell-stt">${STT.index + 1}</td>
                                                <td class="cell-image">
                                                    <c:choose>
                                                        <c:when test="${cate.images != null && cate.images.length() >= 5 && cate.images.substring(0,5) == 'https'}">
                                                            <c:url value="${cate.images}" var="imgUrl"></c:url>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:url value="/image?fname=${cate.images}" var="imgUrl"></c:url>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <img src="${imgUrl}" alt="Thumbnail of ${cate.categoryname}" loading="lazy"/>
                                                </td>
                                                <td class="cell-name">${cate.categoryname}</td>
                                                <td>
                                                    <c:if test="${cate.status == 1}">
                                                        <span class="badge badge-success">
                                                            <span class="dot"></span> Active
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${cate.status != 1}">
                                                        <span class="badge badge-danger">
                                                            <span class="dot"></span> Locked
                                                        </span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="action-group" style="justify-content: center;">
                                                        <a class="btn-action edit" href="<c:url value='/admin/category/edit?id=${cate.categoryId}'/>" aria-label="Edit category" title="Edit">
                                                            <i class="fas fa-pen" style="font-size: 13px;"></i>
                                                        </a>
                                                        <a class="btn-action delete" href="<c:url value='/admin/category/delete?id=${cate.categoryId}'/>"
                                                           onclick="return confirm('Are you sure you want to delete this category?')" aria-label="Delete category" title="Delete">
                                                            <i class="fas fa-trash" style="font-size: 13px;"></i>
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
                                                    <i class="fas fa-inbox"></i>
                                                    <p>No categories found. Click "Add Category" to create one.</p>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

            </main>
        </div>
    </div>

</body>
</html>
