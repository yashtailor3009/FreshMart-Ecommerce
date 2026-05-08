package com.springmvc.real_project;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@Transactional
public class LoginController {
    
    @Autowired
    private UserDao userDao;
    
    @GetMapping("/")
    public String home(){
        return "Login";
    }
    
    @GetMapping("/Login")
    public String showLogin(){
        return "Login";
    }
    
    @PostMapping("/doLogin")
    public String doLogin(@RequestParam("username") String username,
                           @RequestParam("password") String password,
                           HttpSession session, 
                           Model model){
        
        User user = userDao.findByUsernameAndPassword(username, password);
        
        if(user != null){
            session.setAttribute("username", username);
            session.setAttribute("role", user.getRole());
            
            if("ADMIN".equals(user.getRole())){
                return "dashboard_admin";
            } else {
                return "dashboard";
            }
        } else {
            model.addAttribute("error", "Invalid username or password!");
            return "Login";
        }
    }
    
    @GetMapping("/Sign_up")
    public String showSignUp(){
        return "Sign_up";
    }
    
    @PostMapping("/doRegister")
    public String doRegister(@RequestParam("username") String username,
                             @RequestParam("email") String email,
                             @RequestParam("password") String password,
                             @RequestParam("confirm_password") String confirm_password,
                             Model model){
        
        if(!password.equals(confirm_password)){
            model.addAttribute("error", "Passwords do not match!");
            return "Sign_up";
        }
        
        if(userDao.findByUsername(username) != null){
            model.addAttribute("error", "Username already exists!");
            return "Sign_up";
        }
        
        if(userDao.findByEmail(email) != null){
            model.addAttribute("error", "Email already registered!");
            return "Sign_up";
        }
        
        User user = new User(username, email, password);
        user.setRole("USER");
        userDao.saveUser(user);
        
        model.addAttribute("success", "Registration successful! Please login.");
        return "Login";
    }
    
    @GetMapping("/Logout")
    public String logout(HttpSession session){
        session.invalidate();
        return "Login";
    }
}