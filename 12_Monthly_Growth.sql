USE olist_ecommerce;

-- Query 1: Orders by Year
SELECT 
    YEAR(order_purchase_timestamp) AS order_year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY order_year;

-- Query 2: Revenue by Year
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY order_year;

-- Query 3: Items Sold by Year
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    COUNT(*) AS items_sold
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY order_year;

-- Query 4: Average Order Value by Year
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY order_year;

-- Query 5: Orders by Month
SELECT 
    MONTH(o.order_purchase_timestamp) AS order_month,
    MONTHNAME(o.order_purchase_timestamp) AS month_name,
    COUNT(*) AS total_orders
FROM orders o
GROUP BY 
    MONTH(o.order_purchase_timestamp),
    MONTHNAME(o.order_purchase_timestamp)
ORDER BY order_month;

-- Query 6: Revenue by Month
SELECT 
    MONTH(o.order_purchase_timestamp) AS order_month,
    MONTHNAME(o.order_purchase_timestamp) AS month_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY 
    MONTH(o.order_purchase_timestamp),
    MONTHNAME(o.order_purchase_timestamp)
ORDER BY order_month;

-- Query 7: Orders by Year and Month
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    MONTHNAME(o.order_purchase_timestamp) AS month_name,
    COUNT(*) AS total_orders
FROM orders o
GROUP BY 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    MONTHNAME(o.order_purchase_timestamp)
ORDER BY 
    order_year,
    order_month;

-- Query 8: Revenue by Year and Month
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
ORDER BY 
    order_year,
    order_month;

-- Query 9: Revenue Growth from Previous Year
SELECT 
    order_year,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY order_year) AS previous_year_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY order_year))
        * 100.0
        / LAG(total_revenue) OVER (ORDER BY order_year),
        2
    ) AS revenue_growth_percentage
FROM (
    SELECT 
        YEAR(o.order_purchase_timestamp) AS order_year,
        SUM(oi.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY YEAR(o.order_purchase_timestamp)
) AS yearly_revenue
ORDER BY order_year;

-- Query 10: Order Growth from Previous Year
SELECT 
    order_year,
    total_orders,
    LAG(total_orders) OVER (ORDER BY order_year) AS previous_year_orders,
    ROUND(
        (total_orders - LAG(total_orders) OVER (ORDER BY order_year))
        * 100.0
        / LAG(total_orders) OVER (ORDER BY order_year),
        2
    ) AS order_growth_percentage
FROM (
    SELECT 
        YEAR(order_purchase_timestamp) AS order_year,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY YEAR(order_purchase_timestamp)
) AS yearly_orders
ORDER BY order_year;

-- Query 11: Monthly Revenue Growth
SELECT 
    order_year,
    order_month,
    month_name,
    total_revenue,
    LAG(total_revenue) OVER (
        ORDER BY order_year, order_month
    ) AS previous_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (
            ORDER BY order_year, order_month
        )) * 100.0
        / LAG(total_revenue) OVER (
            ORDER BY order_year, order_month
        ),
        2
    ) AS monthly_growth_percentage
FROM (
    SELECT 
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        MONTHNAME(o.order_purchase_timestamp) AS month_name,
        SUM(oi.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY 
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp),
        MONTHNAME(o.order_purchase_timestamp)
) AS monthly_revenue
ORDER BY order_year, order_month;

-- Query 12: Monthly Order Growth
SELECT 
    order_year,
    order_month,
    month_name,
    total_orders,
    LAG(total_orders) OVER (
        ORDER BY order_year, order_month
    ) AS previous_month_orders,
    ROUND(
        (total_orders - LAG(total_orders) OVER (
            ORDER BY order_year, order_month
        )) * 100.0
        / LAG(total_orders) OVER (
            ORDER BY order_year, order_month
        ),
        2
    ) AS monthly_growth_percentage
FROM (
    SELECT 
        YEAR(order_purchase_timestamp) AS order_year,
        MONTH(order_purchase_timestamp) AS order_month,
        MONTHNAME(order_purchase_timestamp) AS month_name,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY 
        YEAR(order_purchase_timestamp),
        MONTH(order_purchase_timestamp),
        MONTHNAME(order_purchase_timestamp)
) AS monthly_orders
ORDER BY order_year, order_month;

-- Query 13: Highest Revenue Month
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

-- Query 14: Highest Order Volume Month
SELECT 
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    MONTHNAME(order_purchase_timestamp) AS month_name,
    COUNT(*) AS total_orders
FROM orders
GROUP BY 
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp),
    MONTHNAME(order_purchase_timestamp)
ORDER BY total_orders DESC
LIMIT 1;

-- Query 15: Lowest Revenue Month
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
ORDER BY total_revenue ASC
LIMIT 1;

-- Query 16: Revenue Growth from 2017 to 2018
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
    ) AS revenue_growth_2018_vs_2017
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;

-- Query 17: Order Growth from 2017 to 2018
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
    ) AS order_growth_2018_vs_2017
FROM orders;

-- Query 18: Revenue Contribution by Year
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(
        SUM(oi.price) * 100.0 /
        (SELECT SUM(price) FROM order_items),
        2
    ) AS revenue_contribution_percentage
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY order_year;

-- Query 19: Orders Contribution by Year
SELECT 
    YEAR(order_purchase_timestamp) AS order_year,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM orders),
        2
    ) AS order_contribution_percentage
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY order_year;

-- Query 20: Yearly Growth Summary
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(oi.order_id) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY order_year;