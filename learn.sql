-- USE
USE sql_store; 

-- SELECT, the order of from where order by is matter
/*
SELECT customer_id, first_name  
-- FROM customers
-- WHERE customer_id = 1
-- ORDER BY first_name

-- SELECT *   retrieve all columns using an asterisk
*/

-- SELECT Clause
/*
SELECT                  
	last_name,
    first_name,
    points,
    (points + 10) * 100 AS discount_factor -- having space could use 'discount factor'
FROM customers
ORDER BY discount_factor

-- SELECT DISTINCT  could remove duplicate item
SELECT DISTINCT name, unit_price, unit_price *1.1 AS new_price
FROM products
*/


-- WHERE Clause
/*
SELECT *
FROM orders
-- WHERE points > 3000   
-- WHERE state <> 'VA'  
WHERE order_date >= '2018-01-01' AND  order_date < '2019-01-01'  

-- operation > >= < <= = 
-- not eqial:  != <> 
-- time use ''  ex. '1990-01-01'
*/


-- AND  OR  NOT
/*
SELECT *
FROM order_items
where order_id = 6 AND unit_price * quantity > 30
-- NOT
-- AND
-- OR
*/

-- in
/*
SELECT * 
FROM customers
WHERE state NOT IN ('VA', 'GA', 'FL')      
-- WHERE state = 'VA' OR state = 'GA' OR state = 'FL'

-- exercise
SELECT *
FROM products
WHERE quantity_in_stock IN (49,38,72)
*/

-- BETWEEN
/*
SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01'  
-- WHERE birth_date >= '1990-01-01' AND birth_date <= '2000-01-01'
*/

-- LIKE
/*
SELECT *
FROM customers
WHERE (address LIKE '%TRAIL%' OR address LIKE '%AVENUE%')
	AND phone LIKE '%0'
-- % any number of characters
-- _ single character
*/

-- REGEXP
/*
SELECT *
FROM customers
 WHERE first_name REGEXP '^ELKA$|^AMBUR$' 
-- ^ beginning
-- $ end
-- | logical or
-- [abcd] choose from a,b,c,d
-- [a-d] choose from a,b,c,d

-- exercise
-- WHERE last_name REGEXP 'EY$|ON$|^MY|SE'
-- WHERE last_name REGEXP 'MY|SE'
-- WHERE last_name REGEXP 'B[R|U]'
*/

-- IS NULL
/*
SELECT *
FROM orders
WHERE shipper_id IS NULL
-- WHERE shipper_id IS NOT NULL
*/

-- ORDER BY
/*
SELECT last_name, address, points, 120 * 2 AS orders
FROM customers
ORDER BY state DESC, points, orders DESC 
-- ORDER BY state DESC, 3, 4 DESC  same as upon. AVOID!!!!

-- exercise
SELECT * 
FROM order_items
WHERE order_id = 2
ORDER BY quantity * unit_price DESC
*/

-- LIMIT
/*
SELECT * 
FROM customers
ORDER BY points DESC
LIMIT 3
-- LIMIT 7, 4  means from 8 count 4. output 8,9,10,11 positons
-- LIMIT always at the last place 
*/

-- --------------------------------------------------------------------------------------------
-- JOIN
-- --------------------------------------------------------------------------------------------

-- inner joins
/*
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
JOIN customers ON o.customer_id = customers.customer_id
-- SELECT customer_id cause fault, orders.customer_id would be fine 
-- FROM orders o  use o to represent orders
-- INNER JOIN  

-- exercise 
SELECT order_id, oi.product_id, quantity, oi.unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
*/

-- Joing Across Databases
/*
SELECT *
FROM order_items oi
JOIN sql_inventory.products p
	ON oi.product_id = p.product_id
-- sql_inventory choose from inventory
*/

-- Self Join
/*
SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM sql_hr.employees e
JOIN sql_hr.employees m       -- use different alias
	ON e.reports_to = m.employee_id
*/

-- Joing Multiple Tables
/*
SELECT 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name AS status
FROM sql_store.orders o
JOIN sql_store.customers c
	ON o.customer_id = c.customer_id
JOIN sql_store.order_statuses os
	ON o.status = os.order_status_id

-- exercise
SELECT 
	p.payment_id,
    p.date,
    c.name,
    p.amount,
    i.invoice_total,
    pm.name AS payment_method
FROM sql_invoicing.payments p
JOIN sql_invoicing.clients c
	ON p.client_id = c.client_id
JOIN sql_invoicing.invoices i 
	ON p.invoice_id = i.invoice_id
JOIN sql_invoicing.payment_methods pm
	ON p.payment_method = pm.payment_method_id
*/

-- Compound Join Conditions
/*
SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id
*/

-- Implicit Join Syntax
/*
SELECT *
FROM order_items oi, order_item_notes oin
WHERE oi.order_id = oin.order_id 
-- suggest not to use
*/

-- Outer Joins
/*
SELECT
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
-- JOIN orders o             -- only where it has an order
LEFT JOIN orders o
-- LEFT and RIGHT JOIN: below right join works the same as above left join
-- FROM orders o
-- RIGHT JOIN customers c    
-- RIGHT OUT JOIN   OUT is optional
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id

-- exercise
SELECT 
	p.product_id,
    name,
    quantity
FROM products p
LEFT JOIN order_items oi 
	ON p.product_id = oi.product_id
ORDER BY p.product_id
*/

-- Outer Joins Between Multiple Tables
/*
SELECT 
	order_date,
    o.order_id,
    c.first_name,
    s.name AS shipper,
    os.name AS status
FROM orders o
LEFT JOIN shippers s
	ON o.shipper_id = s.shipper_id
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY o.status
*/

