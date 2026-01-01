# Florida Retail & Environmental Analytics Project

## Project Overview
This project provides a data-driven analysis of retail performance across various locations in Florida (including Miami Beach and Jacksonville) for the years 2023 and 2024. By integrating daily sales figures with customer demographic surveys and local weather patterns, this project identifies the key drivers of retail foot traffic and revenue.

The core of the project is a **Power BI Dashboard** that visualizes these correlations to support strategic business decisions regarding staffing, marketing, and inventory management.

## Project Structure
The repository is organized into data assets, processing scripts, and visualization files:

* **Data Files (CSV)**
    * `sales_2yrs.csv`: Daily transactional data including `shop_id`, `customers`, and `sales_usd`.
    * `survey_2yrs.csv`: Daily demographic breakdowns (Male/Female %, Family/Single %).
    * `weather_2yrs.csv`: Daily climate data (Temperature, Precipitation, Rain indicators, and Humidity).
* **Engineering**
    * `florida_retail.sql`: SQL script containing the Data Definition Language (DDL) and the logic for joining disparate datasets into a unified view.
* **Visualization**
    * `Miami Retail Dashboard.pbix`: The primary Power BI report file.

## Data Pipeline & Logic
The analysis relies on a centralized view created via SQL. The transformation logic handles:
1.  **Temporal Feature Engineering**: Categorizes dates into `day_of_week` and creates a `is_weekend` flag to analyze high-traffic periods.
2.  **KPI Generation**: Calculates `sales_per_customer` to measure purchasing power independently of foot traffic volume.
3.  **Data Integration**: Uses a `LEFT JOIN` strategy to align customer surveys and weather metrics with specific sales dates.

```sql
-- Example logic from florida_retail.sql
CREATE OR REPLACE VIEW retail.table_joined AS
SELECT 
    s.date,
    DAYNAME(date) AS day_of_week,
    CASE WHEN WEEKDAY(date) IN (5,6) THEN "Weekend" ELSE "Weekday" END AS is_weekend,
    s.sales_usd,
    ROUND(s.sales_usd/s.customers, 2) AS sales_per_customer,
    w.avg_temp_f,
    w.is_rain
FROM retail.sales s
LEFT JOIN retail.survey su USING(date)
LEFT JOIN retail.weather w USING(date);
