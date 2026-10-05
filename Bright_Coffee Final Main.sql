-- Databricks notebook source


USE CATALOG brightcoffee_shop;
USE SCHEMA coffee_data;

CREATE OR REPLACE TABLE bright_coffee_shop_processed AS

WITH coffee_data AS (

    SELECT
        transaction_id,

        -- DATE
        CAST(transaction_date AS DATE) AS transaction_date,

        -- DAY
        DAYOFWEEK(CAST(transaction_date AS DATE)) AS day_number,

        CASE
            WHEN DAYOFWEEK(CAST(transaction_date AS DATE)) = 1 THEN 'Sunday'
            WHEN DAYOFWEEK(CAST(transaction_date AS DATE)) = 2 THEN 'Monday'
            WHEN DAYOFWEEK(CAST(transaction_date AS DATE)) = 3 THEN 'Tuesday'
            WHEN DAYOFWEEK(CAST(transaction_date AS DATE)) = 4 THEN 'Wednesday'
            WHEN DAYOFWEEK(CAST(transaction_date AS DATE)) = 5 THEN 'Thursday'
            WHEN DAYOFWEEK(CAST(transaction_date AS DATE)) = 6 THEN 'Friday'
            WHEN DAYOFWEEK(CAST(transaction_date AS DATE)) = 7 THEN 'Saturday'
        END AS day_name,

        -- MONTH
        DATE_FORMAT(CAST(transaction_date AS DATE),'MMMM') AS month_name,

        MONTH(CAST(transaction_date AS DATE)) AS month_number,

        YEAR(CAST(transaction_date AS DATE)) AS year,

        -- TRANSACTION TIME
        transaction_time,

        HOUR(transaction_time) AS transaction_hour,

        -- YOUR 3-HOUR TIME BUCKET
        CASE
            WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN '06:00-09:00'
            WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN '09:00-12:00'
            WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN '12:00-15:00'
            WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15:00-18:00'
            WHEN HOUR(transaction_time) BETWEEN 18 AND 20  THEN '18:00-21:00'
        END AS transaction_time_bucket,

        -- TRANSACTION DETAILS
        transaction_qty,
        store_id,
        store_location,
        product_id,

        -- PRODUCT CATEGORY
        CASE
            WHEN product_category IS NULL THEN 'Unknown'
            WHEN TRIM(product_category) = '' THEN 'Unknown'
            ELSE product_category
        END AS product_category,

        -- PRODUCT TYPE
        CASE
            WHEN product_type IS NULL THEN 'Unknown'
            WHEN TRIM(product_type) = '' THEN 'Unknown'
            ELSE product_type
        END AS product_type,

        product_detail,

        -- UNIT PRICE
        CAST(unit_price AS DECIMAL(10,2)) AS unit_price,

        -- TOTAL TRANSACTION VALUE
        CAST(
            ROUND(transaction_qty * unit_price, 2)
            AS DECIMAL(10,2)
        ) AS total_amount
    FROM bright_coffee_shop_analysis_case_study_1)

SELECT *
FROM coffee_data;

SELECT COUNT(*) AS total_rows
FROM bright_coffee_shop_processed;

SELECT * 
FROM bright_coffee_shop_processed;

--------------------------------------------------------------------------
--- testing CTE-- 
SELECT COUNT(*) AS total_rows
FROM bright_coffee_shop_processed;

DESCRIBE bright_coffee_shop_processed;


USE CATALOG brightcoffee_shop;

USE SCHEMA coffee_data;

SHOW TABLES;


SELECT DISTINCT store_location
FROM bright_coffee_shop_processed;


