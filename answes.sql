# NOTES:
# 1. SQL is not case-sensitive; SELECT, select, and SeLeCt are all the same.
#    But it is a best-practice to write are reserved words uppercase (SELECT instead of select)
# 2. Extra line breaks, tabs, and spaces are ignored by SQL
# 3. At the end of each qurey a semicolon (;) is mandatory (unless the last query in the file)
# 4. Comments in SQL start with either '#' or '--' followed by a space
 
 
-- ------------------------- Basic Queries -------------------------
-- 0. USE keyword
USE classicmodels;

-- 1. SELECT and FROM stratements
SELECT *
FROM customers;


-- 2. Column selection
SELECT customerNumber, contactFirstName, contactLastName
FROM customers;


-- 3. Alias
SELECT customerNumber AS `Customer ID`,
	   contactFirstName AS `First Name`,
       contactLastName AS `Last Name`
FROM customers;


-- 4. Arithmatic in SELECT statement
SELECT customerNumber AS `Customer ID`,
	   creditLimit / 10000 AS `Credit Score`
FROM customers;
# Note: Arithmatic Operations (ordered by priority):
# 		() Prioritize
# 		*  Multiplication
# 		/  Division
# 		+  Addition
# 		-  Subtraction 
# 		%  Reminder


-- 5. DISTINCT keyword (to discard repetitions)
SELECT DISTINCT state 
FROM customers;


-- 6. WHERE statement for conditioning and filtering
SELECT * 
FROM customers
WHERE country = 'USA';
# Note: Conditioning options: 
# 		=        for equality
# 		!= or <> for inequality
# 		<        for smaller
# 		> 	     for greater
# 		<=       for smaller or equal to
# 		>=       for greater of equal to


-- 7. Multiple conditioning
SELECT * 
FROM customers 
WHERE (state = 'CA' OR state = 'NY') AND creditLimit > 50000;
# Note: conditions with:
# 		()  -> prioritize
# 		AND -> logical and
# 		OR  -> logical or


-- 8. Date comparison
SELECT *
FROM orders
WHERE orderDate >= '2004-01-01';


-- 9. NOT operation
SELECT *
FROM orders
WHERE NOT status = 'Shipped';
# Note: Execution order of logical conditions (AND, OR, NOT, and parantesis) matters:
# 		() > NOT > AND > OR`
# Note: We can do arithmatic in WHERE statement as well 
# Note: Any condition that is writen by using OR operator can be writen by IN, but IN has the following benefits:
# 		IN has more options | IN executes faster than OR | Orders of conditions doesn't matter | Can contain another select statement




-- 10. Arithmatic in WHERE statement
SELECT *, creditLimit / 10000 AS creditScore
FROM customers
WHERE (creditLimit / 10000) > 8;


-- 11. IN operator
SELECT *
FROM customers
WHERE state IN ('CA', 'NY', 'Tokyo'); 
# Equivalent query without IN operator:
SELECT *
FROM customers
WHERE state = 'CA' OR state = 'NY' OR state = 'Tokyo';
# Note: Common mistake: WHERE state = 'CA' OR 'NY' OR 'Tokyo'
# Note: We can also use NOT IN


-- 12. NOT IN operator
SELECT *
FROM customers
WHERE state NOT IN ('CA', 'NY', 'Tokyo'); 
# Equivalent query without IN operator
SELECT *
FROM customers
WHERE state <> 'CA' AND state <> 'NY' AND state <> 'Tokyo';


-- 13. BETWEEN operator
SELECT *
FROM customers 
WHERE creditLimit NOT BETWEEN 80000 AND 120000;
# Equivalent query without using BETWEEN operator
SELECT *
FROM customers
WHERE creditLimit >= 80000 AND creditLimit <= 120000;
# Note: We can use NOT BETWEEN as well


-- 14. NOT BETWEEN operator
SELECT *
FROM customers 
WHERE creditLimit NOT BETWEEN 80000 AND 120000;
# Equivalent query without using BETWEEN operator
SELECT *
FROM customers 
WHERE creditLimit < 80000 OR creditLimit > 120000;


-- 15. LIKE operator
SELECT *
FROM customers
WHERE contactFirstName LIKE 'B%';
# Note: Like Options:
# 		% -> any number of characters
# 		_ -> single character
# Disadvantages of Using Wildcards:
# 		Takes longer to run
# 		Better to use other operators (if possible), like =, <>, <=, etc
# 		Risk of SQL injection attack

-- 16. LIKE operator 
SELECT *
FROM customers 
WHERE contactFirstName LIKE 'b__';
# Note: You can also use NOT LIKE


-- 17. NOT LIKE operator
SELECT *
FROM customers 
WHERE contactFirstName NOT LIKE '%c%' AND contactLastName NOT LIKE '%c%';
 
 
-- 18. REGEXP operator
SELECT *
FROM customers
WHERE contactLastName REGEXP '^fre|fer';
# Note: REGEXP operators
# 		^  -> begining of a string
# 		$  -> end of a string
# 		|  -> logical or
# 		[] -> any single character lister between bracket
# Note: In this lecture, we don't focus on regular expressions.


-- 19. IS NULL operator
SELECT *
FROM customers
WHERE postalCode IS NULL;


-- 20. IS NOT NULL operator
SELECT *
FROM customers
WHERE addressLine2 IS NOT NULL;


-- 21. ORDER BY statement
SELECT *
FROM customers
WHERE creditLimit > 40000
ORDER BY contactLastName;
# Note: WHERE and ORDER BY statements are optional but 
# 		the order of these statements matters: 
# 		SELECT => FROM => WHERE => ORDER BY


-- 22. ORDER BY statement (multiple column ordering)
SELECT contactFirstName, contactLastName, customerNumber
FROM customers
ORDER BY contactLastName, contactFirstName;
# Equivalent Query:
SELECT contactFirstName, contactLastName, customerNumber
FROM customers
ORDER BY 1, 2; 
# Note: 1 referes to column contactFirstName 
# 		2 referes to column contactLastName


-- 23. DESC option in ORDER BY statement
SELECT contactFirstName
FROM customers
ORDER BY creditLimit DESC;
# Note: if you create new column and set it an ailias,
#  		you can sort the entire table with the new column


-- 24. LIMIT clause
SELECT *
FROM customers
ORDER BY creditLimit DESC
LIMIT 10;


-- 25. LIMIT clause
SELECT *
FROM customers
ORDER BY creditLimit DESC
LIMIT 20, 10;
# Note: New statement ordering:
# 		SELECT => FROM => WHERE => ORDER BY => LIMIT


-- -------------------- Aggrigate Functions Intro --------------------
-- 26. COUNT() functions
SELECT COUNT(*)
FROM customers;

-- 27. MAX() function
SELECT MAX(creditLimit)
FROM customers;

-- 28. MIN() function
SELECT MIN(creditLimit)
FROM customers;

-- 29. AVG() function
SELECT AVG(creditLimit)
FROM customers;

-- 30. SUM() function
SELECT SUM(creditLimit)
FROM customers;

-- ------------------------- Joining Section -------------------------
-- -------------------------   INNER JOIN    -------------------------
-- 31. INNTER JOIN
SELECT orders.orderNumber, orders.status, customers.customerNumber, customers.contactFirstName, customers.contactLastName
FROM customers
INNER JOIN orders ON customers.customerNumber = orders.customerNumber
ORDER BY customerNumber;

# Equivalent Query (Abbriveation):
SELECT o.orderNumber, o.status, c.customerNumber, c.contactFirstName, c.contactLastName
FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
ORDER BY customerNumber;

# Equivalent Query (USING statement):
SELECT o.orderNumber, o.status, c.customerNumber, c.contactFirstName, c.contactLastName
FROM customers c
INNER JOIN orders o USING (customerNumber)
ORDER BY customerNumber;
# Note: USING statemnt only can be used in case both column names are the same
# Note: You also can join tables across different databases, 
# 		you only need to specify the database of each table, such as classicmodels.customers


-- 32. INNER JOIN (with conditioning)
SELECT o.orderNumber, o.status, c.customerNumber, c.contactFirstName, c.contactLastName
FROM customers c
INNER JOIN orders o USING(customerNumber)
WHERE status <> 'Shipped'
ORDER BY customerNumber;
# Note: New statement ordering:
# 		SELECT => FROM => INNER JOIN => WHERE => ORDER BY => LIMIT


