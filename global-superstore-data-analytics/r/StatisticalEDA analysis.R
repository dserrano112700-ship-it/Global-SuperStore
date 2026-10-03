# setting the directory
setwd("C:/Users/Enyet/Documents/data analytics/Supermarket")
getwd()
file.exists("C:/Users/Enyet/Documents/data analytics/Supermarket")

#install packages
library(tidyverse)

# pull the data set and save into variable orders
orders <- read_csv("Global Superstore Cleaned.csv")
glimpse(orders)
class(orders)
typeof(orders)

# I think I will have problems with columns '_Year' and '_State' so I will rename it. ------
orders <- orders %>%
     rename(Year = `_Year`,
            State = '_State',
            SubCategory = `Sub-Category`,
            Week_Start_Date = OrderDate1)

# getting the yearly performance -----------------------------------------------
yearly_performance <- orders %>%
     group_by(Year) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE)
     )
yearly_performance

## Visualize the Sales
yearly_performance %>%
     ggplot(aes(Year, Total_Sales))+
     geom_line(linewidth = 1)+
     geom_point(size = 3)+
     theme_bw()+
     labs(
          title = "Annual Sales Performance",
          subtitle = "Total sales increased consistently from 2011 to 2014",
          x = "Year",
          y = "Total Sales"
     )
### key insight
### yearly sales performance steadily grew over the 4-year-period.

## Visualize the Profits
yearly_performance %>%
     ggplot(aes(Year, Total_Profit))+
     geom_line(linewidth = 1)+
     geom_point(size = 3)+
     labs(
          title = "Annual Profit Performance",
          x = "Year",
          y = "Total Profit"
     )
### key insight:
### annual profit performance shown steady growth with the growth of 2011-2012 as
### the lowest growth and 2012-2013 as the highest then 2013-2014 growth is pretty
### same with 2012-2013.

## Profit margin trend
profitmargin <- yearly_performance %>%
     mutate(profit_margin = (Total_Profit / Total_Sales) * 100)
profitmargin

profitmargin %>%
     ggplot(aes(Year, profit_margin))+
     geom_line(linewidth = 1)+
     geom_point(size = 3)+
     labs(
          title = "Annual Profit Margin",
          x = "Year",
          y = "Profit Margin"
     )

### key insights:
### Sales and Performance have stable growth throughout 2011 to 2014
### Profit margin was stable from 2011 to 2013 but saw a slight fall in 2014.


# Category Performance ---------------------------------------------------------
categorical_performance <- orders %>%
     group_by(Category) %>%
     summarise(Total_Sales = sum(Sales, na.rm = TRUE),
               Total_Profit = sum(Profit, na.rm = TRUE),
               profit_margin = (Total_Profit / Total_Sales) * 100)
categorical_performance


## Sales by Category
categorical_performance %>%
     ggplot(aes(
          x = reorder(Category, Total_Sales),
          y = Total_Sales,
          col = Category,
          fill = Category
     )) +
    geom_col()+
     theme_bw() +
     labs(
          title = "Sales by Category",
          x = "Category",
          y = "Total Sales"
     )

## Profit by Category
categorical_performance %>%
     ggplot(aes(
          x = reorder(Category, Total_Sales),
          y = Total_Sales,
          col = Category,
          fill = Category
     )) +
     geom_col()+
     theme_bw()+
     labs(
          title = "Profit by Category",
          x = "Category",
          y = "Total Profit"
     )

## Profit Margin by Category
categorical_performance %>%
     ggplot(aes(
          x = reorder(Category, profit_margin),
          y = profit_margin
     )) +
     geom_segment(
          aes(
               xend = reorder(Category, profit_margin),
               y = 0,
               yend = profit_margin
          ),
          linewidth = 1
     ) +
     geom_point(size = 4) +
     theme_bw() +
     labs(
          title = "Profit Margin by Category",
          x = "Category",
          y = "Profit Margin (%)"
     )

### Key Insights:
### Technology has the highest sales followed by Furniture and then Office Supplies.
### Furniture shows the lowest profit out of all categories by around 55% lower than Technology.
### Office Supplies and Technology are very close on profit margin but we can see that Furniture is
### so much lower by around 50% that of Office Supplies profit margin.

# sub category performance -----------------------------------------------------
subcat_performance <- orders %>%
     group_by(SubCategory) %>%
     summarise(Total_Sales = sum(Sales, na.rm = TRUE),
               Total_Profit = sum(Profit, na.rm = TRUE),
               profit_margin = (Total_Profit / Total_Sales) * 100)
subcat_performance

## Sales by Sub-Category
subcat_performance %>%
     ggplot(aes(
          x = reorder(SubCategory, Total_Sales),
          y = Total_Sales
     )) +
     geom_segment(
          aes(
               xend = reorder(SubCategory, Total_Sales),
               y = 0,
               yend = Total_Sales
          ),
          linewidth = 1
     ) +
     geom_point(size = 3) +
     coord_flip() +
     theme_minimal() +
     labs(
          title = "Sales by Sub-Category",
          x = "Sub-Category",
          y = "Total Sales"
     )

