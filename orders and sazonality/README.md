# Orders and Sazonality Analysis

🔹 The time period of the data set is July 4, 1996 to May 6, 1998.

```sql
SELECT MIN(OrderDate) AS "Min Date",
	MAX(OrderDate) AS "Max Date"
FROM dbo.Orders;
```

|Min Date|Max Date|
|-----|-----|
|1996-07-04 00:00:00.000|1998-05-06 00:00:00.000|

🔹 Filtering only the year of 1997, the best sellers months are December, October and January. It seems like the end of the year and the first month of the year are good periods for the business. After February, however, sales start to decline.

```sql
SELECT Month(o.OrderDate) AS "Month",
	ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) AS "Revenue",
	SUM(d.Quantity) AS "Quantity"
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails d
ON o.OrderID = d.OrderID
WHERE Year(o.OrderDate) = 1997
GROUP BY Month(o.OrderDate)
ORDER BY 2 DESC;
```

|Month|Revenue|Quantity|
|-----|-----|-----|
|12|71398,43|2682|
|10|66749,23|2679|
|1|61258,07|2401|
|9|55629,24|2343|
|5|53781,29|2164|
|4|53032,95|1912|
|7|51020,86|2054|
|8|47287,67|1861|
|11|43533,81|1856|
|3|38547,22|1770|
|2|38483,63|2132|
|6|36362,8|1635|

🔹 In the data available, the year of 1998 had the highest average revenue by order, and the year of 1996 the lowest. But that can be due the different months available in each year.

```sql
SELECT Year(o.OrderDate) AS "Year",
	ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)) / COUNT(d.OrderID),2) AS "Avg Revenue by order"
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails d
ON o.OrderID = d.OrderID
GROUP BY Year(o.OrderDate)
ORDER BY 2 DESC;
```

|Year|Avg Revenue by order|
|-----|-----|
|1998|637,66|
|1997|582,71|
|1996|513,79|

🔹 The best days in terms of revenue are at the end of the week: Thursday and Friday. It seems that there are no sales on weekends.

```sql
SELECT DATENAME(WEEKDAY, o.OrderDate) AS "Day of the week",
	ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) AS "Revenue",
	SUM(d.Quantity) AS "Quantity"
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails d
ON o.OrderID = d.OrderID
WHERE Year(o.OrderDate) = 1997
GROUP BY DATENAME(WEEKDAY, o.OrderDate)
ORDER BY 2 DESC;
```

|Day of the week|Revenue|Quantity|
|-----|-----|-----|
|Thursday|127683,21|4887|
|Friday|123932,08|5155|
|Monday|123279,18|5021|
|Wednesday|121158,16|5313|
|Tuesday|121032,57|5113|

🔹 Some orders are shipped after the required date. Grouping by month, it looks like it happens more often in the months with more orders.

```
SELECT Month(OrderDate) AS "Month",
	COUNT(DISTINCT(OrderID)) AS "Shipped late"
FROM dbo.Orders
WHERE Year(OrderDate) = 1997 AND (ShippedDate > RequiredDate)
GROUP BY Month(OrderDate) 
ORDER BY 2 DESC;
```

|Month|Shipped late|
|-----|-----|
|9|3|
|11|3|
|12|3|
|7|2|
|10|2|
|5|2|
|1|2|
|2|2|
|3|1|
|4|1|
|6|1|

🔹 Still filtering only the year of 1997, the months with the biggest discounts are December, February and January.

```sql
SELECT Month(o.OrderDate) AS "Month",
	ROUND(AVG(d.Discount)*100,2) AS "Discount (%)"
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails d
ON o.OrderID = d.OrderID
WHERE Year(o.OrderDate) = 1997 
GROUP BY Month(o.OrderDate) 
ORDER BY 2 DESC;
```

|Month|Discount (%)|
|-----|-----|
|12|7,46|
|2|7,03|
|1|6,53|
|7|6,49|
|9|6,11|
|10|5,85|
|8|5,77|
|6|5,53|
|5|5,26|
|4|5,12|
|11|4,83|
|3|4,74|

🔹 There is no clear trend of top selling categories per month. In the months of January, March and May, the highlight is Beverages. In February, October and December it's Meat/Poultry, and in April it's Confections. For June, July, September and November it is Dairy Products, and only August has Seafood as the highest revenue category.

```sql
WITH cte_table AS(
SELECT Month(o.OrderDate) AS "Month",
	c.CategoryName AS "Category",
	ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) AS "Revenue",
	RANK() OVER (Partition BY Month(o.OrderDate) 
		ORDER BY ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) DESC) AS "Rank"
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
```

|Month|Category|
|-----|-----|
|1|Beverages|
|2|Meat/Poultry|
|3|Beverages|
|4|Confections|
|5|Beverages|
|6|Dairy Products|
|7|Dairy Products|
|8|Seafood|
|9|Dairy Products|
|10|Meat/Poultry|
|11|Dairy Products|
|12|Meat/Poultry|

🔹 There is also no clear trend of top-selling products by month, but Raclette Courdavault is the only product to appear in three different months as the top product.

```sql
WITH cte_table AS(
SELECT Month(o.OrderDate) AS "Month",
	p.ProductName AS "Product",
	ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) AS "Revenue",
	RANK() OVER (Partition BY Month(o.OrderDate) 
		ORDER BY ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) DESC) AS "Rank"
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
```

|Month|Product|
|-----|-----|
|1|Côte de Blaye|
|2|Pâté chinois|
|3|Raclette Courdavault|
|4|Gnocchi di nonna Alice|
|5|Côte de Blaye|
|6|Manjimup Dried Apples|
|7|Raclette Courdavault|
|8|Carnarvon Tigers|
|9|Thüringer Rostbratwurst|
|10|Thüringer Rostbratwurst|
|11|Raclette Courdavault|
|12|Manjimup Dried Apples|

🔹 The country that generates the most revenue for the company is Germany. However, the top billing position varies from month to month. The United States appears 6 times, while Germany appears 3 times, and Canada, Brazil and Austria appear once in the top countries.

```sql
WITH cte_table AS(
SELECT Month(o.OrderDate) AS "Month",
	o.ShipCountry AS "Country",
	ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) AS "Revenue",
	RANK() OVER (Partition BY Month(o.OrderDate) 
		ORDER BY ROUND(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) DESC) AS "Rank"
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
```

|Month|Country|
|-----|-----|
|1|Canada|
|2|USA|
|3|USA|
|4|Germany|
|5|Germany|
|6|USA|
|7|USA|
|8|Brazil|
|9|USA|
|10|Germany|
|11|USA|
|12|Austria|