-- 33. Self Inner Join
SELECT e.employeeNumber AS employeeNumber, 
	   CONCAT(e.firstName, ' ', e.lastName) AS employeeName, 
       e.jobTitle AS employeeJob,
       m.reportsTo AS managerNumber,
       CONCAT(m.firstName, ' ', m.lastName) AS managerName,
       m.jobTitle AS managerJob
FROM employees e
INNER JOIN employees m ON m.employeeNumber = e.reportsTo AND m.officeCode = e.officeCode;
# Note: In case of self join, you must specify different abbiveation 
#  		for each table, otherwise you'l get error 
#		(here 'e' referes to 'employee' and 'm' referes to 'manager')
# Note: In case of self join, all selected columns must be prefixed by its table
# Note: CONCAT() function can be used to concatenate two columns of type string
#		(you cannot concat strings with +)


-- 34. Joining Mutiple Tables
SELECT od.productCode, p.quantityInStock, p.buyPrice
FROM orders o
INNER JOIN orderdetails od USING (orderNumber)
INNER JOIN products p USING (productCode)
WHERE orderDate BETWEEN '2004-01-01' AND '2004-02-01';


-- 35. Compound Join Conditions
SELECT e.employeeNumber AS employeeNumber, 
	   CONCAT(e.firstName, ' ', e.lastName) AS employeeName, 
       e.jobTitle AS employeeJob,
       m.reportsTo AS managerNumber,
       CONCAT(m.firstName, ' ', m.lastName) AS managerName,
       m.jobTitle AS managerJob
FROM employees e
INNER JOIN employees m ON m.employeeNumber = e.reportsTo AND m.officeCode = e.officeCode;
# Note: Compound join conditions moslty use when we want
#       to join tables with composed column keys


-- 36. Implicit Join
SELECT o.orderNumber, o.status, c.customerNumber, c.contactFirstName, c.contactLastName
FROM customers c, orders o
WHERE o.customerNumber = c.customerNumber
ORDER BY customerNumber;
# Note: This form of joining tables is not recommended, because
# 		compound join conditions and joining mutiple tables
#		in this form, makes the query hard to read.


-- -------------------------   OUTTER JOIN    -------------------------
-- Inner join only gives us customers if and only if they have any order
-- What if we want all the customers, whethere or not they have any order
-- We should use OUTER JOIN
-- There are two types of OUTER JOINs:
--   1) LEFT OUTER JOIN: All records from the left table are returned,
--   	whether or not the join condition is true
-- 	 2) RIGHT OUTER JOIN: All records from the right table are returned,
-- 		whether no not the join condition is true
# NOTE: left table is the one that comes after FROM statement
# 		right table is the one that comes after the JOIN statement


-- 37. OUTER JOIN
SELECT c.customerNumber, c.contactFirstName, c.contactLastName 
FROM customers c
LEFT OUTER JOIN orders o USING (customerNumber)
WHERE orderNumber IS NULL; 
# NOTE: Even though you can convert a left outer join to right outer join,
# 		but it is recommended to always use left outer join, because in case
# 		of multiple join conditions it will become confusing to trace what happend.

# Equivalent Query: Using RIGHT OUTRT JOIN
SELECT c.customerNumber, c.contactFirstName, c.contactLastName
FROM orders o
RIGHT OUTER JOIN customers c USING (customerNumber)
WHERE orderNumber IS NULL;


-- 38. Joining Mutiple Tables (OUTER JOIN)
SELECT *
FROM products p
LEFT OUTER JOIN orderdetails od USING (productCode)
LEFT OUTER JOIN orders o USING (orderNumber)
WHERE o.orderNumber IS NULL;



-- 39. Joining Multiple Tables (OUTER JOIN)
SELECT p.productCode, p.productName
FROM products p
LEFT OUTER JOIN orderdetails od USING (productCode)
LEFT OUTER JOIN orders o USING (orderNumber)
WHERE o.orderDate >= '2003-07-01' AND o.orderDate <= '2003-12-30' AND o.status = 'Shipped';
# NOTE: INNER JOINs and OUTER JOINs can be simuntaliously used in a query.


-- 40. Self Outer Join 
SELECT e.employeeNumber AS employeeID,
	   CONCAT(e.firstname, ' ', e.lastname) AS employeeName,
       e.jobTitle
FROM employees e
LEFT OUTER JOIN employees m ON e.reportsTo = m.employeeNumber
WHERE e.reportsTo IS NULL;
# Note: New statement ordering:
# 		SELECT => FROM => INNER JOIN & OUTER JOIN => WHERE => ORDER BY => LIMIT


-- 41. Natural Join
SELECT e.employeeNumber, 
	   CONCAT(e.firstname, ' ', e.lastname) AS employeeName
FROM employees e
NATURAL JOIN offices o
WHERE city = 'Paris';
# Note: In case of using natural join, it is not required to specify the common 
# 		columns to join based on, it automatically join based on the most common 
# 		column. 
# Note: Even though it has a simpler syntax, it is not recommended.


-- 42. Cross Join
SELECT *
FROM customers c
CROSS JOIN orders o;

# Equivalent Query (Implicit Syntax):
SELECT *
FROM customers c, orders o;



-- 43. Union
SELECT *, 'Active' AS status
FROM orders
WHERE orders.orderDate >= '2005-01-01'
UNION
SELECT *, 'Archived' AS status
FROM orders
WHERE orders.orderDate < '2005-01-01';
# Note: The number of columns of two tables should be the same.
# Note: The columns of the resulting table is the same as the first table






-- 44. Inserting a Row to a Table
INSERT INTO customers
VALUES (1, 
		'amirvahedi18', 
        'Amir', 
        'Vahedi', 
        '09123456789', 
        'abc', 
        NULL, 
        'Tehran', 
        NULL, 
        DEFAULT, 
        'Iran', 
        DEFAULT, 
        DEFAULT);
# Note: For auto increament (AI) columns, we can use either explicit value or DEFAULT
# 		For nullable columns, we can use NULL, DEFAULT, or explicit values
# 		For detault value columns, we an use either explicit value or DEFAULT

# Equivaient Query
INSERT INTO customers (customerNumber, customerName, contactFirstName, contactLastName, phone, addressLine1, city, country) 
VALUES (2, 'amirvahedi', 'AMIR', 'VAHEDI', '091234656789', 'abc', 'Tehran', 'IRAN');


# To Insert Multiple Values:
INSERT INTO customers (customerNumber, customerName, contactFirstName, contactLastName, phone, addressLine1, city, country) 
VALUES (3, 'amirvahedi', 'AMIR', 'VAHEDI', '091234656789', 'abc', 'Tehran', 'IRAN'),
	   (4, 'john', 'A', 'B', '091234656789', 'abc', 'Tehran', 'IRAN'),
       (5, 'kim', 'C', 'D', '091234656789', 'abc', 'Tehran', 'IRAN');



-- 45. Inserting Hierarical Rows
INSERT INTO orders (orderNumber, orderDate, requiredDate, status, customerNumber)
VALUES (14, '2023-04-18', '2023-04-23', 'shipped', 1);

INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES (14, 'S10_1678', 2, 200, 3);
# NOTE: IF the ID column is auto-increamental (AI), then you can use a method called LAST_INSERT_ID() to 
# 		get the id of the last inserted record. (only available if AI is on)

-- 46. Creating a copy of a table
CREATE TABLE orders_archived AS 
SELECT * FROM orders;
# Note: In the copied table, we don't have a primay key and it is not auto incrimental
# Note: The second line of the above query is a sub-query, as a part of another query.

# Note: Temporary table is a table that is available only for the duration of a database session 
# 		or a transaction. They are typically used to store intermediate results that are granted
# 		during the execution of a complex query or stored procedure:
CREATE TEMPORARY TABLE orders_archived AS 
SELECT * FROM orders;

-- 47. Deleting rows and adding selected rows
DELETE FROM orders_archived 
WHERE orderNumber = '10101'; # require safe mode to be disabled

DELETE FROM orders_archived; # this will remove all records in the table

INSERT INTO orders_archived
	(SELECT *
	 FROM orders
	 WHERE orderDate < '2004-01-01');


-- 48. Creating table + Subquery
DROP TABLE IF EXISTS customer_payment;
CREATE TABLE customer_payment AS 
SELECT p.checkNumber, c.customerNumber, c.contactFirstName, c.contactLastName
FROM customers c
INNER JOIN payments p USING (customerNumber)
WHERE p.paymentDate < '2004-01-01';


