# Final Power BI QA Checklist

Before publishing the repository, check these items in Power BI:

1. **Customer & Segment screenshot**
   - The current screenshot has `Year = 2014`.
   - Reset Year to `All` and re-export if you want the portfolio screenshot to represent the full 2011–2014 dataset.

2. **Geographic Performance — Regional Profit Margin**
   - A pie chart is not ideal for profit margin because margins are rates and do not form a meaningful whole.
   - Prefer a sorted bar/lollipop chart by Profit Margin.

3. **Product count KPI**
   - Recheck the `Products` card.
   - Use a DISTINCTCOUNT of the intended product identifier/name rather than a row count.

4. **Discount page**
   - The current screenshots use exact discount levels.
   - If you want the dashboard to match the R analysis and original plan exactly, add the validated discount bands:
     No Discount, Low, Moderate, High, Very High, Extreme.

5. **KPI formatting**
   - Consider showing Total Sales and Total Profit with two decimal places in millions
     (for example `$12.64M` and `$1.47M`) instead of `$13M` and `$1M`.

6. **Top/Bottom N**
   - Confirm every Top 10 / Bottom 10 visual has an actual Top N/Bottom N visual filter,
     not only ascending/descending sorting.

After these checks, overwrite the corresponding PNG files in `images/` with the final exports.
