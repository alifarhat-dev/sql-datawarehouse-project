/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions
-- DATETRUNC()
SELECT
    DATETRUNC(month, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);


--Sum of sales by year -- 
SELECT
    DATETRUNC(year, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year, order_date)
ORDER BY DATETRUNC(year, order_date);

/*
Benefits of this query:
1. Business Insights by Quarter:
   - Provides the total sales amount per quarter to help analyze revenue trends 
     across different times of the year (seasonality).
2. Customer Analytics:
   - Counts the number of distinct customers per quarter, showing how customer 
     engagement changes over time.
3. Product Performance:
   - Summarizes the total quantity sold per quarter, which helps in inventory 
     planning and demand forecasting.
4. Decision-Making:
   - Enables management to quickly identify high-performing quarters and adjust 
     strategies (marketing, discounts, supply chain).
5. Simplicity and Efficiency:
   - Groups data by quarter using DATEPART logic without requiring a calendar table.
*/

-- Sum of sales by quarter 
SELECT
    CASE
        WHEN DATEPART(MONTH, order_date) IN (1,2,3) THEN '1'
        WHEN DATEPART(MONTH, order_date) IN (4,5,6) THEN '2'
        WHEN DATEPART(MONTH, order_date) IN (7,8,9) THEN '3'
        ELSE '4'
    END AS [Quarter],
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY CASE
        WHEN DATEPART(MONTH, order_date) IN (1,2,3) THEN '1'
        WHEN DATEPART(MONTH, order_date) IN (4,5,6) THEN '2'
        WHEN DATEPART(MONTH, order_date) IN (7,8,9) THEN '3'
        ELSE '4'
    END;

--Average cost by month 
SELECT DATETRUNC(YEAR,a.order_date) as Month,AVG(b.cost*a.quantity) as average_cost
FROM gold.fact_sales a
JOIN gold.dim_products b
ON a.product_key = b.product_key
where a.order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR,a.order_date)
ORDER BY DATETRUNC(YEAR,a.order_date)
