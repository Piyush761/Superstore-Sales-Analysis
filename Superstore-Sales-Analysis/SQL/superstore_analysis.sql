-- ============================================================
-- SUPERSTORE SALES ANALYSIS
-- SQL BUSINESS ANALYSIS
-- ============================================================

-- ============================================================
-- 1. OVERALL BUSINESS KPI
-- ============================================================

SELECT
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,

    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS profit_margin,

    COUNT(DISTINCT `Order ID`) AS total_orders,

    ROUND(
        SUM(Sales) /
        NULLIF(COUNT(DISTINCT `Order ID`), 0),
        2
    ) AS average_order_value

FROM orders;

-- ============================================================
-- 2. PRODUCT ANALYSIS
-- ============================================================

-- 2.1 Products with negative total profit

SELECT
    `Product Name`,
    SUM(Profit) AS total_profit
FROM orders
GROUP BY `Product Name`
HAVING SUM(Profit) < 0
ORDER BY total_profit ASC;


-- 2.2 Top 10 products by total profit

SELECT
    `Product Name`,
    SUM(Profit) AS total_profit
FROM orders
GROUP BY `Product Name`
ORDER BY total_profit DESC
LIMIT 10;


-- 2.3 Product profitability / margin

SELECT
    `Product Name`,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS profit_margin
FROM orders
GROUP BY `Product Name`
ORDER BY profit_margin DESC
LIMIT 10;


-- ============================================================
-- 3. CUSTOMER ANALYSIS
-- ============================================================

-- 3.1 Top 10 customers by total sales
SELECT
    `Customer ID`,
    `Customer Name`,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM orders
GROUP BY `Customer ID`, `Customer Name`
ORDER BY total_sales DESC
LIMIT 10;


-- 3.2 High-sales but loss-making customers

SELECT
    `Customer Name`,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM orders
GROUP BY `Customer Name`
HAVING SUM(Sales) > 10000
   AND SUM(Profit) < 0
ORDER BY total_sales DESC;


-- 3.3 Top 10 customers by profit margin

WITH Customer_Profit AS (
    SELECT
        `Customer Name`,
        SUM(Sales) AS total_sales,
        SUM(Profit) AS total_profit
    FROM orders
    GROUP BY `Customer Name`
)
SELECT
    `Customer Name`,
    total_sales,
    total_profit,
    ROUND(
        total_profit / NULLIF(total_sales, 0) * 100,
        2
    ) AS profit_margin
FROM Customer_Profit
ORDER BY profit_margin DESC
LIMIT 10;


-- ============================================================
-- 4. REGION ANALYSIS
-- ============================================================

SELECT
    Region,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS profit_margin
FROM orders
GROUP BY Region
ORDER BY total_profit DESC;


-- ============================================================
-- 5. TIME ANALYSIS
-- ============================================================

-- 5.1 Monthly Sales and Profit

SELECT
    YEAR(`Order Date`) AS order_year,
    MONTH(`Order Date`) AS order_month,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM orders
GROUP BY
    YEAR(`Order Date`),
    MONTH(`Order Date`)
ORDER BY
    order_year,
    order_month;


-- 5.2 Month-over-Month Sales Growth

WITH Monthly_Sales AS (
    SELECT
        YEAR(`Order Date`) AS order_year,
        MONTH(`Order Date`) AS order_month,
        SUM(Sales) AS total_sales
    FROM orders
    GROUP BY
        YEAR(`Order Date`),
        MONTH(`Order Date`)
)
SELECT
    order_year,
    order_month,
    total_sales,

    LAG(total_sales) OVER (
        ORDER BY order_year, order_month
    ) AS previous_sales,

    ROUND(
        (
            total_sales
            - LAG(total_sales) OVER (
                ORDER BY order_year, order_month
            )
        )
        / NULLIF(
            LAG(total_sales) OVER (
                ORDER BY order_year, order_month
            ),
            0
        ) * 100,
        2
    ) AS mom_growth
FROM Monthly_Sales;


-- 5.3 Year-over-Year Sales Growth

WITH Year_Sales AS (
    SELECT
        YEAR(`Order Date`) AS order_year,
        SUM(Sales) AS total_sales
    FROM orders
    GROUP BY YEAR(`Order Date`)
),
Year_Comparison AS (
    SELECT
        order_year,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY order_year
        ) AS previous_sales
    FROM Year_Sales
)
SELECT
    order_year,
    total_sales,
    previous_sales,
    ROUND(
        (
            total_sales - previous_sales
        )
        / NULLIF(previous_sales, 0) * 100,
        2
    ) AS yoy_growth
FROM Year_Comparison
ORDER BY order_year;


-- ============================================================
-- 6. SHIPPING ANALYSIS
-- ============================================================

-- Shipping analysis can be performed using:
-- Order Date
-- Ship Date
-- Ship Mode
--
-- Example: average shipping time by Ship Mode

SELECT
    `Ship Mode`,
    ROUND(
        AVG(
            DATEDIFF(`Ship Date`, `Order Date`)
        ),
        2
    ) AS average_shipping_days
FROM orders
GROUP BY `Ship Mode`
ORDER BY average_shipping_days;


-- ============================================================
-- 7. BUSINESS KPI BY PRODUCT
-- ============================================================

SELECT
    `Product Name`,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS profit_margin
FROM orders
GROUP BY `Product Name`
ORDER BY total_profit DESC;


-- ============================================================
-- END OF SQL ANALYSIS
-- ============================================================