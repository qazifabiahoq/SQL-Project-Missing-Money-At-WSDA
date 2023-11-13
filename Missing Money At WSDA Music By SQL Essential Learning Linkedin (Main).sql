-- Challenge 1: General queries
-- 1. How many transactions took place between the years 2011 and 2012?
SELECT COUNT(*)
FROM Invoice
WHERE InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31';

-- 2. How much money did WSDA Music make during the same period?
SELECT SUM(Total)
FROM Invoice
WHERE InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31';

-- Challenge 2: Targeted questions
-- 1. Get a list of customers who made purchases between 2011 and 2012.
SELECT c.FirstName, c.LastName, i.Total
FROM Invoice i
INNER JOIN Customer c ON i.CustomerId = c.CustomerId
WHERE InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
ORDER BY i.Total DESC;

-- 2. Get a list of customers, sales reps, and total transaction amounts for each customer between 2011 and 2012.
SELECT c.FirstName AS [Customer FN], c.LastName AS [Customer LN], e.FirstName AS [Employee FN], e.LastName AS [Employee LN], i.Total
FROM Invoice i
INNER JOIN Customer c ON i.CustomerId = c.CustomerId
INNER JOIN Employee e ON e.EmployeeId = c.SupportRepId
WHERE InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
ORDER BY i.Total DESC;

-- 3. How many transactions are above the average transaction amount during the same time period?
-- Find the average transaction amount between 2011 and 2012
SELECT ROUND(AVG(Total), 2) AS [Avg Transaction Amount]
FROM Invoice
WHERE InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31';

-- Get the number of transactions above the average transaction amount
SELECT COUNT(Total) AS [Num of Transactions Above Avg]
FROM Invoice
WHERE Total > (
    SELECT ROUND(AVG(Total), 2) AS [Avg Transaction Amount]
    FROM Invoice
    WHERE InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
)
AND InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31';

-- 4. What is the average transaction amount for each year that WSDA Music has been in business?
SELECT ROUND(AVG(Total), 2) AS [Avg Transaction Amount], STRFTIME('%Y', InvoiceDate) AS [Year]
FROM Invoice
GROUP BY STRFTIME('%Y', InvoiceDate);

-- Challenge 3: In-depth analysis
-- 1. Get a list of employees who exceeded the average transaction amount from sales they generated during 2011 and 2012.
SELECT e.FirstName, e.LastName, SUM(i.Total) AS [Total Sales]
FROM Invoice i
INNER JOIN Customer c ON i.CustomerId = c.CustomerId
INNER JOIN Employee e ON e.EmployeeId = c.SupportRepId
WHERE InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31' AND i.Total > 11.66
GROUP BY e.FirstName, e.LastName
ORDER BY e.LastName;

-- 2. Create a Commission Payout column that displays each employee’s commission based on 15% of the sales transaction amount.
SELECT e.FirstName, e.LastName, SUM(i.Total) AS [Total Sales], ROUND(SUM(i.Total) * 0.15, 2) AS [Commission Payout]
FROM Invoice i
INNER JOIN Customer c ON i.CustomerId = c.CustomerId
INNER JOIN Employee e ON e.EmployeeId = c.SupportRepId
WHERE InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
GROUP BY e.FirstName, e.LastName
ORDER BY e.LastName;

-- 3. Which employee made the highest commission?
-- Jane Peacock $106.21

-- 4. List the customers that Jane Peacock supported.
SELECT c.FirstName AS [Customer FN], c.LastName AS [Customer LN], e.FirstName AS [Employee FN], e.LastName AS [Employee LN], SUM(i.Total) AS [Total Sales], ROUND(SUM(i.Total) * 0.15, 2) AS [Commission Payout]
FROM Invoice i
INNER JOIN Customer c ON i.CustomerId = c.CustomerId
INNER JOIN Employee e ON e.EmployeeId = c.SupportRepId
WHERE InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31' AND e.LastName = 'Peacock'
GROUP BY c.FirstName, c.LastName, e.FirstName, e.LastName
ORDER BY [Total Sales] DESC;

-- 5. Which customer made the highest purchase?
-- John Doein

-- 6. Take a look at this customer record—does it look suspicious?
SELECT *
FROM Customer c
WHERE c.LastName = 'Doein';

-- 7. Who do you conclude is our primary person of interest?
-- Jane Peacock
