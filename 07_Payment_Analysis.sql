-- Q1 — Total Payment Records
USE olist_ecommerce;

-- Query 1: Total Payment Records
SELECT
    COUNT(*) AS total_payment_records
FROM payments;

-- Query 2: Total Payment Value
SELECT
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments;

-- Query 3: Average Payment Value
SELECT
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments;

-- Query 4: Payment Methods
SELECT
    payment_type,
    COUNT(*) AS payment_count
FROM payments
GROUP BY payment_type
ORDER BY payment_count DESC;

-- Query 5: Payment Value by Payment Method
SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;

-- Query 6: Average Payment Value by Payment Method
SELECT
    payment_type,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments
GROUP BY payment_type
ORDER BY average_payment_value DESC;

-- Query 7: Payment Method Distribution
SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM payments),
        2
    ) AS payment_percentage
FROM payments
GROUP BY payment_type
ORDER BY payment_count DESC;

-- Query 8: Payment Installment Distribution
SELECT
    payment_installments,
    COUNT(*) AS payment_count
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;

-- Query 9: Average Number of Installments
SELECT
    ROUND(AVG(payment_installments), 2) AS average_installments
FROM payments;

-- Query 10: Payment Value by Installment Count
SELECT
    payment_installments,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;

-- Query 11: Highest Payment Value
SELECT
    MAX(payment_value) AS highest_payment_value
FROM payments;

-- Query 12: Missing Payment Data
SELECT
    SUM(order_id IS NULL OR order_id = '') AS missing_order_id,
    SUM(payment_sequential IS NULL) AS missing_payment_sequential,
    SUM(payment_type IS NULL OR payment_type = '') AS missing_payment_type,
    SUM(payment_installments IS NULL) AS missing_installments,
    SUM(payment_value IS NULL) AS missing_payment_value
FROM payments;