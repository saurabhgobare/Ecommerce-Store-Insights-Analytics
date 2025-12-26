/*
Section: 1.General Sales Insights
Tool: SQL Server
*/

--1.1. What is the total revenue generated over the entire period? 

SELECT SUM(P.PRICE*OD.QUANTITY) AS TOTAL_REVENUE
FROM ORDERDETAILS OD JOIN   PRODUCTS P 
ON P.ProductID=OD.ProductID;

--1.2. Revenue Excluding Returned Orders 
SELECT SUM(P.PRICE*OD.QUANTITY) AS TOTAL_REVENUE
FROM PRODUCTS P JOIN ORDERDETAILS OD 
ON P.ProductID=OD.ProductID
JOIN Orders O ON OD.OrderID=O.OrderID
WHERE O.IsReturned=;

--1.3. Total Revenue per Year / Month 
SELECT SUM(P.PRICE*OD.QUANTITY) AS TOTAL_REVENUE,
YEAR(O.OrderDate) AS 'YEAR',MONTH(O.OrderDate) AS 'MONTH'
FROM PRODUCTS P JOIN ORDERDETAILS OD 
ON P.ProductID=OD.ProductID
JOIN Orders O ON OD.OrderID=O.OrderID
GROUP BY YEAR(O.OrderDate),MONTH(O.OrderDate)
ORDER BY YEAR(O.OrderDate),MONTH(O.OrderDate);


--1.4. Revenue by Product / Category 
SELECT SUM(P.PRICE*OD.QUANTITY) AS TOTAL_REVENUE,
P.ProductName as 'product',p.Category as 'category'
FROM PRODUCTS P JOIN ORDERDETAILS OD 
ON P.ProductID=OD.ProductID
group by p.ProductName,p.Category
order by p.Category,SUM(P.PRICE*OD.QUANTITY) desc;

--1.5. What is the average order value (AOV) across all orders? 
select avg(total_revenue) as average_order_value
from (select o.orderid,sum(P.price*OD.quantity) AS total_revenue 
		from Orders o join OrderDetails od on o.OrderID=od.OrderID
		join Products p on od.ProductID=p.ProductID
		group by o.OrderID) as t

--1.6. AOV per Year / Month 
select avg(total_revenue),YEAR(t.OrderDate),month(t.OrderDate) from 
(select o.Orderid,o.OrderDate,sum(P.PRICE*OD.QUANTITY) as total_revenue
from orders o join OrderDetails od on o.Orderid=od.OrderID
join Products p on od.ProductID=p.ProductID
group by o.Orderid,o.OrderDate) t
group by YEAR(t.OrderDate),month(t.OrderDate)
order by YEAR(t.OrderDate),month(t.OrderDate);


--1.7. What is the average order size by region? 
select r.RegionName as regionname,avg(t.Total_order) as avg_aorder from 
(select od.orderid,c.regionid,sum(od.Quantity) as Total_order from orderdetails od join Orders o 
on od.OrderID=o.orderid
join Customers c on c.CustomerID=o.CustomerID
group by od.orderid,c.regionid) t
join Regions r on t.RegionID=r.RegionID
group by r.RegionName
order by avg_aorder desc;



/*
Section: 2.Customer Insights
Tool: SQL Server
*/

--2.1. Who are the top 10 customers by total revenue spent? 
SELECT top(10) c.CustomerName,SUM(P.PRICE*OD.QUANTITY)  AS TOTAL_REVENUE 
FROM ORDERDETAILS OD JOIN   PRODUCTS P 
ON P.ProductID=OD.ProductID
join orders o on od.OrderID=o.OrderID
join Customers c on o.CustomerID=c.CustomerID
group by c.CustomerName
order by TOTAL_REVENUE desc ;

--2.2. What is the repeat customer rate? 
select 
    cast(count(distinct case when order_count > 1 then customerid end) as decimal(10,2))
    / count(distinct customerid) as repeat_customer_rate
from (
    select customerid, count(orderid) as order_count 
    from orders 
    group by customerid
) as t;


--2.3. What is the average time between two consecutive orders for the same customer Region-wise?  

with rankedorders as (select o.customerid,o.orderid,c.regionid,o.orderdate,
ROW_NUMBER() over(partition by o.customerid order by o.orderdate) as rn
from Orders o join Customers c on o.CustomerID=c.CustomerID),

orderpairs as (select curr.customerid,curr.regionid,DATEDIFF( day,prev.orderdate,curr.orderdate) as daysbetween
from rankedorders curr join
rankedorders prev on curr.customerid=prev.customerid and curr.rn=prev.rn + 1),

region as(select customerid,regionname,daysbetween 
from orderpairs op 
join regions r on r.regionid=op.regionid)

