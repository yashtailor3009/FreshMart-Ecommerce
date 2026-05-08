<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@ page import="java.util.*" %>
<%
    if(session.getAttribute("username") == null){
        response.sendRedirect("Login.jsp");
        return;
    }
    
    // Get cart from session
    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
    if(cart == null || cart.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }
    
    double totalPrice = 0;
    for(Map<String, Object> item : cart) {
        double price = (Double) item.get("price");
        int quantity = (Integer) item.get("quantity");
        totalPrice += price * quantity;
    }
    
    double deliveryCharge = (totalPrice < 500) ? 40 : 0;
    double grandTotal = totalPrice + deliveryCharge;
    
    // Create UPI Payment Link
    String upiId = "freshmart@okhdfcbank"; // 🔥 CHANGE THIS - Your UPI ID
    String payeeName = "FreshMart";
    String transactionNote = "FreshMart Order Payment";
    
    // UPI Intent URL for Google Pay
    String upiIntentUrl = "upi://pay?pa=" + upiId + 
                          "&pn=" + payeeName + 
                          "&am=" + grandTotal + 
                          "&cu=INR" +
                          "&tn=" + transactionNote;
    
    // QR Code content (same UPI intent URL)
    String qrContent = upiIntentUrl;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - FreshMart</title>
    <!-- Include QR Code Library -->
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
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
        .nav-links a {
            color: white;
            text-decoration: none;
            margin: 0 10px;
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
        .payment-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }
        .payment-form {
            flex: 2;
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .order-summary {
            flex: 1;
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: fit-content;
            position: sticky;
            top: 100px;
        }
        .section-title {
            font-size: 24px;
            color: #2e7d32;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #2e7d32;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
        }
        .form-row {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .form-row .form-group {
            flex: 1;
        }
        .payment-option {
            border: 2px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .payment-option:hover {
            border-color: #2e7d32;
        }
        .payment-option.selected {
            border-color: #2e7d32;
            background: #e8f5e9;
        }
        .payment-option input {
            width: 20px;
            height: 20px;
        }
        .payment-option label {
            cursor: pointer;
            margin: 0;
            flex: 1;
        }
        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .summary-total {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            font-size: 20px;
            font-weight: bold;
            color: #2e7d32;
            border-top: 2px solid #2e7d32;
            margin-top: 10px;
        }
        .pay-btn {
            width: 100%;
            background: #ff5722;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 30px;
            font-size: 18px;
            cursor: pointer;
            margin-top: 20px;
            font-weight: bold;
        }
        .pay-btn:hover {
            background: #e64a19;
        }
        .back-btn {
            background: #2e7d32;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 25px;
            display: inline-block;
            margin-bottom: 20px;
        }
        
        /* UPI QR Code Styles */
        .upi-qr-container {
            text-align: center;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 12px;
            margin-top: 20px;
            display: none;
        }
        .upi-qr-container h3 {
            color: #2e7d32;
            margin-bottom: 15px;
        }
        .upi-qr-container p {
            margin: 10px 0;
            color: #666;
        }
        .upi-qr-code {
            display: flex;
            justify-content: center;
            margin: 20px 0;
        }
        .upi-app-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 15px;
        }
        .upi-app-btn {
            background: #2e7d32;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 25px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            transition: 0.3s;
        }
        .upi-app-btn:hover {
            background: #1b5e20;
            transform: scale(1.05);
        }
        .upi-app-btn.gpay { background: #1a73e8; }
        .upi-app-btn.phonepe { background: #5c35b5; }
        .upi-app-btn.paytm { background: #00baf2; }
        .upi-id {
            background: #e8f5e9;
            padding: 10px;
            border-radius: 8px;
            font-family: monospace;
            font-size: 16px;
            margin: 10px 0;
            word-break: break-all;
        }
        
        /* COD Success Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            max-width: 400px;
            animation: slideIn 0.3s ease;
        }
        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .modal-content .checkmark {
            width: 60px;
            height: 60px;
            background: #2e7d32;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
        }
        .modal-content .checkmark span {
            font-size: 35px;
            color: white;
        }
        .modal-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 20px;
        }
        .modal-btn {
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-size: 14px;
        }
        .modal-btn-primary {
            background: #ff5722;
            color: white;
        }
        .modal-btn-secondary {
            background: #2e7d32;
            color: white;
        }
        
        @media (max-width: 768px) {
            .payment-container {
                flex-direction: column;
            }
            body {
                padding-top: 120px;
            }
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">Fresh<span>Mart</span></div>
    <div class="nav-links">
        <a href="dashboard.jsp">Home</a>
        <a href="dashboard.jsp#products">Shop</a>
        <a href="#">Contact</a>
    </div>
    <div class="user-info">
        <span class="user-name">👋 ${sessionScope.username}</span>
        <a href="Logout" class="logout-btn">Logout</a>
    </div>
</div>

<div class="payment-container">
    <div class="payment-form">
        <a href="cart.jsp" class="back-btn">← Back to Cart</a>
        <h2 class="section-title">📋 Billing Details</h2>
        
        <form id="paymentForm" action="ProcessPayment" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullname" placeholder="Enter full name" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" placeholder="Enter email" required>
                </div>
            </div>
            
            <div class="form-group">
                <label>Phone Number</label>
                <input type="tel" name="phone" placeholder="Enter phone number" required>
            </div>
            
            <div class="form-group">
                <label>Address</label>
                <input type="text" name="address" placeholder="Enter delivery address" required>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>City</label>
                    <input type="text" name="city" placeholder="City" required>
                </div>
                <div class="form-group">
                    <label>Pin Code</label>
                    <input type="text" name="pincode" placeholder="Pin code" required>
                </div>
            </div>
            
            <h2 class="section-title" style="margin-top: 30px;">💳 Payment Method</h2>
            
            <div class="payment-option" onclick="selectPayment('card')">
                <input type="radio" name="paymentMethod" value="card" id="cardRadio">
                <label for="cardRadio">💳 Credit/Debit Card</label>
            </div>
            
            <div class="payment-option" onclick="selectPayment('upi')">
                <input type="radio" name="paymentMethod" value="upi" id="upiRadio">
                <label for="upiRadio">📱 UPI (Google Pay, PhonePe, Paytm)</label>
            </div>
            
            <div class="payment-option" onclick="selectPayment('cod')">
                <input type="radio" name="paymentMethod" value="cod" id="codRadio">
                <label for="codRadio">💵 Cash on Delivery</label>
            </div>
            
            <!-- Card Details (shown only when card selected) -->
            <div id="cardDetails" style="margin-top: 20px; display: none;">
                <div class="form-row">
                    <div class="form-group">
                        <label>Card Number</label>
                        <input type="text" name="cardNumber" placeholder="1234 5678 9012 3456">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Expiry Date</label>
                        <input type="text" name="expiry" placeholder="MM/YY">
                    </div>
                    <div class="form-group">
                        <label>CVV</label>
                        <input type="password" name="cvv" placeholder="123">
                    </div>
                </div>
                <div class="form-group">
                    <label>Cardholder Name</label>
                    <input type="text" name="cardName" placeholder="Name on card">
                </div>
            </div>
            
            <!-- UPI QR Code Container -->
            <div id="upiQRContainer" class="upi-qr-container">
                <h3>📱 Scan & Pay via UPI</h3>
                <p>Scan this QR code with any UPI app to pay</p>
                <div id="qrcode" class="upi-qr-code"></div>
                <div class="upi-id">
                    UPI ID: <strong><%= upiId %></strong>
                </div>
                <p style="font-size: 14px;">Amount: ₹<%= grandTotal %></p>
                <div class="upi-app-buttons">
                    <a href="#" id="googlePayBtn" class="upi-app-btn gpay">🔵 Pay with Google Pay</a>
                    <a href="#" id="phonePeBtn" class="upi-app-btn phonepe">🟣 Pay with PhonePe</a>
                    <a href="#" id="paytmBtn" class="upi-app-btn paytm">🔷 Pay with Paytm</a>
                </div>
                <p style="font-size: 12px; margin-top: 15px;">After payment, click the button below to confirm order</p>
                <button type="button" id="confirmUpiPayment" class="pay-btn" style="background: #2e7d32;">✅ I have made the payment</button>
            </div>
            
            <button type="submit" id="submitPaymentBtn" class="pay-btn">✅ Pay ₹<%= grandTotal %> & Place Order</button>
        </form>
    </div>
    
    <div class="order-summary">
        <h2 class="section-title">🛒 Order Summary</h2>
        <div class="summary-item">
            <span>Subtotal</span>
            <span>₹<%= totalPrice %></span>
        </div>
        <% if(deliveryCharge > 0) { %>
        <div class="summary-item">
            <span>Delivery Charge</span>
            <span>₹<%= deliveryCharge %></span>
        </div>
        <% } else { %>
        <div class="summary-item">
            <span>Delivery Charge</span>
            <span>Free 🎉</span>
        </div>
        <% } %>
        <div class="summary-total">
            <span>Grand Total</span>
            <span>₹<%= grandTotal %></span>
        </div>
        <div style="margin-top: 20px; padding: 15px; background: #e8f5e9; border-radius: 8px;">
            <p style="color: #2e7d32;">✅ Free delivery on orders above ₹500</p>
            <p style="color: #2e7d32;">✅ 100% Secure Payment</p>
            <p style="color: #2e7d32;">✅ 30 Minutes Delivery</p>
        </div>
    </div>
</div>

<!-- Success Modal for COD -->
<div id="successModal" class="modal">
    <div class="modal-content">
        <div class="checkmark"><span>✓</span></div>
        <h2>Order Placed Successfully!</h2>
        <p>Your order has been placed. You will receive a confirmation email shortly.</p>
        <div class="modal-buttons">
            <a href="OrderHistory" class="modal-btn modal-btn-primary">View Orders</a>
            <a href="dashboard.jsp" class="modal-btn modal-btn-secondary">Continue Shopping</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
<script>
    let currentPaymentMethod = 'card';
    const upiId = '<%= upiId %>';
    const amount = <%= grandTotal %>;
    const payeeName = 'FreshMart';
    
    // UPI Intent URLs for different apps
    const upiIntentUrl = `upi://pay?pa=${upiId}&pn=${payeeName}&am=${amount}&cu=INR`;
    
    const appDeepLinks = {
        gpay: `gpay://upi/pay?pa=${upiId}&pn=${payeeName}&am=${amount}&cu=INR`,
        phonepe: `phonepe://pay?pa=${upiId}&pn=${payeeName}&am=${amount}&cu=INR`,
        paytm: `paytmmp://pay?pa=${upiId}&pn=${payeeName}&am=${amount}&cu=INR`
    };
    
    function selectPayment(method) {
        currentPaymentMethod = method;
        
        document.getElementById('cardRadio').checked = (method === 'card');
        document.getElementById('upiRadio').checked = (method === 'upi');
        document.getElementById('codRadio').checked = (method === 'cod');
        
        const cardDetails = document.getElementById('cardDetails');
        const upiQRContainer = document.getElementById('upiQRContainer');
        const submitBtn = document.getElementById('submitPaymentBtn');
        
        if (method === 'card') {
            cardDetails.style.display = 'block';
            upiQRContainer.style.display = 'none';
            submitBtn.style.display = 'block';
        } else if (method === 'upi') {
            cardDetails.style.display = 'none';
            upiQRContainer.style.display = 'block';
            submitBtn.style.display = 'none';
            generateQRCode();
        } else {
            cardDetails.style.display = 'none';
            upiQRContainer.style.display = 'none';
            submitBtn.style.display = 'block';
        }
    }
    
    let qr = null;
    function generateQRCode() {
        const qrContainer = document.getElementById('qrcode');
        qrContainer.innerHTML = '';
        qr = new QRCode(qrContainer, {
            text: upiIntentUrl,
            width: 200,
            height: 200,
            colorDark: "#2e7d32",
            colorLight: "#ffffff",
            correctLevel: QRCode.CorrectLevel.H
        });
    }
    
    // Open UPI apps
    document.getElementById('googlePayBtn').addEventListener('click', function(e) {
        e.preventDefault();
        window.location.href = appDeepLinks.gpay;
        setTimeout(() => {
            window.location.href = upiIntentUrl;
        }, 500);
    });
    
    document.getElementById('phonePeBtn').addEventListener('click', function(e) {
        e.preventDefault();
        window.location.href = appDeepLinks.phonepe;
        setTimeout(() => {
            window.location.href = upiIntentUrl;
        }, 500);
    });
    
    document.getElementById('paytmBtn').addEventListener('click', function(e) {
        e.preventDefault();
        window.location.href = appDeepLinks.paytm;
        setTimeout(() => {
            window.location.href = upiIntentUrl;
        }, 500);
    });
    
    // Confirm UPI payment
    document.getElementById('confirmUpiPayment').addEventListener('click', function() {
        if (confirm('Have you successfully completed the payment?')) {
            document.getElementById('paymentForm').submit();
        }
    });
    
    // Handle form submission for Card and COD
    document.getElementById('paymentForm').addEventListener('submit', function(e) {
        if (currentPaymentMethod === 'upi') {
            e.preventDefault();
            alert('Please scan the QR code and complete payment first, then click "I have made the payment" button.');
        }
    });
    
    selectPayment('card');
</script>

</body>
</html>