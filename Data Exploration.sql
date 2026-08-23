-- Databricks notebook source
SELECT *
FROM brightcoffee_shop.coffee_data.bright_coffee_shop_analysis_case_study_1
LIMIT 10;

----- Creating short name for table-----

USE CATALOG brightcoffee_shop;
USE SCHEMA coffee_data;

SELECT *
FROM bright_coffee_shop_analysis_case_study_1
LIMIT 5;
----------------------------------------------------------------------------------------------------

--- Records-------
SELECT COUNT(*)
FROM bright_coffee_shop_analysis_case_study_1;

--- How Many Unique Transaction IDs-------
SELECT COUNT(DISTINCT transaction_id)
FROM bright_coffee_shop_analysis_case_study_1;
--- Now we know we do not have duplicate transactions --------

---- Data Descriptions-----
DESCRIBE bright_coffee_shop_analysis_case_study_1;

-- The null from this code means that the comment section in the data is NULL not specifically that the data has NULLS---

---- Checking for NULLS-----
SELECT
    COUNT(CASE WHEN transaction_id IS NULL THEN 1 END) AS null_transaction_id,
    COUNT(CASE WHEN transaction_date IS NULL THEN 1 END) AS null_transaction_date,
    COUNT(CASE WHEN transaction_time IS NULL THEN 1 END) AS null_transaction_time,
    COUNT(CASE WHEN transaction_qty IS NULL THEN 1 END) AS null_transaction_qty,
    COUNT(CASE WHEN store_id IS NULL THEN 1 END) AS null_store_id,
    COUNT(CASE WHEN store_location IS NULL THEN 1 END) AS null_store_location,
    COUNT(CASE WHEN product_id IS NULL THEN 1 END) AS null_product_id,
    COUNT(CASE WHEN unit_price IS NULL THEN 1 END) AS null_unit_price,
    COUNT(CASE WHEN product_category IS NULL THEN 1 END) AS null_product_category,
    COUNT(CASE WHEN product_type IS NULL THEN 1 END) AS null_product_type,
    COUNT(CASE WHEN product_detail IS NULL THEN 1 END) AS null_product_detail
FROM bright_coffee_shop_analysis_case_study_1;

---- Our data set has no NULLs as per each column count and case condition result----------

---- The below is to find how many unique items we have in our datasets------
--- Unique IDs-------
SELECT COUNT(DISTINCT product_category)
FROM bright_coffee_shop_analysis_case_study_1;

SELECT COUNT(DISTINCT store_location)
FROM bright_coffee_shop_analysis_case_study_1;

SELECT COUNT(DISTINCT product_type)
FROM bright_coffee_shop_analysis_case_study_1;

SELECT COUNT(DISTINCT product_detail)
FROM bright_coffee_shop_analysis_case_study_1;

SELECT COUNT(DISTINCT product_id)
FROM bright_coffee_shop_analysis_case_study_1;
---- After product_id and prodout_detail giving us 80 we investigated if this product_id has multiple details----
SELECT
    product_id,
    COUNT(DISTINCT product_detail) AS product_detail_count
FROM bright_coffee_shop_analysis_case_study_1
GROUP BY product_id
HAVING COUNT(DISTINCT product_detail) > 1;
-------------------------------------------------
--- we are now aware that the id & detail are consistently related e.g barcode----
------------------------------------------------

----- The earliest and latest transaction dates checks in our data----
SELECT MIN( DISTINCT transaction_date),
       MAX(DISTINCT transaction_date)
FROM bright_coffee_shop_analysis_case_study_1; 

---- above code solution correct but the correct practice of coding----
SELECT
    MIN(transaction_date) AS earliest_date,
    MAX(transaction_date) AS latest_date
FROM bright_coffee_shop_analysis_case_study_1;

----- The earliest and latest transaction time checks in our data----
SELECT
    MIN(transaction_time) AS earliest_time,
    MAX(transaction_time) AS latest_time
FROM bright_coffee_shop_analysis_case_study_1;

---The minimum and maximum number of items purchased in a transaction----
SELECT
    MIN(transaction_qty) AS minium_qty,
    MAX(transaction_qty) AS maximum_qty
FROM bright_coffee_shop_analysis_case_study_1;

---The minimum and maximum unit price in dataset----
SELECT
    MIN(unit_price) AS minium_unit_price,
    MAX(unit_price) AS maximum_unit_price
FROM bright_coffee_shop_analysis_case_study_1;

--- Checking Unit price commas----
SELECT DISTINCT unit_price
FROM bright_coffee_shop_analysis_case_study_1
ORDER BY unit_price;
--------------------------------------
--- no commas
-----------------------------------

----Creating Total_amount column-----
SELECT transaction_qty,
       unit_price,
       (transaction_qty*unit_price) AS Total_Amount
FROM bright_coffee_shop_analysis_case_study_1;

----- checking best performing category in sales--------
SELECT
    product_category,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_revenue
FROM bright_coffee_shop_analysis_case_study_1
GROUP BY product_category
ORDER BY total_revenue DESC;

SELECT
    product_category,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_revenue,transaction_qty
FROM bright_coffee_shop_analysis_case_study_1
GROUP BY product_category,transaction_qty
ORDER BY total_revenue DESC;

----- checking best performing product in sales--------

SELECT
    product_type,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_revenue
FROM bright_coffee_shop_analysis_case_study_1
GROUP BY product_type
ORDER BY total_revenue DESC;

SELECT
    product_type,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_revenue,transaction_qty
FROM bright_coffee_shop_analysis_case_study_1
GROUP BY product_type,transaction_qty
ORDER BY total_revenue DESC;

