#Orders Table
#You are given a table orders (id, product_name, order_date) filled with data. 
#Consider that the payment for an order must be accomplished within 3 days after the order date. 
#Also the delivery date is up to 1 month. 
#Write a query to show each product's name, order date, pay and deliver due dates. 
#Submit your query statements as Prepare DB & run queries.
SELECT * FROM `orders`;

SELECT 
    `product_name` AS 'Product Name',
    `order_date` AS 'Order Date',
    ADDDATE(`order_date`, INTERVAL 3 DAY) AS `Pay Due`,
    ADDDATE(`order_date`, INTERVAL 1 MONTH) AS `Delivery Due`
FROM
    `orders`;

