<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
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
    <title>Admin Analytics - FreshMart</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        .analytics-container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .page-title {
            font-size: 32px;
            color: #1a1a2e;
            margin-bottom: 30px;
            text-align: center;
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .stat-card h3 {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }
        .stat-card .value {
            font-size: 28px;
            font-weight: bold;
            color: #1a1a2e;
        }
        .stat-card .sub {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
        
        /* Charts Grid */
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        .chart-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .chart-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #1a1a2e;
            border-left: 4px solid #ff5722;
            padding-left: 12px;
        }
        canvas {
            max-height: 300px;
            width: 100%;
        }
        
        /* Tables */
        .tables-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        .data-table {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .data-table h3 {
            padding: 15px 20px;
            background: #1a1a2e;
            color: white;
            font-size: 16px;
        }
        .data-table table {
            width: 100%;
            border-collapse: collapse;
        }
        .data-table th, .data-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .data-table th {
            background: #f5f5f5;
            font-weight: bold;
        }
        .data-table tr:hover {
            background: #f9f9f9;
        }
        .rank-1 { background: #fff3e0; }
        .rank-2 { background: #f5f5f5; }
        .rank-3 { background: #e8f5e9; }
        
        .refresh-btn {
            background: #ff5722;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            cursor: pointer;
            margin-bottom: 20px;
            float: right;
        }
        .clearfix::after {
            content: "";
            clear: both;
            display: table;
        }
        
        @media (max-width: 768px) {
            body { padding-top: 120px; }
            .charts-grid { grid-template-columns: 1fr; }
            .tables-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">Fresh<span>Mart</span> <span style="font-size: 12px; background: #ff5722; padding: 2px 8px; border-radius: 20px; margin-left: 10px;">ADMIN</span></div>
    <div class="nav-links">
        <a href="dashboard_admin.jsp">Dashboard</a>
        <a href="admin_analytics.jsp" style="color: #ff5722;">Analytics</a>
        <a href="javascript:void(0)" onclick="showSection('orders')">Orders</a>
        <a href="javascript:void(0)" onclick="showSection('products')">Products</a>
    </div>
    <div class="user-info">
        <span class="user-name">👑 Admin ${sessionScope.username}</span>
        <a href="Logout" class="logout-btn">Logout</a>
    </div>
</div>

<div class="analytics-container">
    <div class="clearfix">
        <button class="refresh-btn" onclick="loadAllData()">🔄 Refresh Data</button>
    </div>
    <h1 class="page-title">📊 Advanced Analytics Dashboard</h1>
    
    <!-- Stats Summary Cards -->
    <div class="stats-grid" id="statsGrid">
        <div class="stat-card">
            <h3>Total Orders</h3>
            <div class="value" id="totalOrders">-</div>
        </div>
        <div class="stat-card">
            <h3>Total Revenue</h3>
            <div class="value" id="totalRevenue">-</div>
        </div>
        <div class="stat-card">
            <h3>Average Order Value</h3>
            <div class="value" id="avgOrderValue">-</div>
        </div>
        <div class="stat-card">
            <h3>Total Customers</h3>
            <div class="value" id="totalCustomers">-</div>
        </div>
    </div>
    
    <!-- Charts -->
    <div class="charts-grid">
        <div class="chart-card">
            <div class="chart-title">📈 Monthly Sales Revenue</div>
            <canvas id="revenueChart"></canvas>
        </div>
        <div class="chart-card">
            <div class="chart-title">📦 Orders by Status</div>
            <canvas id="statusChart"></canvas>
        </div>
        <div class="chart-card">
            <div class="chart-title">🏆 Best Selling Products</div>
            <canvas id="topProductsChart"></canvas>
        </div>
        <div class="chart-card">
            <div class="chart-title">💰 Category-wise Revenue</div>
            <canvas id="categoryChart"></canvas>
        </div>
    </div>
    
    <!-- Tables -->
    <div class="tables-grid">
        <div class="data-table">
            <h3>🏆 Top 10 Best Selling Products</h3>
            <table>
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Product Name</th>
                        <th>Quantity Sold</th>
                        <th>Revenue</th>
                    </tr>
                </thead>
                <tbody id="bestSellingTable">
                    <tr><td colspan="4" style="text-align:center;">Loading...</td></tr>
                </tbody>
            </table>
        </div>
        
        <div class="data-table">
            <h3>⭐ Top 10 Customers</h3>
            <table>
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Customer Name</th>
                        <th>Orders</th>
                        <th>Total Spent</th>
                    </tr>
                </thead>
                <tbody id="topCustomersTable">
                    <tr><td colspan="4" style="text-align:center;">Loading...</td></tr>
                </tbody>
            </table>
        </div>
    </div>
    
    <div class="data-table" style="margin-top: 20px;">
        <h3>📅 Daily Sales (Last 30 Days)</h3>
        <div style="padding: 15px; overflow-x: auto;">
            <canvas id="dailySalesChart" style="max-height: 300px;"></canvas>
        </div>
    </div>
</div>

<script>
    let revenueChart, statusChart, topProductsChart, categoryChart, dailySalesChart;
    
    async function loadAllData() {
        try {
            const response = await fetch('AdminAnalytics');
            const data = await response.json();
            
            if(data.success) {
                // Update stats cards
                if(data.salesSummary) {
                    document.getElementById('totalOrders').innerText = data.salesSummary.totalOrders || 0;
                    document.getElementById('totalRevenue').innerText = '₹' + (data.salesSummary.totalRevenue || 0).toLocaleString();
                    document.getElementById('avgOrderValue').innerText = '₹' + (data.salesSummary.avgOrderValue || 0).toFixed(2);
                }
                
                // Update best selling products table
                updateBestSellingTable(data.bestSellingProducts || []);
                
                // Update top customers table
                updateTopCustomersTable(data.topCustomers || []);
                
                // Update charts
                updateRevenueChart(data.monthlySales || []);
                updateStatusChart(data.orderStatusDistribution || []);
                updateTopProductsChart(data.bestSellingProducts || []);
                updateDailySalesChart(data.dailySales || []);
            }
        } catch(error) {
            console.error('Error loading analytics:', error);
        }
    }
    
    function updateBestSellingTable(products) {
        const tbody = document.getElementById('bestSellingTable');
        if(!products || products.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;">No data available</td></tr>';
            return;
        }
        
        let html = '';
        products.forEach((product, index) => {
            let rankClass = '';
            if(index === 0) rankClass = 'rank-1';
            else if(index === 1) rankClass = 'rank-2';
            else if(index === 2) rankClass = 'rank-3';
            
            html += `<tr class="${rankClass}">
                <td>${index + 1}</td>
                <td><strong>${product.productName}</strong></td>
                <td>${product.quantitySold} units</td>
                <td>₹${(product.revenue || 0).toLocaleString()}</td>
            </tr>`;
        });
        tbody.innerHTML = html;
    }
    
    function updateTopCustomersTable(customers) {
        const tbody = document.getElementById('topCustomersTable');
        if(!customers || customers.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;">No data available</td></tr>';
            return;
        }
        
        let html = '';
        customers.forEach((customer, index) => {
            html += `<tr>
                <td>${index + 1}</td>
                <td><strong>${customer.customerName || customer.username}</strong><br><small style="color:#999;">${customer.email || ''}</small></td>
                <td>${customer.orderCount} orders</td>
                <td>₹${(customer.totalSpent || 0).toLocaleString()}</td>
            </tr>`;
        });
        tbody.innerHTML = html;
    }
    
    function updateRevenueChart(monthlySales) {
        const ctx = document.getElementById('revenueChart').getContext('2d');
        
        const labels = monthlySales.map(s => `${s.year}-${s.month}`);
        const revenues = monthlySales.map(s => s.totalRevenue || 0);
        
        if(revenueChart) revenueChart.destroy();
        
        revenueChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels.reverse(),
                datasets: [{
                    label: 'Revenue (₹)',
                    data: revenues.reverse(),
                    borderColor: '#ff5722',
                    backgroundColor: 'rgba(255,87,34,0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'top' },
                    tooltip: { callbacks: { label: (ctx) => `₹${ctx.raw.toLocaleString()}` } }
                }
            }
        });
    }
    
    function updateStatusChart(statusDistribution) {
        const ctx = document.getElementById('statusChart').getContext('2d');
        
        const labels = statusDistribution.map(s => s.status);
        const counts = statusDistribution.map(s => s.count);
        
        if(statusChart) statusChart.destroy();
        
        statusChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: counts,
                    backgroundColor: ['#ff9800', '#2196f3', '#4caf50', '#f44336', '#9c27b0']
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'bottom' } }
            }
        });
    }
    
    function updateTopProductsChart(products) {
        const ctx = document.getElementById('topProductsChart').getContext('2d');
        
        const labels = products.slice(0, 5).map(p => p.productName);
        const quantities = products.slice(0, 5).map(p => p.quantitySold);
        
        if(topProductsChart) topProductsChart.destroy();
        
        topProductsChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Quantity Sold',
                    data: quantities,
                    backgroundColor: '#ff5722',
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'top' } }
            }
        });
    }
    
    function updateDailySalesChart(dailySales) {
        const ctx = document.getElementById('dailySalesChart').getContext('2d');
        
        const labels = dailySales.map(s => s.date);
        const revenues = dailySales.map(s => s.totalRevenue || 0);
        
        if(dailySalesChart) dailySalesChart.destroy();
        
        dailySalesChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Daily Revenue (₹)',
                    data: revenues,
                    backgroundColor: '#2196f3',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    tooltip: { callbacks: { label: (ctx) => `₹${ctx.raw.toLocaleString()}` } }
                },
                scales: {
                    x: { ticks: { maxRotation: 45, autoSkip: true, maxTicksLimit: 10 } }
                }
            }
        });
    }
    
    // Load stats for cards
    async function loadStatsCards() {
        try {
            const response = await fetch('AdminDashboardStats');
            const data = await response.json();
            document.getElementById('totalCustomers').innerText = data.totalCustomers || 0;
        } catch(error) {
            console.error('Error loading stats:', error);
        }
    }
    
    // Initial load
    loadAllData();
    loadStatsCards();
    
    // Refresh every 30 seconds
    setInterval(loadAllData, 30000);
</script>

</body>
</html>