## Profit by Sub-Category
subcat_performance %>%
     ggplot(aes(
          x = reorder(SubCategory, Total_Profit),
          y = Total_Profit
     )) +
     geom_segment(
          aes(
               xend = reorder(SubCategory, Total_Profit),
               y = 0,
               yend = Total_Profit
          ),
          linewidth = 1
     ) +
     geom_point(size = 3) +
     coord_flip() +
     theme_minimal() +
     labs(
          title = "Profit by Sub-Category",
          x = "Sub-Category",
          y = "Total Profit"
     )

## Profit Margin by Sub-Category
subcat_performance %>%
     ggplot(aes(
          x = reorder(SubCategory, profit_margin),
          y = profit_margin
     )) +
     geom_segment(
          aes(
               xend = reorder(SubCategory, profit_margin),
               y = 0,
               yend = profit_margin
          ),
          linewidth = 1
     ) +
     geom_point(size = 3) +
     coord_flip() +
     theme_minimal() +
     labs(
          title = "Profit Margin by Sub-Category",
          x = "Sub-Category",
          y = "Profit Margin (%)"
     )

### Key Insights:
### First thing I noticed was that Tables sub-category shows fairly high sales amount
### but it is the only one generating losses.

### investigating the loss generating products ---------------------------------
loss_products <- orders %>%
     filter(SubCategory == "Tables") %>%
     group_by(ProductName) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE)
     ) %>%
     mutate(profit_margin = (Total_Profit/ Total_Sales) * 100) %>%
     arrange(Total_Profit)
loss_products

### further investigation on Table sub category (Visualization)
loss_products %>%
     filter(Total_Profit < 0) %>%
     slice_head(n = 10) %>%
     ggplot(aes(
          reorder(ProductName, Total_Profit),
          Total_Profit
     )) +
     geom_segment(
          aes(
               xend = reorder(ProductName, Total_Profit),
               y = 0,
               yend = Total_Profit
          ),
          linewidth = 1
     ) +
     geom_point(size = 4) +
     coord_flip() +
     theme_bw() +
     labs(
          title = "Top 10 Loss-Making Products",
          x = "Products",
          y = "Total Profit"
     )

#### Key Insights:
#### Further Investigation shows almost all of table products made losses.

##### Examine discount vs profit ---------------------------------------------------
table_discount <- orders %>%
     filter(SubCategory == "Tables") %>%
     group_by(Discount) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Profit_Margin = (Total_Profit / Total_Sales) * 100,
          .groups = "drop"
     ) %>%
     arrange(Discount)
table_discount

##### discount vs profit graph
ggplot(table_discount, aes(x = Discount, y = Total_Profit)) +
     geom_col() +
     theme_minimal() +
     labs(
          title = "Tables: Profit by Discount Level",
          x = "Discount",
          y = "Total Profit"
     )

#### Key Insights:
#### discounts up to 20% shows positive profit margin and any more above 20%
#### shows negative profit margin.


##### Examine country/region vs profit ---------------------------------------------
profits_country <- orders %>%
     group_by(Country) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Profit_Margin = (Total_Profit / Total_Sales) * 100,
          .groups = "drop"
     )
profits_country

###### Loss-Making Countries
profits_country %>%
     filter(Total_Profit < 0) %>%
     ggplot(aes(
          reorder(Country, Total_Profit),
          Total_Profit
     )) +
     geom_segment(
          aes(
               xend = reorder(Country, Total_Profit),
               y = 0,
               yend = Total_Profit
          ),
          linewidth = 1
     ) +
     geom_point(size = 4) +
     coord_flip() +
     theme_bw() +
     labs(
          title = "Loss-Making Countries",
          x = "Country",
          y = "Total Profit"
     )

##### Table Summary ----------------------------------------------------------------
tables_summary <- orders %>%
     filter(SubCategory == "Tables") %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Profit_Margin = (Total_Profit / Total_Sales) * 100,
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Unique_Products = n_distinct(ProductName),
          Unique_Countries = n_distinct(Country)
     )
tables_summary
## Key Finding:
## Tables is a loss-making sub-category.
## The analysis suggests that high discounts levels are strongly associated with negative profitability,
## while losses are concentrated in certain products and countries.




##### Determining the likely drivers -----------------------------------------------
table_discount ## driver 1
loss_products ## driver 2
profits_country ## driver 3

### compiled  
tables_loss_detail <- orders %>%
     filter(SubCategory == "Tables") %>%
     filter(Profit < 0) %>%
     select(
          Country,
          ProductName,
          Discount,
          Sales,
          Profit,
          Quantity
     ) %>%
     arrange(Profit) %>%
     slice_head(n = 20)
tables_loss_detail


## Insight:
## The losses in the Tables sub-category appear to be driven primarily by
## aggressive discounting on specific products, with losses concentrated in certain countries.
## Higher discount levels are consistently associated with increasingly negative profit margins.
## However, the analysis indicates that the issue is concentrated rather than representative of all
## Table products or markets.



# Product Performance ----------------------------------------------------------
product_performance <- orders %>%
     group_by(ProductName) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE)) %>%
     mutate(Profit_Margin = (Total_Profit / Total_Sales) * 100)
