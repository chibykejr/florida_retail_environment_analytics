CREATE OR REPLACE VIEW retail.table_joined AS
SELECT 
s.date,
DAYNAME(date) AS day_of_week,
CASE WHEN WEEKDAY(date) IN (5,6) THEN "Weekend" ELSE "Weekday" END AS is_weekend,
s.shop_id,
s.shop_name,
s.customers,
s.sales_usd,
ROUND(s.sales_usd/s.customers, 2) AS sales_per_customer,
su.pct_male,
su.pct_female,
su.pct_family,
su.pct_single,
w.avg_temp_f,
w.precip_in,
w.is_rain,
w.humidity_pct
FROM retail.sales s
LEFT JOIN retail.survey su
USING(date)
LEFT JOIN retail.weather w
USING(date);