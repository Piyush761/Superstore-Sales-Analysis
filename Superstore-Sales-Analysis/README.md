# Superstore Sales Analysis

An end-to-end data analysis project exploring sales, profit, regional performance, products, customers, returns, shipping time, and trends over time. The project uses Excel, SQL (MySQL), Python (Pandas), and Power BI to turn order-level data into business insights.

## Project Objectives

- Measure overall sales, profit, profit margin, total orders, and average order value.
- Compare sales and profitability across regions and product categories.
- Identify profitable and loss-making products and customers.
- Analyze monthly performance and Month-over-Month (MoM) and Year-over-Year (YoY) sales growth.
- Examine shipping time by shipping method.
- Explore orders marked as returned and their associated sales/profit.
- Present key metrics in an interactive Power BI dashboard.

## Tools and Technologies

| Tool | How it was used |
|---|---|
| Microsoft Excel | Data review, PivotTables, summaries, and initial analysis |
| MySQL / MySQL Workbench | Aggregations, customer/product/region analysis, date analysis, and SQL window functions |
| Python | Additional data exploration and analysis |
| Pandas | Loading, validating, grouping, and summarizing the dataset |
| Matplotlib | Visualizing yearly performance and sub-category profit |
| Power BI | Interactive dashboard with KPI cards, charts, and a year slicer |
| GitHub | Project version control and documentation |

## Dataset Overview

The main analysis file is `data/Orders_clean.csv`.

- **Rows:** 10,194 order-line records
- **Columns:** 21
- **Order date range:** January 3, 2023 – December 30, 2026
- **Distinct Order IDs:** 5,111
- **Distinct Customer IDs:** 804
- **Distinct Product IDs:** 1,862

Each row represents an order line rather than a complete order. An `Order ID` can therefore appear in multiple rows when an order contains multiple products. For order counts, use ``COUNT(DISTINCT `Order ID`)`` in SQL rather than counting rows or using `COUNT(Order ID)`.

The dataset contains sales, quantity, discount, profit, order and ship dates, customer details, product categories, shipping mode, and region information. The workbook also includes `People` and `Returns` sheets used for regional-manager and return-related analysis.

## Data Quality Checks

The main CSV was checked for common data-quality issues:

- No missing values were found in the CSV fields.
- No exact duplicate rows were found.
- Repeated Order IDs were retained because they represent multiple line items belonging to the same order.
- Date and numeric fields were checked for analysis.
- The first CSV column is currently named `Column1` and contains a sequential row identifier; renaming it to `Row ID` would make the field name clearer.

## Key Performance Indicators

| KPI | Result |
|---|---:|
| Total Sales | $2,326,534.35 |
| Total Profit | $292,296.81 |
| Overall Profit Margin | 12.56% |
| Total Orders (distinct Order IDs) | 5,111 |
| Average Order Value | $455.20 |
| Unique Customers | 804 |
| Unique Products | 1,862 |

**Metric definitions**

- **Profit Margin** = Total Profit / Total Sales × 100
- **Average Order Value (AOV)** = Total Sales / Distinct Order IDs
- **Total Orders** means distinct Order IDs, not the number of order-line rows.

## Analysis and Findings

### 1. Regional Performance

| Region | Total Sales | Total Profit | Profit Margin |
|---|---:|---:|---:|
| West | $739,813.61 | $110,798.82 | 14.98% |
| East | $691,828.17 | $94,883.26 | 13.71% |
| Central | $503,170.67 | $39,865.31 | 7.92% |
| South | $391,721.90 | $46,749.43 | 11.93% |

**Finding:** The West region generated the highest sales and profit. The South region had the lowest sales, while the Central region had the lowest profit margin. Regional performance should be evaluated using both sales and profitability.

### 2. Category Performance

| Category | Total Sales | Total Profit | Profit Margin |
|---|---:|---:|---:|
| Technology | $839,893.28 | $146,543.38 | 17.45% |
| Furniture | $754,747.76 | $19,730.00 | 2.61% |
| Office Supplies | $731,893.31 | $126,023.44 | 17.22% |

**Findings:** Technology generated the highest total sales and profit among the three categories. Furniture had a much lower profit margin than Technology and Office Supplies, despite having higher sales than Office Supplies. This shows why revenue alone is not enough to judge category performance.

### 3. Product and Sub-Category Performance

Products were compared by total sales, total profit, quantity, and profit margin. The analysis identified products with negative total profit as well as products with high total profit.

The three sub-categories with negative total profit were:

| Sub-Category | Total Sales | Total Profit |
|---|---:|---:|
| Tables | $208,020.18 | -$17,753.21 |
| Bookcases | $115,361.20 | -$3,632.07 |
| Supplies | $46,725.50 | -$1,171.39 |

**Finding:** Tables was the largest loss-making sub-category. Discounts may be one factor worth investigating, but this analysis alone does not prove that discounts caused the losses. Pricing, product costs, and order-level factors should also be examined before recommending a change.

A high profit margin and a high total profit are different measures: a product may have a high percentage margin but contribute relatively little absolute profit if its sales volume is low.

### 4. Yearly and Monthly Trends

| Year | Total Sales | Total Profit | Profit Margin |
|---|---:|---:|---:|
| 2023 | $494,040.21 | $51,684.30 | 10.46% |
| 2024 | $472,993.03 | $62,020.97 | 13.11% |
| 2025 | $613,933.58 | $82,665.20 | 13.46% |
| 2026 | $745,567.53 | $95,926.35 | 12.87% |

The SQL analysis also calculates monthly sales/profit, MoM sales growth, and YoY sales growth using date grouping and the `LAG()` window function.

**Verified monthly observations:**

