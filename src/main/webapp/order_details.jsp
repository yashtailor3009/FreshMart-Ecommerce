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
    <title>Order Details - FreshMart</title>
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
        .details-container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .back-btn {
            background: #2e7d32;
            color: white;
            text-decoration: none;
            padding: 8px 20px;
            border-radius: 25px;
            display: inline-block;
            margin-bottom: 20px;
        }
        .card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .section-title {
            font-size: 20px;
            color: #2e7d32;
            margin-bottom: 15px;
            border-left: 4px solid #ff5722;
            padding-left: 12px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
        .info-item {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        .info-label {
            font-weight: bold;
            color: #333;
        }
        .info-value {
            color: #666;
            margin-top: 5px;
        }
        .status-pending { background: #ff9800; color: white; display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .status-shipped { background: #2196f3; color: white; display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .status-delivered { background: #4caf50; color: white; display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        th {
            background: #2e7d32;
            color: white;
        }
        .total {
            text-align: right;
            margin-top: 20px;
            font-size: 20px;
            font-weight: bold;
            color: #2e7d32;
        }
        .btn-invoice {
            background: #ff5722;
            color: white;
            text-decoration: none;
            padding: 10px 25px;
            border-radius: 30px;
            display: inline-block;
            margin-top: 15px;
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

<div class="details-container">
    <a href="OrderHistory" class="back-btn">← Back to Orders</a>
    
    <div class="card">
        <h2 class="section-title">📄 Order Information</h2>
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Order Number</div>
                <div class="info-value">${order.orderNumber}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Order Date</div>
                <div class="info-value">${order.orderDate}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Order Status</div>
                <div class="info-value"><span class="status-${order.status.toLowerCase()}">${order.status}</span></div>
            </div>
            <div class="info-item">
                <div class="info-label">Payment Method</div>
                <div class="info-value">${order.paymentMethod}</div>
            </div>
        </div>
    </div>
    
    <div class="card">
        <h2 class="section-title">👤 Customer Details</h2>
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Full Name</div>
                <div class="info-value">${order.customerName}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Email</div>
                <div class="info-value">${order.email}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Phone</div>
                <div class="info-value">${order.phone}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Address</div>
                <div class="info-value">${order.address}, ${order.city} - ${order.pincode}</div>
            </div>
        </div>
    </div>
    
    <div class="card">
        <h2 class="section-title">🛒 Order Items</h2>
        <table>
            <thead>
                <tr><th>#</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>
            </thead>
            <tbody>
                <c:forEach items="${orderItems}" var="item" varStatus="status">
                    <tr>
                        <td>${status.count}</td>
                        <td>${item.productName}</td>
                        <td>${item.quantity}</td>
                        <td>₹${item.price}</td>
                        <td>₹${item.subtotal}</td>
                     </tr>
                </c:forEach>
            </tbody>
        </table>
        <div class="total">
            Grand Total: ₹${order.totalAmount}
        </div>
        <div style="text-align: center; margin-top: 20px;">
            <a href="DownloadInvoice?orderId=${order.id}" class="btn-invoice" target="_blank">📄 Download Invoice PDF</a>
        </div>
    </div>
</div>

</body>
</html>