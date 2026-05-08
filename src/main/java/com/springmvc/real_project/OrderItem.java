package com.springmvc.real_project;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "order_items")
public class OrderItem implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "order_id")
    private Long orderId;
    
    @Column(name = "product_id")
    private Integer productId;
    
    @Column(name = "product_name")
    private String productName;
    
    private Integer quantity;
    private Double price;
    
    // Default constructor
    public OrderItem() {}
    
    // Parameterized constructor
    public OrderItem(Long orderId, Integer productId, String productName, Integer quantity, Double price) {
        this.orderId = orderId;
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.price = price;
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    
    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
    
    public Double getSubtotal() { return price * quantity; }
}