- Highest monthly sales: **November 2026** — sales of $118,454.51 and profit of $9,692.10.
- Highest monthly profit: **December 2025** — sales of $97,502.28 and profit of $17,926.30.
- Loss-making months identified: **July 2023** and **January 2024**.

**Finding:** Sales and profit do not always move proportionally. Monthly and yearly performance should be reviewed using both measures and profit margin.

### 5. Customer Performance

Customer-level analysis compares sales, profit, order count, and profit margin.

**Example — high sales but negative profit:**

- Customer: **Sean Miller**
- Total Sales: **$25,043.05**
- Total Profit: **-$1,980.74**
- Profit Margin: **-7.91%**

**Finding:** Sean Miller had the highest total sales among customers in this dataset, but his aggregated profit was negative. High customer revenue does not automatically indicate high customer profitability.

The customer analysis also identifies customers with high total profit, customers with high sales and negative profit, and customers with high profit margins. Customer counts should use distinct Order IDs if measuring orders rather than line items.

### 6. Shipping Analysis

Shipping duration was calculated as the difference between `Ship Date` and `Order Date`.

| Ship Mode | Average Shipping Days |
|---|---:|
| Same Day | 0.04 |
| First Class | 2.18 |
| Second Class | 3.24 |
| Standard Class | 5.00 |

**Finding:** Standard Class had the longest average shipping duration, while Same Day had the shortest. These figures describe the observed date difference in the dataset and do not, by themselves, measure customer satisfaction or delivery quality.

### 7. Returns Overview

The workbook's `Returns` sheet contains 296 distinct Order IDs marked as returned. Compared with 5,111 distinct orders, this is a **5.79% returned-order rate**.

- Distinct returned Order IDs: **296**
- Order-line rows associated with those returned orders: **800**
- Sales associated with returned orders: **$180,504.28** (**7.76%** of total recorded sales)
- Profit recorded on those order lines: **$23,232.36** (**7.95%** of total recorded profit)

These sales and profit values are associated with orders marked as returned; they should not be interpreted as the financial loss caused by returns. The current SQL script focuses mainly on the `orders` table, while the return figures are derived by matching the workbook's Returns Order IDs with order lines.

## Key Business Insights

1. **Higher sales do not always mean higher profit.** The customer and category analyses show that revenue must be considered alongside profit and profit margin.
2. **Regional profitability differs.** West leads in sales and profit, while Central has the lowest regional profit margin.
3. **Technology is the strongest category by total profit.** Furniture has a much lower profit margin and warrants deeper review.
4. **Tables is the largest loss-making sub-category.** Investigate discounting, pricing, and costs before attributing the losses to any single cause.
5. **Sales and profit fluctuate over time.** Monthly, MoM, and YoY measures provide more context than total sales alone.
6. **Shipping duration varies by ship mode.** Standard Class has the longest average shipping time in the dataset.
7. **Returns require careful interpretation.** Returned-order sales and recorded profit indicate the scale of orders associated with returns, not the net cost of returns.

## SQL Concepts Used

- `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, and `LIMIT`
- Aggregate functions: `SUM()`, `AVG()`, and `COUNT()`
- Distinct counts: `COUNT(DISTINCT ...)`
- Common Table Expressions (`WITH`)
- Window functions: `LAG()`
- Null/zero handling with `NULLIF()`
- Numeric formatting with `ROUND()`
- Date functions: `YEAR()`, `MONTH()`, and `DATEDIFF()`

## Power BI Dashboard

The Power BI report includes KPI cards for overall sales, profit, profit margin, and total orders, along with visuals for category and sub-category performance, regional performance, yearly sales/profit trends, shipping duration, and return status. A year slicer is available to filter the report.

## Project Structure

```text
Superstore-Sales-Analysis/
├── README.md
├── data/
│   └── Orders_clean.csv
├── Excel/
│   └── sample_-_superstore.xlsx
├── SQL/
│   └── superstore_analysis.sql
├── Python/
│   └── superstore_analysis.ipynb
└── PowerBI/
    └── Superstore_Dashboard.pbix
```

## How to Run the Project

### Excel

1. Open `Excel/sample_-_superstore.xlsx` in Excel.
2. Review the Orders, People, Returns, and summary worksheets.

### SQL (MySQL Workbench)

1. Import `data/Orders_clean.csv` into MySQL Workbench as a table named `orders`.
2. Ensure the imported column names match the names used by the SQL queries, including spaces in names such as `Order ID` and `Order Date`.
3. Open and run `SQL/superstore_analysis.sql` against the database containing the `orders` table.
4. For an order count, use ``COUNT(DISTINCT `Order ID`)``. Do not use `COUNT(Order ID)` when the intended metric is the number of distinct orders.

### Python

1. Install Python and the required packages:

   ```bash
   pip install pandas matplotlib jupyter
   ```

2. Open a terminal in the `Python` folder and launch Jupyter:

   ```bash
   jupyter notebook
   ```

3. Open `superstore_analysis.ipynb` and run the cells in order. The notebook uses `../data/Orders_clean.csv` as its relative data path, so launch it from the project structure as described.

### Power BI

Open `PowerBI/Superstore_Dashboard.pbix` in Power BI Desktop. If prompted to refresh or locate a data source, update the source path to the workbook used by the report.

## Limitations and Next Steps

- The dataset provides order-line sales and profit, but does not provide enough information to determine the net financial impact of returns.
- Sales and profit associated with returned orders should not be interpreted as refunds or losses caused by returns.
- Customer order counts use distinct Order IDs to avoid counting multiple product lines as separate orders.

## Conclusion

This project demonstrates an end-to-end sales analysis workflow using Excel, SQL, Python, and Power BI. It examines business KPIs, regional and product profitability, customer performance, time trends, shipping duration, and returned orders to derive actionable business insights.
