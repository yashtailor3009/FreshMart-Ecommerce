# 🛒 FreshMart - Online Grocery E-commerce Platform

A complete e-commerce web application for grocery shopping built with **Spring MVC**, **Hibernate**, and **MySQL**.

## ✨ Features

### 👤 Customer Side
- ✅ User Registration & Login
- ✅ Browse Products by Categories (Vegetables, Fruits, Grocery)
- ✅ Search Products
- ✅ Add to Cart
- ✅ Update Cart Quantity
- ✅ Remove from Cart
- ✅ Checkout with Multiple Payment Options
  - 💳 Credit/Debit Card
  - 📱 UPI (Google Pay, PhonePe, Paytm) with QR Code
  - 💵 Cash on Delivery
- ✅ Order History
- ✅ Download Invoice as PDF/HTML
- ✅ Email Confirmation on Order

### 👑 Admin Side
- ✅ Admin Dashboard with Stats
- ✅ Order Management (Update Status)
- ✅ Product Management (Add/Edit/Delete)
- ✅ Customer Management
- ✅ Advanced Analytics
  - 📊 Best Selling Products
  - 🏆 Top Customers
  - 📈 Monthly Sales Charts
  - 🥧 Revenue by Category
  - 📅 Daily Sales Report

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| Java 17 | Backend Language |
| Spring MVC 5.3.30 | Web Framework |
| Hibernate 5.6 | ORM Framework |
| MySQL | Database |
| JSP, HTML, CSS | Frontend |
| JavaScript, Chart.js | Charts & Interactivity |
| JavaMail | Email Notifications |

## 📁 Project Structure
```
Real_Project/
├── src/main/java/
│ └── com/springmvc/real_project/
│ ├── config/ # Email configuration
│ ├── service/ # Email service
│ ├── LoginController.java
│ ├── DashboardController.java
│ ├── UserDao.java
│ ├── OrderDao.java
│ ├── ProductDao.java
│ └── ...
├── src/main/webapp/
│ ├── Login.jsp
│ ├── dashboard.jsp
│ ├── cart.jsp
│ ├── payment.jsp
│ ├── order_history.jsp
│ ├── order_confirmation.jsp
│ ├── dashboard_admin.jsp
│ ├── admin_analytics.jsp
│ └── images/
└── pom.xml
```


## 🚀 Installation & Setup

### Prerequisites
- Java 17
- MySQL 8+
- Apache Tomcat 9
- Maven

### Steps to Run Locally

1. **Clone the repository**
   ```bash
   git clone https://github.com/yashtailor3009/FreshMart-Ecommerce.git
   cd FreshMart-Ecommerce
   ```
2. **Create Database** 

    ```sql
    CREATE DATABASE real_project_db;
    ```

3. **Update Database Configuration**
    Edit dispatcher-servlet.xml:

   ```
   <property name="username" value="root"/>
   <property name="password" value="your_password"/>
   ```
4. **Build the Project**
  ```bash
    mvn clean package
  ```
5. **Deploy on Tomcat**

   Copy target/Real_Project.war to tomcat/webapps/
   Start Tomcat

6. **Access the Application**

   ``` http://localhost:8080/RealProject/Login ```

**Default Login Credentials**
  |Role	|Username	|Password|
  |----- |---------|--------|
  |Admin | admin | admin123|
  |User	| Register new account |-|

  **📸 Screenshots**
  
  **Sign_up Page**
  
  <img width="959" height="445" alt="image" src="https://github.com/user-attachments/assets/834b9c5f-b4c9-4c0d-8ff0-f41bc4c9c5ea" />

  <br>
  <b>Login Page</b>
  <img width="960" height="445" alt="image" src="https://github.com/user-attachments/assets/e72f0896-b4e0-4be3-98c2-eb86c7df5460" />

  <br>
  <b>Customer Dashboard</b>
  
  <img width="947" height="444" alt="image" src="https://github.com/user-attachments/assets/50559d98-f1f5-4b3a-bf7c-c821a9758310" />

  <br>
  <b>Shopping Cart</b>
  <img width="949" height="443" alt="image" src="https://github.com/user-attachments/assets/3b272fcc-86dd-4a6e-949f-49a835cebbc4" />

  <br>
  <b>Payment Page with UPI QR</b>
  <img width="946" height="446" alt="image" src="https://github.com/user-attachments/assets/bd0bd2eb-7294-4611-a526-1dc1f7e48e52" />

  <br>
  <b>Admin Analytics</b>
  <img width="947" height="443" alt="image" src="https://github.com/user-attachments/assets/b2a9a707-77bb-4e41-ade8-2e677592bb13" />

  <br>
  
  **🌐 Live Demo**
  
  [Deploying on Render/Railway - Coming Soon]

  <br>
  
  **📧 Email Configuration**
  To enable email notifications, update EmailConfig.java:

  ```
  private static final String EMAIL_USERNAME = "your_email@gmail.com";
  private static final String EMAIL_PASSWORD = "your_app_password";
  ```

  <br>
  
  **📊 API Endpoints**

| Endpoint            | Method | Purpose                  |
|---------------------|--------|--------------------------|
| AddToCart          | POST   | Add product to cart      |
| GetCartCount       | GET    | Get cart item count      |
| UpdateCart         | POST   | Update quantity          |
| RemoveFromCart     | POST   | Remove from cart         |
| ProcessPayment     | POST   | Place order              |
| OrderHistory       | GET    | View orders              |
| DownloadInvoice    | GET    | Download invoice         |
| AdminAnalytics     | GET    | Analytics data           |

  <br>
  
  **🤝 Contributing**
  
  Contributions are welcome! Please feel free to submit a Pull Request.

  <br>
  
  **📝 License**
  
  This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

  <br>
  
  **👨‍💻 Author**
  
  Yash Tailor