product_performance

## Top 10 Products by Sales
product_performance %>%
     arrange(desc(Total_Sales)) %>%
     slice_head(n = 10) %>%
     ggplot(aes(
          reorder(ProductName, Total_Sales),
          Total_Sales
     )) +
     geom_segment(
          aes(
               xend = reorder(ProductName, Total_Sales),
               y = 0,
               yend = Total_Sales
          ),
          linewidth = 1
     ) +
     geom_point(size = 3) +
     coord_flip() +
     theme_minimal() +
     labs(
          title = "Top 10 Products by Sales",
          x = "Product",
          y = "Total Sales"
     )
## top product by profit
product_performance %>%
     arrange(desc(Total_Profit)) %>%
     slice_head(n = 10) %>%
     ggplot(aes(reorder(ProductName, Total_Profit), Total_Profit))+
     geom_col()+
     coord_flip()+
     labs(
          title = "Top 10 Products",
          x = "Products",
          y = "Total Profit"
     )
## bottom product by profit
product_performance %>%
     arrange(Total_Profit) %>%
     slice_head(n = 10) %>%
     ggplot(aes(reorder(ProductName, Total_Profit), Total_Profit))+
     geom_col()+
     coord_flip()+
     labs(
          title = "Least Performing Products",
          x = "Products",
          y = "Total Profit"
     )

# Regional Performance ---------------------------------------------------------
region_performance <- orders %>%
     group_by(Region) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Profit_Margin = (Total_Profit / Total_Sales) * 100) %>%
     arrange(desc(Total_Sales))
region_performance

## Sales by Region
region_performance %>%
     ggplot(aes(x = "", y = Total_Sales, fill = Region)) +
     geom_col(width = 1) +
     coord_polar(theta = "y") +
     labs(
          title = "Sales Distribution by Region",
          fill = "Region"
     ) +
     theme_void()

## Profit vs Sales by region
region_performance %>%
     ggplot(aes(Total_Sales, Total_Profit, col = Region))+
     geom_point(size = 4)+
     geom_text(aes(label = Region),
               vjust = -1)+
     labs(
          title = "Sales vs Profit by Region",
          x = "Total Sales",
          y = "Total Profit")

## Profit Margin by Region
region_performance %>%
     ggplot(aes(x = reorder(Region, Profit_Margin),
                y = Profit_Margin))+
     geom_segment(aes(xend = reorder(Region, Profit_Margin),
                      y = 0,
                      yend = Profit_Margin))+
     geom_point(size = 4)+
     coord_flip()+
     labs(
          title = "Profit Margin by Region",
          x = "Region",
          y = "Profit Margin (%)")

### Key Insights: Regional Performance

### Sales Distribution
### The pie chart clearly shows each region's contribution to total sales
### based on the relative size of its slice. Central has the largest contribution to total sales,
### while Canada has the smallest.

### Sales vs. Profit
### The scatter plot shows the relationship between total sales and total profit across regions.
### It allows us to compare both metrics simultaneously and identify whether regions generating
### higher sales are also producing higher profits.

### Profit Margin
### Although Canada has the lowest total sales and profit, it has the highest profit margin among the regions.
### This indicates that its sales are relatively profitable despite having a smaller overall sales volume.
### If the business can increase sales in Canada while maintaining its current profitability,
### the region could have potential for further profit growth. However, additional analysis
### of market size, demand, and sales opportunities would be needed before recommending market expansion.


# Time-series Analysis ---------------------------------------------------------
monthly_performance <- orders %>%
     mutate(
          Month = floor_date(Week_Start_Date, unit = "month")
     ) %>%
     group_by(Month) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE)
     ) %>%
     arrange(Month)
monthly_performance

## Monthly Sales Trend
monthly_performance %>%
     ggplot(aes(Month, Total_Sales, group = 1)) +
     geom_point(size = 4, alpha = 0.5) +
     geom_line(linewidth = 1) +
     geom_smooth(aes(group = 1),
                 method = "lm",
                 se = F,
                 col = "red")+
     theme_minimal() +
     labs(
          title = "Monthly Sales Trend",
          x = "Month",
          y = "Total Sales"
     )

## Monthly Profit Trend
monthly_performance %>%
     ggplot(aes(Month, Total_Profit))+
     geom_point(size = 4, alpha = 0.5)+
     geom_line(linewidth = 1)+
     labs(
          title = "Monthly Profit Trend",
          x = "Month",
          y = "Total Profit"
     )

## monthly sales by year heatmap
monthly_performance %>%
     mutate(
          Year = year(Month),
          Month_Name = month(Month, label = TRUE, abbr = TRUE),
          Month_Number = month(Month)
     ) %>%
     ggplot(aes(Month_Number, Year, fill = Total_Sales)) +
     geom_tile() +
     scale_x_continuous(
          breaks = 1:12,
          labels = month.abb
     ) +
     labs(
          title = "Monthly Sales by Year",
          x = "Month",
          y = "Year",
          fill = "Sales"
     )

