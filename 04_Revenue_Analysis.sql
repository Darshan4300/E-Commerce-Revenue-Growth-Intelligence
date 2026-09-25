USE olist_ecommerce;

-- Calculation: Total Revenue
SELECT 
    ROUND(SUM(price), 2) AS total_revenue
FROM order_items;

-- Calculation: Revenue by Year
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY order_year;

-- Calculation: Revenue by Month
SELECT 
    MONTH(o.order_purchase_timestamp) AS order_month,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY MONTH(o.order_purchase_timestamp)
ORDER BY order_month;

-- Calculation: Highest Revenue Month
SELECT 
    MONTH(o.order_purchase_timestamp) AS order_month,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY MONTH(o.order_purchase_timestamp)
ORDER BY total_revenue DESC
LIMIT 1;

-- Calculation: Revenue by Order Status
SELECT 
    o.order_status,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_status
ORDER BY total_revenue DESC;

-- Calculation: Revenue by Product Category
SELECT 
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;

-- Calculation: Top 10 Products by Revenue
SELECT 
    oi.product_id,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Calculation: Total Freight Value
SELECT 
    ROUND(SUM(freight_value), 2) AS total_freight_value
FROM order_items;

-- Calculation: Total Revenue Including Freight
SELECT 
    ROUND(SUM(price + freight_value), 2) AS total_revenue_with_freight
FROM order_items;

-- Calculation: Average Freight Value per Item
SELECT 
    ROUND(AVG(freight_value), 2) AS average_freight_value
FROM order_items;

-- Calculation: Freight Percentage of Product Revenue
SELECT 
    ROUND(
        SUM(freight_value) * 100.0 / SUM(price),
        2
    ) AS freight_percentage
FROM order_items;

-- Calculation: Revenue by Payment Type
SELECT 
    p.payment_type,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value
FROM payments p
GROUP BY p.payment_type
ORDER BY total_payment_value DESC;

-- Calculation: Average Payment Value
SELECT 
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments;

-- Calculation: Revenue by Year and Month
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY 
    order_year,
    order_month;
    
    -- Calculation: Highest Revenue Month
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY monthly_revenue DESC
LIMIT 1;

-- Calculation: Average Order Revenue by Year
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS average_order_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY order_year;

-- Calculation: Freight Value by Year
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    ROUND(SUM(oi.freight_value), 2) AS total_freight
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY order_year;

-- Calculation: Revenue Growth from 2016 to 2017
SELECT 
    ROUND(
        (
            SUM(CASE 
                WHEN YEAR(o.order_purchase_timestamp) = 2017 
                THEN oi.price ELSE 0 
            END)
            -
            SUM(CASE 
                WHEN YEAR(o.order_purchase_timestamp) = 2016 
                THEN oi.price ELSE 0 
            END)
        ) * 100.0
        /
        SUM(CASE 
            WHEN YEAR(o.order_purchase_timestamp) = 2016 
            THEN oi.price ELSE 0 
        END),
        2
    ) AS revenue_growth_2017_percent
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;
    
-- Calculation: Revenue Growth from 2017 to 2018
SELECT 
    ROUND(
        (
            SUM(CASE 
                WHEN YEAR(o.order_purchase_timestamp) = 2018 
                THEN oi.price ELSE 0 
            END)
            -
            SUM(CASE 
                WHEN YEAR(o.order_purchase_timestamp) = 2017 
                THEN oi.price ELSE 0 
            END)
        ) * 100.0
        /
        SUM(CASE 
            WHEN YEAR(o.order_purchase_timestamp) = 2017 
            THEN oi.price ELSE 0 
        END),
        2
    ) AS revenue_growth_2018_percent
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;
    
-- Calculation: Top 10 Product Categories by Revenue
SELECT 
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Calculation: Revenue Share of Top 10 Product Categories
SELECT 
    ROUND(
        SUM(category_revenue) * 100.0 /
        (SELECT SUM(price) FROM order_items),
        2
    ) AS top_10_category_revenue_percentage
FROM (
    SELECT 
        p.product_category_name,
        SUM(oi.price) AS category_revenue
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
    ORDER BY category_revenue DESC
    LIMIT 10
) AS top_categories;

-- Calculation: Highest Individual Product Price
SELECT 
    product_id,
    price
FROM order_items
ORDER BY price DESC
LIMIT 1;

-- Calculation: Average Product Price by Top 10 Revenue Categories
SELECT 
    p.product_category_name,
    ROUND(AVG(oi.price), 2) AS average_product_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IN (
    'beleza_saude',
    'relogios_presentes',
    'cama_mesa_banho',
    'esporte_lazer',
    'informatica_acessorios',
    'moveis_decoracao',
    'cool_stuff',
    'utilidades_domesticas',
    'automotivo',
    'ferramentas_jardim'
)
GROUP BY p.product_category_name
ORDER BY average_product_price DESC;

-- Calculation: Number of Items Sold by Year
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    COUNT(*) AS total_items_sold
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY order_year;

-- Calculation: Average Revenue per Item by Year
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    ROUND(AVG(oi.price), 2) AS average_item_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY order_year;

-- Calculation: Revenue by Month Name
SELECT 
    MONTH(o.order_purchase_timestamp) AS month_number,
    MONTHNAME(o.order_purchase_timestamp) AS month_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY 
    MONTH(o.order_purchase_timestamp),
    MONTHNAME(o.order_purchase_timestamp)
ORDER BY month_number;