-- 49. Update single row
UPDATE payments
SET amount = amount * 1.1
WHERE checkNumber = 'HQ336336';


-- 50. Update Multiple rows
UPDATE payments 
SET amount = amount * 1.1
WHERE checkNumber IN ('JM555205', 'GG31455', 'FD317790', 'NT141748', 'ID10962', 'HR182688');

-- 51. Update multiple rows
UPDATE orders 
SET requiredDate = DATE_ADD(requiredDate, INTERVAL 1 DAY)
WHERE status = 'Cancelled';


-- 52. Update table + Subqueries
UPDATE customers
SET creditLimit = creditLimit * 1.2
WHERE customerNumber = ( 
	SELECT customerNumber
	FROM customers
	INNER JOIN orders o USING (customerNumber)
	ORDER BY o.orderDate
	LIMIT 1
); -- >> Error

# Correct Query
UPDATE customers
SET creditLimit = creditLimit * 1.2
WHERE customerNumber = (
	SELECT customerNumber FROM (
		SELECT customerNumber 
        FROM customers 
        INNER JOIN orders o 
        USING (customerNumber) 
        ORDER BY o.orderDate 
        LIMIT 1
    ) AS t
);
# Note: If the subquery returns more than one value, you should use IN operator instead of =

SELECT creditLimit 
FROM customers 
WHERE customerNumber = (
	SELECT customerNumber 
    FROM customers 
    INNER JOIN orders o 
    USING (customerNumber) 
    ORDER BY o.orderDate LIMIT 1
);


-- 53. Upate Multiple Rows + Subqueries
UPDATE customers
SET creditLimit = creditLimit * 0.85
WHERE customerNumber IN (
	SELECT customerNumber 
    FROM (
		SELECT DISTINCT c.customerNumber 
		FROM customers c
		INNER JOIN orders o USING (customerNumber)
		WHERE o.status = 'Cancelled'
    ) AS t
);

SELECT customerNumber, creditLimit
FROM customers
WHERE customerNumber IN (
	SELECT DISTINCT c.customerNumber 
	FROM customers c
	INNER JOIN orders o USING (customerNumber)
	WHERE o.status = 'Cancelled'
);


-- 54. Aggrigate Functions + GROUP BY clause
SELECT orderNumber, customerNumber, SUM(quantityOrdered * priceEach) AS totalPrice 
FROM orders o
INNER JOIN orderdetails od USING (orderNumber)
GROUP BY orderNumber, customerNumber; 
# Note: Aggrigate funtions should be groupped by selected columns except the one 
# 		that it is aggregated, here both orderNumber and customerNumber columns.
# Note: New statement ordering:
# 		SELECT => FROM => INNER JOIN & OUTER JOIN => WHERE => GROUP BY => ORDER BY => LIMIT
# Note: If we want to apply any condition on the groupped columns, we cannot use WHERE caluse,
# 		because the grouping is not happend yet, So we have to use HAVING cluse after the 
# 		GROUP BY clause.




-- 55. Conditional Aggregate Function + GROUP BY clause
SELECT customerNumber, 
	   CONCAT(contactFirstName, contactLastName) AS fullName, 
       SUM(amount) AS totalPayments
FROM customers
INNER JOIN payments USING (customerNumber)
WHERE country = 'USA'
GROUP BY customerNumber, fullName
HAVING totalPayments > 100000;
# Note: With the WHERE clause we can filter data before rows are grouped,
# 		With the HAVING clause we can filter data after rows are grouped.
# Note: Columns that come after the HAVING clause should be among SELECTed columns, 
# 		but any column can be used with WHERE clause.
# Note: New statement ordering:
# 		SELECT => FROM => JOIN => WHERE => GROUP BY => HAVING => ORDER BY => LIMIT



-- 56. WITH ROLLUP
SELECT country, city, SUM(amount) AS totalSale
FROM customers c
INNER JOIN payments p USING (customerNumber)
GROUP BY country, city WITH ROLLUP;
# Note: In case of using ROLLUP operator, we cannot use a column ailias in a GROUP BY clause.
# Note: USE ROLLUP is MySQL-exlusive



-- 57. Nested Subqueries
SELECT customerNumber, 
	   CONCAT(contactFirstName, ' ', contactLastName) AS customerName,
       SUM(amount) AS totalPaid
FROM customers
INNER JOIN payments USING(customerNumber)
GROUP BY customerNumber, customerName
HAVING totalPaid > (
	SELECT AVG(totalPaid)
	FROM (
		SELECT SUM(amount) AS totalPaid
		FROM customers 
		INNER JOIN payments USING(customerNumber)
		GROUP BY customerNumber, customerName
	) AS t
);



-- 58. Using IN operator in subqueries
SELECT *
FROM products
WHERE productCode NOT IN (
	SELECT DISTINCT productCode
	FROM products p
	INNER JOIN orderdetails od USING (productCode)
);

# Equivalent Query 
SELECT *
FROM products
LEFT JOIN orderdetails USING(productCode)
WHERE orderNumber IS NULL;



-- 59. 
SELECT productCode, productName, SUM(quantityOrdered) AS quantitySold
FROM products p
INNER JOIN orderdetails od USING (productCode)
GROUP BY productCode, productName
ORDER BY quantitySold DESC;



-- 60. 
SELECT productCode, productName, SUM(quantityOrdered * priceEach) AS amountSold
FROM products p
INNER JOIN orderdetails od USING (productCode)
GROUP BY productCode, productName
ORDER BY amountSold DESC;




-- 61. 
SELECT customerNumber, CONCAT(contactFirstName, ' ', contactLastName) AS customerName
FROM customers
WHERE customerNumber IN (
	SELECT customerNumber
    FROM orders
    WHERE orderNumber IN (
		SELECT orderNumber
        FROM orderdetails
        WHERE productCode = 'S12_4473'
    )
)
ORDER BY customerNumber;



SELECT DISTINCT customerNumber, CONCAT(contactFirstName, ' ', contactLastName) AS customerName
FROM customers
INNER JOIN orders USING (customerNumber)
INNER JOIN orderdetails USING (orderNumber)
WHERE productCode = 'S12_4473'
ORDER BY customerNumber;





-- 62. ALL Keyword
SELECT *
FROM customers
WHERE creditLimit > (
	SELECT MAX(creditLimit)
    FROM customers
    WHERE country = 'USA'
);

# Equivalent Query 
SELECT *
FROM customers
WHERE creditLimit > ALL (
	SELECT creditLimit
    FROM customers
    WHERE country = 'USA'
);


-- 63. ANY Keyword
SELECT *
FROM customers
WHERE creditLimit > (
	SELECT MIN(creditLimit)
    FROM customers
    WHERE country = 'USA'
);

# Equivalent Query 
SELECT *
FROM customers
WHERE creditLimit > ANY (
	SELECT creditLimit
    FROM customers
    WHERE country = 'USA'
);


-- 64. 
SELECT customerNumber, CONCAT(contactFirstName, ' ',  contactLastName) AS customerName
FROM customers
WHERE customerNumber IN (
	SELECT customerNumber
	FROM payments
	GROUP BY customerNumber
	HAVING COUNT(*) >= 4
);


# Equivalent Query
SELECT customerNumber, CONCAT(contactFirstName, ' ', contactLastName) AS customerName
FROM customers
WHERE customerNumber = ANY (
	SELECT customerNumber
	FROM payments
	GROUP BY customerNumber
	HAVING COUNT(*) >= 4
);

# Equivalent Query
SELECT customerNumber, CONCAT(contactFirstName, ' ', contactLastName) AS customerName
FROM customers
INNER JOIN payments USING(customerNumber)
GROUP BY customerNumber
HAVING COUNT(*) >= 4;



-- 65. 
SELECT *
FROM products
WHERE productCode IN (
	SELECT productCode
	FROM orderdetails
	GROUP BY productCode
	HAVING COUNT(*) > 27
);

# Equivalent Query:
SELECT *
FROM products p 
WHERE productCode = ANY (
	SELECT productCode
	FROM orderdetails
	GROUP BY productCode
	HAVING COUNT(*) > 27
);


