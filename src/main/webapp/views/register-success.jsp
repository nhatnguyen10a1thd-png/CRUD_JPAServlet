<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Thành Công</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>✅</text></svg>">

    <style>
        :root {
            --bg-body: #f0f4ff;
            --bg-surface: #ffffff;
            --color-primary: #2563eb;
            --color-primary-hover: #1d4ed8;
            --color-success: #22c55e;
            --color-success-dark: #16a34a;
            --border-color: #e2e8f0;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --radius-md: 8px;
            --radius-lg: 16px;
            --shadow-lg: 0 20px 60px -12px rgb(37 99 235 / 0.15), 0 8px 24px -8px rgb(0 0 0 / 0.08);
        }

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: var(--bg-body);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background-image:
                radial-gradient(at 30% 70%, hsla(142, 70%, 50%, 0.06) 0px, transparent 50%),
                radial-gradient(at 70% 30%, hsla(220, 90%, 60%, 0.06) 0px, transparent 50%);
        }

        .success-container {
            width: 100%;
            max-width: 460px;
            animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(32px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .success-card {
            background: var(--bg-surface);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            text-align: center;
        }

        .success-header {
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
            padding: 48px 40px 40px;
            position: relative;
            overflow: hidden;
        }

        .success-header::before {
            content: '';
            position: absolute;
            top: -40%;
            right: -20%;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.08);
        }

        /* Animated Checkmark */
        .checkmark-circle {
            width: 88px;
            height: 88px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            position: relative;
            animation: scaleIn 0.5s 0.2s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        @keyframes scaleIn {
            from { opacity: 0; transform: scale(0.5); }
            to { opacity: 1; transform: scale(1); }
        }

        .checkmark-circle::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            border: 3px solid rgba(255, 255, 255, 0.3);
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.15); opacity: 0; }
        }

        .checkmark-circle i {
            font-size: 40px;
            color: #ffffff;
            animation: checkPop 0.4s 0.5s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        @keyframes checkPop {
            from { opacity: 0; transform: scale(0) rotate(-45deg); }
            to { opacity: 1; transform: scale(1) rotate(0deg); }
        }

        .success-header h1 {
            color: #ffffff;
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 6px;
            position: relative;
            animation: fadeIn 0.5s 0.6s ease both;
        }

        .success-header p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 14px;
            position: relative;
            animation: fadeIn 0.5s 0.7s ease both;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .success-body {
            padding: 36px 40px 40px;
        }

        .success-message {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: var(--radius-md);
            padding: 20px;
            margin-bottom: 28px;
            animation: fadeIn 0.5s 0.8s ease both;
        }

        .success-message p {
            color: var(--text-secondary);
            font-size: 14px;
            line-height: 1.7;
        }

        .success-message .highlight {
            color: var(--color-success-dark);
            font-weight: 600;
        }

        /* Confetti Decoration */
        .confetti {
            position: absolute;
            width: 8px;
            height: 8px;
            border-radius: 2px;
            animation: confettiFall 3s ease-in-out infinite;
        }

        .confetti:nth-child(1) { left: 15%; top: 20%; background: #fbbf24; animation-delay: 0s; }
        .confetti:nth-child(2) { left: 35%; top: 15%; background: #f472b6; animation-delay: 0.3s; }
        .confetti:nth-child(3) { left: 55%; top: 25%; background: #60a5fa; animation-delay: 0.6s; }
        .confetti:nth-child(4) { left: 75%; top: 18%; background: #a78bfa; animation-delay: 0.9s; }
        .confetti:nth-child(5) { left: 85%; top: 30%; background: #34d399; animation-delay: 1.2s; width: 6px; height: 6px; }

        @keyframes confettiFall {
            0% { opacity: 0; transform: translateY(-10px) rotate(0deg); }
            20% { opacity: 1; }
            80% { opacity: 1; }
            100% { opacity: 0; transform: translateY(40px) rotate(360deg); }
        }

        /* Buttons */
        .btn-home {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            padding: 13px;
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: #ffffff;
            border: none;
            border-radius: var(--radius-md);
            font-family: inherit;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            animation: fadeIn 0.5s 0.9s ease both;
        }

        .btn-home:hover {
            background: linear-gradient(135deg, #1d4ed8 0%, #1e3a8a 100%);
            transform: translateY(-1px);
            box-shadow: 0 8px 24px -4px rgba(37, 99, 235, 0.35);
            color: #ffffff;
        }

        @media (max-width: 480px) {
            .success-body {
                padding: 28px 20px 32px;
            }
            .success-header {
                padding: 36px 20px 32px;
            }
        }
    </style>
</head>
<body>

<div class="success-container">
    <div class="success-card">

        <!-- Header with Animated Checkmark -->
        <div class="success-header">
            <div class="confetti"></div>
            <div class="confetti"></div>
            <div class="confetti"></div>
            <div class="confetti"></div>
            <div class="confetti"></div>

            <div class="checkmark-circle">
                <i class="fas fa-check"></i>
            </div>
            <h1>Đăng Ký Thành Công!</h1>
            <p>Tài khoản của bạn đã được kích hoạt</p>
        </div>

        <!-- Body -->
        <div class="success-body">
            <div class="success-message">
                <p>
                    <span class="highlight">Chúc mừng!</span> Tài khoản của bạn đã được xác thực và kích hoạt thành công.
                    Bây giờ bạn có thể đăng nhập và sử dụng hệ thống.
                </p>
            </div>

            <a href="<c:url value='/'/>" class="btn-home">
                <i class="fas fa-home"></i>
                Về Trang Chủ
            </a>
        </div>
    </div>
</div>

</body>
</html>
