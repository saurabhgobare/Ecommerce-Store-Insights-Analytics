
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


