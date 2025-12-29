# Ecommerce Store – Insights and Analytics

## 📌 Project Overview
This project analyzes ecommerce sales data to uncover insights on revenue performance, customer behavior, product trends, returns, and regional performance.  

- **Database:** Microsoft SQL Server  
- **Visualization:** Power BI Dashboards  
- **Purpose:** Demonstrate SQL data analysis, business insights, and dashboard creation—skills required for a Data Analyst role.

---

## 🛠 Tools & Technologies
- **SQL Server:** Database creation and querying  
- **Power BI:** Interactive dashboards and visualizations  
- **Relational Database Design:** Normalized tables supporting analytics  

---

## 🗂 Project Structure
📦 ecommerce-store-insights-analytics
├── 01_database_schema/

│ └── ecommerce_schema.sql <-- SQL Server schema

├── 02_sql_queries/

│ ├── 01_general_sales_insights.sql

│ ├── 02_customer_insights.sql
 
├── 03_power_bi/
│ ├── ecommerce_dashboard.pbix
│ └── dashboard_screenshots/
│ ├── sales_overview.png
│ └── returns_analysis.png

├── 04_documentation/
│ └── business_questions.md <-- List of business questions solved

└── README.md <-- This file

## 🗃 Database Schema Overview
The database consists of 5 normalized tables:

| Table | Description |
|-------|-------------|
| Regions | RegionID, RegionName, Country |
| Customers | CustomerID, CustomerName, Email, Phone, RegionID, CreatedAt |
| Products | ProductID, ProductName, Category, Price |
| Orders | OrderID, CustomerID, OrderDate, IsReturned |
| OrderDetails | OrderDetailID, OrderID, ProductID, Quantity |

The schema supports **complex analytical queries** for business insights.

---

## 📊 Business Questions Addressed
### General Sales Insights
- Total revenue and revenue excluding returned orders  
- Revenue trends by year and month  
- Revenue by product and category  
- Average Order Value (AOV)  
- AOV and order size trends by region  

### Customer Insights
- Top 10 customers by revenue  
- Repeat customer rate  
- Average time between consecutive orders (region-wise)  
- Customer segmentation (Platinum, Gold, Silver, Bronze)  
- Customer Lifetime Value (CLV)  

### Product & Order Insights
- Top products by quantity and revenue  
- Products with highest return rates  
- Return rate by category  
- Average price per region  
- Sales trends for each category  

### Regional & Temporal Insights
- Monthly sales trends  
- Revenue per region  
- AOV trends over time  

### Return & Refund Insights
- Return rate by product category  
- Return rate by region  
- Customers with frequent returns  

> All SQL queries are stored in the `02_sql_queries` folder.

---

## 📈 Power BI Dashboards

### 1️⃣ Sales Performance Overview
**Global Slicers:** Year, RegionName, Category, Reset button  

**KPI Cards:**  
- Total Revenue  
- Net Revenue (Excluding Returns)  
- Average Order Value (AOV)  
- Total Orders  

**Visualizations:**  
| Chart | Purpose |
|-------|---------|
| Line Chart | Revenue trend by year and month |
| Line Chart | AOV trend by year and month |
| Stacked Bar Chart | Revenue by product category |
| Table / Bar Chart | Top 10 customers by revenue |
| Line Chart | Average order quantity by region |

**Insights:**  
- Monitor revenue trends globally and regionally  
- Identify top customers and product categories  
- Evaluate average order size for strategic planning  

---

### 2️⃣ Returns & Product Performance Analysis
**Global Slicers:** Year, RegionName, Category, Reset button  

**KPI Cards:**  
- Overall Return Rate  
- Total Returned Orders  

**Visualizations:**  
| Chart | Purpose |
|-------|---------|
| Stacked Bar Chart | Revenue by product |
| Stacked Bar Chart | Total quantity sold by product |
| Stacked Column Chart | Return rate by product |
| Stacked Column Chart | Return rate by product category |
| Table / Card | Average unit price by region |

**Insights:**  
- Analyze product returns and revenue contributions  
- Identify products/categories with high return rates  
- Compare average product pricing across regions  

> Dashboard screenshots are in `03_power_bi/dashboard_screenshots/`

---

## 🎯 Skills Demonstrated
- SQL querying and database management  
- Customer and product analytics  
- KPI definition and business insights  
- Power BI dashboard creation and visualization  
- Translating business questions into actionable insights  

---

## 👤 Author
**Saurabh Gobare**  
Aspiring Data Analyst | SQL Server | Power BI | Data Analysis  
