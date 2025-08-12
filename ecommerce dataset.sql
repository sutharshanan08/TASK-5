
CREATE DATABASE ecommerce_db;
USE ecommerce_db;


CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    country VARCHAR(50),
    created_at DATE
);


CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL
);


CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10,2),
    stock_quantity INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO categories (category_name) VALUES
('Electronics'), ('Fashion'), ('Home & Kitchen'), ('Books'), ('Sports');


INSERT INTO customers (first_name, last_name, email, phone, country, created_at) VALUES
('John', 'Doe', 'john@example.com', '1234567890', 'USA', '2024-01-10'),
('Alice', 'Smith', 'alice@example.com', '9876543210', 'UK', '2024-03-15'),
('Robert', 'Brown', 'robert@example.com', '5551234567', 'India', '2024-05-20');


INSERT INTO products (product_name, category_id, price, stock_quantity) VALUES
('Smartphone', 1, 699.99, 50),
('Laptop', 1, 1299.50, 20),
('T-shirt', 2, 19.99, 200),
('Cookware Set', 3, 79.99, 100),
('Novel Book', 4, 14.50, 300);

INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2024-06-01', 719.98, 'Completed'),
(2, '2024-06-03', 79.99, 'Shipped'),
(3, '2024-06-05', 1314.00, 'Pending');

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 699.99),
(1, 3, 1, 19.99),
(2, 4, 1, 79.99),
(3, 2, 1, 1299.50),
(3, 5, 1, 14.50);

SELECT c.category_name, SUM(oi.price * oi.quantity) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sales DESC;


SELECT cu.first_name, cu.last_name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
GROUP BY cu.customer_id
ORDER BY total_spent DESC
LIMIT 5;


SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS monthly_sales
FROM orders
GROUP BY month
ORDER BY month;

SELECT o.order_id, cu.first_name, cu.last_name, o.total_amount, o.order_date
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
WHERE cu.country = 'USA'
ORDER BY o.total_amount DESC;


SELECT c.category_name, SUM(oi.price * oi.quantity) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sales DESC;

SELECT o.order_id, cu.first_name, cu.last_name, o.total_amount
FROM orders o
INNER JOIN customers cu ON o.customer_id = cu.customer_id;


SELECT cu.customer_id, cu.first_name, cu.last_name, o.order_id
FROM customers cu
LEFT JOIN orders o ON cu.customer_id = o.customer_id;


SELECT o.order_id, cu.first_name, cu.last_name
FROM orders o
RIGHT JOIN customers cu ON o.customer_id = cu.customer_id;

SELECT first_name, last_name, customer_id
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > (SELECT AVG(total_amount) FROM orders)
);

SELECT AVG(total_amount) AS avg_order_value
FROM orders;


SELECT SUM(total_amount) AS total_revenue
FROM orders;

CREATE VIEW monthly_sales AS
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS total_sales
FROM orders
GROUP BY month;


SELECT * FROM monthly_sales ORDER BY month;

CREATE INDEX idx_customers_email ON customers(email);


CREATE INDEX idx_orders_date ON orders(order_date);


CREATE INDEX idx_products_category ON products(category_id);
