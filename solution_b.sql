CREATE DATABASE 2b
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

-- 1. Liệt kê các hóa đơn của khách hàng (mã user, tên user, mã hóa đơn)
SELECT u.user_id, u.user_name, o.order_id 
FROM users u 
JOIN orders o ON u.user_id = o.user_id;

-- 2. Liệt kê số lượng các hóa đơn của khách hàng
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS so_don_hang 
FROM users u 
JOIN orders o ON u.user_id = o.user_id 
GROUP BY u.user_id, u.user_name;

-- 3. Liệt kê thông tin hóa đơn: mã đơn hàng, số sản phẩm
SELECT order_id, COUNT(product_id) AS so_san_pham 
FROM order_details 
GROUP BY order_id;

-- 4. Thông tin mua hàng: mã user, tên user, mã đơn hàng, tên sản phẩm (Gom nhóm theo đơn hàng)
SELECT u.user_id, u.user_name, o.order_id, GROUP_CONCAT(p.product_name SEPARATOR ', ') AS ten_san_pham 
FROM users u 
JOIN orders o ON u.user_id = o.user_id 
JOIN order_details od ON o.order_id = od.order_id 
JOIN products p ON od.product_id = p.product_id 
GROUP BY o.order_id, u.user_id, u.user_name;

-- 5. Liệt kê 7 người dùng có số lượng đơn hàng nhiều nhất
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS so_luong_don_hang 
FROM users u 
JOIN orders o ON u.user_id = o.user_id 
GROUP BY u.user_id, u.user_name 
ORDER BY so_luong_don_hang DESC 
LIMIT 7;

-- 6. 7 người dùng mua sản phẩm Samsung hoặc Apple
SELECT u.user_id, u.user_name, o.order_id, p.product_name 
FROM users u 
JOIN orders o ON u.user_id = o.user_id 
JOIN order_details od ON o.order_id = od.order_id 
JOIN products p ON od.product_id = p.product_id 
WHERE p.product_name LIKE '%Samsung%' OR p.product_name LIKE '%Apple%' 
LIMIT 7;

-- 7. Danh sách mua hàng kèm tổng tiền mỗi đơn hàng
SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS tong_tien 
FROM users u 
JOIN orders o ON u.user_id = o.user_id 
JOIN order_details od ON o.order_id = od.order_id 
JOIN products p ON od.product_id = p.product_id 
GROUP BY u.user_id, u.user_name, o.order_id;

-- 8. Mỗi user chỉ chọn 1 đơn hàng có giá tiền lớn nhất
WITH OrderTotals AS (
    SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS tong_tien
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
),
RankedOrders AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY tong_tien DESC) as rn
    FROM OrderTotals
)
SELECT user_id, user_name, order_id, tong_tien 
FROM RankedOrders 
WHERE rn = 1;

-- 9. Mỗi user chọn 1 đơn hàng có giá tiền nhỏ nhất, hiển thị thêm số sản phẩm
WITH OrderDetailsCalc AS (
    SELECT u.user_id, u.user_name, o.order_id,
           SUM(p.product_price) AS tong_tien,
           COUNT(od.product_id) AS so_san_pham
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
),
RankedMin AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY tong_tien ASC) as rn
    FROM OrderDetailsCalc
)
SELECT user_id, user_name, order_id, tong_tien, so_san_pham 
FROM RankedMin 
WHERE rn = 1;

-- 10. Mỗi user chọn 1 đơn hàng có số sản phẩm nhiều nhất
WITH OrderDetailsCalc AS (
    SELECT u.user_id, u.user_name, o.order_id,
           SUM(p.product_price) AS tong_tien,
           COUNT(od.product_id) AS so_san_pham
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
),
RankedMaxItems AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY so_san_pham DESC) as rn
    FROM OrderDetailsCalc
)
SELECT user_id, user_name, order_id, tong_tien, so_san_pham 
FROM RankedMaxItems 
WHERE rn = 1;