select regionname,avg(daysbetween) as avgdaysbetween 
from region 
group by regionname
order by avgdaysbetween;




--2.4. Customer Segment (based on total spend) 
--? Platinum: Total Spend > 1500 
--? Gold: 1000–1500 
--? Silver: 500–999 
--? Bronze: < 500 

with ads as(SELECT c.CustomerName, SUM(P.PRICE*OD.QUANTITY) AS TOTAL_spend
FROM ORDERDETAILS OD JOIN   PRODUCTS P 
ON P.ProductID=OD.ProductID
join orders o on od.OrderID=o.OrderID
join Customers c on o.CustomerID=c.CustomerID
group by c.CustomerName)
select customername,case when TOTAL_spend >1500 then 'Platinum'
			when TOTAL_spend between 1000 and 1500 then 'Gold'
			when TOTAL_spend between 500 and 999 then 'silver'
			when TOTAL_spend<500 then 'Bronze'
		end as cat 
		from ads

--2.5 What is the customer lifetime value (CLV)?
select c.customerid,c.customername,sum(od.quantity*p.price) as CLV
from customers c 
join orders o on c.CustomerID=o.CustomerID
join OrderDetails od on o.OrderID=od.OrderID
join Products p on p.ProductID=od.ProductID
group by c.customerid,c.customername
order by clv desc;

/*
Section: 3. Product & Order Insights
Tool: SQL Server
*/

--3.1. What are the top 10 most sold products (by quantity)? 
select  top(10) p.ProductID,p.ProductName,sum(od.Quantity) as total_sold_product 
from ORDERDETAILS od join PRODUCTS p
on od.ProductID=p.ProductID
group by p.ProductName,p.ProductID
order by total_sold_product desc ;


--3.2. What are the top 10 most sold products (by revenue)? 
SELECT top(10) p.ProductID,p.ProductName,SUM(P.PRICE*OD.QUANTITY) AS TOTAL_REVENUE
FROM ORDERDETAILS OD JOIN   PRODUCTS P 
ON P.ProductID=OD.ProductID
group by p.ProductName,p.ProductID
order by TOTAL_REVENUE desc;



--3.3. Which products have the highest return rate?

WITH Sold AS (
    SELECT 
        ProductID, 
        SUM(Quantity) AS TotalQty
    FROM OrderDetails
    GROUP BY ProductID
),
Returned AS (
    SELECT 
        od.ProductID, 
        SUM(od.Quantity) AS TotalQtyReturned
    FROM OrderDetails od
    JOIN Orders o ON od.OrderID = o.OrderID
    WHERE o.IsReturned = 1
    GROUP BY od.ProductID
)
SELECT 
    p.ProductName,
    CAST(
    ROUND(
        CAST(r.TotalQtyReturned AS DECIMAL(10,4)) / 
        CAST(s.TotalQty AS DECIMAL(10,4)),
        2
    ) AS DECIMAL(10,2)
) AS ReturnRate
FROM Products p
JOIN Sold s ON p.ProductID = s.ProductID
JOIN Returned r ON p.ProductID = r.ProductID
ORDER BY ReturnRate DESC;


--3.4. Return Rate by Category 

WITH Sold AS (
    SELECT 
        p.category, 
        SUM(Quantity) AS TotalQty
    FROM OrderDetails od
	join Products p on od.ProductID=p.ProductID
    GROUP BY category
),
Returned AS (
    SELECT 
        p.category, 
        SUM(od.Quantity) AS TotalQtyReturned
    FROM OrderDetails od
    JOIN Orders o ON od.OrderID = o.OrderID
	join Products p on od.ProductID=p.ProductID
    WHERE o.IsReturned = 1
    GROUP BY p.category
)
SELECT 
    s.category,
    CAST(
    ROUND(
        CAST(r.TotalQtyReturned AS DECIMAL(10,4)) / 
        CAST(s.TotalQty AS DECIMAL(10,4)),
        2
    ) AS DECIMAL(10,2)
) AS ReturnRate
FROM Sold s 
JOIN Returned r ON s.category = r.category
ORDER BY ReturnRate DESC;



--3.5. What is the average price of products per region?
select R.RegionName,CAST(ROUND(SUM(OD.QUANTITY*P.PRICE)/SUM(OD.QUANTITY),2)AS DECIMAL(10,2)) AS AVG_PRICE
from PRODUCTS p join 
OrderDetails od on p.ProductID=od.ProductID
join orders o on od.OrderID=o.OrderID
join customers c on o.CustomerID=c.CustomerID
join Regions r on c.RegionID=r.RegionID
GROUP BY R.RegionName
ORDER BY AVG_PRICE DESC


