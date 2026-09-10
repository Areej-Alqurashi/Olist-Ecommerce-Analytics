USE olist_ecommerce;

-- =========================
-- TABLE ROW COUNTS
-- =========================

SELECT COUNT(*) AS customers_count
FROM customers;

SELECT COUNT(*) AS orders_count
FROM orders;

SELECT COUNT(*) AS order_items_count
FROM order_items;

SELECT COUNT(*) AS order_payments_count
FROM order_payments;

SELECT COUNT(*) AS order_reviews_count
FROM order_reviews;

SELECT COUNT(*) AS products_count
FROM products;

SELECT COUNT(*) AS sellers_count
FROM sellers;

SELECT COUNT(*) AS geolocation_count
FROM geolocation;


-- =========================
-- ORDERS
-- =========================

SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT COUNT(*) AS duplicate_orders
FROM (
    SELECT order_id
    FROM orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT
    SUM(order_purchase_timestamp IS NULL) AS purchase_nulls,
    SUM(order_approved_at IS NULL) AS approved_nulls,
    SUM(order_delivered_carrier_date IS NULL) AS carrier_nulls,
    SUM(order_delivered_customer_date IS NULL) AS customer_delivery_nulls,
    SUM(order_estimated_delivery_date IS NULL) AS estimated_delivery_nulls
FROM orders;

SELECT COUNT(*) AS total_orders
FROM orders
WHERE order_status = 'delivered';

SELECT COUNT(*) AS non_delivered_with_delivery_date
FROM orders
WHERE order_status <> 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- =========================
-- ORDER ITEMS
-- =========================

SELECT COUNT(*) AS duplicate_order_items
FROM (
    SELECT order_id, order_item_id
    FROM order_items
    GROUP BY order_id, order_item_id
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT COUNT(*) AS invalid_price
FROM order_items
WHERE price < 0;

SELECT COUNT(*) AS invalid_freight
FROM order_items
WHERE freight_value < 0;

SELECT
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    AVG(price) AS avg_price
FROM order_items;

SELECT
    MIN(freight_value) AS min_freight,
    MAX(freight_value) AS max_freight,
    AVG(freight_value) AS avg_freight
FROM order_items;


-- =========================
-- PAYMENTS
-- =========================

SELECT payment_type, COUNT(*) AS total_payments
FROM order_payments
GROUP BY payment_type
ORDER BY total_payments DESC;

SELECT COUNT(*) AS invalid_payment_sequential
FROM order_payments
WHERE payment_sequential < 1;

SELECT COUNT(*) AS invalid_payment_value
FROM order_payments
WHERE payment_value <= 0;

SELECT
    MIN(payment_value) AS min_payment,
    MAX(payment_value) AS max_payment,
    AVG(payment_value) AS avg_payment
FROM order_payments;

SELECT
    order_id,
    COUNT(*) AS payment_count,
    SUM(payment_value) AS total_payment
FROM order_payments
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY payment_count DESC;


-- =========================
-- CUSTOMERS
-- =========================

SELECT COUNT(*) AS duplicate_customer_ids
FROM (
    SELECT customer_id
    FROM customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT COUNT(*) AS duplicate_customer_unique_ids
FROM (
    SELECT customer_unique_id
    FROM customers
    GROUP BY customer_unique_id
    HAVING COUNT(*) > 1
) AS duplicates;


-- =========================
-- PRODUCTS
-- =========================

SELECT COUNT(*) AS duplicate_product_ids
FROM (
    SELECT product_id
    FROM products
    GROUP BY product_id
    HAVING COUNT(*) > 1
) AS duplicates;


-- =========================
-- SELLERS
-- =========================

SELECT COUNT(*) AS duplicate_seller_ids
FROM (
    SELECT seller_id
    FROM sellers
    GROUP BY seller_id
    HAVING COUNT(*) > 1
) AS duplicates;


-- =========================
-- FOREIGN KEY CHECKS
-- =========================

SELECT COUNT(*) AS missing_customer_ids
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS missing_order_ids
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS missing_product_ids
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS missing_seller_ids
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;


-- =========================
-- FINAL VALIDATION
-- =========================

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_sellers
FROM sellers;

SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT COUNT(*) AS total_payments
FROM order_payments;
