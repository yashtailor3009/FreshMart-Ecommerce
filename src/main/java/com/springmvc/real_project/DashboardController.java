package com.springmvc.real_project;

import com.springmvc.real_project.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.OutputStream;
import java.util.*;

@Controller
public class DashboardController {

    @Autowired
    private UserDao userDao;

    @Autowired
    private OrderDao orderDao;

    @Autowired
    private ProductDao productDao;

    @GetMapping("/dashboard_admin")
    public String showAdminDashboard(HttpSession session, Model model){

        if(session.getAttribute("username") == null){
            return "redirect:Login.jsp";
        }

        if(!"ADMIN".equals(session.getAttribute("role"))){
            return "redirect:dashboard.jsp";
        }

        long totalOrders = orderDao.getTotalOrders();
        double totalRevenue = orderDao.getTotalRevenue();
        long totalCustomers = userDao.getTotalCustomers();
        long pendingOrders = orderDao.getPendingOrders();
        List<Order> recentOrders = orderDao.getRecentOrders();

        model.addAttribute("totalOrders", totalOrders);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("totalCustomers", totalCustomers);
        model.addAttribute("pendingOrders", pendingOrders);
        model.addAttribute("recentOrders", recentOrders);

        return "dashboard_admin";
    }

    // ==================== ORDER HISTORY & INVOICE ====================

    @GetMapping("/OrderHistory")
    public String showOrderHistory(HttpSession session, Model model) {
        String username = (String) session.getAttribute("username");
        if(username == null) {
            return "redirect:Login.jsp";
        }

        List<Order> orders = orderDao.getOrdersByUsername(username);
        model.addAttribute("orders", orders);
        return "order_history";
    }

    @GetMapping("/ViewOrderDetails")
    public String viewOrderDetails(@RequestParam("orderId") Long orderId,
                                   HttpSession session,
                                   Model model) {
        String username = (String) session.getAttribute("username");
        if(username == null) {
            return "redirect:Login.jsp";
        }

        Order order = orderDao.getOrderByIdAndUsername(orderId, username);
        if(order == null) {
            return "redirect:OrderHistory";
        }

        List<OrderItem> orderItems = orderDao.getOrderItemsByOrderId(orderId);
        model.addAttribute("order", order);
        model.addAttribute("orderItems", orderItems);
        return "order_details";
    }

