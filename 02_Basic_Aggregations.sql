USE olist_ecommerce;

SELECT ROUND(SUM(price), 2) AS total_revenue
FROM order_items;

SELECT ROUND(AVG(price), 2) AS average_product_price
FROM order_items;

SELECT 
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price
FROM order_items;