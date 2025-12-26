
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