-- 66. EXISTS Keyword
SELECT *
FROM orders
WHERE customerNumber IN (
	SELECT customerNumber
    FROM customers
    INNER JOIN orders USING(customerNumber)
    WHERE country = 'USA'
);

# Note: If the result of subquery is too huge, 
# 		it is more efficient to use EXISTS keyword as follows:
# Equivalent Query:
SELECT *
FROM orders o
WHERE EXISTS (
	SELECT customerNumber
	FROM customers
	INNER JOIN orders USING (customerNumber)
	WHERE country = 'USA' AND o.customerNumber = customerNumber
);


-- 67. Subquery in the SELECT statement
SELECT *, 
		creditLimit - (
			SELECT AVG(creditLimit)
            FROM customers
            WHERE country = 'USA'
        ) AS differenceCreditLimit
FROM customers;


-- 68. Subquery in the FROM statement
SELECT *
FROM (
	SELECT customerNumber, 
		CONCAT(contactFirstName, contactLastName) AS customerName, 
		SUM(amount) AS totalPayment
	FROM customers
	INNER JOIN payments USING (customerNumber)
	GROUP BY customerNumber, customerName
) AS subTable
WHERE totalPayment < (
	SELECT AVG(totalPayment)
    FROM (
		SELECT SUM(amount) AS totalPayment
		FROM customers
		INNER JOIN payments USING (customerNumber)
		GROUP BY customerNumber
        ) AS subTable
);

# Equivalent Qeury:
SELECT customerNumber, SUM(amount) AS totalPaid
FROM customers
INNER JOIN payments USING(customerNumber)
GROUP BY customerNumber
HAVING totalPaid < (
	SELECT AVG(totalPaid)
	FROM (
		SELECT SUM(amount) AS totalPaid
		FROM customers
		INNER JOIN payments USING(customerNumber)
		GROUP BY customerNumber
	) AS T
)

# Equivalent (Simpler) Query:
SELECT customerNumber, SUM(amount) AS totalPayment
FROM customers 
INNER JOIN payments USING (customerNumber)
GROUP BY customerNumber
HAVING totalPayment < (
	SELECT AVG(totalPayment)
    FROM (
		SELECT SUM(amount) AS totalPayment
		FROM customers 
		INNER JOIN payments USING(customerNumber)
		GROUP BY customerNumber
        ) AS subTable
);

-- 69. Numeric Function: ROUND()
SELECT customerNumber, 
	   ROUND(creditLimit / (
			SELECT MAX(creditLimit) - MIN(creditLimit)
			FROM customers), 2)
FROM customers;


-- 70. Numeric Function: TRUNCATE()
SELECT customerNumber, 
	   TRUNCATE(creditLimit / (
			SELECT MAX(creditLimit) - MIN(creditLimit)
			FROM customers), 2)
FROM customers;
# Note: Other Numeric Functions:
# 		CEILING(column_name), FLOOR(column_name), ABS(column_name), ROND()


-- 71. String Functions: LENGTH():
SELECT customerNumber, LENGTH(addressLine1)
FROM customers;


-- 72, String Function: UPPER(), LOWER()
SELECT customerNumber, 
	   LOWER(contactFirstName) AS fristName, 
       UPPER(contactLastName) AS lastName
FROM customers;
# Note: Other String Functions:
# 		LTRIM(column_name), RTRIM(column_name), TRIM(column_name)
#		LEFT(column_name, length), RIGHT(column_name, length)
# 		SUBSTrinG(column_name, start_index, end_index)
# 		LOCATE(search_string, column)
# 		REPLACE(column, string_to_be_replaced, replacement_string)
# 		CONCAT(column1, column2)



-- 73. Date Functions:
SELECT NOW();
SELECT CURDATE(); # current date
SELECT CURTIME(); # current time
SELECT YEAR(NOW()); # current year
SELECT MONTH(NOW()); # current month in year
SELECT WEEK(NOW()); # current week in year
SELECT DAY(NOW()); # current day in month
SELECT HOUR(NOW()); # current hour in day
SELECT MINUTE(NOW()); # current minute in HOUR
SELECT SECOND(NOW()); # curren second in minute
SELECT DAYNAME(NOW()); # name of the current day
SELECT MONTHNAME(NOW()); # name of the current month
SELECT EXTRACT(YEAR FROM NOW());
SELECT DATE_FORMAT(NOW(), '%M %D %Y');
SELECT DATE_FORMAT(NOW(), '%m %d %y');
SELECT TIME_FORMAT(NOW(), '%H:%i %p');
SELECT TIME_FORMAT(NOW(), '%h:%i %p');
SELECT DATE_ADD(NOW(), INTERVAL 1 DAY); # tomarrow
SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR); # next year
SELECT DATE_SUB(NOW(), INTERVAL 1 DAY); # yestarday
SELECT DATE_ADD(NOW(), INTERVAL -1 DAY); # yesterday
SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR); # previous year
SELECT DATEDIFF(CURDATE(), '2004-01-01'); # different in days
SELECT TIME_TO_SEC(NOW());


-- 75. IFNULL()
SELECT customerNumber, 
	   addressLine1, 
       IFNULL(addressLine2, 'NotAssigned') AS addressLine2
FROM customers;


-- 76. COALESCE()
SELECT customerNumber, COALESCE(addressLine2, state, 'NotAssigned')
FROM customers;


-- 77. IF function
SELECT *, IF (orderDate < '2004-01-01', 'Archived', 'Active') AS dateStatus
FROM orders; 


-- 78. IF function
SELECT customerNumber, 
	   IF (COUNT(orderNumber) > 4, 'Vafadar', 'Mamoli') AS vafadari 
FROM customers
INNER JOIN orders USING(customerNumber)
GROUP BY customerNumber;



-- 79. CASE Operator
SELECT o.customerNumber, 
	   CASE 
			WHEN COUNT(orderNumber) > 10 THEN 'very_vafadar'
            WHEN COUNT(orderNumber) > 4 THEN 'vafadar'
            ELSE 'mamoli'
		END AS vafadari
FROM customers c
INNER JOIN orders o USING(customerNumber)
GROUP BY o.customerNumber;


-- 80. VIEWS
CREATE VIEW american_customers AS (
	SELECT *
	FROM customers
	WHERE country = 'USA'
);

SELECT *
FROM american_customers;


# NOTE: After creating a view you can use it like a table.
# NOTE: VIEWs are usually used like a variable, 
#		but they don't store any data, they refer to the 
# 		original table, any chnage in on a view will be 
# 		applied on the original table.
# NOTE: General query to create a view:
# 		CREATE VIEW <view_name> AS (<subquery>)	
# NOTE: Benefits of Views:
# 		1) Simplifying Queries (act as abstraction layer)
#		2) Reduce the impact of changes
# 		3) Restrict access to data
# 		4) More secure (than apply queries on the table itself)
# But don't apply views blindly in every case.

-- 81. DROP VIEW
DROP VIEW american_customers;


# NOTE: General query to drop a view:
#		DROP VIEW <view_name>




-- 82. VIEW
CREATE VIEW special_customers AS (
	SELECT *
	FROM customers c
	INNER JOIN orders o USING(customerNumber)
	INNER JOIN orderdetails od USING (orderNumber)
	WHERE quantityOrdered > 30 AND productCode = 'S10_4962'
);


-- 83. CREATE OR REPLACE VIEW 
CREATE OR REPLACE VIEW special_customers AS (
	SELECT * 
    FROM customers
    INNER JOIN orders USING(customerNumber)
    INNER JOIN orderdetails USING(orderNumber)
    WHERE quantityOrdered > 20 AND productCode = 'S12_3380'
);




-- 84. Updateable Views
# Updateable view is a view that we can use them in INSERT,
# UPDATE, or DELETE statement.
# A view should NOT contain any of the following statements to be 
# an updateable view:
# DISTINCT
# Aggrigate Functions
# GROUP BY / HAVING
# UNION



-- 85. Stored Procedure
# In your application you should not put your application code in the application code.
# Instead, you should take SQL code out of your application code and store it in a database 
# it blongs to. Store it in a stored procedure or function.

# Stored Procedure: A database object that contains a block of SQL code. We call this 
# procedure in our application code to get/store data.

# Benefits of Using Stored Procedure:
# 1. Store and organize SQL 
# 2. Faster Execution
# 3. Data Security (removing drict access to all tables)

# Creating a Stored Procedure:
DELIMITER $$
CREATE PROCEDURE get_customers()
BEGIN 
	SELECT *
    FROM customers;
