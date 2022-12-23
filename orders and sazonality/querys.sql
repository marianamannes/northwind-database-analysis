SELECT MIN(OrderDate) AS "Min Date",
	MAX(OrderDate) AS "Max Date"
FROM dbo.Orders;

SELECT Month(o.OrderDate) AS "Month",
	ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) AS "Revenue",
	SUM(d.Quantity) AS "Quantity"
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails d
ON o.OrderID = d.OrderID
WHERE Year(o.OrderDate) = 1997
GROUP BY Month(o.OrderDate)
ORDER BY 2 DESC;

SELECT Year(o.OrderDate) AS "Year",
	ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)) / COUNT(d.OrderID),2) AS "Avg Revenue by order"
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails d
ON o.OrderID = d.OrderID
GROUP BY Year(o.OrderDate)
ORDER BY 2 DESC;

SELECT DATENAME(WEEKDAY, o.OrderDate) AS "Day of the week",
	ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) AS "Revenue",
	SUM(d.Quantity) AS "Quantity"
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails d
ON o.OrderID = d.OrderID
WHERE Year(o.OrderDate) = 1997
GROUP BY DATENAME(WEEKDAY, o.OrderDate)
ORDER BY 2 DESC;

SELECT Month(OrderDate) AS "Month",
	COUNT(DISTINCT(OrderID)) AS "Shipped late"
FROM dbo.Orders
WHERE Year(OrderDate) = 1997 AND (ShippedDate > RequiredDate)
GROUP BY Month(OrderDate) 
ORDER BY 2 DESC;

SELECT Month(o.OrderDate) AS "Month",
	ROUND(AVG(d.Discount)*100,2) AS "Discount (%)"
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails d
ON o.OrderID = d.OrderID
WHERE Year(o.OrderDate) = 1997 
GROUP BY Month(o.OrderDate) 
ORDER BY 2 DESC;

WITH cte_table AS(
SELECT Month(o.OrderDate) AS "Month",
	c.CategoryName AS "Category",
	ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) AS "Revenue",
	RANK() over (Partition BY Month(o.OrderDate) ORDER BY ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) DESC) AS "Rank"
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails d
ON o.OrderID = d.OrderID
INNER JOIN dbo.Products p
ON d.ProductID = p.ProductID
INNER JOIN dbo.Categories c
ON p.CategoryID = c.CategoryID
WHERE Year(o.OrderDate) = 1997
GROUP BY Month(o.OrderDate), c.CategoryName)
SELECT Month,
	Category 
FROM cte_table
WHERE Rank = 1;

WITH cte_table AS(
SELECT Month(o.OrderDate) AS "Month",
	p.ProductName AS "Product",
	ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) AS "Revenue",
	RANK() over (Partition BY Month(o.OrderDate) ORDER BY ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) DESC) AS "Rank"
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails d
ON o.OrderID = d.OrderID
INNER JOIN dbo.Products p
ON d.ProductID = p.ProductID
WHERE Year(o.OrderDate) = 1997
GROUP BY Month(o.OrderDate), p.ProductName)
SELECT Month,
	Product 
FROM cte_table
WHERE Rank = 1;

WITH cte_table AS(
SELECT Month(o.OrderDate) AS "Month",
	o.ShipCountry AS "Country",
	ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) AS "Revenue",
	RANK() over (Partition BY Month(o.OrderDate) ORDER BY ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) DESC) AS "Rank"
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails d
ON o.OrderID = d.OrderID
INNER JOIN dbo.Products p
ON d.ProductID = p.ProductID
WHERE Year(o.OrderDate) = 1997
GROUP BY Month(o.OrderDate), o.ShipCountry)
SELECT Month,
	Country 
FROM cte_table
WHERE Rank = 1;



