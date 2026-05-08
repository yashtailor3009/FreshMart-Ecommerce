<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sign Up Page</title>
        <style>
            body{
                height: 100vh;
                display: flex;
                margin: 0;
                padding: 0;
                font-family: sans-serif;
                background: url("https://images.unsplash.com/photo-1687289355977-a6dbe60ef19f?q=80&w=1074&auto=format&fit=crop");
                background-size: cover;
                justify-content: center;
                align-items: center;
            }
            .form-container{
                max-width: 320px;
                width: 100%;
                padding: 40px;
                box-shadow: 0 0 10px black;
                background: transparent;
                backdrop-filter: blur(20px);
                border-radius: 10px;
            }
            .form-header{
                text-align: center;
                margin-bottom: 25px;
                font-weight: bold;
                font-size: 1rem;
                text-transform: uppercase;
                color: white;
            }
            .input-container input{
                padding: 15px 20px;
                width: calc(100% - 40px);
                border-radius: 30px;
                border: 1px solid rgba(255,255,255,0.3);
                margin-bottom: 20px;
                background: rgba(255,255,255,0.1);
                font-size: 1rem;
                color: white;
            }
            input::placeholder{
                color: rgba(255,255,255,0.7);
            }
            .button{
                margin-bottom: 20px;
            }
            .submit{
                width: 100%;
                padding: 15px;
                border-radius: 20px;
                border: none;
                font-weight: bold;
                cursor: pointer;
                background: rgba(255,255,255,0.9);
            }
            .submit:hover{
                box-shadow: 0 0 9px rgba(255,255,255,0.662);
            }
            .signup{
                text-align: center;
                color: white;
            }
            .signup a{
                color: #ffd700;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <form action="doRegister" method="post">
            <div class="form-container">
                <div class="form-header">
                    <h3>Sign Up</h3>
                </div>
                <div class="input-container">
                    <input type="text" name="username" placeholder="Username" required>
                    <input type="email" name="email" placeholder="Email Address" required>
                    <input type="password" name="password" placeholder="Create Password" required>
                    <input type="password" name="confirm_password" placeholder="Re-Enter Password" required>
                    
                    <div class="button">
                        <button class="submit" type="submit">SIGN UP</button>
                    </div>
                    <div class="signup">
                        Already Have An Account? <a href="Login.jsp">Log In</a>
                    </div>
                </div>
            </div>
        </form>
    </body>
</html>