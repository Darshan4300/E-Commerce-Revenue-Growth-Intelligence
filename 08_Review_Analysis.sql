USE olist_ecommerce;


-- Q1
-- Calculation: Total Review Records
SELECT 
    COUNT(*) AS total_review_records
FROM reviews;


-- Q2
-- Calculation: Average Review Score
SELECT 
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews;


-- Q3
-- Calculation: Review Score Distribution
SELECT 
    review_score,
    COUNT(*) AS review_count
FROM reviews
GROUP BY review_score
ORDER BY review_score;


-- Q4
-- Calculation: Percentage Distribution of Review Scores
SELECT 
    review_score,
    COUNT(*) AS review_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM reviews),
        2
    ) AS percentage
FROM reviews
GROUP BY review_score
ORDER BY review_score;


-- Q5
-- Calculation: Positive Reviews (4 and 5 Stars)
SELECT 
    COUNT(*) AS positive_reviews
FROM reviews
WHERE review_score IN (4, 5);


-- Q6
-- Calculation: Negative Reviews (1 and 2 Stars)
SELECT 
    COUNT(*) AS negative_reviews
FROM reviews
WHERE review_score IN (1, 2);


-- Q7
-- Calculation: Positive Review Rate
SELECT 
    ROUND(
        COUNT(CASE WHEN review_score IN (4, 5) THEN 1 END) 
        * 100.0 / COUNT(*),
        2
    ) AS positive_review_rate
FROM reviews;


-- Q8
-- Calculation: Negative Review Rate
SELECT 
    ROUND(
        COUNT(CASE WHEN review_score IN (1, 2) THEN 1 END) 
        * 100.0 / COUNT(*),
        2
    ) AS negative_review_rate
FROM reviews;


-- Q9
-- Calculation: Review Score by Year
SELECT 
    YEAR(review_creation_date) AS review_year,
    COUNT(*) AS review_count,
    ROUND(AVG(review_score), 2) AS average_score
FROM reviews
GROUP BY YEAR(review_creation_date)
ORDER BY review_year;


-- Q10
-- Calculation: Review Score by Month
SELECT 
    MONTH(review_creation_date) AS review_month,
    COUNT(*) AS review_count,
    ROUND(AVG(review_score), 2) AS average_score
FROM reviews
GROUP BY MONTH(review_creation_date)
ORDER BY review_month;


-- Q11
-- Calculation: Average Review Score by Order Status
SELECT 
    o.order_status,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM reviews r
JOIN orders o
    ON r.order_id = o.order_id
GROUP BY o.order_status
ORDER BY average_review_score DESC;


-- Q12
-- Calculation: Review Coverage - Orders with Reviews
SELECT 
    COUNT(DISTINCT r.order_id) AS orders_with_reviews,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT r.order_id) * 100.0 
        / COUNT(DISTINCT o.order_id),
        2
    ) AS review_coverage_rate
FROM orders o
LEFT JOIN reviews r
    ON o.order_id = r.order_id;