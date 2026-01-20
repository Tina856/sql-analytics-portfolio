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


-- ## Creating Geographical Tables
-- Now we define the analytical data model that will be used throughout this module.
-- The schema follows a normalized (3NF) design with a clear geographic hierarchy:
-- Country → Region → City → Customer


--Countires
--This table represents sovereign countries and serves as the top-level geographic entity.
CREATE TABLE analytics.countries (
    country_id   INT PRIMARY KEY,
    country_name TEXT NOT NULL
);

--Regions
CREATE TABLE analytics.regions (
    region_id   INT PRIMARY KEY,
    region_name TEXT NOT NULL,
    country_id  INT NOT NULL REFERENCES analytics.countries(country_id)
);

-- Cities
CREATE TABLE analytics.cities (
    city_id   INT PRIMARY KEY,
    city_name TEXT NOT NULL,
    region_id INT NOT NULL REFERENCES analytics.regions(region_id)
);

-- Creating Non Geographical Tables
-- Customers
CREATE TABLE analytics.customers (
    customer_id INT PRIMARY KEY,
    first_name  TEXT NOT NULL,
    last_name   TEXT NOT NULL,
    age         INT CHECK (age BETWEEN 16 AND 100),
    email       TEXT UNIQUE,
    city_id     INT REFERENCES analytics.cities(city_id),
    signup_date DATE NOT NULL
);

-- Products
CREATE TABLE analytics.products (
    product_id   INT PRIMARY KEY,
    product_name TEXT NOT NULL,
    category     TEXT NOT NULL,
    price        NUMERIC(10,2) NOT NULL
);

-- Orders
CREATE TABLE analytics.orders (
    order_id    INT PRIMARY KEY,
    customer_id INT REFERENCES analytics.customers(customer_id),
    order_date  DATE NOT NULL,
    status      TEXT NOT NULL
);

-- Order Items
CREATE TABLE analytics.order_items (
    order_item_id INT PRIMARY KEY,
    order_id      INT NOT NULL REFERENCES analytics.orders(order_id),
    product_id    INT NOT NULL REFERENCES analytics.products(product_id),
    quantity      INT NOT NULL CHECK (quantity > 0)
);

-- Country Boundaries
-- These tables extend the relational model with geometries, enabling spatial joins.

CREATE TABLE analytics.country_boundaries (
    country_id INT PRIMARY KEY REFERENCES analytics.countries(country_id),
    geom       GEOMETRY(MultiPolygon, 4326)
);

-- Region Boundaries
CREATE TABLE analytics.region_boundaries (
    region_id INT PRIMARY KEY REFERENCES analytics.regions(region_id),
    geom      GEOMETRY(Polygon, 4326)
);

-- City Boundaries
CREATE TABLE analytics.city_boundaries (
    city_id INT PRIMARY KEY REFERENCES analytics.cities(city_id),
    geom    GEOMETRY(Polygon, 4326)
);

-- Customer Locations
CREATE TABLE analytics.customer_locations (
    customer_id INT PRIMARY KEY REFERENCES analytics.customers(customer_id),
    geom        GEOMETRY(Point, 4326)
);

-- Checking
SELECT pg_ls_dir('/data');


-- analytics.countries
COPY analytics.countries
FROM '/data/countries.csv'
CSV HEADER;

SELECT * FROM analytics.countries;

-- analytics.regions
COPY analytics.regions
FROM '/data/regions.csv'
CSV HEADER;

SELECT * FROM analytics.regions;

-- analytics.cities
COPY analytics.cities
FROM '/data/cities.csv'
CSV HEADER;

SELECT * FROM analytics.cities;

-- analytics.customers
COPY analytics.customers
FROM '/data/customers.csv'
CSV HEADER;

SELECT * FROM analytics.customers LIMIT 10;

-- analytics.products
COPY analytics.products
FROM '/data/products.csv'
CSV HEADER;

SELECT * FROM analytics.products;

-- analytics.orders
COPY analytics.orders
FROM '/data/orders.csv'
CSV HEADER;

SELECT * FROM analytics.orders LIMIT 10;

-- analytics.order_items
COPY analytics.order_items
FROM '/data/order_items.csv'
CSV HEADER;

SELECT * FROM analytics.order_items LIMIT 10;



-- CREATE TABLE IF NOT EXISTS analytics._stg_country_boundaries (
--    country_id INT,
--    wkt TEXT
--);

-- CREATE TABLE IF NOT EXISTS analytics._stg_region_boundaries (
--    region_id INT,
--    wkt TEXT
--);

-- CREATE TABLE IF NOT EXISTS analytics._stg_city_boundaries (
--    city_id INT,
--    wkt TEXT
--);

-- CREATE TABLE IF NOT EXISTS analytics._stg_points (
--    point_id INT,
--    wkt TEXT
--);



COPY analytics._stg_country_boundaries
FROM '/data/country_boundaries.csv'
CSV HEADER;

SELECT * FROM analytics._stg_country_boundaries;

COPY analytics._stg_region_boundaries
FROM '/data/region_boundaries.csv'
CSV HEADER;

SELECT * FROM analytics._stg_region_boundaries;

COPY analytics._stg_city_boundaries
FROM '/data/city_boundaries.csv'
CSV HEADER;

SELECT * FROM analytics._stg_city_boundaries;


COPY analytics._stg_points
FROM '/data/customer_locations.csv'
CSV HEADER;

SELECT * FROM analytics._stg_points;


-- analytics.country_boundaries
INSERT INTO analytics.country_boundaries (country_id, geom)
SELECT
  country_id,
  ST_GeomFromText(wkt, 4326)
FROM analytics._stg_country_boundaries;


-- analytics.region_boundaries
INSERT INTO analytics.region_boundaries (region_id, geom)
SELECT
  region_id,
  ST_GeomFromText(wkt, 4326)
FROM analytics._stg_region_boundaries;

-- analytics.city_boundaries
INSERT INTO analytics.city_boundaries (city_id, geom)
SELECT
  city_id,
  ST_GeomFromText(wkt, 4326)
FROM analytics._stg_city_boundaries;

-- analytics.customer_locations
INSERT INTO analytics.customer_locations (customer_id, geom)
SELECT
  point_id,
  ST_GeomFromText(wkt, 4326)
FROM analytics._stg_points;


-- Geometry checks
SELECT
  COUNT(*) FILTER (WHERE ST_IsValid(geom)) AS valid_geom,
  COUNT(*) AS total
FROM analytics.country_boundaries;

SELECT
  ST_GeometryType(geom),
  COUNT(*)
FROM analytics.country_boundaries
GROUP BY 1;


-- Geometry Validation
SELECT
  COUNT(*) FILTER (WHERE ST_IsValid(geom)) AS valid_geometries,
  COUNT(*) AS total_geometries
FROM analytics.city_boundaries;

SELECT
  COUNT(*) FILTER (WHERE ST_SRID(geom) = 4326) AS correct_srid,
  COUNT(*) AS total_geometries
FROM analytics.city_boundaries;



SELECT * FROM analytics.country_boundaries;