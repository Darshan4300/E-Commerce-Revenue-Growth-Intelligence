USE olist_ecommerce;

-- Calculation: Total Number of Products
SELECT 
    COUNT(*) AS total_products
FROM products;

-- Calculation: Products with Missing Category
SELECT 
    COUNT(*) AS products_without_category
FROM products
WHERE product_category_name IS NULL
   OR product_category_name = '';
   
-- Calculation: Number of Products by Category
SELECT 
    product_category_name,
    COUNT(*) AS total_products
FROM products
WHERE product_category_name IS NOT NULL
  AND product_category_name <> ''
GROUP BY product_category_name
ORDER BY total_products DESC;

-- Calculation: Average Product Weight
SELECT 
    ROUND(AVG(product_weight_g), 2) AS average_product_weight_g
FROM products
WHERE product_weight_g IS NOT NULL;

-- Calculation: Minimum and Maximum Product Weight
SELECT 
    MIN(product_weight_g) AS minimum_weight_g,
    MAX(product_weight_g) AS maximum_weight_g
FROM products
WHERE product_weight_g IS NOT NULL;

-- Calculation: Average Number of Product Photos
SELECT 
    ROUND(AVG(product_photos_qty), 2) AS average_product_photos
FROM products
WHERE product_photos_qty IS NOT NULL;

-- Query 7: Average Product Dimensions
SELECT 
    ROUND(AVG(product_length_cm), 2) AS average_length_cm,
    ROUND(AVG(product_height_cm), 2) AS average_height_cm,
    ROUND(AVG(product_width_cm), 2) AS average_width_cm
FROM products
WHERE product_length_cm IS NOT NULL
  AND product_height_cm IS NOT NULL
  AND product_width_cm IS NOT NULL;
  
-- Query 8: Missing Product Data
SELECT
    SUM(product_category_name IS NULL) AS missing_category,
    SUM(product_name_lenght IS NULL) AS missing_name_length,
    SUM(product_description_lenght IS NULL) AS missing_description_length,
    SUM(product_photos_qty IS NULL) AS missing_photos,
    SUM(product_weight_g IS NULL) AS missing_weight,
    SUM(product_length_cm IS NULL) AS missing_length,
    SUM(product_height_cm IS NULL) AS missing_height,
    SUM(product_width_cm IS NULL) AS missing_width
FROM products;

-- Query 9: Products by Weight Range
SELECT
    CASE
        WHEN product_weight_g < 1000 THEN 'Under 1 kg'
        WHEN product_weight_g < 5000 THEN '1–5 kg'
        WHEN product_weight_g < 10000 THEN '5–10 kg'
        ELSE '10+ kg'
    END AS weight_range,
    COUNT(*) AS product_count
FROM products
WHERE product_weight_g IS NOT NULL
GROUP BY weight_range
ORDER BY product_count DESC;

-- Query 10: Products by Photo Count
SELECT
    product_photos_qty,
    COUNT(*) AS product_count
FROM products
WHERE product_photos_qty IS NOT NULL
GROUP BY product_photos_qty
ORDER BY product_photos_qty;

-- Query 11: Average Product Name Length
SELECT
    ROUND(AVG(product_name_lenght), 2) AS average_name_length
FROM products
WHERE product_name_lenght IS NOT NULL;

-- Query 12: Average Product Description Length
SELECT
    ROUND(AVG(product_description_lenght), 2) AS average_description_length
FROM products
WHERE product_description_lenght IS NOT NULL;

-- Query 13: Top 10 Categories by Average Product Price
SELECT
    p.product_category_name AS category,
    ROUND(AVG(oi.price), 2) AS average_price
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY average_price DESC
LIMIT 10;

-- Query 14: Product Count by Category
SELECT
    product_category_name AS category,
    COUNT(*) AS product_count
FROM products
WHERE product_category_name IS NOT NULL
GROUP BY product_category_name
ORDER BY product_count DESC;

-- Query 15: Average Product Weight by Category
SELECT
    product_category_name AS category,
    ROUND(AVG(product_weight_g), 2) AS average_weight_g
FROM products
WHERE product_category_name IS NOT NULL
  AND product_weight_g IS NOT NULL
GROUP BY product_category_name
ORDER BY average_weight_g DESC;

-- Query 16: Average Product Photos by Category
SELECT
    product_category_name AS category,
    ROUND(AVG(product_photos_qty), 2) AS average_photos
FROM products
WHERE product_category_name IS NOT NULL
  AND product_photos_qty IS NOT NULL
GROUP BY product_category_name
ORDER BY average_photos DESC;

-- Query 17: Products with Zero Weight
SELECT
    COUNT(*) AS zero_weight_products
FROM products
WHERE product_weight_g = 0;

-- Query 18: Products with Zero Dimensions
SELECT
    SUM(product_length_cm = 0) AS zero_length,
    SUM(product_height_cm = 0) AS zero_height,
    SUM(product_width_cm = 0) AS zero_width
FROM products;

-- Query 19: Top 10 Categories by Total Product Weight
SELECT
    product_category_name AS category,
    ROUND(SUM(product_weight_g) / 1000, 2) AS total_weight_kg
FROM products
WHERE product_category_name IS NOT NULL
  AND product_weight_g IS NOT NULL
GROUP BY product_category_name
ORDER BY total_weight_kg DESC
LIMIT 10;

SELECT
    oi.product_id,
    p.product_category_name AS category,
    ROUND(MAX(oi.price), 2) AS highest_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY oi.product_id, p.product_category_name
ORDER BY highest_price DESC
LIMIT 10;