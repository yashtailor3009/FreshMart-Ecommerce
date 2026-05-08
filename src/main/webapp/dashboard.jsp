<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
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
    <title>Customer Dashboard - FreshMart</title>
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
            flex-wrap: wrap;
        }
        .nav-links a {
            color: white;
            text-decoration: none;
            font-size: 16px;
            cursor: pointer;
        }
        .cart-link {
            color: white;
            text-decoration: none;
            font-size: 18px;
            position: relative;
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
            margin-left: 5px;
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
        .hero {
            background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), 
                        url('https://images.unsplash.com/photo-1542838132-92c53300491e?w=1600&h=500&fit=crop');
            background-size: cover;
            background-position: center;
            color: white;
            text-align: center;
            padding: 80px 20px;
            margin-top: 20px;
        }
        .hero h1 {
            font-size: 48px;
            margin-bottom: 15px;
        }
        .hero h1 span { color: #ffeb3b; }
        .hero p {
            font-size: 18px;
            margin-bottom: 25px;
        }
        .hero button {
            background: #ff5722;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 30px;
            font-size: 18px;
            cursor: pointer;
        }
        
        /* Category Tabs */
        .category-tabs {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 30px 5% 20px;
            flex-wrap: wrap;
        }
        .category-tab {
            background: white;
            border: 2px solid #2e7d32;
            color: #2e7d32;
            padding: 12px 30px;
            border-radius: 40px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }
        .category-tab:hover {
            background: #2e7d32;
            color: white;
        }
        .category-tab.active {
            background: #2e7d32;
            color: white;
        }
        
        /* Category Sections */
        .category-section {
            padding: 30px 5%;
        }
        .category-title {
            font-size: 32px;
            color: #2e7d32;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-left: 5px solid #ff5722;
            padding-left: 20px;
        }
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }
        .product-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: 0.3s;
            text-align: center;
            padding-bottom: 15px;
        }
        .product-card:hover {
            transform: translateY(-5px);
        }
        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .product-card h3 {
            font-size: 18px;
            margin: 12px 0 5px;
        }
        .category-badge {
            color: #999;
            font-size: 12px;
        }
        .price {
            color: #2e7d32;
            font-size: 22px;
            font-weight: bold;
            margin: 8px 0;
        }
        .old-price {
            text-decoration: line-through;
            color: #999;
            font-size: 14px;
            margin-left: 8px;
        }
        .buttons {
            padding: 0 15px 15px;
        }
        .buttons button {
            border: none;
            padding: 8px 18px;
            border-radius: 25px;
            cursor: pointer;
            margin: 5px;
            font-size: 13px;
        }
        .cart-btn {
            background: #ff5722;
            color: white;
        }
        .view-btn {
            background: #2e7d32;
            color: white;
        }
        .footer {
            background: #1a1a2e;
            color: white;
            text-align: center;
            padding: 30px;
            margin-top: 50px;
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
            font-size: 14px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
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
        @media (max-width: 768px) {
            .hero h1 { font-size: 32px; }
            body { padding-top: 120px; }
            .category-tab { padding: 8px 20px; font-size: 14px; }
            .category-title { font-size: 24px; }
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">Fresh<span>Mart</span></div>
    <div class="nav-links">
        <a onclick="showCategory('all')">Home</a>
        <a onclick="showCategory('vegetables')">Vegetables</a>
        <a onclick="showCategory('fruits')">Fruits</a>
        <a onclick="showCategory('grocery')">Grocery</a>
        <a href="OrderHistory">📋 My Orders</a>
        <a href="#">Contact</a>
    </div>
    <div class="user-info">
        <a href="cart.jsp" class="cart-link">
            🛒 Cart <span id="cartCount" class="cart-count">0</span>
        </a>
        <span class="user-name">👋 ${sessionScope.username}</span>
        <a href="Logout" class="logout-btn">Logout</a>
    </div>
</div>

<div class="hero">
    <h1>Fresh Grocery <span>At Your Door</span></h1>
    <p>Get 25% Discount On All Products</p>
    <button onclick="scrollToProducts()">Shop Now →</button>
</div>

<!-- Category Tabs -->
<div class="category-tabs">
    <button class="category-tab active" onclick="showCategory('all')">🍽️ All Products</button>
    <button class="category-tab" onclick="showCategory('vegetables')">🥬 Vegetables</button>
    <button class="category-tab" onclick="showCategory('fruits')">🍎 Fruits</button>
    <button class="category-tab" onclick="showCategory('grocery')">🛒 Grocery</button>
</div>

<!-- Vegetables Section -->
<div id="vegetablesSection" class="category-section" style="display: none;">
    <h2 class="category-title">🥬 Fresh Vegetables</h2>
    <div class="products-grid" id="vegetablesGrid"></div>
</div>

<!-- Fruits Section -->
<div id="fruitsSection" class="category-section" style="display: none;">
    <h2 class="category-title">🍎 Fresh Fruits</h2>
    <div class="products-grid" id="fruitsGrid"></div>
</div>

<!-- Grocery Section -->
<div id="grocerySection" class="category-section" style="display: none;">
    <h2 class="category-title">🛒 Grocery & Staples</h2>
    <div class="products-grid" id="groceryGrid"></div>
</div>

<!-- All Products Section -->
<div id="allSection" class="category-section">
    <h2 class="category-title">🍽️ All Products</h2>
    <div class="products-grid" id="allProductsGrid"></div>
</div>

<div class="footer">
    <p>&copy; 2026 FreshMart. All rights reserved.</p>
</div>

<div id="toast" class="toast"></div>

<script>
    // ==================== PRODUCTS DATA ====================
    
    // Vegetables
    const vegetables = [
        { id: 1, name: "Tomato", price: 28, oldPrice: 45, image: "https://images.unsplash.com/photo-1582284540020-8acbe03f4924?w=280&h=200&fit=crop" },
        { id: 2, name: "Potato", price: 22, oldPrice: 35, image: "https://images.unsplash.com/photo-1590165482129-1b8b27698780?w=280&h=200&fit=crop" },
        { id: 3, name: "Onion", price: 16, oldPrice: 30, image: "https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=280&h=200&fit=crop" },
        { id: 4, name: "Carrot", price: 35, oldPrice: 50, image: "https://images.unsplash.com/photo-1590868309235-ea34bed7bd7f?w=280&h=200&fit=crop" },
        { id: 5, name: "Cauliflower", price: 30, oldPrice: 45, image: "https://images.unsplash.com/photo-1692956706779-576c151ec712?w=280&h=200&fit=crop" },
        { id: 6, name: "Brinjal", price: 35, oldPrice: 50, image: "https://images.unsplash.com/photo-1694152417806-e42b0d469990?w=280&h=200&fit=crop" },
        { id: 7, name: "Cabbage", price: 30, oldPrice: 45, image: "https://images.unsplash.com/photo-1594282486552-05b4d80fbb9f?w=280&h=200&fit=crop" },
        { id: 8, name: "Capsicum", price: 40, oldPrice: 55, image: "https://images.unsplash.com/photo-1585159079680-8dec029b76ed?w=280&h=200&fit=crop" },
        { id: 9, name: "Broccoli", price: 55, oldPrice: 75, image: "https://plus.unsplash.com/premium_photo-1702403157830-9df749dc6c1e?w=280&h=200&fit=crop" },
        { id: 10, name: "Ladyfinger", price: 32, oldPrice: 48, image: "https://images.unsplash.com/photo-1664289242854-e99d345cfa92?w=280&h=200&fit=crop" },
        { id: 11, name: "Cucumber", price: 25, oldPrice: 40, image: "https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?w=280&h=200&fit=crop" },
        { id: 12, name: "Spinach", price: 18, oldPrice: 30, image: "https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=280&h=200&fit=crop" }
    ];
    
    // Fruits
    const fruits = [
        { id: 101, name: "Apple", price: 120, oldPrice: 160, image: "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=280&h=200&fit=crop" },
        { id: 102, name: "Banana", price: 40, oldPrice: 60, image: "https://images.unsplash.com/photo-1603833665858-e61d17a86224?w=280&h=200&fit=crop" },
        { id: 103, name: "Orange", price: 90, oldPrice: 120, image: "https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8b3Jhbmdlc3xlbnwwfHwwfHx8MA%3D%3D" },
        { id: 104, name: "Mango", price: 80, oldPrice: 110, image: "https://images.unsplash.com/photo-1553279768-865429fa0078?w=280&h=200&fit=crop" },
        { id: 105, name: "Grapes", price: 70, oldPrice: 95, image: "https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=280&h=200&fit=crop" },
        { id: 106, name: "Strawberry", price: 150, oldPrice: 200, image: "https://images.unsplash.com/photo-1587393855524-087f83d95bc9?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8c3RyYXdiZXJyaWVzfGVufDB8fDB8fHww" },
        { id: 107, name: "Watermelon", price: 60, oldPrice: 85, image: "https://images.unsplash.com/photo-1708982553355-794739c6693e?q=80&w=1225&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" },
        { id: 108, name: "Pomegranate", price: 110, oldPrice: 150, image: "https://plus.unsplash.com/premium_photo-1668076515507-c5bc223c99a4?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cG9tZWdyYW5hdGV8ZW58MHx8MHx8fDA%3D" },
        { id: 109, name: "Kiwi", price: 130, oldPrice: 170, image: "https://plus.unsplash.com/premium_photo-1674223384432-84e04bb77101?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDF8fHxlbnwwfHx8fHw%3D" },
        { id: 110, name: "Papaya", price: 50, oldPrice: 75, image: "https://images.unsplash.com/photo-1623492229905-ebc1202e8904?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8UGFwYXlhfGVufDB8fDB8fHww" },
        { id: 111, name: "Guava", price: 27, oldPrice: 45, image: "https://images.unsplash.com/photo-1689996647099-a7a0b67fd2f6?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8R3VhdmF8ZW58MHx8MHx8fDA%3D"},
        { id: 112, name: "Cherry", price: 110, oldPrice: 220, image: "https://images.unsplash.com/photo-1647963476906-4069b7da8918?q=80&w=1189&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"},
        { id: 113, name: "Blue Berries", price: 150, oldPrice: 300, image: "https://images.unsplash.com/photo-1498557850523-fd3d118b962e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Ymx1ZSUyMGJlcnJpZXN8ZW58MHx8MHx8fDA%3D"},
        { id: 114, name: "Amla", price: 100, oldPrice: 200, image: "https://images.unsplash.com/photo-1676043966983-f5bd22435e64?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8YW1sYXxlbnwwfHwwfHx8MA%3D%3D"},
        { id: 115, name: "Pineapple", price: 50, oldPrice: 80, image: "https://images.unsplash.com/photo-1587883012610-e3df17d41270?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8cGluZWFwcGxlfGVufDB8fDB8fHww"}
    ];
    
    // Grocery Items
    const grocery = [
        { id: 201, name: "Rice (5kg)", price: 250, oldPrice: 320, image: "https://images.unsplash.com/photo-1625827626291-6fbd47a431ae?q=80&w=1160&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" },
        { id: 202, name: "Wheat Flour (5kg)", price: 180, oldPrice: 240, image: "https://www.bbassets.com/media/uploads/p/l/126903_12-aashirvaad-atta-whole-wheat.jpg" },
        { id: 203, name: "Sugar (1kg)", price: 42, oldPrice: 55, image: "https://www.bbassets.com/media/uploads/p/l/244096_6-madhur-sugar-refined.jpg" },
        { id: 204, name: "Cooking Oil (1L)", price: 110, oldPrice: 140, image: "https://m.media-amazon.com/images/I/51Hxuw8kJfL._SL1100_.jpg" },
        { id: 205, name: "Salt (1kg)", price: 20, oldPrice: 30, image: "https://rukminim2.flixcart.com/image/1280/1280/xif0q/salt/c/2/r/970-saltfree-flowing-and-iodised-namak-1-iodized-salt-tata-original-imah8ukfxwd73hgh.jpeg?q=90" },
        { id: 206, name: "Tea (250g)", price: 80, oldPrice: 110, image: "https://m.media-amazon.com/images/I/61TiRbejgCL._SL1000_.jpg" },
        { id: 207, name: "Coffee (100g)", price: 150, oldPrice: 200, image: "https://m.media-amazon.com/images/I/61BcX08RM2L._SL1000_.jpg" },
        { id: 208, name: "Spices Combo", price: 120, oldPrice: 160, image: "https://availeverything.com/public/uploads/all/gQ8kUQGX87pQb47PEIoZHi6Ar8p4ZHXjWK90wgNi.webp" },
        { id: 209, name: "Pulses (1kg)", price: 90, oldPrice: 120, image: "https://www.wcrf.org/wp-content/uploads/2022/02/675_mixed-legume-varieties-healthy-nutrition-2026-01-11-10-44-50-utc.jpg" },
        { id: 210, name: "Pasta (500g)", price: 60, oldPrice: 85, image: "https://m.media-amazon.com/images/I/71wPsP5g-LL.jpg" },
        { id: 211, name: "McCain(Smiles) (500g)", price: 60, oldPrice: 85, image: "https://www.bbassets.com/media/uploads/p/l/40016983_2-mccain-smiles-crispy-happy-potatoes.jpg" }
    ];
    
    // All products combined
    const allProducts = [...vegetables, ...fruits, ...grocery];
    
    // Get category badge
    function getCategory(name) {
        if(vegetables.some(v => v.name === name)) return "🥬 Vegetable";
        if(fruits.some(f => f.name === name)) return "🍎 Fruit";
        return "🛒 Grocery";
    }
    
    // Display products in grid
    function displayProducts(productsToShow, containerId) {
        const grid = document.getElementById(containerId);
        if (!grid) return;
        
        if (productsToShow.length === 0) {
            grid.innerHTML = '<p style="text-align:center; padding:50px;">❌ No products found</p>';
            return;
        }
        
        let html = '';
        for(let i = 0; i < productsToShow.length; i++) {
            const p = productsToShow[i];
            html += '<div class="product-card">';
            html += '<img src="' + p.image + '" alt="' + p.name + '" onerror="this.src=\'https://picsum.photos/280/200\'">';
            html += '<h3>' + p.name + '</h3>';
            html += '<div class="category-badge">' + getCategory(p.name) + '</div>';
            html += '<div class="price">₹' + p.price + '<span class="old-price">₹' + p.oldPrice + '</span></div>';
            html += '<div class="buttons">';
            html += '<button class="cart-btn" onclick="addToCart(' + p.id + ', \'' + p.name + '\', ' + p.price + ', \'' + p.image + '\')">🛒 Add To Cart</button>';
            html += '<button class="view-btn" onclick="buyNow(' + p.id + ', \'' + p.name + '\', ' + p.price + ', \'' + p.image + '\')">💰 Buy Now</button>';
            html += '</div></div>';
        }
        grid.innerHTML = html;
    }
    
    // Show category function
    function showCategory(category) {
        // Hide all sections
        document.getElementById('vegetablesSection').style.display = 'none';
        document.getElementById('fruitsSection').style.display = 'none';
        document.getElementById('grocerySection').style.display = 'none';
        document.getElementById('allSection').style.display = 'none';
        
        // Update active tab style
        const tabs = document.querySelectorAll('.category-tab');
        tabs.forEach(tab => tab.classList.remove('active'));
        
        // Show selected section
        if(category === 'vegetables') {
            document.getElementById('vegetablesSection').style.display = 'block';
            document.querySelector('.category-tab:nth-child(2)').classList.add('active');
        } else if(category === 'fruits') {
            document.getElementById('fruitsSection').style.display = 'block';
            document.querySelector('.category-tab:nth-child(3)').classList.add('active');
        } else if(category === 'grocery') {
            document.getElementById('grocerySection').style.display = 'block';
            document.querySelector('.category-tab:nth-child(4)').classList.add('active');
        } else {
            document.getElementById('allSection').style.display = 'block';
            document.querySelector('.category-tab:nth-child(1)').classList.add('active');
        }
        
        // Scroll to products
        document.querySelector('.category-section').scrollIntoView({ behavior: 'smooth' });
    }
    
    function scrollToProducts() {
        document.querySelector('.category-tabs').scrollIntoView({ behavior: 'smooth' });
    }
    
    // Load cart count
    function loadCartCount() {
        fetch('GetCartCount')
            .then(response => response.json())
            .then(data => {
                if(data.count !== undefined) {
                    document.getElementById('cartCount').innerText = data.count;
                }
            })
            .catch(error => console.log('Error loading cart count:', error));
    }
    
    // Show toast notification
    function showToast(message) {
        const toast = document.getElementById('toast');
        toast.textContent = message;
        toast.className = "toast show";
        setTimeout(() => {
            toast.className = "toast";
        }, 2000);
    }
    
    // Add to cart function
    function addToCart(id, name, price, image) {
        const cartSpan = document.getElementById('cartCount');
        let currentCount = parseInt(cartSpan.innerText) || 0;
        cartSpan.innerText = currentCount + 1;
        
        fetch('AddToCart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'productId=' + id + '&name=' + encodeURIComponent(name) + '&price=' + price + '&image=' + encodeURIComponent(image)
        })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
                showToast("✅ " + name + " added to cart! (₹" + price + ")");
                cartSpan.innerText = data.cartCount;
            } else {
                showToast("❌ Failed to add " + name);
                cartSpan.innerText = currentCount;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast("✅ " + name + " added to cart! (₹" + price + ")");
        });
    }
    
    // Buy Now function
    function buyNow(id, name, price, image) {
        fetch('AddToCart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'productId=' + id + '&name=' + encodeURIComponent(name) + '&price=' + price + '&image=' + encodeURIComponent(image)
        })
        .then(response => response.json())
        .then(data => {
            window.location.href = 'cart.jsp';
        })
        .catch(error => {
            window.location.href = 'cart.jsp';
        });
    }
    
    // Initialize all sections
    displayProducts(vegetables, 'vegetablesGrid');
    displayProducts(fruits, 'fruitsGrid');
    displayProducts(grocery, 'groceryGrid');
    displayProducts(allProducts, 'allProductsGrid');
    
    // Load cart count on page load
    loadCartCount();
    setInterval(loadCartCount, 5000);
</script>

</body>
</html>