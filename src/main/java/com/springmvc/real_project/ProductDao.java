package com.springmvc.real_project;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Repository
@Transactional
public class ProductDao {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    public List<Product> getAllProducts() {
        Session session = sessionFactory.getCurrentSession();
        Query<Product> query = session.createQuery("FROM Product", Product.class);
        return query.list();
    }
    
    public Product getProductById(Long id) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(Product.class, id);
    }
    
    public void saveProduct(Product product) {
        Session session = sessionFactory.getCurrentSession();
        session.saveOrUpdate(product);
    }
    
    public void updateProduct(Product product) {
        Session session = sessionFactory.getCurrentSession();
        session.update(product);
    }
    
    public void deleteProduct(Long productId) {
        Session session = sessionFactory.getCurrentSession();
        Product product = session.get(Product.class, productId);
        if(product != null) {
            session.delete(product);
        }
    }
    
    public long getTotalProducts() {
        Session session = sessionFactory.getCurrentSession();
        Query<Long> query = session.createQuery("SELECT COUNT(*) FROM Product", Long.class);
        Long result = query.uniqueResult();
        return result != null ? result : 0L;
    }
    
    public List<Product> getProductsByCategory(String category) {
        Session session = sessionFactory.getCurrentSession();
        Query<Product> query = session.createQuery("FROM Product WHERE category = :category", Product.class);
        query.setParameter("category", category);
        return query.list();
    }
}