## Sales vs Profit Trend
monthly_long <- monthly_performance %>%
     pivot_longer(
          cols = c(Total_Sales, Total_Profit),
          names_to = "Metric",
          values_to = "Amount")
monthly_long
### plotting
monthly_long %>%
     ggplot(aes(Month, Amount, linetype = Metric, col = Metric))+
     geom_line(linewidth = 1)+
     labs(
          title = "Monthly Sales and Profit Trends",
          x = "Month",
          y = "Amount",
          linetype = "Metric"
     )

## Year-over-Year Performance
annual_performance <- monthly_performance %>%
     mutate(
          Year = year(Month)
     ) %>%
     group_by(Year) %>%
     summarise(
          Total_Sales = sum(Total_Sales),
          Total_Profit = sum(Total_Profit),
          Total_Quantity = sum(Total_Quantity)
     ) %>%
     arrange(Year)
annual_performance

### Annual Sales Performance
yearly_performance %>%
     ggplot(aes(Year, Total_Sales, group = 1)) +
     geom_line(linewidth = 1) +
     geom_point(size = 3) +
     theme_bw() +
     labs(
          title = "Annual Sales Performance",
          subtitle = "Sales increased consistently from 2011 to 2014",
          x = "Year",
          y = "Total Sales"
     )

### Annual Profit Performance
yearly_performance %>%
     ggplot(aes(Year, Total_Profit, group = 1)) +
     geom_line(linewidth = 1) +
     geom_point(size = 3) +
     theme_bw() +
     labs(
          title = "Annual Profit Performance",
          subtitle = "Profit increased consistently from 2011 to 2014",
          x = "Year",
          y = "Total Profit"
     )

## computing YoY growth
annual_performance <- annual_performance %>%
     mutate(
          Sales_YoY = (Total_Sales / lag(Total_Sales) - 1) * 100,
          Profit_YoY = (Total_Profit / lag(Total_Profit) - 1) * 100
     )
annual_performance
### key insight:
### YoY of 2011 shown huge numbers is because 2010 doesn't have much sales.
### The company started operating around the end of 2010.

## removing 2011 YoY growth
annual_performance <- annual_performance %>%
     mutate(
          Sales_YoY = if_else(
               Year == 2011,
               NA_real_,
               (Total_Sales / lag(Total_Sales) - 1) * 100
          ),
          Profit_YoY = if_else(
               Year == 2011,
               NA_real_,
               (Total_Profit / lag(Total_Profit) - 1) * 100
          )
     )
annual_performance


## Best and worst months by sales
monthly_performance %>%
     arrange(desc(Total_Sales)) %>%  # REMOVE desc to get the worst months
     slice_head(n = 10)
## Best and worst months by profit
monthly_performance %>%
     arrange(desc(Total_Profit)) %>% # REMOVE desc to get the worst months
     slice_head(n = 10)

# seasonality analysis ---------------------------------------------------------
monthly_seasonality <- monthly_performance %>%
     mutate(
          Month_Name = month(Month, label = TRUE, abbr = TRUE),
          Month_Number = month(Month)
     ) %>%
     group_by(Month_Number, Month_Name) %>%
     summarise(
          Avg_Sales = mean(Total_Sales),
          Avg_Profit = mean(Total_Profit),
          .groups = "drop"
     ) %>%
     arrange(Month_Number)
monthly_seasonality

## Visualizing average monthly sales
monthly_seasonality %>%
     ggplot(aes(Month_Name, Avg_Sales, group = 1)) +
     geom_line(linewidth = 1) +
     geom_point(size = 3) +
     theme_minimal() +
     labs(
          title = "Average Monthly Sales Pattern",
          x = "Month",
          y = "Average Sales"
     )
## average monthly profit
monthly_seasonality %>%
     ggplot(aes(Month_Name, Avg_Profit, group = 1)) +
     geom_line(linewidth = 1) +
     geom_point(size = 3) +
     labs(
          title = "Average Monthly Profit Pattern",
          x = "Month",
          y = "Average Profit"
     )

### identifying the strongest and weakest periods
monthly_seasonality %>%
     arrange(desc(Avg_Sales)) # REMOVE desc to get weakest periods

monthly_seasonality %>%
     arrange(desc(Avg_Profit)) # REMOVE desc to get weakest periods

#### calculating the seasonal range
seasonality_summary <- monthly_seasonality %>%
     summarise(
          Highest_Sales_Month = Month_Name[which.max(Avg_Sales)],
          Highest_Avg_Sales = max(Avg_Sales),
          Lowest_Sales_Month = Month_Name[which.min(Avg_Sales)],
          Lowest_Avg_Sales = min(Avg_Sales),
          Sales_Range = max(Avg_Sales) - min(Avg_Sales),
          Sales_Difference_Pct =
               ((max(Avg_Sales) / min(Avg_Sales)) - 1) * 100,
          
          Highest_Profit_Month = Month_Name[which.max(Avg_Profit)],
          Highest_Avg_Profit = max(Avg_Profit),
          Lowest_Profit_Month = Month_Name[which.min(Avg_Profit)],
          Lowest_Avg_Profit = min(Avg_Profit),
          Profit_Range = max(Avg_Profit) - min(Avg_Profit),
          Profit_Difference_Pct =
               ((max(Avg_Profit) / min(Avg_Profit)) - 1) * 100
     )
