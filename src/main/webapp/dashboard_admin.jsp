<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
<%@ page import="com.springmvc.real_project.Order" %>
<%
    if(session.getAttribute("username") == null){
        response.sendRedirect("Login.jsp");
        return;
    }
    
    if(!"ADMIN".equals(session.getAttribute("role"))){
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - FreshMart</title>
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
            background: #1a1a2e;
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
        .logo span { color: #ff5722; }
        .nav-links {
            display: flex;
            gap: 25px;
            flex-wrap: wrap;
        }
        .nav-links a {
            color: white;
            text-decoration: none;
            font-size: 16px;
            cursor: pointer;
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
            font-size: 14px;
        }
        
        /* Dashboard Stats Cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            padding: 30px 5%;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-card.orders { border-bottom: 5px solid #2196f3; }
        .stat-card.revenue { border-bottom: 5px solid #4caf50; }
        .stat-card.customers { border-bottom: 5px solid #ff9800; }
        .stat-card.pending { border-bottom: 5px solid #f44336; }
        
        .stat-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        .stat-value {
            font-size: 36px;
            font-weight: bold;
            color: #333;
        }
        .stat-label {
            font-size: 16px;
            color: #666;
            margin-top: 10px;
        }
        
        /* Charts Section */
        .charts-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 25px;
            padding: 0 5% 30px;
        }
        .chart-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .chart-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #333;
            border-left: 4px solid #ff5722;
            padding-left: 12px;
        }
        
        /* Recent Orders Table */
        .recent-section {
            padding: 0 5% 50px;
        }
        .section-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
            border-left: 4px solid #ff5722;
            padding-left: 15px;
        }
        .orders-table {
            width: 100%;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .orders-table th {
            background: #1a1a2e;
            color: white;
            padding: 15px;
            text-align: left;
        }
        .orders-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        .orders-table tr:hover {
            background: #f9f9f9;
        }
        .status-pending {
            background: #ff9800;
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
        .status-delivered {
            background: #4caf50;
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
        .status-shipped {
            background: #2196f3;
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
        
        /* Products Management Section */
        .products-section {
            padding: 0 5% 50px;
        }
        .add-product-btn {
            background: #4caf50;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            cursor: pointer;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .add-product-btn:hover {
            background: #45a049;
        }
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
        }
        .product-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            padding-bottom: 15px;
        }
        .product-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }
        .product-card h4 {
            margin: 10px 0;
        }
        .product-card .price {
            color: #2e7d32;
            font-size: 18px;
            font-weight: bold;
        }
        .product-actions {
            margin-top: 10px;
        }
        .edit-btn, .delete-btn {
            border: none;
            padding: 5px 12px;
            border-radius: 15px;
            cursor: pointer;
            margin: 0 3px;
            font-size: 12px;
        }
        .edit-btn {
            background: #2196f3;
            color: white;
        }
        .delete-btn {
            background: #f44336;
            color: white;
        }
        
        .footer {
            background: #1a1a2e;
            color: white;
            text-align: center;
            padding: 30px;
            margin-top: 50px;
        }
        
        @media (max-width: 768px) {
            body { padding-top: 120px; }
            .stats-container {
                grid-template-columns: 1fr 1fr;
            }
            .charts-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<div class="navbar">
    <div class="logo">Fresh<span>Mart</span> <span style="font-size: 12px; background: #ff5722; padding: 2px 8px; border-radius: 20px; margin-left: 10px;">ADMIN</span></div>
    <div class="nav-links">
        <a onclick="showSection('dashboard')">Dashboard</a>
        <a onclick="showSection('orders')">Orders</a>
        <a onclick="showSection('products')">Products</a>
        <a onclick="showSection('customers')">Customers</a>
    </div>
    <div class="user-info">
        <span class="user-name">👑 Admin ${sessionScope.username}</span>
        <a href="Logout" class="logout-btn">Logout</a>
    </div>
</div>

<!-- Dashboard Section -->
<div id="dashboardSection" class="dashboard-section">
    <!-- Stats Cards -->
    <div class="stats-container">
        <div class="stat-card orders">
            <div class="stat-icon">📦</div>
            <div class="stat-value" id="totalOrders">0</div>
            <div class="stat-label">Total Orders</div>
        </div>
        <div class="stat-card revenue">
            <div class="stat-icon">💰</div>
            <div class="stat-value" id="totalRevenue">₹0</div>
            <div class="stat-label">Total Revenue</div>
        </div>
        <div class="stat-card customers">
            <div class="stat-icon">👥</div>
            <div class="stat-value" id="totalCustomers">0</div>
            <div class="stat-label">Total Customers</div>
        </div>
        <div class="stat-card pending">
            <div class="stat-icon">⏳</div>
            <div class="stat-value" id="pendingOrders">0</div>
            <div class="stat-label">Pending Orders</div>
        </div>
    </div>
    
    <!-- Charts -->
    <div class="charts-container">
        <div class="chart-card">
            <div class="chart-title">📊 Monthly Orders</div>
            <canvas id="ordersChart" height="200"></canvas>
        </div>
        <div class="chart-card">
            <div class="chart-title">💰 Revenue by Category</div>
            <canvas id="revenueChart" height="200"></canvas>
        </div>
    </div>
    
    <!-- Recent Orders -->
    <div class="recent-section">
        <h2 class="section-title">🕒 Recent Orders</h2>
        <table class="orders-table" id="recentOrdersTable">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>Date</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="recentOrdersBody">
                <tr><td colspan="6" style="text-align:center;">Loading...</td></tr>
            </tbody>
        </table>
    </div>
</div>

<!-- Orders Section -->
<div id="ordersSection" style="display: none;">
    <div class="stats-container" style="padding: 30px 5% 0;">
        <div class="stat-card">
            <div class="stat-icon">📦</div>
            <div class="stat-value" id="allOrdersCount">0</div>
            <div class="stat-label">All Orders</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">✅</div>
            <div class="stat-value" id="deliveredCount">0</div>
            <div class="stat-label">Delivered</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">🚚</div>
            <div class="stat-value" id="shippedCount">0</div>
            <div class="stat-label">Shipped</div>
        </div>
    </div>
    <div class="recent-section">
        <h2 class="section-title">📋 All Orders</h2>
        <table class="orders-table" id="allOrdersTable">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>Date</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="allOrdersBody">
                <tr><td colspan="6" style="text-align:center;">Loading...</td></tr>
            </tbody>
        </table>
    </div>
</div>

<!-- Products Section -->
<div id="productsSection" style="display: none;">
    <div class="recent-section">
        <h2 class="section-title">🛍️ Manage Products</h2>
        <button class="add-product-btn" onclick="showAddProductModal()">➕ Add New Product</button>
        <div class="products-grid" id="productsGrid">
            <!-- Products will be loaded here -->
        </div>
    </div>
</div>

<!-- Customers Section -->
<div id="customersSection" style="display: none;">
    <div class="recent-section">
        <h2 class="section-title">👥 All Customers</h2>
        <table class="orders-table" id="customersTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Join Date</th>
                </tr>
            </thead>
            <tbody id="customersBody">
                <tr><td colspan="5" style="text-align:center;">Loading...</td></tr>
            </tbody>
        </table>
    </div>
</div>

<div class="footer">
    <p>&copy; 2026 FreshMart Admin Panel. All rights reserved.</p>
</div>

<!-- Add Product Modal -->
<div id="addProductModal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); z-index: 2000; justify-content: center; align-items: center;">
    <div style="background: white; padding: 30px; border-radius: 15px; width: 90%; max-width: 500px;">
        <h3 style="margin-bottom: 20px;">Add New Product</h3>
        <input type="text" id="prodName" placeholder="Product Name" style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 5px;">
        <input type="number" id="prodPrice" placeholder="Price" style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 5px;">
        <input type="text" id="prodImage" placeholder="Image URL" style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 5px;">
        <select id="prodCategory" style="width: 100%; padding: 10px; margin-bottom: 20px; border: 1px solid #ddd; border-radius: 5px;">
            <option value="vegetables">Vegetables</option>
            <option value="fruits">Fruits</option>
            <option value="grocery">Grocery</option>
        </select>
        <button onclick="addProduct()" style="background: #4caf50; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer;">Add Product</button>
        <button onclick="closeModal()" style="background: #999; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; margin-left: 10px;">Cancel</button>
    </div>
</div>

<script>
    // API URLs
    const API_BASE = '';
    
    // Load dashboard stats
    function loadDashboardStats() {
        fetch('AdminDashboardStats')
            .then(response => response.json())
            .then(data => {
                document.getElementById('totalOrders').innerText = data.totalOrders || 0;
                document.getElementById('totalRevenue').innerText = '₹' + (data.totalRevenue || 0);
                document.getElementById('totalCustomers').innerText = data.totalCustomers || 0;
                document.getElementById('pendingOrders').innerText = data.pendingOrders || 0;
                document.getElementById('allOrdersCount').innerText = data.totalOrders || 0;
            })
            .catch(error => console.error('Error:', error));
    }
    
    // Load recent orders
    function loadRecentOrders() {
        fetch('GetRecentOrders')
            .then(response => response.json())
            .then(data => {
                const tbody = document.getElementById('recentOrdersBody');
                if(data.orders && data.orders.length > 0) {
                    let html = '';
                    data.orders.forEach(order => {
                        let statusClass = 'status-pending';
                        if(order.status === 'Delivered') statusClass = 'status-delivered';
                        if(order.status === 'Shipped') statusClass = 'status-shipped';
                        
                        html += `<tr>
                            <td>#${order.id}</td>
                            <td>${order.customerName}</td>
                            <td>${order.orderDate}</td>
                            <td>₹${order.total}</td>
                            <td><span class="${statusClass}">${order.status}</span></td>
                            <td><button onclick="updateOrderStatus(${order.id})" style="background:#2196f3; color:white; border:none; padding:5px 10px; border-radius:15px;">Update</button></td>
                        </tr>`;
                    });
                    tbody.innerHTML = html;
                } else {
                    tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;">No orders found</td></tr>';
                }
            })
            .catch(error => console.error('Error:', error));
    }
    
    // Load all orders
    function loadAllOrders() {
        fetch('GetAllOrders')
            .then(response => response.json())
            .then(data => {
                const tbody = document.getElementById('allOrdersBody');
                if(data.orders && data.orders.length > 0) {
                    let html = '';
                    let delivered = 0, shipped = 0;
                    data.orders.forEach(order => {
                        let statusClass = 'status-pending';
                        if(order.status === 'Delivered') {
                            statusClass = 'status-delivered';
                            delivered++;
                        }
                        if(order.status === 'Shipped') {
                            statusClass = 'status-shipped';
                            shipped++;
                        }
                        
                        html += `<tr>
                            <td>#${order.id}</td>
                            <td>${order.customerName}</td>
                            <td>${order.orderDate}</td>
                            <td>₹${order.total}</td>
                            <td><span class="${statusClass}">${order.status}</span></td>
                            <td><button onclick="updateOrderStatus(${order.id})" style="background:#2196f3; color:white; border:none; padding:5px 10px; border-radius:15px;">Update</button></td>
                        </tr>`;
                    });
                    tbody.innerHTML = html;
                    document.getElementById('deliveredCount').innerText = delivered;
                    document.getElementById('shippedCount').innerText = shipped;
                } else {
                    tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;">No orders found</td></tr>';
                }
            })
            .catch(error => console.error('Error:', error));
    }
    
    // Load products
    function loadProducts() {
        fetch('GetAllProducts')
            .then(response => response.json())
            .then(data => {
                const grid = document.getElementById('productsGrid');
                if(data.products && data.products.length > 0) {
                    let html = '';
                    data.products.forEach(product => {
                        html += `<div class="product-card">
                            <img src="${product.image}" alt="${product.name}" onerror="this.src='https://picsum.photos/220/150'">
                            <h4>${product.name}</h4>
                            <div class="price">₹${product.price}</div>
                            <div class="product-actions">
                                <button class="edit-btn" onclick="editProduct(${product.id})">Edit</button>
                                <button class="delete-btn" onclick="deleteProduct(${product.id})">Delete</button>
                            </div>
                        </div>`;
                    });
                    grid.innerHTML = html;
                } else {
                    grid.innerHTML = '<p style="text-align:center;">No products found</p>';
                }
            })
            .catch(error => console.error('Error:', error));
    }
    
    // Load customers
    function loadCustomers() {
        fetch('GetAllCustomers')
            .then(response => response.json())
            .then(data => {
                const tbody = document.getElementById('customersBody');
                if(data.customers && data.customers.length > 0) {
                    let html = '';
                    data.customers.forEach(customer => {
                        html += `<tr>
                            <td>${customer.id}</td>
                            <td>${customer.username}</td>
                            <td>${customer.email}</td>
                            <td>${customer.role}</td>
                            <td>${customer.joinDate || 'N/A'}</td>
                        </tr>`;
                    });
                    tbody.innerHTML = html;
                } else {
                    tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;">No customers found</td></tr>';
                }
            })
            .catch(error => console.error('Error:', error));
    }
    
    // Update order status
    function updateOrderStatus(orderId) {
        const newStatus = prompt('Enter new status (Pending, Shipped, Delivered):');
        if(newStatus) {
            fetch('UpdateOrderStatus', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'orderId=' + orderId + '&status=' + newStatus
            })
            .then(response => response.json())
            .then(data => {
                if(data.success) {
                    alert('Order status updated!');
                    loadRecentOrders();
                    loadAllOrders();
                    loadDashboardStats();
                }
            });
        }
    }
    
    // Add product
    function addProduct() {
        const name = document.getElementById('prodName').value;
        const price = document.getElementById('prodPrice').value;
        const image = document.getElementById('prodImage').value;
        const category = document.getElementById('prodCategory').value;
        
        if(!name || !price) {
            alert('Please fill product name and price');
            return;
        }
        
        fetch('AddProduct', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'name=' + encodeURIComponent(name) + '&price=' + price + '&image=' + encodeURIComponent(image) + '&category=' + category
        })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
                alert('Product added successfully!');
                closeModal();
                loadProducts();
            } else {
                alert('Error adding product');
            }
        });
    }
    
    function showAddProductModal() {
        document.getElementById('addProductModal').style.display = 'flex';
    }
    
    function closeModal() {
        document.getElementById('addProductModal').style.display = 'none';
        document.getElementById('prodName').value = '';
        document.getElementById('prodPrice').value = '';
        document.getElementById('prodImage').value = '';
    }
    
    // Section navigation
    function showSection(section) {
        document.getElementById('dashboardSection').style.display = 'none';
        document.getElementById('ordersSection').style.display = 'none';
        document.getElementById('productsSection').style.display = 'none';
        document.getElementById('customersSection').style.display = 'none';
        
        if(section === 'dashboard') {
            document.getElementById('dashboardSection').style.display = 'block';
            loadDashboardStats();
            loadRecentOrders();
        } else if(section === 'orders') {
            document.getElementById('ordersSection').style.display = 'block';
            loadAllOrders();
        } else if(section === 'products') {
            document.getElementById('productsSection').style.display = 'block';
            loadProducts();
        } else if(section === 'customers') {
            document.getElementById('customersSection').style.display = 'block';
            loadCustomers();
        }
    }
    
    // Initialize charts
    function initCharts() {
        const ordersCtx = document.getElementById('ordersChart').getContext('2d');
        new Chart(ordersCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Orders',
                    data: [12, 19, 15, 25, 22, 30],
                    borderColor: '#ff5722',
                    backgroundColor: 'rgba(255,87,34,0.1)',
                    tension: 0.4
                }]
            },
            options: { responsive: true }
        });
        
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        new Chart(revenueCtx, {
            type: 'doughnut',
            data: {
                labels: ['Vegetables', 'Fruits', 'Grocery'],
                datasets: [{
                    data: [45, 30, 25],
                    backgroundColor: ['#4caf50', '#ff9800', '#2196f3']
                }]
            },
            options: { responsive: true }
        });
    }
    
    // Initialize
    initCharts();
    showSection('dashboard');
</script>

</body>
</html>