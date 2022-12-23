# Customers and Employees

🔹 Northwind Traders has 91 costumers, from 21 different countries.

```sql
SELECT COUNT(DISTINCT(CustomerID)) AS "Customers",
	COUNT(DISTINCT(Country)) AS "Countries"
FROM dbo.Customers;
```

|Customers|Countries|
|-----|-----|
|91|21|

🔹 Most part of costumers are from the USA, Germany and France. The ones that bring more revenue to the company are the USA, Germany and Austria.

```sql
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
```

|Country|Customers|Revenue|
|-----|-----|-----|
|USA|13|245584,61|
|Germany|11|230284,63|
|France|10|81358,32|
|Brazil|9|106925,78|
|UK|7|58971,31|
|Mexico|5|23582,08|
|Spain|4|17983,2|
|Venezuela|4|56810,63|
|Italy|3|15770,15|
|Canada|3|50196,29|
|Argentina|3|8119,1|
|Austria|2|128003,84|
|Belgium|2|33824,85|
|Denmark|2|32661,02|
|Finland|2|18810,05|
|Sweden|2|54495,14|
|Switzerland|2|31692,66|
|Portugal|2|11472,36|
|Norway|1|5735,15|
|Poland|1|3531,95|
|Irelan|1|49979,91|

🔹 The main positions of the clients by number are Sales Representative, Owner and Marketing Manager. But the main positions by revenue are Accounting Manager, Sales Manager and Sales Representative.

```sql
SELECT c.ContactTitle AS "Title",
	COUNT(DISTINCT(c.CustomerID)) AS "Customers",
	ROUND(SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)),2) AS "Revenue"
FROM dbo.Customers c
INNER JOIN dbo.Orders d
ON c.CustomerID = d.CustomerID
INNER JOIN dbo.OrderDetails o
ON d.OrderID = o.OrderID
GROUP BY c.ContactTitle
ORDER BY 2 DESC
```

|Title|Customers|Revenue|
|-----|-----|-----|
|Sales Representative|17|225453,32|
|Owner|16|175953,26|
|Marketing Manager|12|92049,75|
|Sales Manager|11|228377,28|
|Accounting Manager|9|229346,46|
|Sales Associate|7|102381,61|
|Marketing Assistant|6|66209,18|
|Sales Agent|5|38954,54|
|Assistant Sales Agent|2|24117,7|
|Order Administrator|2|28690,79|
|Assistant Sales Representative|1|51097,8|
|Owner/Marketing Assistant|1|3161,35|

🔹 These are the top 5 companies by revenue.

```sql
SELECT TOP 5 c.CompanyName AS "Company",
	ROUND(SUM(o.UnitPrice * o.Quantity * (1 - o.Discount)),2) AS "Revenue"
FROM dbo.Customers c
INNER JOIN dbo.Orders d
ON c.CustomerID = d.CustomerID
INNER JOIN dbo.OrderDetails o
ON d.OrderID = o.OrderID
GROUP BY c.CompanyName
ORDER BY 2 DESC;
```

|Company|Revenue|
|-----|-----|
|QUICK-Stop|110277,3|
|Ernst Handel|104874,98|
|Save-a-lot Markets|104361,95|
|Rattlesnake Canyon Grocery|51097,8|
|Hungry Owl All-Night Grocers|49979,91|

🔹 Only 1 of the top 5 companies with more discount is also a top 5 company by revenue: Hungry Owl All-Night Grocers.

```sql
SELECT TOP 5 c.CompanyName AS "Company",
	ROUND(AVG(o.Discount)*100,2) AS "Discount"
FROM dbo.Customers c
INNER JOIN dbo.Orders d
ON c.CustomerID = d.CustomerID
INNER JOIN dbo.OrderDetails o
ON d.OrderID = o.OrderID
GROUP BY c.CompanyName
ORDER BY 2 DESC;
```

|Company|Discount|
|-----|-----|
|Simons bistro|14|
|La maison d'Asie|12,58|
|Bólido Comidas preparadas|11,67|
|Hungry Owl All-Night Grocers|11,36|
|Let's Stop N Shop|11|

🔹Northwind Traders has 9 employees.

```sql
SELECT COUNT(DISTINCT(EmployeeID)) AS "Employees"
FROM dbo.Employees;
```

|Employees|
|-----|
|9|

🔹 More than 70% of the revenue comes from the Sales Representative position. The other titles represent less than 15% of the total revenue.

```sql
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
```

|Title|% of Revenue|
|-----|-----|
|Sales Representative|71,39|
|Vice President, Sales|13,16|
|Inside Sales Coordinator|10,02|
|Sales Manager|5,43|

🔹 Among Sales Representatives, Margaret, Janet and Nancy accounted more than 20% of the revenue, who are also the employees who have been working the longest for the company. Michael, on the other hand, was hired in the same year of Margaret, and is the last employee in the ranking by revenue.

```sql
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
```

|Name|Hire Date|% of Revenue|
|-----|-----|-----|
|Margaret|1993-05-03|25,77|
|Janet|1992-04-01|22,44|
|Nancy|1992-05-01|21,26|
|Robert|1994-01-02|13,79|
|Anne|1994-11-15|8,56|
|Michael|1993-10-17|8,18|