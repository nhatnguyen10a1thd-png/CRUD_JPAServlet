<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Category</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        h2 {
            color: #333;
        }
        .form-container {
            background-color: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            max-width: 500px;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            color: #555;
        }
        input[type="text"], input[type="file"] {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        input[type="text"]:focus, input[type="file"]:focus {
            border-color: #007bff;
            outline: none;
        }
        .radio-group {
            margin-top: 5px;
        }
        .radio-group label {
            display: inline;
            font-weight: normal;
            margin-left: 5px;
        }
        .radio-group input[type="radio"] {
            margin-left: 15px;
        }
        .radio-group input[type="radio"]:first-of-type {
            margin-left: 0;
        }
        input[type="submit"] {
            margin-top: 20px;
            padding: 10px 30px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        a.back-link {
            display: inline-block;
            margin-top: 15px;
            color: #007bff;
            text-decoration: none;
        }
        a.back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h2>Thêm Category mới</h2>
    <div class="form-container">
        <form action="<c:url value="/admin/category/insert"/>" method="post" enctype="multipart/form-data">
            <label for="categoryname">Tên Category:</label>
            <input type="text" id="categoryname" name="categoryname" required>

            <label for="images">Link hình ảnh (URL):</label>
            <input type="text" id="images" name="images" placeholder="https://example.com/image.jpg">

            <label for="images1">Hoặc Upload hình ảnh:</label>
            <input type="file" id="images1" name="images1" accept="image/*">

            <label>Trạng thái:</label>
            <div class="radio-group">
                <input type="radio" id="ston" name="status" value="1" checked>
                <label for="ston">Hoạt động</label>
                <input type="radio" id="stoff" name="status" value="0">
                <label for="stoff">Khóa</label>
            </div>

            <br>
            <input type="submit" value="Thêm mới">
        </form>
        <a class="back-link" href="<c:url value="/admin/categories"/>">← Quay lại danh sách</a>
    </div>
</body>
</html>
