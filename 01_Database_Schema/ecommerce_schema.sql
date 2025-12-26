/*
Project Name : Ecommerce Store – Insights and Analytics
Database     : Microsoft SQL Server
Author       : Saurabh Gobare
Description  : Normalized ecommerce database schema designed
               for sales, customer, product, and return analysis.
*/

/* =========================================================
   1. Regions Table
   ========================================================= */
CREATE TABLE Regions (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(100) NOT NULL,
    Country VARCHAR(100) NOT NULL
);

/* =========================================================
   2. Customers Table
   ========================================================= */
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(30),
    RegionID INT NOT NULL,
    CreatedAt DATE,
    CONSTRAINT FK_Customers_Regions
        FOREIGN KEY (RegionID) REFERENCES Regions(RegionID)
);

/* =========================================================
   3. Products Table
   ========================================================= */
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

/* =========================================================
   4. Orders Table
   ========================================================= */
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    IsReturned BIT DEFAULT 0,
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

/* =========================================================
   5. OrderDetails Table
   ========================================================= */
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    CONSTRAINT FK_OrderDetails_Orders
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
