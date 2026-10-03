# Global Superstore Data Analytics Portfolio

## Project Overview

This project analyzes the **Global Superstore** dataset using an end-to-end data analytics workflow across **Excel, MySQL, R, and Power BI**.

The goal was to clean and validate the data, explore business performance, identify profitability drivers and risks, and communicate the findings through an interactive Power BI dashboard.

## Tools Used

- **Microsoft Excel** — initial inspection and data preparation
- **MySQL** — data validation, duplicate checks, schema work, and SQL analysis
- **R / RStudio** — exploratory data analysis, profitability analysis, customer analysis, and statistical summaries
- **Power BI** — interactive dashboard development and business storytelling

## Dataset

- Cleaned records: **51,290**
- Reporting period: **2011–2014**
- Orders: **25,035**
- Customers: **795**

A duplicate issue was identified during SQL validation and resolved before downstream analysis.

## Core Business KPIs

| KPI | Result |
|---|---:|
| Total Sales | **$12.64M** |
| Total Profit | **$1.47M** |
| Profit Margin | **11.6%** |
| Total Orders | **25,035** |
| Total Customers | **795** |
| Total Quantity | **178,312** |

## Analytical Workflow

### 1. Data Cleaning and Validation

The project began with data-quality checks in Excel and MySQL.

Key tasks included:

- Duplicate detection and removal
- Data type validation
- Missing-value checks
- Product and identifier consistency checks
- Date-field validation
- Revenue and profitability reconciliation
- Verification of row counts after cleaning

A date-boundary issue was also identified in the derived `Week_Start_Date` field. Reporting was therefore standardized to the complete **2011–2014** business period.

### 2. Exploratory Data Analysis in R

R was used to analyze performance across:

- Year
- Category
- Sub-category
- Product
- Region and country
- Customer segment
- Customer profitability
- Discount behavior
- Seasonality

Visualizations were selected based on the analytical question rather than using one chart type repeatedly.

Examples included:

- Line charts for trends
- Scatter plots for relationships
- Heatmaps for matrix analysis
- Lollipop charts for ranked comparisons
- Bar charts for categorical comparison where appropriate

## Key Findings

### Sales and Profit Growth

Business performance increased strongly from 2011 to 2014.

| Year | Sales | Profit | Profit Margin |
|---|---:|---:|---:|
| 2011 | $2.26M | $248.9K | 11.0% |
| 2012 | $2.68M | $307.4K | 11.5% |
| 2013 | $3.41M | $406.9K | 11.9% |
| 2014 | $4.30M | $504.2K | 11.7% |

Sales nearly doubled across the period while the overall margin remained relatively stable.

### Category Performance

| Category | Sales | Profit | Margin |
|---|---:|---:|---:|
| Technology | $4.74M | $663.8K | 14.0% |
| Office Supplies | $3.79M | $518.5K | 13.7% |
| Furniture | $4.11M | $285.2K | 6.9% |

**Technology** was the strongest category by profit.

**Furniture** generated substantial sales but had a much weaker profit margin than Technology and Office Supplies.

### Sub-Category Risk

**Tables** was identified as the only loss-making sub-category overall.

This made Tables an important focus in the Product & Category and Discount & Profitability analyses.

### Discount and Profitability

Profitability declined sharply as discounting increased.

| Discount Band | Sales | Profit | Margin |
|---|---:|---:|---:|
| No Discount | $7.25M | $1.83M | 25.2% |
| Low | $1.70M | $280.2K | 16.5% |
| Moderate | $1.77M | $172.7K | 9.74% |
| High | $366.3K | -$20.6K | -5.61% |
| Very High | $1.18M | -$380.9K | -32.4% |
| Extreme | $371.6K | -$412.6K | -111% |

The analysis shows a strong **negative association** between higher discounts and profitability.

Discounting above roughly 20% was especially concerning, with all sub-categories showing negative aggregate profit in the high-discount analysis.

Among those sub-categories:

- Tables had the largest absolute loss
- Binders had one of the worst margins
- Bookcases, Phones, Machines, Chairs, Storage, Copiers, and Appliances also showed substantial losses under high discounting

This is an association observed in the data and should not be interpreted as proof of causation.

### Geographic Performance

Regional profitability differed materially.

Examples:

- **North Asia** showed strong profitability efficiency
- **Central Asia** also performed well on margin
- **Southeast Asia** generated meaningful sales but only about a **2.0%** profit margin
- **Canada** showed a very high margin, although on relatively low sales volume

This demonstrates why sales volume alone is not sufficient for evaluating geographic performance.

### Customer and Segment Analysis

Segment performance was relatively balanced.

| Segment | Sales | Profit | Margin |
|---|---:|---:|---:|
| Consumer | $6.51M | $749.2K | 11.5% |
| Corporate | $3.82M | $441.2K | 11.5% |
| Home Office | $2.31M | $277.0K | 12.0% |

Home Office had the highest segment margin, while Consumer generated the largest absolute sales and profit.

Customer analysis also showed that high sales do not always guarantee profitability.

