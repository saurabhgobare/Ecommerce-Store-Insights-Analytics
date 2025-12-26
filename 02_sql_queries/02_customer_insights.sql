
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

