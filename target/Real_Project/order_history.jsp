<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    if(session.getAttribute("username") == null){
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - FreshMart</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }
        body {
            background: #f5f5f5;
            padding-top: 80px;
        }
        .navbar {
            background: #2e7d32;
            padding: 15px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
        .logo {
            font-size: 28px;
            font-weight: bold;
            color: white;
        }
        .logo span { color: #ffeb3b; }
        .nav-links {
            display: flex;
            gap: 25px;
        }
        .nav-links a {
            color: white;
            text-decoration: none;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .user-name {
            color: white;
            background: rgba(255,255,255,0.2);
            padding: 6px 15px;
            border-radius: 20px;
        }
        .logout-btn {
            background: #dc3545;
            color: white;
            text-decoration: none;
            padding: 6px 18px;
            border-radius: 20px;
        }
        .orders-container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .page-title {
            font-size: 32px;
            color: #2e7d32;
            margin-bottom: 30px;
            text-align: center;
        }
        .order-card {
            background: white;
            border-radius: 12px;
            margin-bottom: 20px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
            margin-bottom: 15px;
        }
        .order-number {
            font-size: 18px;
            font-weight: bold;
            color: #2e7d32;
        }
        .order-date {
            color: #666;
        }
        .order-status {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-pending { background: #ff9800; color: white; }
        .status-shipped { background: #2196f3; color: white; }
        .status-delivered { background: #4caf50; color: white; }
        .order-items {
            margin-bottom: 15px;
        }
        .order-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .order-total {
            text-align: right;
            font-size: 18px;
            font-weight: bold;
            color: #2e7d32;
            margin-top: 10px;
        }
        .order-actions {
            margin-top: 15px;
            display: flex;
            gap: 15px;
            justify-content: flex-end;
        }
        .btn-view, .btn-invoice {
            padding: 8px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-size: 14px;
        }
        .btn-view {
            background: #2e7d32;
            color: white;
        }
        .btn-invoice {
            background: #ff5722;
            color: white;
        }
        .empty-cart {
            text-align: center;
            padding: 80px;
            background: white;
            border-radius: 12px;
        }
        .shop-now-btn {
            background: #ff5722;
            color: white;
            text-decoration: none;
            padding: 12px 30px;
            border-radius: 30px;
            display: inline-block;
            margin-top: 20px;
        }
        @media (max-width: 768px) {
            body { padding-top: 120px; }
            .order-header { flex-direction: column; gap: 10px; }
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">Fresh<span>Mart</span></div>
    <div class="nav-links">
        <a href="dashboard.jsp">Home</a>
        <a href="dashboard.jsp#products">Shop</a>
        <a href="OrderHistory">My Orders</a>
    </div>
    <div class="user-info">
        <span class="user-name">👋 ${sessionScope.username}</span>
        <a href="Logout" class="logout-btn">Logout</a>
    </div>
</div>

<div class="orders-container">
    <h1 class="page-title">📋 My Orders</h1>
    
    <c:if test="${empty orders}">
        <div class="empty-cart">
            <h2>📦 No orders yet!</h2>
            <p>You haven't placed any orders yet.</p>
            <a href="dashboard.jsp" class="shop-now-btn">🛍️ Start Shopping</a>
        </div>
    </c:if>
    
    <c:forEach items="${orders}" var="order">
        <div class="order-card">
            <div class="order-header">
                <div class="order-number">${order.orderNumber}</div>
                <div class="order-date">📅 ${order.orderDate}</div>
                <div class="order-status status-${order.status.toLowerCase()}">${order.status}</div>
            </div>
            <div class="order-total">
                Total: ₹${order.totalAmount}
            </div>
            <div class="order-actions">
                <a href="ViewOrderDetails?orderId=${order.id}" class="btn-view">👁️ View Details</a>
                <a href="DownloadInvoice?orderId=${order.id}" class="btn-invoice" target="_blank">📄 Download Invoice</a>
            </div>
        </div>
    </c:forEach>
</div>

</body>
</html>