-- Self Outer Joins
/*
SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM sql_hr.employees e
-- for self Joins, it dosen't have information about manager herself
-- JOIN sql_hr.employees m       -- use different alias
--  	ON e.reports_to = m.employee_id
LEFT JOIN sql_hr.employees m       -- use different alias
	ON e.reports_to = m.employee_id
*/

-- USING 
/*
SELECT *
FROM order_items oi
JOIN order_item_notes oin
	USING (order_id, product_id)
-- compound join example is kind of messy, use using for same purpose
-- 	ON oi.order_id = oin.order_id
--    AND oi.product_id = oin.product_id

-- exercise
SELECT 
	date,
    c.name AS client,
    amount,
    pm.name
FROM sql_invoicing.payments p
JOIN sql_invoicing.payment_methods pm
	ON p.payment_method = pm.payment_method_id
JOIN sql_invoicing.clients c USING (client_id)
*/

-- Natural Joins
/*
-- not recommandate, as natrual joins join two table by columns with same id not control
 SELECT o.order_id, c.first_name
 FROM orders o
 NATURAL JOIN customers c
*/

-- Cross Joins
/*
SELECT *
FROM customers c, products p
-- explicit syntax
-- FROM customers c
-- CROSS JOIN products p
ORDER BY c.first_name

-- exercise
-- explicit
SELECT *
FROM shippers
CROSS JOIN products
-- implicit
SELECT *
FROM shippers, products
*/

-- Unions
/*
SELECT order_id, order_date, 'Active' AS status 
FROM orders 
WHERE order_date >= '2019-01-01'
UNION
SELECT order_id, order_date, 'Archived' AS status
FROM orders 
WHERE order_date < '2019-01-01'

SELECT name AS full_name  -- use first select as name
FROM shippers
UNION
SELECT first_name 
FROM customers

-- exercise
SELECT 
	customer_id, 
    first_name, 
    points,
    'Bronze' AS type
FROM customers 
WHERE points < 2000
UNION
SELECT 
	customer_id, 
    first_name, 
    points,
    'silver' 
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT 
	customer_id, 
    first_name, 
    points,
    'Gold' 
FROM customers
WHERE points >= 3000
ORDER BY first_name
*/



-- --------------------------------------------------------------------------------------------
-- insert data
-- --------------------------------------------------------------------------------------------


-- Column Attributes
/*
cloumn  
datatype:  VARCHAR(50) means maximum 50  CHAR(50) will refill all 50 -- waste
PK: primary key  uniquely identify
NN: not null  can expect null value or not, select when every column have this data
AI: auto increment use with pk
default 
*/

-- Inserting a Single Row
/*
INSERT INTO customers
VALUES (
	DEFAULT,
    'Henry',
    'Zhang',
    NULL,
    NULL,
    'Adress',
    'City',
    'CA',
    DEFAULT
)

INSERT INTO customers (
	address,
    city,
    state,
    last_name,
    first_name,
    points
)
VALUES (
	'Adress',
    'City',
    'CA',
    'Zhang',
    'Henry',
    520
)
*/

-- Inserting Multiple Rows
/*
INSERT INTO shippers (name)
VALUES ('shipper1'),
	   ('shipper2'),
       ('shipper3')
       
-- exercise
INSERT INTO products
VALUES 
	(DEFAULT, 'p1', 20, 9.21),
    (DEFAULT, 'p2', 30, 5.20),
    (DEFAULT, 'p3', 40, 3.56)
*/

-- Inserting Hierarchical Rows
/*
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2002-05-20', 1);

INSERT INTO order_items 
VALUES (LAST_INSERT_ID(), 1, 20, 3.68),
	   (LAST_INSERT_ID(), 2, 20, 4.68)
*/

-- Creating a Copy of a Table
/*
CREATE TABLE orders_copy AS
SELECT * FROM orders
-- clear data  truncate data

INSERT INTO orders_copy
SELECT *
FROM orders
WHERE order_date < '2019-01-01'

-- exercise
CREATE TABLE sql_invoicing.invoice_archieve AS
SELECT 
	i.invoice_id,
    c.name AS client_id,
    invoice_total,
    payment_date
FROM sql_invoicing.invoices i
JOIN sql_invoicing.clients c 
	ON i.client_id = c.client_id
WHERE i.payment_date IS NOT NULL
*/

-- Updating a Single Row
/*
UPDATE sql_invoicing.invoices i
SET i.payment_total = i.invoice_total * 0.5,
	i.payment_date = i.due_date
WHERE i.invoice_id = 3
*/

-- Updating Multiple Rows
/*
UPDATE customers
SET points = points+50
WHERE birth_date < '1990-01-01'
*/

-- Using Subqueries in Updates
/*
UPDATE sql_invoicing.invoices_new i
SET
	i.payment_total = i.invoice_total *0.5,
    i.payment_date = i.due_date
WHERE i.client_id IN
	(SELECT c.client_id
	 FROM sql_invoicing.clients c
     WHERE state IN ('CA', 'CN'))

-- exercise
UPDATE orders
SET comments = 'gold customer'
WHERE customer_id IN
	(SELECT customer_id
    FROM customers
    WHERE points >= 3000)
*/

-- Deleting Rows
/*
-- careful use, no where statement would delete all datas
DELETE FROM invoices
WHERE client_id IN
	(SELECT client_id
	 FROM clients
     WHERE state IN ('CA', 'CN'))
*/

-- Restoring Course Databases
/*
-- reopen the file, and work it
*/

