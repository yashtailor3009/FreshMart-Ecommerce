<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@ page import="java.util.*" %>
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
    <title>Order Confirmation - FreshMart</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background: #f5f5f5; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .confirmation-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            max-width: 500px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
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
        }
        .checkmark span { font-size: 50px; color: white; }
        h1 { color: #2e7d32; margin-bottom: 10px; }
        .order-details { text-align: left; margin: 20px 0; padding: 20px; background: #f5f5f5; border-radius: 10px; }
        .btn { background: #ff5722; color: white; text-decoration: none; padding: 12px 30px; border-radius: 30px; display: inline-block; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="confirmation-card">
        <div class="checkmark"><span>✓</span></div>
        <h1>Order Confirmed! 🎉</h1>
        <p>Thank you for shopping with FreshMart</p>
        <div class="order-details">
            <p><strong>Order ID:</strong> #FRESH<%= System.currentTimeMillis() %></p>
            <p><strong>Amount Paid:</strong> ₹<%= orderDetails.get("grandTotal") %></p>
            <p><strong>Payment Method:</strong> <%= orderDetails.get("paymentMethod") %></p>
            <p><strong>Delivery Address:</strong> <%= orderDetails.get("address") %></p>
        </div>
        <a href="dashboard.jsp" class="btn">Continue Shopping →</a>
    </div>
</body>
</html>