seasonality_summary


# segment performance ----------------------------------------------------------
segment_performance <- orders %>%
     group_by(Segment) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Profit_Margin = (Total_Profit / Total_Sales) * 100,
          Unique_Customers = n_distinct(CustomerName),
          .groups = "drop") %>%
     arrange(desc(Total_Sales))

segment_performance

## Segment Sales
segment_performance %>%
     ggplot(aes(x = reorder(Segment, Total_Sales), Total_Sales))+
     geom_segment(aes(xend = reorder(Segment, Total_Sales),
                      y = 0,
                      yend = Total_Sales),
                  linewidth = 1)+
     geom_point(size = 4)+
     coord_flip()+
     theme_bw()+
     labs(
          title = "Sales by Customer Segment",
          x = "Segment",
          y = "total Sales"
     )

## Segment Profit
segment_performance %>%
     ggplot(aes(x = reorder(Segment, Total_Sales), Total_Sales, fill = Segment))+
     geom_col()+
     coord_flip()+
     theme_bw()+
     labs(
          title = "Profits by Customer Segment",
          x = "Segment",
          y = "Total Profit"
     )

     
## Customers value by segments
     segment_customer_value <- orders %>%
          group_by(Segment) %>%
          summarise(
               Total_Sales = sum(Sales, na.rm = TRUE),
               Total_Profit = sum(Profit, na.rm = TRUE),
               Unique_Customers = n_distinct(CustomerName),
               .groups = "drop"
          ) %>%
          mutate(
               Sales_per_Customer = Total_Sales / Unique_Customers,
               Profit_per_Customer = Total_Profit / Unique_Customers
          ) %>%
          arrange(desc(Sales_per_Customer))
     segment_customer_value

     
## segment contributions
segment_contribution <- segment_customer_value %>%
     mutate(
          Sales_Share = (Total_Sales / sum(Total_Sales)) * 100,
          Profit_Share = (Total_Profit / sum(Total_Profit)) * 100,
          Customer_Share = (Unique_Customers / sum(Unique_Customers)) * 100
     ) %>%
     arrange(desc(Sales_Share))
segment_contribution


# Customer level analysis ------------------------------------------------------
customer_performance <- orders %>%
     group_by(CustomerName, Segment) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Order_count = n_distinct(OrderID),
          Profit_Margin = (Total_Profit / Total_Sales) * 100,
          .groups = "drop"
     )
customer_performance


## top customers by sales
top_customers_sales <- customer_performance %>%
     arrange(desc(Total_Sales)) %>%
     slice_head(n = 10)
top_customers_sales

### key finding:
### Sean Miller is the 5th-highest customer by sales but is actually loss-making

top_customers_sales %>%
     ggplot(aes(x = reorder(CustomerName, Total_Sales), Total_Sales, fill = Segment))+
     geom_col()+
     coord_flip()+
     labs(
          title = "Top 10 Customers by Sales",
          x = "Customer Names",
          y = "Total Sales"
     )

## top customers by profit
top_customers_profit <- customer_performance %>%
     arrange(desc(Total_Profit)) %>%
     slice_head(n = 10)
top_customers_profit

top_customers_profit %>%
     ggplot(aes(
          x = reorder(CustomerName, Total_Profit),
          y = Total_Profit,
          col = Segment
     )) +
     geom_segment(
          aes(
               xend = reorder(CustomerName, Total_Profit),
               y = 0,
               yend = Total_Profit
          ),
          linewidth = 1
     ) +
     geom_point(size = 4) +
     coord_flip() +
     theme_minimal() +
     labs(
          title = "Top 10 Customers by Profit",
          x = "Customer",
          y = "Total Profit"
     )

## loss making customers -------------------------------------------------------
loss_making_customers <- customer_performance %>%
     filter(Total_Profit < 0) %>%
     arrange(Total_Profit)
loss_making_customers

loss_making_customers %>%
     summarise(
          loss_making_customers = n(),
          total_loss = sum(Total_Profit),
          Total_Sales = sum(Total_Sales)
     )

loss_making_customers %>%
     slice_head(n = 10)

loss_making_customers %>%
     ggplot(aes(x = reorder(CustomerName, Total_Profit), Total_Profit))+
     geom_segment(
          aes(
               xend = reorder(CustomerName, Total_Profit),
               y = 0,
               yend = Total_Profit),
          linewidth = 1
     )+
     geom_point(size = 4)+
     coord_flip()+
     theme_minimal()+
     labs(
          title = "Customers we're making losses with",
          x = "Names",
          y = "Total Profit"
     )

## customer sales concentration ------------------------------------------------------
customer_concentration <- customer_performance %>%
     arrange(desc(Total_Sales)) %>%
     mutate(
          customer_rank = row_number(),
          cumulative_sales = cumsum(Total_Sales),
          cumulative_sales_share = 
               cumulative_sales / sum(Total_Sales) * 100,
          customer_share = customer_rank / n() * 100
     )
customer_concentration