For example, **Sean Miller** ranked among the highest customers by sales while producing an overall loss.

The **top 20% of customers ranked by profit** generated **43.3% of total profit**. Their average profit per customer was about **$3,994**, compared with about **$1,309** for the remaining 80%.

### Seasonality

The time analysis showed clear monthly variation.

After correcting the date-boundary issue, **September** emerged as the strongest average month while **February** was the weakest.

This suggests that business performance is not evenly distributed throughout the year.

## Power BI Dashboard

The final dashboard contains six pages.

### 1. Executive Overview

Purpose: provide a high-level view of business performance.

Includes:

- Total Sales
- Total Profit
- Profit Margin
- Total Orders
- Total Customers
- Total Quantity
- Annual Sales Trend
- Annual Profit Trend
- Profit by Category
- Sales by Region
- Year, Region, Category, and Segment slicers

### 2. Product & Category Performance

Purpose: identify strong and weak areas in the product portfolio.

Includes:

- Sales by Category
- Profit by Category
- Profit Margin by Category
- Profit by Sub-Category
- Sales vs Profit by Sub-Category scatter plot
- Top 10 Products by Profit
- Bottom 10 Products by Profit
- Category and Sub-Category slicers

Tables is intentionally surfaced as a loss-making sub-category.

### 3. Discount & Profitability

Purpose: analyze the relationship between discounting and profit performance.

Includes:

- Profit Margin by Discount Level
- Profitability by Discount Band
- Category × Discount Band matrix / heatmap
- High-discount sub-category losses
- Discount and Category filters

### 4. Geographic Performance

Purpose: compare sales volume and profitability across regions and countries.

Includes:

- Regional Sales
- Regional Profit
- Regional Profit Margin
- Geographic comparison visuals
- Region and Country slicers

### 5. Customer & Segment Analysis

Purpose: evaluate customer and segment value.

Includes:

- Segment Sales
- Segment Profit
- Segment Profit Margin
- Customer counts
- Sales per Customer
- Profit per Customer
- Top Customers by Sales
- Top Customers by Profit
- Loss-making customers
- Customer profitability concentration

A **lollipop chart** is used for one ranked customer comparison to avoid unnecessary repetition of standard bar charts while preserving readability.

### 6. Time & Seasonality

Purpose: show long-term growth and recurring monthly patterns.

Includes:

- Annual Sales Trend
- Annual Profit Trend
- Monthly Sales Trend
- Monthly Profit Trend
- Monthly seasonality matrix / heatmap
- Year and month filtering


## Dashboard Screenshots

### Executive Overview

![Executive Overview](images/executive-overview.png)

### Product & Category Performance

![Product & Category Performance](images/product-category-performance.png)

### Discount & Profitability

![Discount & Profitability](images/discount-profitability.png)

### Geographic Performance

![Geographic Performance](images/geographic-performance.png)

### Customer & Segment Analysis

![Customer & Segment Analysis](images/customer-segment-analysis.png)

### Time & Seasonality

![Time & Seasonality](images/time-seasonality.png)

## Dashboard Design Principles

The Power BI report was designed around the following principles:

- Use chart types based on the analytical question
- Avoid unnecessary visual repetition
- Keep KPI definitions consistent across pages
- Use filters and slicers consistently
- Keep titles and labels business-readable
- Highlight loss-making and low-margin areas
- Avoid overloading executive pages with excessive detail
- Preserve the validated data model and calculations

## Key Business Takeaways

1. Sales and profit grew substantially between 2011 and 2014 while overall profitability remained relatively stable.
2. Technology was the strongest profit-generating category.
3. Furniture underperformed on margin despite substantial sales.
4. Tables was the primary loss-making sub-category.
5. Higher discounts were strongly associated with deteriorating profitability.
6. Regional sales volume and profitability efficiency varied significantly.
7. Customer profitability was more concentrated than the overall customer base.
8. High-revenue customers were not necessarily high-profit customers.
9. Monthly performance showed meaningful seasonality.

## Skills Demonstrated

This project demonstrates:

- Data cleaning and validation
- SQL querying
- Exploratory data analysis
- Data visualization
- DAX measure creation
- Profitability analysis
- Customer segmentation
- Discount analysis
- Time-series analysis
- Dashboard design
- Business storytelling
- Cross-tool data validation
- End-to-end analytical workflow

## Repository Structure

```text
global-superstore-data-analytics/
│
├── powerbi/
│   └── Global Superstore Dashboard.pbix
│
├── r/
│   └── StatisticalEDA analysis.R
│
├── images/
│   ├── executive-overview.png
│   ├── product-category-performance.png
│   ├── discount-profitability.png
│   ├── geographic-performance.png
│   ├── customer-segment-analysis.png
│   └── time-seasonality.png
│
└── README.md
```

> SQL scripts and the cleaned dataset can be added to `sql/` and `data/` folders when you are ready to publish them.

## Portfolio Summary

This project shows a complete data analyst workflow from raw-data validation through business analysis and dashboard delivery.

The same business metrics were cross-checked across SQL, R, and Power BI to ensure consistency before final reporting.