---- Total Revenue generated-----
SELECT SUM(Total_Amount)
       AS Total_revenue
FROM bright_coffee_shop_analysis_case_study_1;
----- The above did not work as the column above is a temporary column, fixing this with aggregate calculation method------

SELECT SUM(transaction_qty * unit_price) AS total_revenue
FROM bright_coffee_shop_analysis_case_study_1;

----When does Bright Coffee perform best during the day?----
--- The time stamp is HH:MM:SS, we simplify it before creating a bucket------
SELECT
    transaction_time,
    HOUR(transaction_time) AS transaction_hour
FROM bright_coffee_shop_analysis_case_study_1
LIMIT 10;
---- Transaction_time_bucket------
SELECT DISTINCT DATE_FORMAT(transaction_time,'HH:MM:SS')
FROM bright_coffee_shop_analysis_case_study_1;

SELECT
    transaction_time,
    HOUR(transaction_time) AS transaction_hour,
    CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN '06:00–09:00'
        WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN '09:00–12:00'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN '12:00–15:00'
        WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15:00–18:00'
        WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN '18:00–21:00'
    END AS transaction_time_bucket
FROM bright_coffee_shop_analysis_case_study_1;

----- Checking number of transactions & Revenue in each time bucket------

SELECT
    CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN '06:00-09:00'
        WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN '09:00-12:00'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN '12:00-15:00'
        WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15:00-18:00'
        WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN '18:00-21:00'
    END AS transaction_time_bucket,
    COUNT(*) AS transaction_time_count,
    ROUND(SUM(unit_price * transaction_qty),2) AS total_revenue
FROM bright_coffee_shop_analysis_case_study_1
GROUP BY
    CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN '06:00-09:00'
        WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN '09:00-12:00'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN '12:00-15:00'
        WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15:00-18:00'
        WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN '18:00-21:00'
    END;

----- Checking  transactions & Revenue of each revenue product type------
    SELECT
    CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN '06:00-09:00'
        WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN '09:00-12:00'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN '12:00-15:00'
        WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15:00-18:00'
        WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN '18:00-21:00'
    END AS transaction_time_bucket,

    product_type,

    SUM(transaction_qty) AS total_units_sold,

    ROUND(SUM(unit_price * transaction_qty), 2) AS total_revenue

FROM bright_coffee_shop_analysis_case_study_1

GROUP BY
    CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN '06:00-09:00'
        WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN '09:00-12:00'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN '12:00-15:00'
        WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15:00-18:00'
        WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN '18:00-21:00'
    END,
    product_type

ORDER BY
    transaction_time_bucket,
    total_units_sold DESC;

--- checking all transactons are in
SELECT
    COUNT(*) AS total_records,
    COUNT(
        CASE
            WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN 1
            WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN 1
            WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN 1
            WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN 1
            WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN 1
        END
    ) AS bucketed_records
FROM bright_coffee_shop_analysis_case_study_1;

---Duplicate Checks----------------------------------------------------------
--- checks all the table data than to do each column check-------
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT *) AS unique_rows
FROM bright_coffee_shop_analysis_case_study_1;

SELECT DISTINCT
    product_category,
    CASE 
        WHEN product_category IS NULL THEN 'Unknown'
        WHEN TRIM(product_category) = '' THEN 'Unknown'
        ELSE product_category
    END AS product_cat
FROM bright_coffee_shop_analysis_case_study_1;

SELECT DISTINCT
    product_type,
    CASE 
        WHEN product_type IS NULL THEN 'Unknown'
        WHEN TRIM(product_type) = '' THEN 'Unknown'
        ELSE product_type
    END AS product_typ
FROM bright_coffee_shop_analysis_case_study_1;


----- Date Column -month name-----------------------------
SELECT DISTINCT DATE_FORMAT(transaction_date,'MMMM') AS Month_name
FROM bright_coffee_shop_analysis_case_study_1;

SELECT DISTINCT
       DATE_FORMAT(transaction_date, 'MM') AS Month_number,
       DATE_FORMAT(transaction_date, 'MMMM') AS Month_name
FROM bright_coffee_shop_analysis_case_study_1;

------checking day of week -----------
SELECT
    CASE 
    WHEN DAYOFWEEK(transaction_date) = 1 THEN 'Sunday'
    WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
    WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
    WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
    WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
    WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
    WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
    END AS Day_type
FROM bright_coffee_shop_analysis_case_study_1;

----Revenue by location---------
SELECT
    store_location,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_revenue
FROM bright_coffee_shop_analysis_case_study_1
GROUP BY store_location
ORDER BY total_revenue DESC;

----High/Low product performance------
SELECT
    MAX(transaction_qty * unit_price) AS highest_transaction_value,
    MIN(transaction_qty * unit_price) AS lowest_transaction_value
FROM bright_coffee_shop_analysis_case_study_1;
-----which product generates the highest/lowest revenue----------
SELECT
    product_detail,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_revenue
FROM bright_coffee_shop_analysis_case_study_1
GROUP BY product_detail
ORDER BY total_revenue DESC;

SELECT
    product_detail,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_revenue
FROM bright_coffee_shop_analysis_case_study_1
GROUP BY product_detail
ORDER BY total_revenue ASC;

----which product type sells most units-----
SELECT
    product_type,
    SUM(transaction_qty) AS total_units_sold
FROM bright_coffee_shop_analysis_case_study_1
GROUP BY product_type
ORDER BY total_units_sold DESC;

SELECT
    product_type,
    SUM(transaction_qty) AS total_units_sold
FROM bright_coffee_shop_analysis_case_study_1
GROUP BY product_type
ORDER BY total_units_sold ASC;