### top 10 customers
customer_concentration %>%
     summarise(
          Total_Customers = n(),
          Total_Sales = sum(Total_Sales),
          Top_10_Sales = sum(head(Total_Sales, 10)),
          Top_10_Sales_Share = 
               sum(head(Total_Sales, 10)) / sum(Total_Sales) * 100
     )

### top 20% customers
customer_concentration %>%
     summarise(
          Total_Customers = n(),
          Top_20pct_Customers = ceiling(n() * 0.20),
          Top_20pct_Sales =
               sum(head(Total_Sales, ceiling(n() * 0.20))),
          Top_20pct_Sales_Share =
               sum(head(Total_Sales, ceiling(n() * 0.20))) /
               sum(Total_Sales) * 100
     )

customer_concentration %>%
     ggplot(aes(customer_share, cumulative_sales_share))+
     geom_line(linewidth = 1)+
     geom_point(data = customer_concentration %>% filter(customer_rank %% 50 == 0),
                size = 2)+
     theme_minimal()+
     labs(
          title = "Customer Sales Concentration",
          x = "Cumulative Share of Customers (%)",
          y = "Cumulative Share of Sales (%)"
     )


## customer profit concentration -----------------------------------------------
customer_profit_concentration <- customer_performance %>%
     arrange(desc(Total_Profit)) %>%
     mutate(
          customer_rank = row_number(),
          cumulative_profit = cumsum(Total_Profit),
          cumulative_profit_share = 
               cumulative_profit / sum(Total_Profit) * 100,
          customer_share = customer_rank / n() * 100
     )
customer_profit_concentration

### customers' profitability
customer_profit_concentration %>%
     mutate(
          Customer_Group = if_else(
               customer_rank <= ceiling(n() * 0.20),
               "Top 20%",
               "Remaining 80%"
          )
     ) %>%
     group_by(Customer_Group) %>%
     summarise(
          Average_Profit_Per_Customer = mean(Total_Profit),
          .groups = "drop"
     ) %>%
     summarise(
          Top_20pct_Avg_Profit =
               Average_Profit_Per_Customer[Customer_Group == "Top 20%"],
          Remaining_80pct_Avg_Profit =
               Average_Profit_Per_Customer[Customer_Group == "Remaining 80%"],
          Profit_Ratio =
               Top_20pct_Avg_Profit / Remaining_80pct_Avg_Profit
     )

### top 10 customers by profit
customer_profit_concentration %>%
     summarise(
          Total_Customers = n(),
          Total_Profit = sum(Total_Profit),
          Top_10_Profits = sum(head(Total_Profit, 10)),
          Top_10_Profit_Share =
               sum(head(Total_Profit, 10)) / sum(Total_Profit) * 100
     )

customer_profit_concentration %>%
     summarise(
          Total_Customers = n(),
          Top_20pct_Customers = ceiling(n() * 0.20),
          Top_20pct_Profit =
               sum(head(Total_Profit, ceiling(n() * 0.20))),
          Top_20pct_Profit_Share =
               sum(head(Total_Profit, ceiling(n() * 0.20))) /
               sum(Total_Profit) * 100
     )

customer_profit_concentration %>%
     ggplot(aes(customer_share, cumulative_profit_share))+
     geom_line(linewidth = 1)+
     geom_point(data = customer_profit_concentration %>% filter(customer_rank %% 50 == 0),
                size = 2)+
     theme_minimal()+
     labs(
          title = "Customer Profit Concentration",
          x = "Cumulative Share of Customers (%)",
          y = "Cumulative Share of Profit (%)"
     )

# Discount Profitability -------------------------------------------------------
unique(orders$Discount)

orders %>%
     count(Discount) %>%
     arrange(Discount)

## Profitability by discount levels
discount_profitability <- orders %>%
     group_by(Discount) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = T),
          Total_Profit = sum(Profit, na.rm = T),
          Total_Quantity = sum(Quantity, na.rm = T),
          Number_of_Orders = n_distinct(OrderID),
          profitmargin = (Total_Profit / Total_Sales) * 100,
          .groups = "drop"
     ) %>%
     arrange(Discount)
discount_profitability
### key insight:
### There is a very strong negative association between discount level and profit margin.
### As discount levels increase, profitability decreases. At 0% discount, 
### the company achieves a 25.2% profit margin, which declines to just 0.9% at a 25% discount. 
### At the next observed discount level of 27%, profitability turns negative at -1.9%, 
### indicating that discounts of 27% and above are associated with losses in the aggregated dataset.

## Profitability by discount levels Visualization
discount_profitability %>%
     ggplot(aes(x = Discount, y = profitmargin))+
     geom_line(linewidth = 1)+
     geom_smooth(aes(group = 1),
                 se = F,
                 method = "lm",
                 col = "red")+
     geom_point(size = 3)+
     scale_x_continuous(
          labels = scales::percent_format(accuracy = 1)
     )+
     theme_bw()+
     labs(
          title = "Profit Margin by Discount Level",
          x = "Discount",
          y = "Profit Margin (%)"
     )

