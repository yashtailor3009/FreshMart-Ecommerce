package com.springmvc.real_project;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Repository
@Transactional
public class OrderDao {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    // ==================== BASIC METHODS ====================
    
    public long getTotalOrders(){
        Session session = sessionFactory.getCurrentSession();
        Query<Long> query = session.createQuery("SELECT COUNT(*) FROM Order", Long.class);
        Long result = query.uniqueResult();
        return result != null ? result : 0L;
    }
    
    public double getTotalRevenue(){
        Session session = sessionFactory.getCurrentSession();
        Query<Double> query = session.createQuery("SELECT SUM(totalAmount) FROM Order", Double.class);
        Double result = query.uniqueResult();
        return result != null ? result : 0.0;
    }
    
    public long getPendingOrders(){
        Session session = sessionFactory.getCurrentSession();
        Query<Long> query = session.createQuery("SELECT COUNT(*) FROM Order WHERE status = 'Pending'", Long.class);
        Long result = query.uniqueResult();
        return result != null ? result : 0L;
    }
    
    public long getShippedOrders() {
        Session session = sessionFactory.getCurrentSession();
        Query<Long> query = session.createQuery("SELECT COUNT(*) FROM Order WHERE status = 'Shipped'", Long.class);
        Long result = query.uniqueResult();
        return result != null ? result : 0L;
    }
    
    public long getDeliveredOrders() {
        Session session = sessionFactory.getCurrentSession();
        Query<Long> query = session.createQuery("SELECT COUNT(*) FROM Order WHERE status = 'Delivered'", Long.class);
        Long result = query.uniqueResult();
        return result != null ? result : 0L;
    }
    
    public List<Order> getRecentOrders() {
        Session session = sessionFactory.getCurrentSession();
        Query<Order> query = session.createQuery("FROM Order ORDER BY orderDate DESC", Order.class);
        query.setMaxResults(10);
        return query.list();
    }
    
    public List<Order> getAllOrders() {
        Session session = sessionFactory.getCurrentSession();
        Query<Order> query = session.createQuery("FROM Order ORDER BY orderDate DESC", Order.class);
        return query.list();
    }
    
    public void updateOrderStatus(Long orderId, String status) {
        Session session = sessionFactory.getCurrentSession();
        Order order = session.get(Order.class, orderId);
        if(order != null) {
            order.setStatus(status);
            session.update(order);
        }
    }
    
    public List<Order> getOrdersByCustomer(String customerName) {
        Session session = sessionFactory.getCurrentSession();
        Query<Order> query = session.createQuery("FROM Order WHERE customerName LIKE :customerName ORDER BY orderDate DESC", Order.class);
        query.setParameter("customerName", "%" + customerName + "%");
        return query.list();
    }
    
