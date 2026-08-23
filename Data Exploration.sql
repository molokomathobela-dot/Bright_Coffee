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

---- Total Revenue generated-----
SELECT SUM(Total_Amount)
       AS Total_revenue
FROM bright_coffee_shop_analysis_case_study_1;
----- The above did not work as the column above is a temporary column, fixing this with aggregate calculation method------

SELECT SUM(transaction_qty * unit_price) AS total_revenue
FROM bright_coffee_shop_analysis_case_study_1;

----When does Bright Coffee perform best?----

