<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if(session.getAttribute("username") == null){
        response.sendRedirect("Login.jsp");
        return;
    }
    
    Map<String, Object> orderDetails = (Map<String, Object>) session.getAttribute("orderDetails");
    if(orderDetails == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - FreshMart</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }
        body {
            background: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        .confirmation-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            animation: fadeIn 0.5s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .checkmark {
            width: 80px;
            height: 80px;
            background: #2e7d32;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            animation: scaleIn 0.3s ease 0.3s both;
        }
        @keyframes scaleIn {
            from { transform: scale(0); }
            to { transform: scale(1); }
        }
        .checkmark span {
            font-size: 50px;
            color: white;
        }
        h1 {
            color: #2e7d32;
            margin-bottom: 10px;
        }
        .order-number {
            font-size: 18px;
            color: #ff5722;
            margin: 10px 0;
            font-weight: bold;
        }
        .order-details {
            text-align: left;
            margin: 20px 0;
            padding: 20px;
            background: #f5f5f5;
            border-radius: 10px;
        }
        .order-details p {
            margin: 8px 0;
        }
        .email-status {
            background: #e8f5e9;
            padding: 10px;
            border-radius: 8px;
            margin-top: 15px;
        }
        .email-status.success {
            background: #e8f5e9;
            color: #2e7d32;
        }
        .email-status.error {
            background: #ffebee;
            color: #c62828;
        }
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        .btn {
            padding: 12px 25px;
            border-radius: 30px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            transition: 0.3s;
        }
        .btn-primary {
            background: #ff5722;
            color: white;
        }
        .btn-primary:hover {
            background: #e64a19;
        }
        .btn-secondary {
            background: #2e7d32;
            color: white;
        }
        .btn-secondary:hover {
            background: #1b5e20;
        }
        .btn-invoice {
            background: #2196f3;
            color: white;
        }
        .btn-invoice:hover {
            background: #1976d2;
        }
    </style>
</head>
<body>
    <div class="confirmation-card">
        <div class="checkmark">
            <span>✓</span>
        </div>
        <h1>Order Confirmed! 🎉</h1>
        <p>Thank you for shopping with FreshMart</p>
        
        <div class="order-number">
            Order #${orderDetails.orderNumber}
        </div>
        
        <div class="order-details">
            <p><strong>Order ID:</strong> #${orderDetails.orderId}</p>
            <p><strong>Name:</strong> ${orderDetails.fullname}</p>
            <p><strong>Phone:</strong> ${orderDetails.phone}</p>
            <p><strong>Address:</strong> ${orderDetails.address}, ${orderDetails.city} - ${orderDetails.pincode}</p>
            <p><strong>Payment Method:</strong> ${orderDetails.paymentMethod}</p>
            <p><strong>Amount Paid:</strong> ₹${orderDetails.grandTotal}</p>
        </div>
        
        <c:if test="${orderDetails.emailSent}">
            <div class="email-status success">
                ✅ A confirmation email has been sent to ${orderDetails.email}
            </div>
        </c:if>
        <c:if test="${not orderDetails.emailSent}">
            <div class="email-status error">
                ⚠️ Could not send email. Please check your email address.
            </div>
        </c:if>
        
        <div class="btn-group">
            <a href="OrderHistory" class="btn btn-primary">📦 View My Orders</a>
            <a href="dashboard.jsp" class="btn btn-secondary">🛍️ Continue Shopping</a>
            <a href="DownloadInvoice?orderId=${orderDetails.orderId}" class="btn btn-invoice" target="_blank">📄 Download Invoice</a>
        </div>
    </div>
</body>
</html>