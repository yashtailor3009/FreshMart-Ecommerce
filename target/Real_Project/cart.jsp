<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@ page import="java.util.*" %>
<%
    if(session.getAttribute("username") == null){
        response.sendRedirect("Login.jsp");
        return;
    }
    
    // Get cart from session - HashMap se kaam le rahe hain
    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
    if(cart == null) {
        cart = new ArrayList<>();
    }
    
    double totalPrice = 0;
    for(Map<String, Object> item : cart) {
        double price = (Double) item.get("price");
        int quantity = (Integer) item.get("quantity");
        totalPrice += price * quantity;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - FreshMart</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }
        body {
            background: #f5f5f5;
            padding-bottom: 100px;
        }
        .navbar {
            background: #2e7d32;
            padding: 15px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
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
        .cart-link {
            color: white;
            text-decoration: none;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .cart-count {
            background: #ff5722;
            color: white;
            border-radius: 50%;
            padding: 2px 8px;
            font-size: 12px;
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
        .cart-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
        }
        .cart-title {
            font-size: 36px;
            color: #2e7d32;
            margin-bottom: 30px;
            text-align: center;
        }
        .cart-table {
            width: 100%;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .cart-table th {
            background: #2e7d32;
            color: white;
            padding: 15px;
            text-align: left;
        }
        .cart-table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        .product-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
        }
        .quantity-input {
            width: 60px;
            text-align: center;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .remove-btn {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
        }
        .cart-summary {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-top: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: right;
        }
        .total-price {
            font-size: 28px;
            color: #2e7d32;
            font-weight: bold;
            margin: 15px 0;
        }
        .checkout-btn {
            background: #ff5722;
            color: white;
            border: none;
            padding: 12px 35px;
            border-radius: 30px;
            font-size: 16px;
            cursor: pointer;
            margin-left: 15px;
        }
        .continue-btn {
            background: #2e7d32;
            color: white;
            border: none;
            padding: 12px 35px;
            border-radius: 30px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .empty-cart {
            text-align: center;
            padding: 80px;
            background: white;
            border-radius: 12px;
        }
        .empty-cart h2 {
            color: #999;
            margin-bottom: 20px;
        }
        .shop-now-btn {
            background: #ff5722;
            color: white;
            text-decoration: none;
            padding: 12px 30px;
            border-radius: 30px;
            display: inline-block;
        }
        .toast {
            visibility: hidden;
            min-width: 250px;
            background-color: #2e7d32;
            color: white;
            text-align: center;
            border-radius: 8px;
            padding: 12px;
            position: fixed;
            bottom: 30px;
            right: 30px;
            z-index: 1000;
        }
        .toast.show {
            visibility: visible;
            animation: fadeInOut 2s;
        }
        @keyframes fadeInOut {
            0% { opacity: 0; transform: translateX(100px); }
            10% { opacity: 1; transform: translateX(0); }
            90% { opacity: 1; transform: translateX(0); }
            100% { opacity: 0; transform: translateX(100px); }
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
        <a href="cart.jsp" class="cart-link">
            🛒 Cart <span id="cartCount" class="cart-count"><%= cart.size() %></span>
        </a>
        <span class="user-name">👋 ${sessionScope.username}</span>
        <a href="Logout" class="logout-btn">Logout</a>
    </div>
</div>

<div class="cart-container">
    <h1 class="cart-title">🛍️ Your Shopping Cart</h1>
    
    <% if(cart.isEmpty()) { %>
        <div class="empty-cart">
            <h2>🛒 Your cart is empty!</h2>
            <p>Looks like you haven't added any items yet.</p>
            <br>
            <a href="dashboard.jsp" class="shop-now-btn">🛍️ Continue Shopping</a>
        </div>
    <% } else { %>
        <table class="cart-table">
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% for(Map<String, Object> item : cart) { 
                    int id = (Integer) item.get("id");
                    String name = (String) item.get("name");
                    double price = (Double) item.get("price");
                    int quantity = (Integer) item.get("quantity");
                    String image = (String) item.get("image");
                %>
                <tr>
                    <td><img src="<%= image %>" class="product-img" alt="<%= name %>"></td>
                    <td><strong><%= name %></strong></td>
                    <td>₹<%= price %></td>
                    <td>
                        <input type="number" class="quantity-input" id="qty_<%= id %>" value="<%= quantity %>" min="1" onchange="updateQuantity(<%= id %>, this.value)">
                    </td>
                    <td id="total_<%= id %>">₹<%= price * quantity %></td>
                    <td>
                        <button class="remove-btn" onclick="removeFromCart(<%= id %>)">Remove</button>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <div class="cart-summary">
            <h3>Order Summary</h3>
            <div class="total-price">
                Total: ₹<span id="grandTotal"><%= totalPrice %></span>
            </div>
            <a href="dashboard.jsp" class="continue-btn">🛍️ Continue Shopping</a>
            <button class="checkout-btn" onclick="checkout()">💰 Buy Now</button>
        </div>
    <% } %>
</div>

<div id="toast" class="toast"></div>

<script>
    function showToast(message) {
        const toast = document.getElementById('toast');
        toast.textContent = message;
        toast.className = "toast show";
        setTimeout(() => {
            toast.className = "toast";
        }, 2000);
    }
    
    function updateQuantity(productId, newQuantity) {
        fetch('UpdateCart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'productId=' + productId + '&quantity=' + newQuantity
        })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
                document.getElementById('total_' + productId).innerHTML = '₹' + data.itemTotal;
                document.getElementById('grandTotal').innerText = data.cartTotal;
                document.getElementById('cartCount').innerText = data.cartCount;
                showToast("Cart updated!");
            }
        })
        .catch(error => console.error('Error:', error));
    }
    
    function removeFromCart(productId) {
        if(confirm('Remove this item from cart?')) {
            fetch('RemoveFromCart', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'productId=' + productId
            })
            .then(response => response.json())
            .then(data => {
                if(data.success) {
                    showToast("Item removed from cart");
                    setTimeout(() => location.reload(), 500);
                }
            })
            .catch(error => console.error('Error:', error));
        }
    }
    
    function checkout() {
        //alert("🛒 Proceeding to checkout!\nTotal Amount: ₹" + document.getElementById('grandTotal').innerText);
        window.location.href = 'payment.jsp';
    }
</script>

</body>
</html>