    @GetMapping("/DownloadInvoice")
    public void downloadInvoice(@RequestParam("orderId") Long orderId,
                                HttpSession session,
                                HttpServletResponse response) throws Exception {
        String username = (String) session.getAttribute("username");
        if(username == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        Order order = orderDao.getOrderByIdAndUsername(orderId, username);
        if(order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        List<OrderItem> orderItems = orderDao.getOrderItemsByOrderId(orderId);

        // Set response headers
        response.setContentType("text/html");
        response.setHeader("Content-Disposition", "attachment; filename=Invoice_" + order.getOrderNumber() + ".html");

        // Generate invoice HTML
        String html = generateInvoiceHTML(order, orderItems);
        response.getWriter().write(html);
        response.getWriter().flush();
    }

    private String generateInvoiceHTML(Order order, List<OrderItem> orderItems) {
        StringBuilder sb = new StringBuilder();
        sb.append("<!DOCTYPE html>");
        sb.append("<html><head><meta charset='UTF-8'><title>Invoice - ").append(order.getOrderNumber()).append("</title>");
        sb.append("<style>");
        sb.append("body { font-family: Arial, sans-serif; margin: 50px; }");
        sb.append(".invoice-header { text-align: center; margin-bottom: 30px; }");
        sb.append(".invoice-header h1 { color: #2e7d32; }");
        sb.append(".order-info { margin-bottom: 20px; border: 1px solid #ddd; padding: 15px; border-radius: 8px; }");
        sb.append(".order-info table { width: 100%; }");
        sb.append(".order-info td { padding: 5px; }");
        sb.append("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
        sb.append("th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }");
        sb.append("th { background: #2e7d32; color: white; }");
        sb.append(".total { text-align: right; margin-top: 20px; font-size: 18px; }");
        sb.append(".footer { text-align: center; margin-top: 50px; color: #666; }");
        sb.append("</style>");
        sb.append("</head><body>");

        // Header
        sb.append("<div class='invoice-header'>");
        sb.append("<h1>FreshMart</h1>");
        sb.append("<p>Fresh Grocery At Your Door</p>");
        sb.append("</div>");

        // Order Info
        sb.append("<div class='order-info'>");
        sb.append("<td>");
        sb.append("汽<td width='30%'><strong>Order Number:</strong></td><td>").append(order.getOrderNumber()).append("</td>");
        sb.append("<td width='30%'><strong>Order Date:</strong></td><td>").append(order.getOrderDate()).append("</td>");
        sb.append("</tr>");
        sb.append("<tr>");
        sb.append("<td><strong>Customer Name:</strong></td><td>").append(order.getCustomerName()).append("</td>");
        sb.append("<td><strong>Payment Method:</strong></td><td>").append(order.getPaymentMethod()).append("</td>");
        sb.append("</tr>");
        sb.append("<tr>");
        sb.append("<td><strong>Email:</strong></td><td>").append(order.getEmail()).append("</td>");
        sb.append("<td><strong>Phone:</strong></td><td>").append(order.getPhone()).append("</td>");
        sb.append("</tr>");
        sb.append("<tr>");
        sb.append("<td><strong>Address:</strong></td><td colspan='3'>").append(order.getAddress()).append(", ").append(order.getCity()).append(" - ").append(order.getPincode()).append("</td>");
        sb.append("</tr>");
        sb.append("</table>");
        sb.append("</div>");

        // Items Table
        sb.append("<table>");
        sb.append("<thead><tr><th>#</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr></thead>");
        sb.append("<tbody>");
        int i = 1;
        for(OrderItem item : orderItems) {
            sb.append("<tr>");
            sb.append("<td>").append(i++).append("</td>");
            sb.append("<td>").append(item.getProductName()).append("</td>");
            sb.append("<td>").append(item.getQuantity()).append("</td>");
            sb.append("<td>₹").append(item.getPrice()).append("</td>");
            sb.append("<td>₹").append(item.getSubtotal()).append("</td>");
            sb.append("</tr>");
        }
        sb.append("</tbody>");
        sb.append("</table>");

        // Total
        sb.append("<div class='total'>");
        sb.append("<p><strong>Total Amount: ₹").append(order.getTotalAmount()).append("</strong></p>");
        sb.append("</div>");

        // Footer
        sb.append("<div class='footer'>");
        sb.append("<p>Thank you for shopping with FreshMart!</p>");
        sb.append("<p>For any queries, contact: support@freshmart.com</p>");
        sb.append("</div>");

        sb.append("</body></html>");
        return sb.toString();
    }

    // ==================== BASIC ADMIN APIS ====================

    @GetMapping("/AdminDashboardStats")
    @ResponseBody
    public Map<String, Object> getAdminStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalOrders", orderDao.getTotalOrders());
        stats.put("totalRevenue", orderDao.getTotalRevenue());
        stats.put("totalCustomers", userDao.getTotalCustomers());
        stats.put("pendingOrders", orderDao.getPendingOrders());
        stats.put("shippedOrders", orderDao.getShippedOrders());
        stats.put("deliveredOrders", orderDao.getDeliveredOrders());
        return stats;
    }

    @GetMapping("/GetRecentOrders")
    @ResponseBody
    public Map<String, Object> getRecentOrders() {
        Map<String, Object> response = new HashMap<>();
        List<Order> orders = orderDao.getRecentOrders();

        List<Map<String, Object>> orderList = new ArrayList<>();
        if(orders != null) {
            for(Order order : orders) {
                Map<String, Object> orderMap = new HashMap<>();
                orderMap.put("id", order.getId());
                orderMap.put("orderNumber", order.getOrderNumber());
                orderMap.put("customerName", order.getCustomerName());
                orderMap.put("status", order.getStatus());
                orderMap.put("total", order.getTotalAmount());
                orderMap.put("orderDate", order.getOrderDate() != null ? order.getOrderDate().toString() : new Date().toString());
                orderList.add(orderMap);
            }
        }
        response.put("orders", orderList);
        return response;
    }

    @GetMapping("/GetAllOrders")
    @ResponseBody
    public Map<String, Object> getAllOrders() {
        Map<String, Object> response = new HashMap<>();
        List<Order> orders = orderDao.getAllOrders();

        List<Map<String, Object>> orderList = new ArrayList<>();
        if(orders != null) {
            for(Order order : orders) {
                Map<String, Object> orderMap = new HashMap<>();
                orderMap.put("id", order.getId());
                orderMap.put("orderNumber", order.getOrderNumber());
                orderMap.put("customerName", order.getCustomerName());
                orderMap.put("status", order.getStatus());
                orderMap.put("total", order.getTotalAmount());
                orderMap.put("orderDate", order.getOrderDate() != null ? order.getOrderDate().toString() : new Date().toString());
                orderList.add(orderMap);
            }
        }
        response.put("orders", orderList);
        return response;
    }

    @PostMapping("/UpdateOrderStatus")
    @ResponseBody
    public Map<String, Object> updateOrderStatus(@RequestParam("orderId") Long orderId,
                                                  @RequestParam("status") String status) {
        Map<String, Object> response = new HashMap<>();
        orderDao.updateOrderStatus(orderId, status);
        response.put("success", true);
        return response;
    }

    @GetMapping("/GetAllCustomers")
    @ResponseBody
    public Map<String, Object> getAllCustomers() {
        Map<String, Object> response = new HashMap<>();
        List<User> users = userDao.getAllUsers();

        List<Map<String, Object>> userList = new ArrayList<>();
        if(users != null) {
            for(User user : users) {
                Map<String, Object> userMap = new HashMap<>();
                userMap.put("id", user.getId());
                userMap.put("username", user.getUsername());
                userMap.put("email", user.getEmail());
                userMap.put("role", user.getRole());
                userList.add(userMap);
            }
        }
        response.put("customers", userList);
        return response;
    }

    // ==================== CART FUNCTIONALITY ====================

    @GetMapping("/GetCartCount")
    @ResponseBody
    public Map<String, Object> getCartCount(HttpSession session) {
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        Map<String, Object> response = new HashMap<>();
        response.put("count", cart != null ? cart.size() : 0);
        return response;
    }

    @PostMapping("/AddToCart")
    @ResponseBody
    public Map<String, Object> addToCart(@RequestParam("productId") int productId,
                                          @RequestParam("name") String name,
                                          @RequestParam("price") double price,
                                          @RequestParam("image") String image,
                                          HttpSession session) {

        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        if(cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        boolean found = false;
        for(Map<String, Object> item : cart) {
            if((Integer) item.get("id") == productId) {
                int currentQty = (Integer) item.get("quantity");
                item.put("quantity", currentQty + 1);
                found = true;
                break;
            }
        }

        if(!found) {
            Map<String, Object> newItem = new HashMap<>();
            newItem.put("id", productId);
            newItem.put("name", name);
            newItem.put("price", price);
            newItem.put("quantity", 1);
            newItem.put("image", image);
            cart.add(newItem);
        }

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("cartCount", cart.size());
        return response;
    }

    @PostMapping("/UpdateCart")
    @ResponseBody
    public Map<String, Object> updateCart(@RequestParam("productId") int productId,
                                          @RequestParam("quantity") int quantity,
                                          HttpSession session) {

        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        Map<String, Object> response = new HashMap<>();

        if(cart != null && quantity > 0) {
            for(Map<String, Object> item : cart) {
                if((Integer) item.get("id") == productId) {
                    item.put("quantity", quantity);
                    break;
                }
            }
        }

        double cartTotal = 0;
        double itemTotal = 0;
        if(cart != null) {
            for(Map<String, Object> item : cart) {
                double price = (Double) item.get("price");
                int qty = (Integer) item.get("quantity");
                double total = price * qty;
                cartTotal += total;
                if((Integer) item.get("id") == productId) {
                    itemTotal = total;
                }
            }
        }

        response.put("success", true);
        response.put("cartTotal", cartTotal);
        response.put("itemTotal", itemTotal);
        response.put("cartCount", cart != null ? cart.size() : 0);

        return response;
    }

    @PostMapping("/RemoveFromCart")
    @ResponseBody
    public Map<String, Object> removeFromCart(@RequestParam("productId") int productId,
                                              HttpSession session) {

        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        Map<String, Object> response = new HashMap<>();

        if(cart != null) {
            cart.removeIf(item -> (Integer) item.get("id") == productId);
        }

        response.put("success", true);
        response.put("cartCount", cart != null ? cart.size() : 0);

        return response;
    }

    @PostMapping("/ClearCart")
    @ResponseBody
    public Map<String, Object> clearCart(HttpSession session) {
        session.removeAttribute("cart");
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        return response;
    }

    // ==================== PROCESS PAYMENT WITH EMAIL & UPI SUPPORT ====================

    @PostMapping("/ProcessPayment")
    public String processPayment(@RequestParam("fullname") String fullname,
                                 @RequestParam("email") String email,
                                 @RequestParam("phone") String phone,
                                 @RequestParam("address") String address,
                                 @RequestParam("city") String city,
                                 @RequestParam("pincode") String pincode,
                                 @RequestParam("paymentMethod") String paymentMethod,
                                 HttpSession session,
                                 Model model) {

        String username = (String) session.getAttribute("username");
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");

        if(cart == null || cart.isEmpty()) {
            return "redirect:cart.jsp";
        }

        // Calculate totals
        double totalPrice = 0;
        for(Map<String, Object> item : cart) {
            double price = (Double) item.get("price");
            int quantity = (Integer) item.get("quantity");
            totalPrice += price * quantity;
        }

        double deliveryCharge = (totalPrice < 500) ? 40 : 0;
        double grandTotal = totalPrice + deliveryCharge;

        // Create and save order
        Order order = new Order();
        order.setOrderNumber(orderDao.generateOrderNumber());
        order.setUsername(username);
        order.setCustomerName(fullname);
        order.setEmail(email);
        order.setPhone(phone);
        order.setAddress(address);
        order.setCity(city);
        order.setPincode(pincode);
        order.setPaymentMethod(paymentMethod);
        order.setTotalAmount(grandTotal);
        
        // Set status based on payment method
        if(paymentMethod.equals("cod")) {
            order.setStatus("Pending");
        } else if(paymentMethod.equals("upi")) {
            order.setStatus("Payment Pending");
        } else {
            order.setStatus("Processing");
        }
        order.setOrderDate(new Date());

        Long orderId = orderDao.saveOrder(order);

        // Save order items and collect for email
        List<OrderItem> orderItems = new ArrayList<>();
        for(Map<String, Object> item : cart) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(orderId);
            orderItem.setProductId((Integer) item.get("id"));
            orderItem.setProductName((String) item.get("name"));
            orderItem.setQuantity((Integer) item.get("quantity"));
            orderItem.setPrice((Double) item.get("price"));
            orderDao.saveOrderItem(orderItem);
            orderItems.add(orderItem);
        }

        // Send email notification
        boolean emailSent = false;
        try {
            emailSent = EmailService.sendOrderConfirmation(order, orderItems, email);
            if(emailSent) {
                System.out.println("✅ Order confirmation email sent to: " + email);
            } else {
                System.out.println("❌ Failed to send email to: " + email);
            }
        } catch(Exception e) {
            System.err.println("❌ Email error: " + e.getMessage());
            e.printStackTrace();
        }

        // Save order details in session for confirmation page
        Map<String, Object> orderDetails = new HashMap<>();
        orderDetails.put("orderId", orderId);
        orderDetails.put("orderNumber", order.getOrderNumber());
        orderDetails.put("fullname", fullname);
        orderDetails.put("email", email);
        orderDetails.put("phone", phone);
        orderDetails.put("address", address);
        orderDetails.put("city", city);
        orderDetails.put("pincode", pincode);
        orderDetails.put("paymentMethod", paymentMethod);
        orderDetails.put("totalPrice", totalPrice);
        orderDetails.put("deliveryCharge", deliveryCharge);
        orderDetails.put("grandTotal", grandTotal);
        orderDetails.put("orderDate", new Date());
        orderDetails.put("emailSent", emailSent);

        session.setAttribute("orderDetails", orderDetails);
        session.removeAttribute("cart");

        if(emailSent) {
            model.addAttribute("message", "Order placed Successfully! Confirmation email sent to " + email);
        } else {
            model.addAttribute("message", "Order placed Successfully! But email could not be sent.");
        }

        return "redirect:/order_confirmation.jsp";
    }

    // ==================== ADVANCED ANALYTICS APIs ====================

    @GetMapping("/AdminAnalytics")
    @ResponseBody
    public Map<String, Object> getAdminAnalytics() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Best selling products
            List<Object[]> bestSelling = orderDao.getBestSellingProducts(10);
            List<Map<String, Object>> bestSellingList = new ArrayList<>();
            for(Object[] item : bestSelling) {
                Map<String, Object> product = new HashMap<>();
                product.put("productId", item[0]);
                product.put("productName", item[1]);
                product.put("quantitySold", item[2]);
                product.put("revenue", item[3]);
                bestSellingList.add(product);
            }
            response.put("bestSellingProducts", bestSellingList);
            
            // Top customers
            List<Object[]> topCustomers = orderDao.getTopCustomers(10);
            List<Map<String, Object>> topCustomersList = new ArrayList<>();
            for(Object[] customer : topCustomers) {
                Map<String, Object> cust = new HashMap<>();
                cust.put("username", customer[0]);
                cust.put("customerName", customer[1]);
                cust.put("email", customer[2]);
                cust.put("orderCount", customer[3]);
                cust.put("totalSpent", customer[4]);
                topCustomersList.add(cust);
            }
            response.put("topCustomers", topCustomersList);
            
            // Monthly sales report
            List<Object[]> monthlySales = orderDao.getMonthlySalesReport();
            List<Map<String, Object>> monthlySalesList = new ArrayList<>();
            for(Object[] sale : monthlySales) {
                Map<String, Object> month = new HashMap<>();
                month.put("year", sale[0]);
                month.put("month", sale[1]);
                month.put("orderCount", sale[2]);
                month.put("totalRevenue", sale[3]);
                monthlySalesList.add(month);
            }
            response.put("monthlySales", monthlySalesList);
            
            // Sales summary
            response.put("salesSummary", orderDao.getSalesSummary());
            
            // Order status distribution
            List<Object[]> statusDist = orderDao.getOrderStatusDistribution();
            List<Map<String, Object>> statusList = new ArrayList<>();
            for(Object[] status : statusDist) {
                Map<String, Object> stat = new HashMap<>();
                stat.put("status", status[0]);
                stat.put("count", status[1]);
                statusList.add(stat);
            }
            response.put("orderStatusDistribution", statusList);
            
            // Daily sales (last 30 days)
            List<Object[]> dailySales = orderDao.getDailySalesReport(30);
            List<Map<String, Object>> dailySalesList = new ArrayList<>();
            for(Object[] sale : dailySales) {
                Map<String, Object> day = new HashMap<>();
                day.put("date", sale[0] != null ? sale[0].toString() : "");
                day.put("orderCount", sale[1]);
                day.put("totalRevenue", sale[2]);
                dailySalesList.add(day);
            }
            response.put("dailySales", dailySalesList);
            
            // Category sales
            List<Object[]> categorySales = orderDao.getCategorySales();
            List<Map<String, Object>> categoryList = new ArrayList<>();
            for(Object[] cat : categorySales) {
                Map<String, Object> category = new HashMap<>();
                category.put("category", cat[0]);
                category.put("itemsSold", cat[1]);
                category.put("revenue", cat[2]);
                categoryList.add(category);
            }
            response.put("categorySales", categoryList);
            
            // Payment method distribution
            List<Object[]> paymentMethods = orderDao.getOrdersByPaymentMethod();
            List<Map<String, Object>> paymentList = new ArrayList<>();
            for(Object[] pm : paymentMethods) {
                Map<String, Object> payment = new HashMap<>();
                payment.put("method", pm[0]);
                payment.put("count", pm[1]);
                payment.put("total", pm[2]);
                paymentList.add(payment);
            }
            response.put("paymentMethods", paymentList);
            
            response.put("success", true);
            
        } catch(Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            e.printStackTrace();
        }
        
        return response;
    }