## Discount profitability by category
discount_category <- orders %>%
     group_by(Category, Discount) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Number_of_Orders = n_distinct(OrderID),
          Profit_Margin = (Total_Profit / Total_Sales) * 100,
          .groups = "drop"
     ) %>%
     arrange(Category, Discount)
discount_category
### key insight:
### Higher discount levels are generally associated with lower profit margins across all three categories.
### Furniture profitability declines substantially as discounts increase, 
### falling from 24.2% at 0% discount to 3.32% at 25% and becoming negative at 27%.
### 
### Office Supplies maintains positive profitability through the observed 20% discount level 
### but becomes loss-making at 27%, with margins declining substantially at higher discounts.
### 
### Technology profitability falls from 25.6% at 0% discount to -2.13% at 25%, 
### making 25% the first observed discount level with negative aggregate profitability for the category.

## Discount bands
orders_discount <- orders %>%
     mutate(
          Discount_Band = case_when(
               Discount == 0 ~ 'No Discount',
               Discount <= 0.10 ~ 'Low',
               Discount <= 0.20 ~ 'Moderate',
               Discount <= 0.30 ~ 'High',
               Discount <= 0.50 ~ 'Very High',
               Discount > 0.50 ~ 'Extreme'
          )
     )
orders_discount %>%
     count(Discount_Band)

# discount band profitability
discount_band_profitability <- orders_discount %>%
     group_by(Discount_Band) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Number_of_Orders = n_distinct(OrderID),
          Profit_Margin = (Total_Profit / Total_Sales) * 100,
          .groups = "drop"
     ) %>%
     arrange(
          factor(
               Discount_Band,
               levels = c(
                    "No Discount",
                    "Low",
                    "Moderate",
                    "High",
                    "Very High",
                    "Extreme"
               )
          )
     )
discount_band_profitability
### key insight:
### Profitability declines substantially as discount levels increase. Transactions with 
### no discount generated a 25.2% profit margin, compared with 16.5% for low discounts 
### and 9.74% for moderate discounts. Profitability turned negative in the High discount band 
### (>20%–30%), with a -5.61% margin, and deteriorated further to -32.4% for Very High discounts 
### and -111% for Extreme discounts. Overall, the analysis shows a strong association between 
### higher discount levels and declining profitability, with discounts above 20% becoming 
### increasingly unfavorable at the aggregated level.

# discount band by category
discount_band_category <- orders_discount %>%
     group_by(Category, Discount_Band) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Number_of_Orders = n_distinct(OrderID),
          Profit_Margin = (Total_Profit / Total_Sales) * 100,
          .groups = "drop"
     ) %>%
     mutate(
          Discount_Band = factor(
               Discount_Band,
               levels = c(
                    "No Discount",
                    "Low",
                    "Moderate",
                    "High",
                    "Very High",
                    "Extreme"
               )
          )
     ) %>%
     arrange(Category, Discount_Band)
discount_band_category

## discount band by category heatmap
discount_band_category %>%
     ggplot(aes(Discount_Band, Category, fill = Profit_Margin))+
     geom_tile()+
     geom_text(
          aes(label = paste0(round(Profit_Margin, 1), "%")),
          size = 4
     ) +
     scale_fill_gradient2(
          midpoint = 0
     )+
     labs(
          title = "Profit Margin by Discount Band and Category",
          x = "Discount Band",
          y = "Category",
          fill = "Profit Margin (%)"
     ) +
     theme_minimal()

### key insights:
### ### Key Insights
### Profit margins decline as discount levels increase across all three product categories,
### indicating a strong association between higher discount bands and declining profitability.
### 
### Furniture experiences a particularly sharp decline, falling from a 24.2% margin with no discount
### to 4.62% at moderate discounts and -6.18% at high discounts.
### 
### Office Supplies maintains a 13.6% margin at moderate discounts but becomes loss-making 
### in the high discount band at -6.83%.
### 
### Technology retains an 11.7% margin at moderate discounts and reaches -1.18% 
### .in the high discount band, showing a comparatively smaller decline at that stage.
### 
### All three categories experience substantial negative margins at very high and 
### extreme discount levels, with margins falling below -30% in the very high band.
### 
### Overall, the analysis suggests that discount sensitivity varies by category,
###  but higher discount levels are consistently associated with deteriorating profitability.

## discount band by sub category
high_discount_subcategory <- orders_discount %>%
     filter(Discount > 0.20) %>%
     group_by(SubCategory) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Number_of_Orders = n_distinct(OrderID),
          Profit_Margin = (Total_Profit / Total_Sales) * 100,
          .groups = "drop"
     ) %>%
     arrange(Total_Profit)
high_discount_subcategory

### key insights:
### ### Key Insights
### All 17 sub-categories generated negative aggregate profit among transactions 
### receiving discounts above 20%, indicating that high discounting is associated 
### with widespread profitability deterioration across the product portfolio.
### 
### Tables generated the largest absolute loss at approximately $132.5K, reinforcing 
### its position as a major profitability concern identified in earlier sub-category analysis.
### 
### Bookcases and Phones were the next largest contributors to high-discount losses, 
### with approximately $90.4K and $87.1K in losses respectively.
### 
### Some sub-categories experienced particularly severe losses relative to sales. 
### Binders recorded an aggregate profit margin of -89.5%, while Appliances reached -60.6%.
### 
### The analysis also highlights the difference between absolute loss and relative profitability: 
### Tables had the largest dollar loss, while Binders had the lowest margin.
### 
### Overall, higher discount levels are associated with substantial profitability 
### deterioration across all sub-categories, suggesting that discount strategies may 
### need to account for differences in product-level profitability.


