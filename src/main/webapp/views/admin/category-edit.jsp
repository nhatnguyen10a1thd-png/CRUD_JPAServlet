<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa Category</title>
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
            background-color: #ffc107;
            color: #333;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        input[type="submit"]:hover {
            background-color: #e0a800;
        }
        img.preview {
            margin-top: 10px;
            border-radius: 4px;
            border: 1px solid #ddd;
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
    <h2>Sửa Category</h2>
    <div class="form-container">
        <form action="<c:url value="/admin/category/update"/>" method="post" enctype="multipart/form-data">
            <input type="hidden" name="categoryid" value="${cate.categoryId}">

            <label for="categoryname">Tên Category:</label>
            <input type="text" id="categoryname" name="categoryname" value="${cate.categoryname}" required>

            <label for="images">Link hình ảnh (URL):</label>
            <input type="text" id="images" name="images" value="${cate.images}">

            <label>Hình ảnh hiện tại:</label>
            <c:choose>
                <c:when test="${cate.images != null && cate.images.length() >= 5 && cate.images.substring(0,5) == 'https'}">
                    <c:url value="${cate.images}" var="imgUrl"></c:url>
                </c:when>
                <c:otherwise>
                    <c:url value="/image?fname=${cate.images}" var="imgUrl"></c:url>
                </c:otherwise>
            </c:choose>
            <img class="preview" height="150" width="200" src="${imgUrl}" alt="${cate.categoryname}"/>

            <label for="images1">Upload hình ảnh mới:</label>
            <input type="file" id="images1" name="images1" accept="image/*">

            <label>Trạng thái:</label>
            <div class="radio-group">
                <input type="radio" id="ston" name="status" value="1" ${cate.status == 1 ? 'checked' : ''}>
                <label for="ston">Hoạt động</label>
                <input type="radio" id="stoff" name="status" value="0" ${cate.status != 1 ? 'checked' : ''}>
                <label for="stoff">Khóa</label>
            </div>

            <br>
            <input type="submit" value="Cập nhật">
        </form>
        <a class="back-link" href="<c:url value="/admin/categories"/>">← Quay lại danh sách</a>
    </div>
</body>
</html>
