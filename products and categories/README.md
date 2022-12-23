# Products and Categories Analysis

🔹 There is a total of 77 products offered by Northwind Traders.

```sql
SELECT COUNT(DISTINCT(ProductID)) AS "Number of products"
FROM dbo.Products;
```

|Number of products|
|-----|
|77|

🔹There are 8 categories.

```sql
SELECT COUNT(DISTINCT(CategoryID)) AS "Number of categories"
FROM dbo.Products;
```

|Number of categories|
|-----|
|8|


🔹 Most part of the revenue comes from the categories Beverages (21,16%) and Dairy Products (18,53%). The categories Produce (7,9%) and Grains/Cereals (7,56%) are the ones with less revenue after discounts.

```sql
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
```

|Category|% of Revenue|
|-----|-----|
|Beverages|21,16|
|Dairy Products|18,53|
|Confections|13,22|
|Meat/Poultry|12,88|
|Seafood|10,37|
|Condiments|8,38|
|Produce|7,9|
|Grains/Cereals|7,56|

🔹 When analysing by quantity, the results of percentage by category are similar. The category Meat/Poultry however fell from position 4 in revenue to position 7 in quantity, which may mean that it has a higher average selling price.

```sql
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
```

|Category|% of Quantity|
|-----|-----|
|Beverages|18,57|
|Dairy Products|17,83|
|Confections|15,41|
|Seafood|14,97|
|Condiments|10,32|
|Grains/Cereals|8,89|
|Meat/Poultry|8,18|
|Produce|5,83|

🔹 With the query below, we can confirm that the category Meat/Poultry is in fact the one with the highest average price.

```sql
SELECT c.CategoryName AS "Category",
	AVG(o.UnitPrice) AS "Avg. Price"
FROM dbo.OrderDetails o
INNER JOIN dbo.Products p
ON o.ProductID = p.ProductID
INNER JOIN dbo.Categories c
ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY 2 DESC;
```

|Category|Avg. Price|
|-----|-----|
|Meat/Poultry|42,8747|
|Produce|35,1944|
|Beverages|29,2367|
|Dairy Products|26,983|
|Confections|22,6026|
|Condiments|21,3208|
|Grains/Cereals|21,2464|
|Seafood|19,0629|

🔹 The top products by revenue after discounts are:

```sql
SELECT TOP 5 p.ProductName AS Product,
	ROUND(SUM((o.UnitPrice * o.Quantity * (1 -o.Discount))),2) AS "Revenue"
FROM dbo.OrderDetails o
INNER JOIN dbo.Products p
ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY 2 DESC;
```

|Product|Revenue|
|-----|-----|
|Côte de Blaye|141396,74|
|Thüringer Rostbratwurst|80368,67|
|Raclette Courdavault|71155,7|
|Tarte au sucre|47234,97|
|Camembert Pierrot|46825,48|

🔹 And the top products by quantity:

```sql
SELECT TOP 5 p.ProductName AS Product,
	SUM(o.Quantity) AS "Quantity"
FROM dbo.OrderDetails o
INNER JOIN dbo.Products p
ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY 2 DESC;
```

|Product|Quantity|
|-----|-----|
|Camembert Pierrot|1577|
|Raclette Courdavault|1496|
|Gorgonzola Telino|1397|
|Gnocchi di nonna Alice|1263|
|Pavlova|1158|

🔹 One relevant question may be if the top categories are the ones with the highests discounts. The query below shows that only the category Beverages is at the same time one of the top 3 most discounted categories and also one of the top 3 most sold. However, it is possible to notice that the categories with the lowest discount are also the least sold.

```sql
SELECT c.CategoryName AS "Category",
	ROUND(AVG(o.Discount)*100,2) AS "Avg. Discount (%)"
FROM dbo.OrderDetails o
INNER JOIN dbo.Products p
ON o.ProductID = p.ProductID
INNER JOIN dbo.Categories c
ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY 2 DESC;
```

|Category|Avg. Discount (%)|
|-----|-----|
|Meat/Poultry|6,45|
|Beverages|6,19|
|Seafood|6,02|
|Confections|5,69|
|Dairy Products|5,34|
|Condiments|5,26|
|Produce|4,54|
|Grains/Cereals|4,53|

🔹 Expanding this analysis to the product level, it is possible to see which products have the biggest discounts. With a greater margin over competitors, it may be interesting to focus on them in marketing campaigns.

```sql
SELECT TOP 5 p.ProductName AS "Product",
	ROUND(AVG(o.Discount)*100,2) AS "Avg. Discount (%)"
FROM dbo.OrderDetails o
INNER JOIN dbo.Products p
ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY 2 DESC;
```

|Product|Avg. Discount (%)|
|-----|-----|
|Chocolade|10,83|
|Chang|10,23|
|Escargots de Bourgogne|10|
|Mishi Kobe Niku|10|
|NuNuCa Nuß-Nougat-Creme|8,61|

🔹 It may also be relevant to check the number of products in each category. A greater amount of available products may be generating a greater amount of sales in the top categories.

```sql
SELECT c.CategoryName AS "Category",
	COUNT(DISTINCT(p.ProductID)) AS "Number of products"
FROM dbo.Products p
INNER JOIN dbo.Categories c
ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY 2 DESC;
```

|Category|Number of products|
|-----|-----|
|Confections|13|
|Beverages|12|
|Condiments|12|
|Seafood|12|
|Dairy Products|10|
|Grains/Cereals|7|
|Meat/Poultry|6|
|Produce|5|