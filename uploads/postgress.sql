CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id),
    amount DECIMAL(10,2) NOT NULL,
    method VARCHAR(30),
    status VARCHAR(30) DEFAULT 'pending',
    paid_at TIMESTAMP
);

INSERT INTO users (name, email) VALUES
('Arash', 'arash@example.com'),
('Ali', 'ali@example.com'),
('Sara', 'sara@example.com');

INSERT INTO orders (user_id, total_amount, status) VALUES
(1, 250.00, 'completed'),
(1, 120.00, 'pending'),
(2, 500.00, 'completed'),
(3, 75.00, 'completed');

INSERT INTO payments (order_id, amount, method, status, paid_at) VALUES
(1, 250.00, 'card', 'success', NOW()),
(3, 500.00, 'card', 'success', NOW()),
(4, 75.00, 'wallet', 'success', NOW()),
(2, 120.00, 'card', 'pending', NULL);
