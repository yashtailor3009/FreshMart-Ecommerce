package com.springmvc.real_project;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "orders")
public class Order implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "order_number", unique = true)
    private String orderNumber;
    
    @Column(name = "username")
    private String username;
    
    @Column(name = "customer_name")
    private String customerName;
    
    private String email;
    private String phone;
    
    @Column(length = 500)
    private String address;
    
    private String city;
    private String pincode;
    
    @Column(name = "payment_method")
    private String paymentMethod;
    
    @Column(name = "total_amount")
    private Double totalAmount;
    
    private String status;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "order_date")
    private Date orderDate;
    
    // Default constructor
    public Order() {}
    
    // Parameterized constructor
    public Order(String orderNumber, String username, String customerName, String email, 
                 String phone, String address, String city, String pincode, 
                 String paymentMethod, Double totalAmount, String status) {
        this.orderNumber = orderNumber;
        this.username = username;
        this.customerName = customerName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.city = city;
        this.pincode = pincode;
        this.paymentMethod = paymentMethod;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDate = new Date();
    }
    
    // Getters
    public Long getId() { return id; }
    public String getOrderNumber() { return orderNumber; }
    public String getUsername() { return username; }
    public String getCustomerName() { return customerName; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getAddress() { return address; }
    public String getCity() { return city; }
    public String getPincode() { return pincode; }
    public String getPaymentMethod() { return paymentMethod; }
    public Double getTotalAmount() { return totalAmount; }
    public String getStatus() { return status; }
    public Date getOrderDate() { return orderDate; }
    
    // For backward compatibility (if any old code uses getTotal)
    public Double getTotal() { return totalAmount; }
    
    // Setters
    public void setId(Long id) { this.id = id; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }
    public void setUsername(String username) { this.username = username; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public void setEmail(String email) { this.email = email; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setAddress(String address) { this.address = address; }
    public void setCity(String city) { this.city = city; }
    public void setPincode(String pincode) { this.pincode = pincode; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public void setTotalAmount(Double totalAmount) { this.totalAmount = totalAmount; }
    public void setStatus(String status) { this.status = status; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }
    
    // For backward compatibility
    public void setTotal(Double total) { this.totalAmount = total; }
    
    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", orderNumber='" + orderNumber + '\'' +
                ", username='" + username + '\'' +
                ", customerName='" + customerName + '\'' +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", orderDate=" + orderDate +
                '}';
    }
}