CREATE DATABASE 2a
-- 1. Tạo bảng users 
CREATE TABLE users (
    user_id INT(11) NOT NULL AUTO_INCREMENT, 
    user_name VARCHAR(25) NOT NULL,          
    user_email VARCHAR(55) NOT NULL,         
    user_pass VARCHAR(255) NOT NULL,         
    updated_at DATETIME,                     
    created_at DATETIME,                     
    PRIMARY KEY (user_id)
);

-- 2. Tạo bảng products 
CREATE TABLE products (
    product_id INT(11) NOT NULL AUTO_INCREMENT, 
    product_name VARCHAR(255) NOT NULL,         
    product_price DOUBLE NOT NULL,              
    product_description TEXT NOT NULL,          
    updated_at DATETIME,                        
    created_at DATETIME,                        
    PRIMARY KEY (product_id)
);

-- 3. Tạo bảng orders
CREATE TABLE orders (
    order_id INT(11) NOT NULL AUTO_INCREMENT, 
    user_id INT(11) NOT NULL,                 
    updated_at DATETIME,                      
    created_at DATETIME,                      
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 4. Tạo bảng order_details 
CREATE TABLE order_details (
    order_detail_id INT(11) NOT NULL AUTO_INCREMENT, 
    order_id INT(11) NOT NULL,                       
    product_id INT(11) NOT NULL,                     
    updated_at DATETIME,                             
    created_at DATETIME,                             
    PRIMARY KEY (order_detail_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 1. Lấy ra danh sách người dùng theo thứ tự tên theo Alphabet (A->Z)
SELECT * FROM users ORDER BY user_name ASC;

-- 2. Lấy ra 07 người dùng theo thứ tự tên theo Alphabet (A->Z)
SELECT * FROM users ORDER BY user_name ASC LIMIT 7;

-- 3. Lấy ra danh sách người dùng theo thứ tự tên theo Alphabet (A->Z), trong đó tên người dùng có chữ a
SELECT * FROM users WHERE user_name LIKE '%a%' ORDER BY user_name ASC;

-- 4. Lấy ra danh sách người dùng trong đó tên người dùng bắt đầu bằng chữ m
SELECT * FROM users WHERE user_name LIKE 'm%';

-- 5. Lấy ra danh sách người dùng trong đó tên người dùng kết thúc bằng chữ i
SELECT * FROM users WHERE user_name LIKE '%i';

-- 6. Lấy ra danh sách người dùng trong đó email người dùng là Gmail
SELECT * FROM users WHERE user_email LIKE '%@gmail.com';

-- 7. Lấy ra danh sách người dùng trong đó email người dùng là Gmail, tên bắt đầu bằng chữ m
SELECT * FROM users WHERE user_email LIKE '%@gmail.com' AND user_name LIKE 'm%';

-- 8. Lấy ra danh sách người dùng có email Gmail, tên có chữ i và chiều dài lớn hơn 5
SELECT * FROM users WHERE user_email LIKE '%@gmail.com' AND user_name LIKE '%i%' AND LENGTH(user_name) > 5;

-- 9. Tên có chữ a, dài từ 5 đến 9, email Gmail, trong tên email có chữ i (trước @)
SELECT * FROM users 
WHERE user_name LIKE '%a%' 
  AND LENGTH(user_name) BETWEEN 5 AND 9 
  AND user_email LIKE '%@gmail.com' 
  AND SUBSTRING_INDEX(user_email, '@', 1) LIKE '%i%';

-- 10. (Tên có a VÀ dài 5-9) HOẶC (tên có i VÀ dài < 9) HOẶC (email Gmail VÀ tên email có i)
SELECT * FROM users 
WHERE (user_name LIKE '%a%' AND LENGTH(user_name) BETWEEN 5 AND 9) 
   OR (user_name LIKE '%i%' AND LENGTH(user_name) < 9) 
   OR (user_email LIKE '%@gmail.com' AND SUBSTRING_INDEX(user_email, '@', 1) LIKE '%i%');