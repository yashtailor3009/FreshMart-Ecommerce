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
public class UserDao {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    public void saveUser(User user){
        Session session = sessionFactory.getCurrentSession();
        session.saveOrUpdate(user);
    }
    
    public User findByUsername(String username){
        Session session = sessionFactory.getCurrentSession();
        Query<User> query = session.createQuery("FROM User WHERE username = :username", User.class);
        query.setParameter("username", username);
        return query.uniqueResult();
    }
    
    public User findByEmail(String email){
        Session session = sessionFactory.getCurrentSession();
        Query<User> query = session.createQuery("FROM User WHERE email = :email", User.class);
        query.setParameter("email", email);
        return query.uniqueResult();
    }
    
    public boolean validateUser(String username, String password){
        Session session = sessionFactory.getCurrentSession();
        Query<User> query = session.createQuery("FROM User WHERE username = :username AND password = :password", User.class);
        query.setParameter("username", username);
        query.setParameter("password", password);
        return query.uniqueResult() != null;
    }
    
    public User findByUsernameAndPassword(String username, String password) {
        Session session = sessionFactory.getCurrentSession();
        Query<User> query = session.createQuery("FROM User WHERE username = :username AND password = :password", User.class);
        query.setParameter("username", username);
        query.setParameter("password", password);
        return query.uniqueResult();
    }

    public long getTotalCustomers() {
        Session session = sessionFactory.getCurrentSession();
        Query<Long> query = session.createQuery("SELECT COUNT(*) FROM User", Long.class);
        Long result = query.uniqueResult();
        return result != null ? result : 0L;
    }
    
    // ==================== NEW METHODS ====================
    
    public List<User> getAllUsers() {
        Session session = sessionFactory.getCurrentSession();
        Query<User> query = session.createQuery("FROM User ORDER BY id", User.class);
        return query.list();
    }
    
    public long getTotalAdmins() {
        Session session = sessionFactory.getCurrentSession();
        Query<Long> query = session.createQuery("SELECT COUNT(*) FROM User WHERE role = 'ADMIN'", Long.class);
        Long result = query.uniqueResult();
        return result != null ? result : 0L;
    }
    
    public List<User> getRecentUsers() {
        Session session = sessionFactory.getCurrentSession();
        Query<User> query = session.createQuery("FROM User ORDER BY id DESC", User.class);
        query.setMaxResults(5);
        return query.list();
    }
    
    public List<User> searchUsersByUsername(String username) {
        Session session = sessionFactory.getCurrentSession();
        Query<User> query = session.createQuery("FROM User WHERE username LIKE :username", User.class);
        query.setParameter("username", "%" + username + "%");
        return query.list();
    }
    
    public void updateUserRole(Long userId, String role) {
        Session session = sessionFactory.getCurrentSession();
        User user = session.get(User.class, userId);
        if(user != null) {
            user.setRole(role);
            session.update(user);
        }
    }
    
    public void deleteUser(Long userId) {
        Session session = sessionFactory.getCurrentSession();
        User user = session.get(User.class, userId);
        if(user != null) {
            session.delete(user);
        }
    }
}