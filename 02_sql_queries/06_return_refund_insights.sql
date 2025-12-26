
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