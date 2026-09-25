USE olist_ecommerce;

-- Query 1: Total Customer Records
SELECT
    COUNT(*) AS total_customer_records
FROM customers;

-- Query 2: Total Unique Customers
SELECT
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

-- Query 3: Customers by State
SELECT
    customer_state AS state,
    COUNT(DISTINCT customer_unique_id) AS customer_count
FROM customers
WHERE customer_state IS NOT NULL
  AND customer_state <> ''
GROUP BY customer_state
ORDER BY customer_count DESC;

-- Query 4: Customers with Multiple Orders
SELECT
    customer_unique_id,
    COUNT(*) AS order_count
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY order_count DESC;

-- Query 5: Total Repeat Customers
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        customer_unique_id
    FROM customers
    GROUP BY customer_unique_id
    HAVING COUNT(*) > 1
) AS repeat_customer_list;

-- Query 6: Repeat Customer Rate
SELECT
    ROUND(
        100.0 * SUM(order_count > 1) / COUNT(*),
        2
    ) AS repeat_customer_rate_percent
FROM (
    SELECT
        customer_unique_id,
        COUNT(*) AS order_count
    FROM customers
    GROUP BY customer_unique_id
) AS customer_orders;

-- Query 7: Top 10 States by Customer Base
SELECT
    customer_state AS state,
    COUNT(DISTINCT customer_unique_id) AS customer_count
FROM customers
WHERE customer_state IS NOT NULL
  AND customer_state <> ''
GROUP BY customer_state
ORDER BY customer_count DESC
LIMIT 10;

-- Query 8: Average Orders per Customer
SELECT
    ROUND(AVG(order_count), 2) AS average_orders_per_customer
FROM (
    SELECT
        customer_unique_id,
        COUNT(*) AS order_count
    FROM customers
    GROUP BY customer_unique_id
) AS customer_orders;

-- Query 9: Customers by Order Frequency
SELECT
    CASE
        WHEN order_count = 1 THEN '1 Order'
        WHEN order_count = 2 THEN '2 Orders'
        WHEN order_count BETWEEN 3 AND 5 THEN '3–5 Orders'
        ELSE '6+ Orders'
    END AS order_frequency,
    COUNT(*) AS customer_count
FROM (
    SELECT
        customer_unique_id,
        COUNT(*) AS order_count
    FROM customers
    GROUP BY customer_unique_id
) AS customer_orders
GROUP BY order_frequency
ORDER BY customer_count DESC;

-- Query 10: Top 10 Customer Cities
SELECT
    customer_city AS city,
    COUNT(DISTINCT customer_unique_id) AS customer_count
FROM customers
WHERE customer_city IS NOT NULL
  AND customer_city <> ''
GROUP BY customer_city
ORDER BY customer_count DESC
LIMIT 10;

-- Query 11: Customer Distribution by State
SELECT
    customer_state AS state,
    COUNT(DISTINCT customer_unique_id) AS customer_count,
    ROUND(
        100.0 * COUNT(DISTINCT customer_unique_id)
        / (SELECT COUNT(DISTINCT customer_unique_id) FROM customers),
        2
    ) AS customer_percentage
FROM customers
WHERE customer_state IS NOT NULL
  AND customer_state <> ''
GROUP BY customer_state
ORDER BY customer_count DESC;

-- Query 12: Missing Customer Data
SELECT
    SUM(customer_id IS NULL OR customer_id = '') AS missing_customer_id,
    SUM(customer_unique_id IS NULL OR customer_unique_id = '') AS missing_unique_id,
    SUM(customer_zip_code_prefix IS NULL) AS missing_zip_code,
    SUM(customer_city IS NULL OR customer_city = '') AS missing_city,
    SUM(customer_state IS NULL OR customer_state = '') AS missing_state
FROM customers;