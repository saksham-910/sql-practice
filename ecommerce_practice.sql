-- SQL Practice: E-Commerce Database
-- Custom questions and answers for practice
-- Schema:
--   customer (id, name, email, country, joined_date)
--   product (id, name, category, price, stock)
--   order (id, customer_id, order_date, status)
--   order_item (order_id, product_id, quantity, unit_price)
--   review (id, customer_id, product_id, rating, review_date)
--   seller (id, name, country, rating)
--   product_seller (product_id, seller_id)

-- ============================================================
-- SECTION 1: Basic SELECT and WHERE
-- ============================================================

-- Q1. Show all customers from India
SELECT * FROM customer
WHERE country = 'India';

-- Q2. Show all products under $50
SELECT name, price FROM product
WHERE price < 50
ORDER BY price ASC;

-- Q3. Show all orders that are still pending
SELECT * FROM order
WHERE status = 'pending';

-- Q4. Show products that are out of stock
SELECT name, category FROM product
WHERE stock = 0;

-- Q5. Show customers who joined after January 1, 2023
SELECT name, joined_date FROM customer
WHERE joined_date > '2023-01-01'
ORDER BY joined_date ASC;

-- ============================================================
-- SECTION 2: Aggregation (SUM, COUNT, AVG, GROUP BY, HAVING)
-- ============================================================

-- Q6. How many customers are there from each country?
SELECT country, COUNT(id) AS customer_count
FROM customer
GROUP BY country
ORDER BY customer_count DESC;

-- Q7. What is the total revenue from each product category?
SELECT product.category, SUM(order_item.quantity * order_item.unit_price) AS total_revenue
FROM order_item
JOIN product ON order_item.product_id = product.id
GROUP BY product.category
ORDER BY total_revenue DESC;

-- Q8. What is the average rating for each product?
SELECT product.name, ROUND(AVG(review.rating), 2) AS avg_rating
FROM product
JOIN review ON product.id = review.product_id
GROUP BY product.name
ORDER BY avg_rating DESC;

-- Q9. Which customers have placed more than 5 orders?
SELECT customer.name, COUNT(order.id) AS order_count
FROM customer
JOIN order ON customer.id = order.customer_id
GROUP BY customer.name
HAVING COUNT(order.id) > 5
ORDER BY order_count DESC;

-- Q10. What is the total quantity sold for each product?
SELECT product.name, SUM(order_item.quantity) AS total_sold
FROM product
JOIN order_item ON product.id = order_item.product_id
GROUP BY product.name
ORDER BY total_sold DESC;

-- ============================================================
-- SECTION 3: JOIN
-- ============================================================

-- Q11. Show each order with customer name, order date and status
SELECT customer.name, order.order_date, order.status
FROM order
JOIN customer ON order.customer_id = customer.id
ORDER BY order.order_date DESC;

-- Q12. Show all products purchased by customers from Singapore
SELECT DISTINCT product.name
FROM product
JOIN order_item ON product.id = order_item.product_id
JOIN order ON order_item.order_id = order.id
JOIN customer ON order.customer_id = customer.id
WHERE customer.country = 'Singapore';

-- Q13. Show the seller name and product name for every product
SELECT seller.name AS seller, product.name AS product
FROM product
JOIN product_seller ON product.id = product_seller.product_id
JOIN seller ON product_seller.seller_id = seller.id
ORDER BY seller.name;

-- Q14. Show the top rated seller (by average seller rating) and their country
SELECT name, country, rating
FROM seller
ORDER BY rating DESC
LIMIT 1;

-- Q15. For each completed order, show customer name, product name and quantity
SELECT customer.name, product.name, order_item.quantity
FROM order
JOIN customer ON order.customer_id = customer.id
JOIN order_item ON order.id = order_item.order_id
JOIN product ON order_item.product_id = product.id
WHERE order.status = 'completed';

-- ============================================================
-- SECTION 4: Subqueries
-- ============================================================

-- Q16. Show products that cost more than the average product price
SELECT name, price FROM product
WHERE price > (SELECT AVG(price) FROM product)
ORDER BY price DESC;

-- Q17. Show customers who have never placed an order
SELECT name FROM customer
WHERE id NOT IN (
    SELECT DISTINCT customer_id FROM order
);

-- Q18. Show the most purchased product in each category
SELECT category, name, total_sold
FROM (
    SELECT product.category, product.name,
           SUM(order_item.quantity) AS total_sold
    FROM product
    JOIN order_item ON product.id = order_item.product_id
    GROUP BY product.category, product.name
) AS sales
WHERE total_sold = (
    SELECT MAX(total_sold_inner)
    FROM (
        SELECT product.category AS cat,
               SUM(order_item.quantity) AS total_sold_inner
        FROM product
        JOIN order_item ON product.id = order_item.product_id
        GROUP BY product.category, product.name
    ) AS inner_sales
    WHERE inner_sales.cat = sales.category
);

-- Q19. Show customers from the same country as the highest rated seller
SELECT customer.name, customer.country
FROM customer
WHERE customer.country = (
    SELECT country FROM seller
    ORDER BY rating DESC
    LIMIT 1
);

-- Q20. Show products that have been reviewed by more than 100 customers
SELECT product.name, COUNT(review.id) AS review_count
FROM product
JOIN review ON product.id = review.product_id
GROUP BY product.name
HAVING COUNT(review.id) > 100
ORDER BY review_count DESC;
