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



