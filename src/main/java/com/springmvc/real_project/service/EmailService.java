package com.springmvc.real_project.service;

import com.springmvc.real_project.Order;
import com.springmvc.real_project.OrderItem;
import com.springmvc.real_project.config.EmailConfig;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.List;

public class EmailService {
    
    // Send order confirmation email
    public static boolean sendOrderConfirmation(Order order, List<OrderItem> orderItems, String customerEmail) {
        try {
            Session session = EmailConfig.getEmailSession();
            
            // Create email message
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress("your_email@gmail.com", "FreshMart"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(customerEmail));
            message.setSubject("Order Confirmation - FreshMart #" + order.getOrderNumber());
            message.setContent(generateOrderEmailHTML(order, orderItems), "text/html");
            
            // Send email
            Transport.send(message);
            System.out.println("Email sent successfully to: " + customerEmail);
            return true;
            
        } catch (Exception e) {
            System.err.println("Error sending email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Generate HTML email content
    private static String generateOrderEmailHTML(Order order, List<OrderItem> orderItems) {
        StringBuilder sb = new StringBuilder();
        
        sb.append("<!DOCTYPE html>");
        sb.append("<html><head><meta charset='UTF-8'><title>Order Confirmation</title>");
        sb.append("<style>");
        sb.append("body { font-family: Arial, sans-serif; background-color: #f5f5f5; padding: 20px; }");
        sb.append(".container { max-width: 600px; margin: 0 auto; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        sb.append(".header { background: #2e7d32; color: white; padding: 20px; text-align: center; }");
        sb.append(".header h1 { margin: 0; font-size: 24px; }");
        sb.append(".header p { margin: 5px 0 0; opacity: 0.9; }");
        sb.append(".content { padding: 25px; }");
        sb.append(".order-info { background: #f9f9f9; padding: 15px; border-radius: 8px; margin-bottom: 20px; }");
        sb.append(".order-info h3 { margin: 0 0 10px; color: #2e7d32; }");
        sb.append(".order-info p { margin: 5px 0; }");
        sb.append("table { width: 100%; border-collapse: collapse; margin: 15px 0; }");
        sb.append("th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }");
        sb.append("th { background: #2e7d32; color: white; }");
        sb.append(".total { text-align: right; font-size: 18px; font-weight: bold; color: #2e7d32; margin-top: 15px; }");
        sb.append(".footer { background: #f5f5f5; padding: 15px; text-align: center; color: #666; font-size: 12px; }");
        sb.append(".button { display: inline-block; background: #ff5722; color: white; padding: 10px 20px; text-decoration: none; border-radius: 25px; margin-top: 15px; }");
        sb.append("</style>");
        sb.append("</head><body>");
        
        sb.append("<div class='container'>");
        
        // Header
        sb.append("<div class='header'>");
        sb.append("<h1>🎉 Order Confirmed! 🎉</h1>");
        sb.append("<p>Thank you for shopping with FreshMart</p>");
        sb.append("</div>");
        
        // Content
        sb.append("<div class='content'>");
        
        // Order Info
        sb.append("<div class='order-info'>");
        sb.append("<h3>📋 Order Details</h3>");
        sb.append("<p><strong>Order Number:</strong> #").append(order.getOrderNumber()).append("</p>");
        sb.append("<p><strong>Order Date:</strong> ").append(order.getOrderDate()).append("</p>");
        sb.append("<p><strong>Payment Method:</strong> ").append(order.getPaymentMethod()).append("</p>");
        sb.append("<p><strong>Delivery Address:</strong> ").append(order.getAddress()).append(", ").append(order.getCity()).append(" - ").append(order.getPincode()).append("</p>");
        sb.append("</div>");
        
        // Items Table
        sb.append("<h3>🛒 Items Ordered</h3>");
        sb.append("<table>");
        sb.append("<thead><tr><th>Product</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr></thead>");
        sb.append("<tbody>");
        
        for(OrderItem item : orderItems) {
            sb.append("<tr>");
            sb.append("<td>").append(item.getProductName()).append("</td>");
            sb.append("<td>").append(item.getQuantity()).append("</td>");
            sb.append("<td>₹").append(item.getPrice()).append("</td>");
            sb.append("<td>₹").append(item.getSubtotal()).append("</td>");
            sb.append("</tr>");
        }
        
        sb.append("</tbody>");
        sb.append("</table>");
        
        // Total
        double deliveryCharge = (order.getTotalAmount() < 500 ? 40 : 0);
        double subtotal = order.getTotalAmount() - deliveryCharge;
        
        sb.append("<div style='text-align: right; margin-top: 10px;'>");
        sb.append("<p><strong>Subtotal:</strong> ₹").append(subtotal).append("</p>");
        sb.append("<p><strong>Delivery Charge:</strong> ₹").append(deliveryCharge).append("</p>");
        sb.append("<div class='total'><strong>Total Amount:</strong> ₹").append(order.getTotalAmount()).append("</div>");
        sb.append("</div>");
        
        // Button to view order
        sb.append("<div style='text-align: center;'>");
        sb.append("<a href='http://localhost:8090/RealProject/OrderHistory' class='button'>📦 View My Orders</a>");
        sb.append("</div>");
        
        sb.append("</div>");
        
        // Footer
        sb.append("<div class='footer'>");
        sb.append("<p>© 2026 FreshMart. All rights reserved.</p>");
        sb.append("<p>For any queries, contact us at: support@freshmart.com</p>");
        sb.append("</div>");
        
        sb.append("</div>");
        sb.append("</body></html>");
        
        return sb.toString();
    }
}