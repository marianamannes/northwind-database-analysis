SELECT COUNT(DISTINCT(ProductID)) AS "Number of products"
FROM dbo.Products;

SELECT COUNT(DISTINCT(CategoryID)) AS "Number of categories"
FROM dbo.Products;

SELECT c.CategoryName AS "Category",
	ROUND((SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)) / 
		(SELECT SUM(UnitPrice * Quantity * (1 - Discount)) FROM dbo.OrderDetails))*100,2) AS "% of Revenue"
FROM dbo.OrderDetails o
INNER JOIN dbo.Products p
ON o.ProductID = p.ProductID
INNER JOIN dbo.Categories c
ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY 2 DESC;

SELECT c.CategoryName AS "Category",
	ROUND((SUM(CAST(o.Quantity AS float)) /
		(SELECT SUM(Quantity) FROM dbo.OrderDetails))*100,2) AS "% of Quantity"
FROM dbo.OrderDetails o
INNER JOIN dbo.Products p
ON o.ProductID = p.ProductID
INNER JOIN dbo.Categories c
ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY 2 DESC;

SELECT c.CategoryName AS "Category",
	AVG(o.UnitPrice) AS "Avg. Price"
FROM dbo.OrderDetails o
INNER JOIN dbo.Products p
ON o.ProductID = p.ProductID
INNER JOIN dbo.Categories c
ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY 2 DESC;

SELECT TOP 5 p.ProductName AS Product,
	ROUND(SUM((o.UnitPrice * o.Quantity * (1 -o.Discount))),2) AS "Revenue"
FROM dbo.OrderDetails o
INNER JOIN dbo.Products p
ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY 2 DESC;

SELECT TOP 5 p.ProductName AS Product,
	SUM(o.Quantity) AS "Quantity"
FROM dbo.OrderDetails o
INNER JOIN dbo.Products p
ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY 2 DESC;

SELECT c.CategoryName AS "Category",
	ROUND(AVG(o.Discount)*100,2) AS "Avg. Discount (%)"
FROM dbo.OrderDetails o
INNER JOIN dbo.Products p
ON o.ProductID = p.ProductID
INNER JOIN dbo.Categories c
ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY 2 DESC;

SELECT TOP 5 p.ProductName AS "Product",
	ROUND(AVG(o.Discount)*100,2) AS "Avg. Discount (%)"
FROM dbo.OrderDetails o
INNER JOIN dbo.Products p
ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY 2 DESC;

SELECT c.CategoryName AS "Category",
	COUNT(DISTINCT(p.ProductID)) AS "Number of products"
FROM dbo.Products p
INNER JOIN dbo.Categories c
ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY 2 DESC;