END $$
DELIMITER ;

CALL get_customers();




-- 86. Dropping a Stored Procedure
DROP PROCEDURE get_customers;

# Note: Better approach to drop a stored procedure is as follow, without giving any error:
DROP PROCEDURE IF EXISTS get_customers;

# Note: To update a stored procedure:
DROP PROCEDURE IF EXISTS get_customers;
DELIMITER $$
CREATE PROCEDURE get_customers()
BEGIN
	SELECT *
    FROM customers;
END $$
DELIMITER ;



-- 87. Parameterized Stored Procedure:
DROP PROCEDURE IF EXISTS get_customers_by_country;
DELIMITER $$
CREATE PROCEDURE get_customers_by_country(country CHAR(15))
BEGIN
	SELECT * 
    FROM customers c
    WHERE c.country = country;
END $$
DELIMITER ;

CALL get_customers_by_country('USA');



-- 88. Default Value for Parameters
DROP PROCEDURE IF EXISTS get_customers_by_country;
DELIMITER $$
CREATE PROCEDURE get_customers_by_country(country CHAR(15))
BEGIN 
	IF country IS NULL THEN
		SELECT *
        FROM customers;
	ELSE 
		SELECT *
        FROM customers c
        WHERE c.country = country;
	END IF;
END $$
DELIMITER ;

CALL get_customers_by_country(NULL);
CALL get_customers_by_country('Japan');

# Equivalent Query:
DROP PROCEDURE IF EXISTS get_customers_by_country;
DELIMITER $$
CREATE PROCEDURE get_customers_by_country(country CHAR(15))
BEGIN 
	SELECT *
    FROM customers c
    WHERE c.country = IFNULL(country, c.country);
END $$
DELIMITER ;

CALL get_customers_by_country(NULL);
CALL get_customers_by_country('Japan');


-- 89. Default For Parameters
DROP PROCEDURE IF EXISTS get_customers_by_country;
DELIMITER $$
CREATE PROCEDURE get_customers_by_country(country CHAR(15))
BEGIN 
	IF country IS NULL THEN 
		SET country = 'USA';
	END IF;
    SELECT *
    FROM customers c
    WHERE c.country = country;
END $$
DELIMITER ;

CALL get_customers_by_country(NULL);
CALL get_customers_by_country('Japan');




-- 90. Stored Procedure
DROP PROCEDURE IF EXISTS get_orders;
DELIMITER $$
CREATE PROCEDURE get_orders(customerNumber INT, status_ VARCHAR(15))
BEGIN
	SELECT *
    FROM orders o 
    WHERE o.customerNumber = IFNULL(customerNumber, o.customerNumber) AND 
		  o.status = IFNULL(status_, o.status);
END $$

CALL get_orders(NULL, NULL);
CALL get_orders(177, NULL);
CALL get_orders(NULL, 'Shipped');
CALL get_orders(177, 'Shipped');



-- 91. Parameter Validation
DROP PROCEDURE IF EXISTS update_creditLimit;
DELIMITER $$ 
CREATE PROCEDURE update_creditLimit(customerNumber INT, creditLimit DECIMAL(10, 2))
BEGIN
	IF customerNumber NOT IN (SELECT c.customerNumber FROM customers c) THEN
		SIGNAL SQLSTATE '22003'
        SET MESSAGE_TEXT = 'Invalid customerNumber passed.';
	ELSE IF creditLimit < 0 THEN 
		SIGNAL SQLSTATE '22003'
        SET MESSAGE_TEXT = 'Invalid creditLimit passed.';
	END IF;
    END IF;
    UPDATE customers c
    SET c.creditLimit = creditLimit
    WHERE c.customerNumber = customerNumber;
END $$
DELIMITER ;

CALL update_creditLimit(177, 123); # without error
CALL update_creditLimit(177, -123); # error
CALL update_creditLimit(15555, 123); # error

SELECT *
FROM customers
WHERE customerNumber = 177;


-- 92. Output Parameters
DROP PROCEDURE IF EXISTS get_paied_customer;
DELIMITER $$
CREATE PROCEDURE get_paied_for_customer(
	customerNumber INT, 
    OUT n_payments INT, 
    OUT total_payments DECIMAL(10, 2)
)
BEGIN 
	SELECT COUNT(*), SUM(amount)
    INTO n_payments, total_payments
    FROM payments p
    WHERE p.customerNumber = customerNumber;
END $$
DELIMITER ;

SET @n_payments = 0; -- user-defined variables
SET @total_payments = 0; -- user-defined variables
CALL get_paied_for_customer(177, @n_payments, @total_payments);

SELECT @n_payments, @total_payments;
SELECT *
FROM payments
WHERE customerNumber = 177;

# Note: Output parameters make the script complex.



-- 93. Variables  
# There are two types of user variables: 
# 	1) User or session variable
#	2) Local variable (used in functions of stored procedures)
# Note: A variable cannot contain a table. Only a single value is allowd.

# To create a user or session variable:
SET @variable_name = 0;
# Note: Stay in memory for the entire session, until the connection will be lost
# Note: In case of using SET, you have to set it a value.


# To create a local variable (example):
DROP PROCEDURE IF EXISTS customers_with_score;
DELIMITER $$
CREATE PROCEDURE customers_with_score()
BEGIN	
	DECLARE score DECIMAL(10, 2) DEFAULT 0;
    DECLARE maxCreditLimit DECIMAL(10, 2);
    DECLARE minCreditLimit DECIMAL(10, 2);
    
    SET maxCreditLimit = (
		SELECT MAX(creditLimit)
        FROM customers 
	);
    
    SET minCreditLimit = (
		SELECT MIN(creditLimit)
        FROM customers 
    );
    
    SELECT *, creditLimit / (maxCreditLimit - minCreditLimit) AS score
    FROM customers;
END $$
DELIMITER ;

CALL customers_with_score();
# Note: In case of using DECLARE, you can ignore defining the variable.
# Note: If you don't set a defualt value for a local variable, it will be null
# Note: As soon as the stored porcedure or function is finished, the local variables
#		will be freed up.




-- 94. Variables
DROP PROCEDURE IF EXISTS get_average_payments;
DELIMITER $$
CREATE PROCEDURE get_average_payments(customerNumber INT)
BEGIN
	DECLARE total_payments DECIMAL(9, 2);
    DECLARE n_payments INT;
    
    SELECT COUNT(*), SUM(amount)
    INTO n_payments, total_payments
    FROM payments p
    WHERE p.customerNumber = customerNumber;
    
    SELECT total_payments / n_payments AS average_payments;
END $$
DELIMITER ;

CALL get_average_payments(189);



-- 95. Functions:
# Note: Main difference between a stored procedure and function is 
# 		the fact that s function can only return a single value, 
# 		but stored porcedure can return a table as well.
# Note: A function can be used in SELECT statement, like any other 
#		built-in SQL functions.
DROP FUNCTION IF EXISTS get_average_payments_func;
DELIMITER $$
CREATE FUNCTION get_average_payments_func(customerNumber INT) RETURNS DECIMAL(9, 2)
READS SQL DATA
BEGIN
	DECLARE n_payments INT;
    DECLARE total_payments DECIMAL(9, 2);
    DECLARE average DECIMAL(9, 2);
    
    SELECT COUNT(*), SUM(amount)
    INTO n_payments, total_payments
    FROM payments p
    WHERE p.customerNumber = customerNumber;
    
    SET average = (SELECT total_payments / n_payments);
RETURN average;
END $$
DELIMITER ;

SELECT customerNumber, 
	   CONCAT(contactFirstName, ' ', contactLastName) AS customerName,
       get_average_payments_func(customerNumber) AS averagePayments
FROM customers;

# Note: Syntax of function is very similar to stored procedure, with the following differences:
# 		1) Return type declaration: 'RETURN DECIMAL(9, 2)'
#		2) Attributes: 'DETERMINISTIC': if you give it the same input, it always return the same input.alter
#					   'READS SQL DATA': use SELECT statement in the function
#					   'MODIFIES SQL DATA': use INSERT, UPDATE, DELETE statements in the function
#		3) Return: a single value should be returned.



-- 96. Triggers
# Trigger: A block of SQL code that automatically gets executed before 
#		   or after an INSERT, UPDATE, or DELETE statements
# Note: Dropping Triggers is like dropping stored procedures or functions
# Note: In trigger, we are allowd to update any table except the table 
#		the trigger is defined on. (e.g., in the following example, payment cannot be updated)

