<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách Category</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        h2 {
            color: #333;
        }
        a.btn-add {
            display: inline-block;
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        a.btn-add:hover {
            background-color: #218838;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #343a40;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #e9ecef;
        }
        a.action-link {
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 3px;
            color: white;
        }
        a.edit-link {
            background-color: #ffc107;
            color: #333;
        }
        a.delete-link {
            background-color: #dc3545;
        }
        a.edit-link:hover {
            background-color: #e0a800;
        }
        a.delete-link:hover {
            background-color: #c82333;
        }
        .status-active {
            color: #28a745;
            font-weight: bold;
        }
        .status-locked {
            color: #dc3545;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h2>Quản lý Category</h2>
    <a class="btn-add" href="<c:url value="/admin/category/add"/>">+ Thêm Category</a>
    <hr>
    <table>
        <tr>
            <th>STT</th>
            <th>Hình ảnh</th>
            <th>Tên Category</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
        <c:forEach items="${listcate}" var="cate" varStatus="STT">
            <tr>
                <td>${STT.index + 1}</td>
                <td>
                    <c:choose>
                        <c:when test="${cate.images != null && cate.images.length() >= 5 && cate.images.substring(0,5) == 'https'}">
                            <c:url value="${cate.images}" var="imgUrl"></c:url>
                        </c:when>
                        <c:otherwise>
                            <c:url value="/image?fname=${cate.images}" var="imgUrl"></c:url>
                        </c:otherwise>
                    </c:choose>
                    <img height="100" width="150" src="${imgUrl}" alt="${cate.categoryname}" style="border-radius: 4px;"/>
                </td>
                <td>${cate.categoryname}</td>
                <td>
                    <c:if test="${cate.status == 1}">
                        <span class="status-active">Hoạt động</span>
                    </c:if>
                    <c:if test="${cate.status != 1}">
                        <span class="status-locked">Khóa</span>
                    </c:if>
                </td>
                <td>
                    <a class="action-link edit-link" href="<c:url value='/admin/category/edit?id=${cate.categoryId}'/>">Sửa</a>
                    &nbsp;
                    <a class="action-link delete-link" href="<c:url value='/admin/category/delete?id=${cate.categoryId}'/>"
                       onclick="return confirm('Bạn có chắc chắn muốn xóa?')">Xóa</a>
                </td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
