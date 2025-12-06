# credit-card-fraud-sql-project
"SQL-based fraud detection project using 555,720 transaction dataset"
Fraud Detection Using SQL (MySQL)

SQL Project on 555,720 Credit Card Transactions

📌 Project Overview

This project analyzes 555,720 real-world credit card transactions to identify fraud patterns using SQL.
It demonstrates strong skills in data cleaning, ETL, schema design, analytical SQL, optimization, and fraud analysis — perfect for a Data Analyst, Data Scientist, or SQL Engineer role.

The dataset contains timestamps, geolocation data, merchant information, transaction amount, card details, customer profile, and the fraud label.

🎯 Objectives

Build a clean relational database for a large transactional dataset

Load raw CSV data into MySQL efficiently

Fix data type issues (BIGINT, DECIMAL, DATETIME, etc.)

Design a robust schema with primary keys, auto-increment, and indexes

Run analytical SQL queries to identify:

Fraud patterns

Merchant/category-level risks

High-risk locations

Customer behavior

Time-based patterns

Create a reusable fraud analytics SQL portfolio project

🗂️ Database Schema
Table: transactions
CREATE TABLE transactions (
    trans_date_trans_time   DATETIME,
    cc_num                  BIGINT,
    merchant                VARCHAR(255),
    category                VARCHAR(50),
    amt                     DECIMAL(10,2),
    first_name              VARCHAR(100),
    last_name               VARCHAR(100),
    gender                  CHAR(1),
    street                  VARCHAR(255),
    city                    VARCHAR(100),
    state                   CHAR(2),
    zip                     INT,
    latitude                DECIMAL(10,6),
    longitude               DECIMAL(10,6),
    city_pop                INT,
    job                     VARCHAR(255),
    dob                     DATE,
    trans_num               VARCHAR(100),
    unix_time               BIGINT,
    merch_lat               DECIMAL(10,6),
    merch_long              DECIMAL(10,6),
    is_fraud                TINYINT,
    PRIMARY KEY (trans_num)
);

Auto-Increment Transaction ID
ALTER TABLE transactions
ADD COLUMN sr_no BIGINT AUTO_INCREMENT UNIQUE FIRST;

📥 Loading the Dataset (MySQL)
1. Move CSV files into MySQL Uploads directory
C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\

2. Enable Local Infile

Start MySQL with:

mysql --local-infile=1 -u root -p


Then enable:

SET GLOBAL local_infile = 1;

3. Load CSV (clean + safe)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fraudTest_1.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @row_id,
    trans_date_trans_time,
    @cc_num,
    merchant,
    category,
    amt,
    first_name,
    last_name,
    gender,
    street,
    city,
    state,
    zip,
    latitude,
    longitude,
    city_pop,
    job,
    dob,
    trans_num,
    unix_time,
    merch_lat,
    merch_long,
    is_fraud
)
SET cc_num = CAST(@cc_num AS DECIMAL(20,0));


Repeat for all CSV chunks (fraudTest_1 to fraudTest_6).

📊 Analysis Performed (SQL)
1. Total Transactions & Fraud Count
SELECT 
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS total_fraud,
    ROUND(SUM(is_fraud) / COUNT(*) * 100, 2) AS fraud_rate
FROM transactions;

2. Fraud by Category
SELECT category, 
       COUNT(*) AS total_txn,
       SUM(is_fraud) AS fraud_txn
FROM transactions
GROUP BY category
ORDER BY fraud_txn DESC;

3. Top 10 High-Risk Merchants
SELECT merchant,
       COUNT(*) AS total_txn,
       SUM(is_fraud) AS fraud_txn
FROM transactions
GROUP BY merchant
ORDER BY fraud_txn DESC
LIMIT 10;

4. Fraud by State
SELECT state,
       SUM(is_fraud) AS fraud_cases
FROM transactions
GROUP BY state
ORDER BY fraud_cases DESC;

5. Fraud by Transaction Hour
SELECT 
    HOUR(trans_date_trans_time) AS hour,
    SUM(is_fraud) AS fraud_cases
FROM transactions
GROUP BY hour
ORDER BY fraud_cases DESC;

📈 Key Insights

Fraud spikes during late-night and early-morning hours

Certain categories (like shopping_net & misc_net) show higher fraud concentration

A small number of merchants contribute disproportionately to fraud

High-population cities tend to have more fraudulent activities

Fraud amounts tend to be small and designed to blend with normal purchases

🛠️ Tech Stack

MySQL 8.0

SQL (DDL, DML, ETL, Aggregations, Window Functions)

Data Cleaning

Windows OS

GitHub

📦 Folder Structure
Fraud-Detection-SQL-Project/
│── schema.sql        # Database schema
│── queries.sql       # All analysis queries
│── README.md         # This file

🚀 How to Run This Project
Step 1 — Clone the Repository
git clone https://github.com/<your-username>/fraud-detection-sql-project

Step 2 — Create the database
mysql> SOURCE schema.sql;

Step 3 — Load your CSV chunks

Place them into the Uploads folder and run LOAD DATA INFILE.

Step 4 — Run Analysis Queries
mysql> SOURCE queries.sql;


🙋‍♂️ Author

Divya Kathare
SQL • Data Analyst • Data Science Enthusiast
GitHub:https://github.com/Divya-Kathare
LinkedIn:www.linkedin.com/in/divya-kathare-41323a3a0

⭐ Support the Project

If this helped you, star the repository on GitHub to support the work!