DROP TRIGGER IF EXISTS updata_creditLimit_after_payment;
DELIMITER $$
CREATE TRIGGER update_creditLimit_after_payment
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
	UPDATE customers
    SET creditLimit = creditLimit + 0.1 * NEW.amount
    WHERE customerNumber = NEW.customerNumber;
END $$
DELIMITER ;

SELECT creditLimit
FROM customers 
WHERE customerNumber = 177; # 123.00

INSERT INTO payments
VALUES (177, 'JM556245', NOW(), 10000);

SELECT creditLimit
FROM customers 
WHERE customerNumber = 177; # 1123.00

# Note: Syntax of trigger is very similar to stored procedure, with the following differences:
# 		1) No curly brackets () required.
#		2) When to do insert: [BEFORE, AFTER] [INSERT, UPDATE, DELETE] ON <table_name>
#		3) FOR EACH ROW



-- 97. SHOW TRIGGERS
SHOW TRIGGERS;
SHOW TRIGGERS like 'payment%';



-- 98. Using Triggers For Auditing
# We can use triggers to log changes in a table.
# First, create a table to log:
CREATE TABLE payments_audit (
	customerNumber INT            NOT NULL,
    date           DATE           NOT NULL,
    amount         DECIMAL(9, 2)  NOT NULL,
    action_type    VARCHAR(50)    NOT NULL,
    action_date    DATETIME       NOT NULL
);

# Next, create a table:
DROP TRIGGER IF EXISTS updata_creditLimit_after_payment;
DELIMITER $$
CREATE TRIGGER updata_creditLimit_after_payment
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
	UPDATE customers
    SET creditLimit = creditLimit + 0.1 * NEW.amount
    WHERE customerNumber = NEW.customerNumber;
    
    INSERT INTO payments_audit
    VALUES (NEW.customerNumber, NEW.paymentDate, NEW.amount, 'Insert', NOW());
END $$
DELIMITER ;

SELECT creditLimit
FROM customers 
WHERE customerNumber = 177; # 1123.00

INSERT INTO payments
VALUES (177, 'JM559785', NOW(), 10000);

SELECT creditLimit
FROM customers 
WHERE customerNumber = 177; # 3123.00

SELECT * 
FROM payments_audit; # log added

# Note: If the action of the trigger is deleting (instead of update),
#		you should use ODL instead of NEW.
# Note: We don't create an audit table for each table and each action,
# 		We should have a general audit table.



-- 99. Triggers For Auditing
DROP TRIGGER IF EXISTS update_creditLimit_after_payment_delete;
DELIMITER $$
CREATE TRIGGER update_creditLimit_after_payment_delete
AFTER DELETE ON payments
FOR EACH ROW
BEGIN
	UPDATE customers
    SET creditLimit = creditLimit - 0.1 * OLD.amount
    WHERE customerNumber = OLD.customerNumber;
    
    INSERT INTO payments_audit
    VALUES (OLD.customerNumber, OLD.paymentDate, OLD.amount, 'Delete', NOW());
END $$
DELIMITER ;

SELECT creditLimit
FROM customers
WHERE customerNumber = 177; # 3123.0

DELETE FROM payments
WHERE checkNumber = 'JM559785';

SELECT creditLimit
FROM customers
WHERE customerNumber = 177; # 2123.0

SELECT *
FROM payments_audit;




-- 100. 
SHOW VARIABLES LIKE 'event%';
SET GLOBAL event_scheduler = ON;





-- 101. 
DROP EVENT IF EXISTS yearly_delete_audit_rows;
DELIMITER $$ 
CREATE EVENT yearly_delete_audit_rows
ON SCHEDULE 
EVERY 1 YEAR STARTS NOW() ENDS DATE_ADD(NOW(), INTERVAL 10 YEAR)
DO
BEGIN 
	DELETE FROM payment_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END $$
DELIMITER ;


-- 102. SHOW EVENTS
SHOW EVENTS;
SHOW EVENTS LIKE 'pattern';


-- 103. ALTER EVENT
DELIMITER $$ 
ALTER EVENT yearly_delete_audit_rows
ON SCHEDULE 
EVERY 6 MONTH STARTS NOW() ENDS DATE_ADD(NOW(), INTERVAL 10 YEAR)
DO
BEGIN 
	DELETE FROM payment_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END $$
DELIMITER ;


-- 104. ALTER EVENT (DISABLE/ENABLE)
ALTER EVENT yearly_delete_audit_rows DISABLE;
ALTER EVENT yearly_delete_audit_rows ENABLE;


-- 105. DROP EVENT
DROP EVENT IF EXISTS yearly_delete_audit_rows;



-- 106. TRANSACTION
# Definition: A group of SQL statement that reperesent a single uint if work.
# 			  Used when we want to do multiple chages to the database and we want 
#			  all changes to be successful or to fail together as a signle unit.
# Note: In a transaction, 
# 		if we encounter with an error: none of the statements take place
#		if we don't encounter with an error: all statements take place.
# Properites: ACID
# 			Atomicity
#			Consistancy
# 			Isolation
# 			Durability



-- 107. Creating Transactions
# General Structure:
# > START TRANSACTION;
# > QUERIES...
# > COMMIT; or ROLLBACK; 

# COMMIT: apply all changes if we didn't encounterd with any error
# ROLLBACK: roll back even if we didn't encounter with any error

# Note: MySQL automatically wraps any statement in a transaction,
# 		if it didn't have any error, it will commit the statement.
# 		To see whether this option is ON or OFF:
SHOW VARIABLES LIKE 'autocommit';
# 		To turn if off:
SET GLOBAL autocommit = OFF;
# 		To turn if on:
SET GLOBAL autocommit = ON;


START TRANSACTION;
INSERT INTO orders
VALUES (10500, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY), NULL, 'On Hold', NULL, 177);
INSERT INTO orderdetails
VALUES (10500, 'S10_4757', 100, 200, 3);
COMMIT;

SELECT *
FROM orders
WHERE orderNumber = 10500;

SELECT *
FROM orderdetails
WHERE orderNumber = 10500;


-- 108. Concurrency and Locking
# Multiple users want to access or modify the same data at the same time
# If multiple users want to modify a sigle row at the same time,
# by using transactions, SQL stop the second user who wants to modify 
# until the transaction of the first user is not commited.
# Most of the time, the default behavior works well, but sometime it is not
# enough and we need to overwrite the default behaior.

# Query of file script1.sql
START TRANSACTION;
UPDATE customers
SET creditLimit = creditLimit + 100
WHERE customerNumber = 177;
COMMIT;

# Query of file script2.sql
START TRANSACTION;
UPDATE customers
SET creditLimit = creditLimit + 100
WHERE customerNumber = 177;
COMMIT;

# Second transaction waits until the first transaction commit.


-- 109. Concurrency and Locking
# Query of file script1.sql
START TRANSACTION;
UPDATE customers
SET creditLimit = creditLimit + 100
WHERE customerNumber = 177;
COMMIT;

# Query of file script2.sql
START TRANSACTION;
UPDATE customers
SET creditLimit = creditLimit + 100
WHERE customerNumber = 188;
COMMIT;

# Both queries execute without one waiting for the other.



-- 110. Concurrency and Locking
# Query of file script1.sql
START TRANSACTION;
UPDATE customers
SET contactFirstName = 'Amir'
WHERE customerNumber = 177;
COMMIT;

# Query of file script2.sql
START TRANSACTION;
UPDATE customers
SET creditLimit = creditLimit + 100
WHERE customerNumber = 177;
COMMIT;


-- 111. Concurrency Problems (Lost Update)
# If transaction of user B commits last, we will lose the update 
# made by transaction of the user A.
# The transaction that commits last will overwrite the changes
# made earlier. To solve the problem, we use LUX. By using LUX, 
# second user is not allowed to make any change on the row that 
# first user is changing and not commited yet. 
# (MySQL take care of this problem by default)
# SOLUTION: LUX (default behavore)


-- 112. Concurrency Problems (Dirty Reads)
# When a transaction reads data that hasn't commited yet, 
# the read data is not valid yet. 
# SOLUTION: Set transaction isolation level to "READ COMMITED"





