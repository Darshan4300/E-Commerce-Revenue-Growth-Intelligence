USE olist_ecommerce;


-- Query 1: Highest Revenue Year
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY total_revenue DESC
LIMIT 1;


-- Query 2: Revenue Growth from 2017 to 2018
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
    ) AS revenue_growth_percentage
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;


-- Query 3: Order Growth from 2017 to 2018
SELECT 
    ROUND(
        (
            SUM(CASE 
                WHEN YEAR(order_purchase_timestamp) = 2018 
                THEN 1 ELSE 0 
            END)
            -
            SUM(CASE 
                WHEN YEAR(order_purchase_timestamp) = 2017 
                THEN 1 ELSE 0 
            END)
        ) * 100.0
        /
        SUM(CASE 
            WHEN YEAR(order_purchase_timestamp) = 2017 
            THEN 1 ELSE 0 
        END),
        2
    ) AS order_growth_percentage
FROM orders;


-- Query 4: Growth Driver - Orders vs Average Order Value
SELECT 
    order_year,
    total_orders,
    total_revenue,
    average_order_value
FROM (
    SELECT 
        YEAR(o.order_purchase_timestamp) AS order_year,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.price), 2) AS total_revenue,
        ROUND(
            SUM(oi.price) / COUNT(DISTINCT o.order_id),
            2
        ) AS average_order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE YEAR(o.order_purchase_timestamp) IN (2017, 2018)
    GROUP BY YEAR(o.order_purchase_timestamp)
) AS yearly_data
ORDER BY order_year;


-- Query 5: Highest Revenue Month
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    MONTHNAME(o.order_purchase_timestamp) AS month_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    MONTHNAME(o.order_purchase_timestamp)
ORDER BY total_revenue DESC
LIMIT 1;


-- Query 6: Top Product Category by Revenue
SELECT 
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 1;


-- Query 7: Top 10 Categories Revenue Contribution
SELECT 
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(
        SUM(oi.price) * 100.0 /
        (SELECT SUM(price) FROM order_items),
        2
    ) AS revenue_contribution_percentage
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;


-- Query 8: Highest-Revenue Customer State
SELECT 
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 1;


-- Query 9: Highest-Revenue Seller
SELECT 
    oi.seller_id,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 1;


-- Query 10: Seller Revenue Distribution
SELECT 
    CASE
        WHEN seller_revenue < 1000 THEN 'Below R$1,000'
        WHEN seller_revenue < 5000 THEN 'R$1,000 - R$4,999'
        WHEN seller_revenue < 10000 THEN 'R$5,000 - R$9,999'
        WHEN seller_revenue < 50000 THEN 'R$10,000 - R$49,999'
        ELSE 'R$50,000+'
    END AS revenue_range,
    COUNT(*) AS seller_count
FROM (
    SELECT 
        seller_id,
        SUM(price) AS seller_revenue
    FROM order_items
    GROUP BY seller_id
) AS seller_sales
GROUP BY revenue_range
ORDER BY MIN(seller_revenue);


-- Query 11: Dominant Payment Method
SELECT 
    payment_type,
    COUNT(*) AS payment_records,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM payments),
        2
    ) AS payment_percentage
FROM payments
GROUP BY payment_type
ORDER BY payment_records DESC
LIMIT 1;


-- Query 12: Customer Satisfaction - Positive Review Rate
SELECT 
    COUNT(CASE 
        WHEN review_score IN (4, 5) THEN 1 
    END) AS positive_reviews,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(CASE 
            WHEN review_score IN (4, 5) THEN 1 
        END) * 100.0 / COUNT(*),
        2
    ) AS positive_review_rate
FROM reviews;


-- Query 13: Review Score by Order Status
SELECT 
    o.order_status,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM reviews r
JOIN orders o
    ON r.order_id = o.order_id
GROUP BY o.order_status
ORDER BY average_review_score DESC;


-- Query 14: Customer Geolocation Coverage
SELECT 
    COUNT(DISTINCT CASE
        WHEN g.geolocation_zip_code_prefix IS NOT NULL
        THEN c.customer_id
    END) AS customers_with_geolocation,

    COUNT(DISTINCT c.customer_id) AS total_customers,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN g.geolocation_zip_code_prefix IS NOT NULL
            THEN c.customer_id
        END) * 100.0
        / COUNT(DISTINCT c.customer_id),
        2
    ) AS geolocation_coverage_percentage
FROM customers c
LEFT JOIN (
    SELECT DISTINCT geolocation_zip_code_prefix
    FROM geolocation
) AS g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;


-- Query 15: Business Performance Summary
SELECT 
    (SELECT COUNT(*) FROM customers) AS total_customers,
    
    (SELECT COUNT(*) FROM orders) AS total_orders,
    
    (SELECT ROUND(SUM(price), 2) FROM order_items) AS total_product_revenue,
    
    (SELECT ROUND(SUM(freight_value), 2) FROM order_items) AS total_freight,
    
    (SELECT ROUND(AVG(review_score), 2) FROM reviews) AS average_review_score,
    
    (SELECT ROUND(AVG(payment_installments), 2) FROM payments) AS average_installments,
    
    (SELECT 
        ROUND(
            COUNT(CASE WHEN order_status = 'delivered' THEN 1 END)
            * 100.0 / COUNT(*),
            2
        )
     FROM orders) AS delivered_order_rate;