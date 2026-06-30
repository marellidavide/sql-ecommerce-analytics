/* 
===============================================================
E-COMMERCE BUSINESS ANALYTICS PROJECT
Author: Davide Marelli
Goal: Extract business KPIs and metrics from raw database tables
===============================================================
*/

-- 1. CREAZIONE DELLE TABELLE (Struttura Database)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    registration_date DATE,
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 2. POPOLAMENTO DATI FITTIZI (Mock Data)
INSERT INTO customers VALUES 
(1, 'John', 'Doe', '2025-11-15', 'USA'),
(2, 'Mario', 'Rossi', '2026-01-10', 'Italy'),
(3, 'Emma', 'Smith', '2026-03-22', 'UK');

INSERT INTO products VALUES 
(101, 'Wireless Mouse', 'Electronics', 25.99),
(102, 'Mechanical Keyboard', 'Electronics', 89.99),
(103, 'Desk Lamp', 'Office', 35.50);

INSERT INTO orders VALUES 
(1001, 1, '2026-05-10', 115.98),
(1002, 2, '2026-06-15', 35.50),
(1003, 1, '2026-06-20', 25.99),
(1004, 3, '2026-07-01', 125.49);


-- ============================================================
-- 3. DATA ANALYSIS & BUSINESS QUERIES
-- ============================================================

-- METRICA 1: Fatturato Totale per Mese (Total Revenue by Month)
-- Utile per il management per capire i mesi di picco delle vendite.
SELECT 
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(total_amount) AS monthly_revenue,
    COUNT(order_id) AS total_orders
FROM 
    orders
GROUP BY 
    EXTRACT(MONTH FROM order_date)
ORDER BY 
    order_month;

-- METRICA 2: Valore del Ciclo di Vita del Cliente (Customer Lifetime Value - LTV)
-- Identifica i clienti più spendenti (VIP) per campagne marketing mirate.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spent,
    COUNT(o.order_id) AS number_of_purchases
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    total_spent DESC
LIMIT 5;

-- METRICA 3: Analisi Geografica delle Vendite (Revenue by Country)
-- Mostra in quali nazioni il business sta performando meglio.
SELECT 
    c.country,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    SUM(o.total_amount) AS total_revenue
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.country
ORDER BY 
    total_revenue DESC;