-- 113. Concurrency Problems (Non-repeating Reads)
# Getting different results for the same entry of during the
# execution of a query.
# SOLUTION: Set transaction isolation level to REPEATABLE READ
# NOTE: Defalut transaction isolation level is REPEATABLE READ





-- 114. Concurrency Problems (Phantom Reads)
# We want to include all records that satisfies the same
# condition, if during the process any of the records change,
# the result is not valid.
# SOLUTION: Based on the application, solution may change.
# 			If dropping one or two records is acceptable, do nothing, 
#			If we shouldn't neglect any record, set transaction isolation
# 			level to SERIALIZABLE. 
# 			By doing so, no two query execute at the same time. (no parallelism)



-- 115. Transaction Isolation Level
# TO handle the problems of concurrency, SQL offers a concept, Transaction Isolation Levels:
# 1) READ UNCOMMITED      
# 2) READ COMMITED         
# 3) REPEATABLE READS (default)   
# 4) SERIALIZABLE         
# Top to down: Better Protection
#			   Slower
#			   Fewer Concurrency Problems
# 			   More LUX
# 			   Less Scalablility
#			   Less Performance
# 			   Extra Resources
 
# NOTES:
# 		If and only if you want to prevent phantom reads, use SERIALIZABLE
# 		Use READ COMMITED or READ UNCOMMITED in situations where you 
# 		1) don't need precise consistancy 
#		2) when you are dealing with data that is rarely updated
# 		3) if you want to achive better performance

# To see the current isolation level:
SHOW VARIABLES LIKE 'transaction_isolation';

# To set isolation level (only for the next transaction):
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; # [or READ UNCOMMITED, READ COMMITED, SERIALIZABLE]

# To set isolation level (for all future transactions/current session/connectino)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

# To set isolation level for all sessions/connections:
SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;  

# NOTE: 
# + -> Concurrency Problem    
# - -> No Concurrency Problem
# 				     | Lost Update | Dirty Reads | Non-repeating Reads | Phantom Reads
# -------------------------------------------------------------------------------------		
# READ UNCOMMITED    |      +      |       +     |        +            |       +
# READ COMMITED      |      +      |       -     |        +            |       + 
# REPEATABLE READS   |      -      |       -     |        -            |       +
# SERIALIZABLE       |      -      |       -     |        -            |       -



-- 116. Dirty Read Solution
# Put the following script in new session (session#1):
USE classicmodels;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT creditLimit 
FROM customers 
WHERE customerNumber = 177;

# Put the following script on another session (session#2):
USE classicmodels;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
UPDATE customers
SET creditLimit = 100
WHERE customerNumber = 177;
COMMIT;

# If you call script in the session#1 before committing the transaction in the 
# session#2, you get the update value, which is not desired.
# To solve the problem, use READ COMMITED transaction isolation level, instead of 
# READ UMCOMMITED transaction isolation level.


-- 117. Non-repeating Read Solution
# Put the following script in new session (session#1):
USE classicmodels;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT * 
FROM customers
WHERE state = 'PA';
COMMIT;

# Put the following script on another session (session#2):
USE classicmodels;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
UPDATE customers
SET state = 'PA'
WHERE customerNumber = 187;
COMMIT;
 
# If you execute query in transaction of session#1 but not commit the transaction,
# then execute entire script in session#2, you will get different result if you execute
# query in transaction of the first session. 
# To solve the problem, set REPEATABLE READ transaction isolation level, instead of 
# READ COMMITED transaction isolation level.



-- 118. Phantom Reads Solution:
# Put the following script in new session (session#1):
USE classicmodels;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * 
FROM customers
WHERE state = 'PA';
COMMIT;


# Put the following script on another session (session#2):
USE classicmodels;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
UPDATE customers
SET state = 'PA'
WHERE customerNumber = 144;
COMMIT;
SELECT * FROM customers;

# If you execute first 6 lines of the frist session, you will able to execute the transaction of the second session, 
# if we want to prevent this from happening, we should set SERIALIZABLE transaction isolation level instead of REPEATABLE READ 



-- 119. Deadlock
# Problem: Different transactions cannot complete because each transaction holds a lock at other needs. 
# So, several transactions keep waiting for each other and none of them release their key.

# SQL Approach to Solve Deadlock: In case of deadlock, the transaction that led to the deadlock will be a victom and SQL
# will roll it back.

# NOTE: In general, they are not a big issue, unless they happen frequently.

# Minimizing Deadlock:
# 	1) Try not to have reverse update
# 	2) Keep your transaction small and short duration. 
# 	3) Executing queries that takes a long time to execute increase the possibility of deadlock,
#	   Try to schedule these time-consuming queries during non-pick hours, when the server has low load. 


-- 120. Reverse Update
# Problem: A kind of deadlock, which two (or more) sessions want to update same recordes in a reverse order.
# Example:
# In session#1:
USE classicmodels; # step#1
START TRANSACTION; # step#2
UPDATE customers SET creditLimit = 123 WHERE customerNumber = 177; # step#3
UPDATE customers SET state = 'NY' WHERE customerNumber = 144; # step#8 (deadlock will happen)
COMMIT;

# In session#2:
USE classicmodels; # step#4
START TRANSACTION; # step#5
UPDATE customers SET state = 'NY' WHERE customerNumber = 144; # step#6
UPDATE customers SET creditLimit = 123 WHERE customerNumber = 177; # step#7
COMMIT;

# If you execute in specified order, in the 8th step a deadlock will take place. 
 
 
-- 121. Data Types
# SQL has different data types:
# 	1) String Type
# 	2) Numeric Types
# 	3) Date and Time Types
# 	4) Blob Types (string binary types)
# 	5) Special Types (e.g., Storing Geometric or Geographical Values)

-- 122. String Data Types
# Fixed-length String (n chars):
# CHAR(n)

# Variable-length String (maximun of n chars):
# VARCHAR(n)

# Larger String Type:
# MEDIUMTEXT()

# Even Larger String Type:
# LONGTEXT()

# To store Small Strings:
# TINYTEXT()

# Another String Data Type:
# TEXT()

# NOTE: Numerical values like ZipCode or phone number are prefered to be stored as
# 		string type, because we don't want to do mathematical operations on them.

# NOTE: Maximum size of VARCHAR is about 64KB (65535 chars)
# 		Maximum size of MEDIUMTEXT is 16 MB (sutible for storing JSON, CSV string, book, so on)
# 		Maximum size of LONGTEXT is up to 4GB (sutible for log files or textbooks)
# 		Maximum size of TINYTEXT is up to 255 Bytes 
# 		Maximum size of TEXT is up to 64KB


-- 123. Integer Data Types
# TINYINT: 				1 Byte 	(from -128 to 127)
# UNSIGNED TINYINT: 	1 Byte 	(from 0 to 255)
# SMALLINT: 			2 Bytes (from ~-32K to ~32K)
# MEDIUMINT: 			3 Bytes (from ~-8M to ~8M)
# INT: 					4 Bytes (from ~-2B to ~2B)
# BIGING: 				8 Bytes (from ~-9Z to ~9Z)

# NOTE: Use the smallest integer data type possible



-- 124. Floating-point and Fixed-point Data Types
# Fixed Points: DECIMAL(precision, scale)
# 				precision is the maxinum number of digits (1 < precision < 65)
# 				scale is the number of digits after the decimal point

# Floating Point: FLOAT  4 Bytes
#       	      Double 8 Bytes 

# NOTE: Floating-point data types are sutible for very large or very small 
# 		fractional numbers, used for scienfific applications.


-- 125. Boolean Data Types
# To use boolean data typ, use BOOL or BOOLEAN data types, which only accept two values, true(1) or false(0)



-- 126. ENUM Data Type
# A data type that only accepts special values
# For example, ENUM('small', 'medium', 'large') only accepts three values: small, medium, or large
# NOTE: Try not to use them, because: 
# 		Changing the numbers of an ENUM type can be expensive, specially for large tables
# 		ENUMs are not reusable, i.e., we cannot use them in other tables. So changing in one place leads to chnage in multiple places.

# NOTE: Instead of using ENUMs, save an ID for any option of ENUM, then create a new table that contains name of any option for any ID.
# 		The separate table is usually called lookup table.


-- 127. SET Data Type
# A data type that can have multiple items
# For example, SET('value1', 'value2', ...)
# For the same reason of not useing ENUM, this data type is also not recommended to use. 
# Instead, use a lookup talbe.


