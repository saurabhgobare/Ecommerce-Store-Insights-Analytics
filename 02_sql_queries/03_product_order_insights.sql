
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