# overall performance ----------------------------------------------------------
overall_performance <- orders %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Total_Orders = n_distinct(OrderID),
          Total_Customers = n_distinct(CustomerName),
          Profit_Margin = (Total_Profit / Total_Sales) * 100
     )
overall_performance

### Overall Business Performance
### The Global Superstore dataset contains 25,035 orders from 795 customers, 
### generating approximately $12.64 million in sales and $1.47 million in profit. 
### The business achieved an overall profit margin of 11.6% across 178,312 units sold. 
### This establishes a profitable overall business baseline while providing sufficient transaction, 
### customer, product, and geographic data for deeper profitability and performance analysis.

# category summary -------------------------------------------------------------
category_summary <- orders %>%
     group_by(Category) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Profit_Margin = (Total_Profit / Total_Sales) * 100,
          .groups = "drop"
     ) %>%
     arrange(desc(Total_Profit))
category_summary

### key insights
### Technology generated the highest sales and profit, with approximately $4.74 million in sales, 
### $663.8 thousand in profit, and a 14.0% profit margin. Office Supplies generated lower sales at 
### $3.79 million but maintained a comparable 13.7% margin, demonstrating relatively 
### strong profitability despite lower revenue. Furniture generated $4.11 million in sales 
### but only $285.2 thousand in profit, resulting in the lowest category margin at 6.94%. 
### The results indicate that sales volume alone does not reflect profitability, 
### with Furniture showing substantially lower profit efficiency than Technology and Office Supplies.

# geographical performance -----------------------------------------------------
region_summary <- orders %>%
     group_by(Region) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Total_Quantity = sum(Quantity, na.rm = TRUE),
          Profit_Margin = (Total_Profit / Total_Sales) * 100,
          .groups = "drop"
     ) %>%
     arrange(desc(Total_Sales))
region_summary

### key insights
### Central generated the highest sales and absolute profit at approximately $2.82 million 
### and $311.4 thousand respectively, with an 11.0% profit margin. However, profitability 
### varied considerably across regions. North Asia generated an 19.5% margin despite 
### substantially lower sales than Central, while Canada recorded the highest margin 
### at 26.6% on a much smaller sales base. In contrast, Southeast Asia generated 
### approximately $884.4 thousand in sales but only a 2.02% margin, while EMEA achieved 
### a 5.45% margin. These results demonstrate that geographic performance should be 
### evaluated using both sales scale and profitability rather than sales alone.

# time and seasonality ---------------------------------------------------------
time_summary <- yearly_performance %>%
     mutate(
          Profit_Margin = (Total_Profit / Total_Sales) * 100
     )
time_summary

### key insights
### The business demonstrated consistent growth from 2011 to 2014, with annual sales 
### increasing from approximately $2.26 million to $4.30 million and profit increasing 
### from $248.9 thousand to $504.2 thousand. Profit margins remained relatively stable 
### throughout the period, ranging from 11.0% to 11.9%, with 2013 recording 
### the highest annual margin at 11.9%. Monthly analysis also revealed seasonal variation, 
### with September recording the highest average sales and profit while February 
### recorded the lowest. September generated approximately 2.7 times the average sales 
### and 2.8 times the average profit of February.

# segment profitability --------------------------------------------------------
segment_summary <- orders %>%
     group_by(Segment) %>%
     summarise(
          Total_Sales = sum(Sales, na.rm = TRUE),
          Total_Profit = sum(Profit, na.rm = TRUE),
          Unique_Customers = n_distinct(CustomerName),
          Profit_Margin = (Total_Profit / Total_Sales) * 100,
          Sales_Per_Customer = Total_Sales / Unique_Customers,
          Profit_Per_Customer = Total_Profit / Unique_Customers,
          .groups = "drop"
     ) %>%
     arrange(desc(Total_Sales))
segment_summary

### key insight
### Customer segment analysis shows that Consumer customers generated the largest contribution, 
### with approximately $6.51 million in sales and $749.2 thousand in profit across 409 customers. 
### Corporate generated $3.82 million in sales and $441.2 thousand in profit, 
### while Home Office generated $2.31 million in sales and $277.0 thousand in profit. 
### Although Consumer accounted for the largest share of revenue and profit, 
### profitability efficiency was relatively similar across segments. 
### Home Office recorded the highest profit margin at 12.0% and the highest profit per customer 
### at approximately $1,872, while Corporate had the highest sales per customer 
### at approximately $16,071. This indicates that differences between segments are 
### driven primarily by customer base size rather than major differences in profitability. 
### At the individual-customer level, however, profitability is more concentrated, 
### with the top 20% of customers generating 43.3% of total profit while accounting 
### for only 30.0% of sales.