--3.6. What is the sales trend for each product category?
SELECT FORMAT(O.OrderDate, 'yyyy-MMM') AS 'PERIOD',CATEGORY,SUM(OD.QUANTITY*P.PRICE) AS REVENUE
FROM ORDERS O 
JOIN OrderDetails OD ON O.OrderID=OD.OrderID
JOIN PRODUCTS P ON P.ProductID=OD.ProductID
GROUP BY FORMAT(O.OrderDate, 'yyyy-MMM'),Category
ORDER BY 'PERIOD',Category,REVENUE DESC


/*
Section: 4. Temporal Trends
Tool: SQL Server
*/

--4.1. What are the monthly sales trends over the past year? 
select year(o.OrderDate) as 'year',month(orderdate) as 'month',sum(od.quantity*p.price) as sales
from orders o join OrderDetails od on o.OrderID=od.OrderID
join Products p on od.ProductID=p.ProductID
WHERE OrderDate >= DATEADD(MONTH, -12, GETDATE())
group by year(o.orderdate),month(o.orderdate)
order by year(o.orderdate) desc,month(o.orderdate) desc;


--4.2. How does the average order value (AOV) change by month or week?
select format(o.orderdate,'yyyy-MM') as 'period',
		SUM(P.PRICE*OD.QUANTITY)/count(distinct o.OrderID) AS TOTAL_REVENUE
from OrderDetails od join 
products p on od.ProductID=p.ProductID
join Orders o on od.OrderID=o.OrderID
group by format(o.orderdate,'yyyy-MM')


/*
Section: 5. Regional Insights
Tool: SQL Server
*/

--5.1. Which regions have the highest order volume and which have the lowest? 
	select r.regionname,count(o.orderid) as ordervolumn
	from orders o join
	Customers c on o.CustomerID=c.CustomerID
	join Regions r on c.RegionID=r.RegionID
	group by r.regionname
	order by ordervolumn desc;




--5.2. What is the revenue per region and how does it compare across different regions? 
select r.regionname,sum(od.quantity*p.Price) as totalrevenue from Orders o 
join OrderDetails od on o.OrderID=od.OrderID
join Customers c on o.CustomerID=c.CustomerID
join Regions r on c.RegionID=r.RegionID
join Products p on od.ProductID=p.ProductID
group by r.regionname
order by totalrevenue desc

with t1 as (
		select r.regionname,count(o.orderid) as ordervolumn
		from orders o join
		Customers c on o.CustomerID=c.CustomerID
		join Regions r on c.RegionID=r.RegionID
		group by r.regionname
		
),
t2 as (select r.regionname,sum(od.quantity*p.Price) as totalrevenue from Orders o 
join OrderDetails od on o.OrderID=od.OrderID
join Customers c on o.CustomerID=c.CustomerID
join Regions r on c.RegionID=r.RegionID
join Products p on od.ProductID=p.ProductID
group by r.regionname
)

select t1.RegionName,ordervolumn,totalrevenue 
from t1 join t2 on t1.RegionName=t2.RegionName
order by ordervolumn desc

SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERDETAILS;
SELECT * FROM ORDERS;
SELECT * FROM PRODUCTS;
SELECT * FROM REGIONS;


/*
Section: 6. Return & Refund Insights
Tool: SQL Server
*/

--6.1. What is the overall return rate by product category? 
SELECT 
    p.Category,
    CAST(
        ROUND(
            (CAST(SUM(CASE WHEN o.IsReturned = 1 THEN 1 ELSE 0 END) AS DECIMAL(10,4)) /
             CAST(COUNT(o.OrderID) AS DECIMAL(10,4))) ,
        2) 
    AS DECIMAL(10,2)) AS ReturnRatePercent
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY p.Category
ORDER BY ReturnRatePercent DESC;

--6.2. What is the overall return rate by region? 
SELECT 
    r.regionname,
    CAST(
        ROUND(
            (CAST(SUM(CASE WHEN o.IsReturned = 1 THEN 1 ELSE 0 END) AS DECIMAL(10,4)) /
             CAST(COUNT(o.OrderID) AS DECIMAL(10,4))) ,
        2) 
    AS DECIMAL(10,2)) AS ReturnRate
FROM Customers c
JOIN Orders o ON o.CustomerID=c.CustomerID 
join Regions r on c.RegionID=r.RegionID
GROUP BY r.regionname
ORDER BY ReturnRate DESC;



--6.3. Which customers are making frequent returns? 

select top(10) c.CustomerID,c.CustomerName,count(o.OrderID) as returncount
from Customers c 
join Orders o on c.CustomerID=o.CustomerID
where o.IsReturned=1
group by c.CustomerID,c.CustomerName
order by returncount desc;