    public Order getOrderById(Long orderId) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(Order.class, orderId);
    }
    
    public List<Object[]> getMonthlyOrders() {
        Session session = sessionFactory.getCurrentSession();
        Query<Object[]> query = session.createQuery(
            "SELECT MONTH(orderDate), COUNT(*) FROM Order " +
            "WHERE orderDate >= CURRENT_DATE - 180 " +
            "GROUP BY MONTH(orderDate) ORDER BY MONTH(orderDate)", Object[].class);
        return query.list();
    }
    
    public Map<String, Double> getRevenueByCategory() {
        Map<String, Double> revenueMap = new HashMap<>();
        revenueMap.put("Vegetables", 45000.0);
        revenueMap.put("Fruits", 30000.0);
        revenueMap.put("Grocery", 25000.0);
        return revenueMap;
    }
    
    // ==================== ORDER HISTORY METHODS ====================
    
    public Long saveOrder(Order order) {
        Session session = sessionFactory.getCurrentSession();
        return (Long) session.save(order);
    }
    
    public void saveOrderItem(OrderItem orderItem) {
        Session session = sessionFactory.getCurrentSession();
        session.save(orderItem);
    }
    
    public List<OrderItem> getOrderItemsByOrderId(Long orderId) {
        Session session = sessionFactory.getCurrentSession();
        Query<OrderItem> query = session.createQuery("FROM OrderItem WHERE orderId = :orderId", OrderItem.class);
        query.setParameter("orderId", orderId);
        List<OrderItem> items = query.list();
        return items != null ? items : new ArrayList<>();
    }
    
    public List<Order> getOrdersByUsername(String username) {
        Session session = sessionFactory.getCurrentSession();
        Query<Order> query = session.createQuery("FROM Order WHERE username = :username ORDER BY orderDate DESC", Order.class);
        query.setParameter("username", username);
        return query.list();
    }
    
    public Order getOrderByIdAndUsername(Long orderId, String username) {
        Session session = sessionFactory.getCurrentSession();
        Query<Order> query = session.createQuery("FROM Order WHERE id = :orderId AND username = :username", Order.class);
        query.setParameter("orderId", orderId);
        query.setParameter("username", username);
        return query.uniqueResult();
    }
    
    public Order getOrderByOrderNumber(String orderNumber) {
        Session session = sessionFactory.getCurrentSession();
        Query<Order> query = session.createQuery("FROM Order WHERE orderNumber = :orderNumber", Order.class);
        query.setParameter("orderNumber", orderNumber);
        return query.uniqueResult();
    }

    public String generateOrderNumber() {
        return "ORD" + System.currentTimeMillis();
    }
    
    public List<Order> getOrdersByStatus(String status) {
        Session session = sessionFactory.getCurrentSession();
        Query<Order> query = session.createQuery("FROM Order WHERE status = :status ORDER BY orderDate DESC", Order.class);
        query.setParameter("status", status);
        return query.list();
    }
    
    public List<Order> getOrdersByDateRange(Date startDate, Date endDate) {
        Session session = sessionFactory.getCurrentSession();
        Query<Order> query = session.createQuery("FROM Order WHERE orderDate BETWEEN :startDate AND :endDate ORDER BY orderDate DESC", Order.class);
        query.setParameter("startDate", startDate);
        query.setParameter("endDate", endDate);
        return query.list();
    }
    
    public double getRevenueByDateRange(Date startDate, Date endDate) {
        Session session = sessionFactory.getCurrentSession();
        Query<Double> query = session.createQuery("SELECT SUM(totalAmount) FROM Order WHERE orderDate BETWEEN :startDate AND :endDate", Double.class);
        query.setParameter("startDate", startDate);
        query.setParameter("endDate", endDate);
        Double result = query.uniqueResult();
        return result != null ? result : 0.0;
    }
    
    public long getOrderCountByDateRange(Date startDate, Date endDate) {
        Session session = sessionFactory.getCurrentSession();
        Query<Long> query = session.createQuery("SELECT COUNT(*) FROM Order WHERE orderDate BETWEEN :startDate AND :endDate", Long.class);
        query.setParameter("startDate", startDate);
        query.setParameter("endDate", endDate);
        Long result = query.uniqueResult();
        return result != null ? result : 0L;
    }
    
    public List<Object[]> getLast30DaysOrders() {
        Session session = sessionFactory.getCurrentSession();
        Query<Object[]> query = session.createQuery(
            "SELECT DATE(orderDate), COUNT(*) FROM Order " +
            "WHERE orderDate >= CURRENT_DATE - 30 " +
            "GROUP BY DATE(orderDate) ORDER BY DATE(orderDate)", Object[].class);
        return query.list();
    }
    
    // ==================== ADVANCED ANALYTICS ====================
    
    public List<Object[]> getBestSellingProducts(int limit) {
        Session session = sessionFactory.getCurrentSession();
        Query<Object[]> query = session.createQuery(
            "SELECT oi.productId, oi.productName, SUM(oi.quantity) as totalSold, SUM(oi.price * oi.quantity) as totalRevenue " +
            "FROM OrderItem oi " +
            "GROUP BY oi.productId, oi.productName " +
            "ORDER BY totalSold DESC", Object[].class);
        query.setMaxResults(limit);
        return query.list();
    }
    
    public List<Object[]> getTopCustomers(int limit) {
        Session session = sessionFactory.getCurrentSession();
        Query<Object[]> query = session.createQuery(
            "SELECT o.username, o.customerName, o.email, COUNT(o.id) as orderCount, SUM(o.totalAmount) as totalSpent " +
            "FROM Order o " +
            "WHERE o.username IS NOT NULL " +
            "GROUP BY o.username, o.customerName, o.email " +
            "ORDER BY totalSpent DESC", Object[].class);
        query.setMaxResults(limit);
        return query.list();
    }
    
    public List<Object[]> getMonthlySalesReport() {
        Session session = sessionFactory.getCurrentSession();
        Query<Object[]> query = session.createQuery(
            "SELECT YEAR(orderDate) as year, MONTH(orderDate) as month, " +
            "COUNT(*) as orderCount, SUM(totalAmount) as totalRevenue " +
            "FROM Order " +
            "WHERE orderDate >= DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH) " +
            "GROUP BY YEAR(orderDate), MONTH(orderDate) " +
            "ORDER BY year DESC, month DESC", Object[].class);
        return query.list();
    }
    
    public List<Object[]> getDailySalesReport(int days) {
        Session session = sessionFactory.getCurrentSession();
        Query<Object[]> query = session.createQuery(
            "SELECT DATE(orderDate), COUNT(*) as orderCount, SUM(totalAmount) as totalRevenue " +
            "FROM Order " +
            "WHERE orderDate >= DATE_SUB(CURRENT_DATE, :days) " +
            "GROUP BY DATE(orderDate) " +
            "ORDER BY DATE(orderDate) DESC", Object[].class);
        query.setParameter("days", days);
        return query.list();
    }
    
    public List<Object[]> getCategorySales() {
        Session session = sessionFactory.getCurrentSession();
        try {
            Query<Object[]> query = session.createQuery(
                "SELECT p.category, COUNT(oi.id) as itemsSold, SUM(oi.price * oi.quantity) as revenue " +
                "FROM OrderItem oi " +
                "JOIN Product p ON oi.productId = p.id " +
                "WHERE p.category IS NOT NULL " +
                "GROUP BY p.category " +
                "ORDER BY revenue DESC", Object[].class);
            return query.list();
        } catch(Exception e) {
            List<Object[]> defaultList = new ArrayList<>();
            defaultList.add(new Object[]{"Vegetables", 0L, 0.0});
            defaultList.add(new Object[]{"Fruits", 0L, 0.0});
            defaultList.add(new Object[]{"Grocery", 0L, 0.0});
            return defaultList;
        }
    }
    
    public List<Object[]> getOrdersByPaymentMethod() {
        Session session = sessionFactory.getCurrentSession();
        Query<Object[]> query = session.createQuery(
            "SELECT paymentMethod, COUNT(*) as count, SUM(totalAmount) as total " +
            "FROM Order " +
            "WHERE paymentMethod IS NOT NULL " +
            "GROUP BY paymentMethod", Object[].class);
        return query.list();
    }
    
    public Map<String, Object> getSalesSummary() {
        Session session = sessionFactory.getCurrentSession();
        Map<String, Object> summary = new HashMap<>();
        
        Query<Object[]> query = session.createQuery(
            "SELECT COUNT(*) as totalOrders, SUM(totalAmount) as totalRevenue, AVG(totalAmount) as avgOrderValue " +
            "FROM Order", Object[].class);
        
        Object[] result = query.uniqueResult();
        if(result != null) {
            summary.put("totalOrders", result[0] != null ? result[0] : 0L);
            summary.put("totalRevenue", result[1] != null ? result[1] : 0.0);
            summary.put("avgOrderValue", result[2] != null ? result[2] : 0.0);
        } else {
            summary.put("totalOrders", 0L);
            summary.put("totalRevenue", 0.0);
            summary.put("avgOrderValue", 0.0);
        }
        
        return summary;
    }
    
    public List<Object[]> getOrderStatusDistribution() {
        Session session = sessionFactory.getCurrentSession();
        Query<Object[]> query = session.createQuery(
            "SELECT status, COUNT(*) as count FROM Order GROUP BY status", Object[].class);
        return query.list();
    }
    
    public Map<String, Object> getCurrentMonthSales() {
        Session session = sessionFactory.getCurrentSession();
        Map<String, Object> sales = new HashMap<>();
        
        Query<Object[]> query = session.createQuery(
            "SELECT COUNT(*) as orderCount, SUM(totalAmount) as totalRevenue " +
            "FROM Order " +
            "WHERE MONTH(orderDate) = MONTH(CURRENT_DATE) AND YEAR(orderDate) = YEAR(CURRENT_DATE)", Object[].class);
        
        Object[] result = query.uniqueResult();
        if(result != null) {
            sales.put("orderCount", result[0] != null ? result[0] : 0L);
            sales.put("totalRevenue", result[1] != null ? result[1] : 0.0);
        } else {
            sales.put("orderCount", 0L);
            sales.put("totalRevenue", 0.0);
        }
        
        return sales;
    }
}