-- 128. Date and Time Data Types
# DATE: 		Date Data Type
# TIME: 		Time Data Type
# DATETIME: 	Date and time (8 Bytes | can go beyond the year 2038)
# TIMESTAMP: 	Mostly used for last update or insertion time (4 Bytes | up to the year 2038)
# YEAR: 		Only year


-- 129. BLOB Data Type
# Mostly used for large amount of binary data, such as images, videos, pdfs, ...
# Types:
# 	TINYBLOB: 	Up to 255 Bytes
# 	BLOB: 		Up to 65 KB
# 	MEDIUMBLOB: Up to 16 MB
# 	LONGBLOB:   Up to 4GB

# NOTE: Using BLOB files can result in:
# 		Increase Database Size
# 		Slower Backup
# 		Performace Problem
# 		More Code to Read/Write Images

# NOTE: It is better to use your files out of your datebases, 
# 		because relational databases are designed to store 
# 		structured relational data, not large binary files.


-- 130. JSON Data Types
# JSON is a lightwaight format for storing and transforming data over the internet. 
# There is a data type in SQL for storing content of JSON files.



-- 131. Data Modeling
# Data Modeling: The process of modeling the data to store in database
# Steps:
# 	1) Understand and analyze the business requirements: Talk to business stackholders, domain experts, end users, so on
# 	2) Build a conceptual model: Identify identities, things, or concepts of the business and the relationship between them. (a way to communicate with stackholders | ER/EER diagrams, relational diagrams)
# 	3) Build a logical model: An abstact data model that is independent of database technologies (just tables and columns needed)
# 	4) Build a Phisical Model: Implementation of a logial model for a particular database technology (dealing with data types, default values, primary key, nullable, so on)


-- 132. Conceptual Models
# Conceptual model: A way to represent the entities, things, or concepts and their relationships
# 					Mostly used to understand the problem domain and communicate with stackholders and domain experts
# 					Must NOT contain any technical aspect of the model

# Two ways to visualize the entities:
# 	1) Entity-Relationship (ER) Diagrams
# 	2) Unified Modeling Language (UML)

# Modeling Tools: 
# 	1) Microsoft Visio
# 	2) drow.io
# 	3) LucidCharts


-- 133. Logical Models
# To specify the type of each attribute
# To specify the type of relationships between entities (one_to_one | one_to_many | many_to_many)
# To specify the primary key of any entity and relationship
# Try to have atomic attributes (firstName and lastName instead of fullName)

# Try to delete relational entities:
# There are two options for the primary key of a relation:
# 	1) A Composite key of primary keys of the entities in the relationship
# 	2) New primary key
# The choice depents on the model scenario,
# The first option has the advantage of not being able to add repeated record
# The first option has the disadvantage of redundancy in case of having three or more entities in the relationship


-- 134. Primary Key
# Definition: A primary key is the column or columns that contain values that uniquely identify each row in a table
# Composite Primary Key: Multiple columns as a primary key to uniquely identify each row, for example two foreign key as a primary key for a relationship (frequently used in relationships)
# Primary key can change, but it is not recommended to change a primary key. 
# Primary key shouldn't take a lot of space


-- 135. Foreign Key
# In a relationship we have parent (primary key table) and child (foreign key table). 
# The child should have primary key of its parent.
# Foreign keys prevents to have a child record without parent record.



-- 136. Foreign Key Constraints
# There are two events for foreign keys:
# 	1) ON UPDATE: what happen in the child table if a record of the parent table gets updated?
# 	2) ON DELETE: what happen in the child table if a record of the parent table gets deleted?

# There are four options for each of these events:
# 	1) NO ACTION
# 	2) SET NULL
# 	3) CASCASE
# 	4) RESTRICTED: reject the event from happening

# For update, we usually use CASCASE
# For delete, depends on the scenario, most of the time use RESTRICTED
# In case of RESTRICTED, we are not allowd to delete a record from the parent table, unless we have deleted the child record.


-- 137. Normalization
# Definition: The process of reviewing our design and ensuring that it follows a few predefined rules that prevents data duplication 
# 			  Normalization has 7 rules called 7 normal forms: Each rule assumes that you have applied previous rules.
# Notes: 
# 	1) Don't try to memorize normalization rules, just try to reduce redundancy
# 	2) Always try to design your database based on your business scenario.
# 	3) Don't start with creating tables, start with conceptual and logical models and create them based on requirements (not based on your assumption)
# 	4) Design based on today's problems/requirements, not future problems that may never happen
# 	5) Build a model based on your problem domain, not the real world.


-- 138. First Normal Form (1NF)
# 1NF: Each cell in a row should have a single value and a table cannot have repeated columns (atomic attributes)
# If we have a column that can accept multiple values, we should have another table, containing these values and the primary key of the original table as a foreign key 
# The secondary table has a many_to_many relationship with the original table. 


-- 139. Link Table
# In relational databases we don't have many_to_many relationship. To do so, we have to create a link table.
# The link table contains primary keys of all identities in the relationship as a foreign key and each identity in the 
# relationship has one_to_many relationship with the link table.


-- 140. Second Normal Form (2NF)
# 2NF: 1) The design should satisfy the first normal form (1NF)
# 	   2) Not have any non-pirme attribute that is dependent on any proper subset of any condidate key of the relationship.
# 		  On the other hand, A non-prime attribute of a relation is an attribute that is not part of any condidate key of the relation.
# 		  Simply, every table should describe one entity and every column of a table should describe one entity
# 		  If we are in such a situation that the 2NF is not satisfied, we should bring the attributes out and add it to another table.
# 	      Note that we shouldn't have any duplicate column.



-- 141. Third Normal Form (3NF)
# 3NF: 1) The design should satisfy the second normal form (2NF)
#	   2) All attributes in a table are determined only by the condidate keys of that relation and not by any non-prime attributes.
# 	      Simply, we shouldn't have redundant columns in which can be driven from other columns. 


-- 142. Synchronizing a Model with a Database
# To change the design of a database, there are two ways:
# 	1) Use design mode of each table: 
# 		This approach only works for databases controlled by a person
# 		For muli-client databases, any change should be replicated to other clients (consistancy)
# 	2) Use forward engineering 
# 		In case we don't have a database and we create a database based on a model.


-- 143. Reverse Engineering
# The process of creating a model based on the current database
# Used in case we want to change the database and we don't have its model.


-- 144. Creating a Database
CREATE DATABASE IF NOT EXISTS sample_database;


-- 145. Dropping a Database
DROP DATABASE IF EXISTS sample_database;


-- 146. Creating Tables
CREATE DATABASE IF NOT EXISTS supermarket;
USE supermarket;
DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS customers 
(
	customer_id 		INT 			PRIMARY KEY 	AUTO_INCREMENT,
    first_name 			VARCHAR(50)		NOT NULL,
    last_name 			VARCHAR(50) 	NOT NULL, 
    points 				INT				DEFAULT 0,
    email 				VARCHAR(255) 	NOT NULL
);
# NOTE: If you consider a column as a PRIMARY KEY, by detault it will be NOT NULL


-- 147. Altering Tables
ALTER TABLE customers
	ADD COLUMN 		birth_date		DATE 			NOT NULL 	AFTER last_name,
    ADD COLUMN 		city 			VARCHAR(50) 	NOT NULL 	AFTER email,
    MODIFY 			email 			VARCHAR(255) 	NOT NULL 	UNIQUE,
    DROP COLUMN points;


-- 148. Creating Relationships
DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders 
(
	order_id 		INT				PRIMARY KEY,
    customer_id 	INT				NOT NULL,
    FOREIGN KEY fk_orders_customers(customer_id) REFERENCES customers(customer_id) 
			ON UPDATE CASCADE 
            ON DELETE NO ACTION
);
# After executing the above query, we will not be able to delete
# the customers table, first you should delete orders table.


-- 149. Altering Primary Key and Foreign Key Constraints
# If you want to create a relationship after creating a table: 
ALTER TABLE orders
	ADD COLUMN description VARCHAR(255),
	ADD PRIMARY KEY (order_id),
    DROP PRIMARY KEY,
    DROP KEY fk_orders_customers,
    ADD FOREIGN KEY fk_orders_customers (customer_id) REFERENCES customers(customer_id)
		ON UPDATE CASCADE
        ON DELETE NO ACTION;