    @GetMapping("/GetBestSellingProducts")
    @ResponseBody
    public Map<String, Object> getBestSellingProducts(@RequestParam(defaultValue = "10") int limit) {
        Map<String, Object> response = new HashMap<>();
        List<Object[]> products = orderDao.getBestSellingProducts(limit);
        
        List<Map<String, Object>> productList = new ArrayList<>();
        for(Object[] product : products) {
            Map<String, Object> p = new HashMap<>();
            p.put("productId", product[0]);
            p.put("productName", product[1]);
            p.put("quantitySold", product[2]);
            p.put("totalRevenue", product[3]);
            productList.add(p);
        }
        
        response.put("products", productList);
        return response;
    }

    @GetMapping("/GetTopCustomers")
    @ResponseBody
    public Map<String, Object> getTopCustomers(@RequestParam(defaultValue = "10") int limit) {
        Map<String, Object> response = new HashMap<>();
        List<Object[]> customers = orderDao.getTopCustomers(limit);
        
        List<Map<String, Object>> customerList = new ArrayList<>();
        for(Object[] customer : customers) {
            Map<String, Object> c = new HashMap<>();
            c.put("username", customer[0]);
            c.put("customerName", customer[1]);
            c.put("email", customer[2]);
            c.put("orderCount", customer[3]);
            c.put("totalSpent", customer[4]);
            customerList.add(c);
        }
        
        response.put("customers", customerList);
        return response;
    }

