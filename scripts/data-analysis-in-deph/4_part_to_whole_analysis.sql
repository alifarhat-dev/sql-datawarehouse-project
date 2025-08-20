/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.
===============================================================================
*/

-- Declare a variable to hold the total sales amount
DECLARE @total_sales INT;

-- Calculate the total sales from the fact_sales table and store it in the variable
SET @total_sales = (SELECT SUM(sales_amount) FROM gold.fact_sales);

-- Query 1: Calculate sales percentage per country
SELECT 
    b.country,  -- Select country from dimension table
    CONCAT(
        ROUND(SUM(a.sales_amount) * 100.00 / @total_sales, 2),  -- Calculate sales % and round to 2 decimals
        '%'  -- Append percentage sign
    ) AS sales_precentage_per_country
FROM gold.fact_sales a
JOIN gold.dim_customers b
    ON a.customer_key = b.customer_key  -- Join fact_sales with dim_customers to get country info
WHERE b.country <> 'n/a'  -- Exclude records where country is not available
GROUP BY b.country;  -- Group by country to calculate percentage per country

-- Query 2: Calculate sales percentage per product category
SELECT 
    b.category,  -- Select product category from dimension table
    CONCAT(
        ROUND(100.00 * SUM(a.sales_amount) / @total_sales, 2),  -- Calculate sales % and round to 2 decimals
        '%'  -- Append percentage sign
    ) AS sales_precentage_per_category
FROM gold.fact_sales a
JOIN gold.dim_products b
    ON a.product_key = b.product_key  -- Join fact_sales with dim_products to get category info
GROUP BY b.category;  -- Group by product category to calculate percentage per category
