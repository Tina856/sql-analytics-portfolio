CREATE TABLE IF NOT EXISTS sales_analysis AS
SELECT
    s.transaction_id,

    o.order_date,
    o.year,
    o.quarter,
    o.month,

    c.customer_name,
    c.city,
    c.zip_code,

    p.product_name,
    p.category,
    p.price,

    e.first_name  AS employee_first_name,
    e.last_name   AS employee_last_name,
    e.salary      AS employee_salary,

    s.quantity,
    s.discount,
    s.total_sales

FROM sales AS s
JOIN orders AS o
    ON s.order_id = o.order_id
JOIN customers AS c
    ON s.customer_id = c.customer_id
JOIN products AS p
    ON s.product_id = p.product_id
LEFT JOIN employees AS e
    ON s.employee_id = e.employee_id;



	CREATE INDEX idx_sales_analysis_order_date
    ON sales_analysis(order_date_date);

CREATE INDEX idx_sales_analysis_year
    ON sales_analysis(year);

CREATE INDEX idx_sales_analysis_city
    ON sales_analysis(city);

CREATE INDEX idx_sales_analysis_category
    ON sales_analysis(category);



SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'your_table_name';


CREATE INDEX idx_sales_analysis_order_date
    ON sales_analysis(order_date);

CREATE INDEX idx_sales_analysis_year
    ON sales_analysis(year);

CREATE INDEX idx_sales_analysis_city
    ON sales_analysis(city);

CREATE INDEX idx_sales_analysis_category
    ON sales_analysis(category);


SELECT
    transaction_id,
    order_date,
    category,
    total_sales
FROM sales_analysis
WHERE total_sales > 100000;

SELECT
    transaction_id,
    city,
    category,
    total_sales
FROM sales_analysis
WHERE city = 'East Amanda';



SELECT 
   customer_name,
   SUM(total_sales) as total_sales
   FROM sales_analysis
   GROUP by customer_name
   Order by SUM(total_sales)  DESC
   LIMIT 10;

   SELECT
    *,
    CASE 
        WHEN customer_name IN (
            'Laura Brown',
            'Michael Smith',
            'Kurt Hayes',
            'Justin Clark',
            'David Lopez',
            'Cathy Mckenzie',
            'Paul Smith',
            'James Moore',
            'Danielle Carter',
            'Julie Clark'
        )
        THEN 'Top_10'
        ELSE 'Other'
    END AS top_clients
FROM sales_analysis;



-- homework

SELECT
  DATE_TRUNC('month', order_date_date) AS month,
  SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY DATE_TRUNC('month', order_date_date)
ORDER BY month;


SELECT 
  DATE_TRUNC('quarter', order_date_date) as quarter,
  SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY DATE_TRUNC('quarter', order_date_date)
ORDER BY quarter;


SELECT
  DATE_TRUNC('year', order_date_date) as year,
  SUM(total_sales) as total_revenue
 FROM sales_analysis
 GROUP BY DATE_TRUNC('year', order_date_date)
 ORDER BY year;


--Monthly grain-ը ցույց է տալիս կարճաժամկետ տատանումներ և սեզոնայնություն

--Quarterly aggregation-ը հարթում է աղմուկը և օգնում է համեմատել բիզնես շրջանները

--Yearly aggregation-ը բացահայտում է երկարաժամկետ աճի կամ անկման ուղղությունը

--Տարբեր grain-ներ օգտագործելիս նույն տվյալներից ստացվում են տարբեր եզրակացություններ