    @GetMapping("/GetMonthlySales")
    @ResponseBody
    public Map<String, Object> getMonthlySales() {
        Map<String, Object> response = new HashMap<>();
        List<Object[]> monthlySales = orderDao.getMonthlySalesReport();
        
        List<Map<String, Object>> salesList = new ArrayList<>();
        for(Object[] sale : monthlySales) {
            Map<String, Object> month = new HashMap<>();
            month.put("year", sale[0]);
            month.put("month", sale[1]);
            month.put("orderCount", sale[2]);
            month.put("totalRevenue", sale[3]);
            salesList.add(month);
        }
        
        response.put("sales", salesList);
        return response;
    }

    @GetMapping("/GetSalesSummary")
    @ResponseBody
    public Map<String, Object> getSalesSummary() {
        return orderDao.getSalesSummary();
    }

    @GetMapping("/GetOrderStatusDistribution")
    @ResponseBody
    public Map<String, Object> getOrderStatusDistribution() {
        Map<String, Object> response = new HashMap<>();
        List<Object[]> statusDist = orderDao.getOrderStatusDistribution();
        
        List<Map<String, Object>> statusList = new ArrayList<>();
        for(Object[] status : statusDist) {
            Map<String, Object> stat = new HashMap<>();
            stat.put("status", status[0]);
            stat.put("count", status[1]);
            statusList.add(stat);
        }
        
        response.put("distribution", statusList);
        return response;
    }

    @GetMapping("/GetCurrentMonthSales")
    @ResponseBody
    public Map<String, Object> getCurrentMonthSales() {
        return orderDao.getCurrentMonthSales();
    }
}