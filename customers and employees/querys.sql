SELECT COUNT(DISTINCT(CustomerID)) AS "Customers",
	COUNT(DISTINCT(Country)) AS "Countries"
FROM dbo.Customers;

SELECT c.Country,
	COUNT(DISTINCT(c.CustomerID)) AS "Customers",
	ROUND(SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)),2) AS "Revenue"
FROM dbo.Customers c
INNER JOIN dbo.Orders d
ON c.CustomerID = d.CustomerID
INNER JOIN dbo.OrderDetails o
ON d.OrderID = o.OrderID
GROUP BY c.Country
ORDER BY 2 DESC;

SELECT c.ContactTitle AS "Title",
	COUNT(DISTINCT(c.CustomerID)) AS "Customers",
	ROUND(SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)),2) AS "Revenue"
FROM dbo.Customers c
INNER JOIN dbo.Orders d
ON c.CustomerID = d.CustomerID
INNER JOIN dbo.OrderDetails o
ON d.OrderID = o.OrderID
GROUP BY c.ContactTitle
ORDER BY 3 DESC;

SELECT TOP 5 c.CompanyName AS "Company",
	ROUND(SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)),2) AS "Revenue"
FROM dbo.Customers c
INNER JOIN dbo.Orders d
ON c.CustomerID = d.CustomerID
INNER JOIN dbo.OrderDetails o
ON d.OrderID = o.OrderID
GROUP BY c.CompanyName
ORDER BY 2 DESC;

SELECT TOP 5 c.CompanyName AS "Company",
	ROUND(AVG(o.Discount)*100,2) AS "Discount"
FROM dbo.Customers c
INNER JOIN dbo.Orders d
ON c.CustomerID = d.CustomerID
INNER JOIN dbo.OrderDetails o
ON d.OrderID = o.OrderID
GROUP BY c.CompanyName
ORDER BY 2 DESC;

SELECT COUNT(DISTINCT(EmployeeID)) AS "Employees"
FROM dbo.Employees;

SELECT e.Title AS "Title",
	ROUND(SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)) / 
		(SELECT SUM(UnitPrice * Quantity * (1 - Discount)) FROM dbo.OrderDetails)*100,2) AS "% of Revenue"
FROM dbo.Employees e
INNER JOIN dbo.Orders d
ON e.EmployeeID = d.EmployeeID
INNER JOIN dbo.OrderDetails o
ON d.OrderID = o.OrderID
GROUP BY e.Title
ORDER BY 2 DESC;

SELECT e.FirstName AS "Name",
	CAST(e.HireDate AS DATE) AS "Hire Date",
	ROUND(SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)) / 
		(SELECT SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)) 
		FROM dbo.Employees e
		INNER JOIN dbo.Orders d
		ON e.EmployeeID = d.EmployeeID
		INNER JOIN dbo.OrderDetails o
		ON d.OrderID = o.OrderID
		WHERE e.Title = 'Sales Representative')*100,2) AS "% of Revenue"
FROM dbo.Employees e
INNER JOIN dbo.Orders d
ON e.EmployeeID = d.EmployeeID
INNER JOIN dbo.OrderDetails o
ON d.OrderID = o.OrderID
WHERE e.Title = 'Sales Representative'
GROUP BY e.FirstName, e.HireDate
ORDER BY 3 DESC;

