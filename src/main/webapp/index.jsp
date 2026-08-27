<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Management System</title>
    
    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Minimal Favicon setup (Fallback) -->
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>📦</text></svg>">
    
    <style>
        /* Design System Variables */
        :root {
            /* Colors */
            --bg-body: #f8fafc;
            --bg-surface: #ffffff;
            --color-primary: #2563eb;
            --color-primary-hover: #1d4ed8;
            --border-color: #e2e8f0;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --text-muted: #94a3b8;
            
            /* Spacing & Sizes */
            --sidebar-width: 260px;
            --header-height: 64px;
            --radius-md: 6px;
            --radius-lg: 8px;
            
            /* Shadows */
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
        }

        /* Reset & Base Styles */
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: var(--bg-body);
            color: var(--text-primary);
            line-height: 1.5;
            font-size: 14px;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        /* Layout Structure */
        .app-layout {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
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
            color: var(--text-primary);
        }

        .brand i {
            color: var(--color-primary);
            font-size: 20px;
        }

        .sidebar-nav {
            padding: 24px 16px;
            flex: 1;
        }

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
            transition: all 0.2s ease;
            margin-bottom: 4px;
        }

        .nav-item i {
            font-size: 16px;
            width: 20px;
            text-align: center;
        }

        .nav-item:hover {
            background-color: var(--bg-body);
            color: var(--text-primary);
        }

        .nav-item.active {
            background-color: #eff6ff; /* blue-50 */
            color: var(--color-primary);
        }

        /* Main Content Area */
        .main-wrapper {
            flex: 1;
            margin-left: var(--sidebar-width);
            display: flex;
            flex-direction: column;
        }

        /* Top Header */
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

        .header-search {
            position: relative;
            width: 300px;
        }

        .header-search i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
        }

        .header-search input {
            width: 100%;
            padding: 8px 12px 8px 36px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            background-color: var(--bg-body);
            font-family: inherit;
            font-size: 13px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .header-search input:focus {
            outline: none;
            border-color: var(--color-primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .icon-btn {
            background: none;
            border: none;
            color: var(--text-secondary);
            font-size: 18px;
            cursor: pointer;
            padding: 8px;
            border-radius: var(--radius-md);
            transition: background-color 0.2s;
        }

        .icon-btn:hover {
            background-color: var(--bg-body);
            color: var(--text-primary);
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            padding-left: 16px;
            border-left: 1px solid var(--border-color);
            cursor: pointer;
        }

        .avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: var(--color-primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 12px;
        }

        /* Page Content */
        .page-content {
            padding: 32px;
            flex: 1;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 24px;
        }

        .page-title h1 {
            font-size: 24px;
            font-weight: 600;
            color: var(--text-primary);
            letter-spacing: -0.02em;
            margin-bottom: 4px;
        }

        .page-title p {
            color: var(--text-secondary);
            font-size: 14px;
        }

        /* Dashboard Cards */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
        }

        .card {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
        }

        .card-icon {
            width: 40px;
            height: 40px;
            border-radius: var(--radius-md);
            background-color: #eff6ff;
            color: var(--color-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .card-title {
            font-weight: 600;
            font-size: 16px;
        }

        .card-body p {
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        .btn-primary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
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
        }

        .btn-primary:hover {
            background-color: var(--color-primary-hover);
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
                <a href="<c:url value='/'/>" class="nav-item active">
                    <i class="fas fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>
                
                <div class="nav-group-title" style="margin-top: 24px;">Management</div>
                <a href="<c:url value='/admin/categories'/>" class="nav-item">
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
                    <input type="text" placeholder="Search resources...">
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
                
                <div class="page-header">
                    <div class="page-title">
                        <h1>Dashboard Overview</h1>
                        <p>Welcome back, Administrator. Here's what's happening today.</p>
                    </div>
                </div>

                <div class="dashboard-grid">
                    <!-- Quick Access Card -->
                    <div class="card">
                        <div class="card-header">
                            <div class="card-icon">
                                <i class="fas fa-tags"></i>
                            </div>
                            <div class="card-title">Category Management</div>
                        </div>
                        <div class="card-body">
                            <p>Manage all product categories in the system. You can create, update, and organize category data.</p>
                            <a href="<c:url value='/admin/categories'/>" class="btn-primary">
                                Go to Categories
                                <i class="fas fa-arrow-right" style="font-size: 12px;"></i>
                            </a>
                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>

</body>
</html>