Full End-to-End Data Engineering + SQL Analytics Project

This project analyzes 555,720 credit card transactions to detect fraud patterns using SQL (MySQL).
It includes database design, data cleaning, ETL, analytical SQL, geolocation-based insights, and fraud trend reports.

Dataset Source (Kaggle):
👉 https://www.kaggle.com/code/youssefelbadry10/credit-card-fraud-detection

📌 Project Overview

This project shows how to work with a large real-world financial dataset and turn it into a structured analytics environment using SQL.

You’ll find work demonstrating:

Database schema design

ETL with LOAD DATA INFILE

Handling large datasets by splitting into multiple CSV files

Fixing numeric and geolocation data issues

Fraud analytics using SQL

Building a reusable project for analytics portfolios

The dataset contains:

Customer details

Location (lat/long, city, state)

Merchant information

Transaction amount

Timestamps

Fraud labels

🎯 Objectives

Build a clean relational database

Load large CSV files efficiently

Fix data type issues (BIGINT, DECIMAL, DATETIME, DOUBLE)

Run analytical SQL to uncover fraud trends

Create a GitHub-ready SQL project

🗂️ Database Schema
CREATE TABLE transactions (
    trans_date_trans_time DATETIME,
    cc_num                BIGINT,
    merchant              VARCHAR(255),
    category              VARCHAR(50),
    amt                   DECIMAL(10,2),
    first_name            VARCHAR(100),
    last_name             VARCHAR(100),
    gender                CHAR(1),
    street                VARCHAR(255),
    city                  VARCHAR(100),
    state                 CHAR(2),
    zip                   INT,
    latitude              DOUBLE,
    longitude             DOUBLE,
    city_pop              INT,
    job                   VARCHAR(255),
    dob                   DATE,
    trans_num             VARCHAR(100),
    unix_time             BIGINT,
    merch_lat             DOUBLE,
    merch_long            DOUBLE,
    is_fraud              TINYINT,
    PRIMARY KEY (trans_num)
);

Auto-increment Primary Index
ALTER TABLE transactions
ADD COLUMN sr_no BIGINT AUTO_INCREMENT UNIQUE FIRST;

🧩 Handling Large Dataset (555,720 rows)
Why the dataset was split

MySQL often struggles with a single huge CSV because of:

secure-file-priv restrictions

memory limits

timeout when loading ~600k rows

row length overflow

So the dataset was split into multiple files, for example:

fraudTest_1.csv  
fraudTest_2.csv  
fraudTest_3.csv  
fraudTest_4.csv  
fraudTest_5.csv  
fraudTest_6.csv


This makes ETL faster, safer, and easier to debug.

🛠️ Fixing Latitude & Longitude Errors

MySQL DECIMAL(10,6) caused rounding issues for some rows.

So we upgraded to DOUBLE:

ALTER TABLE transactions
MODIFY latitude   DOUBLE,
MODIFY longitude  DOUBLE,
MODIFY merch_lat  DOUBLE,
MODIFY merch_long DOUBLE;

📥 Loading Each CSV Chunk (ETL Process)

Move all CSV files into MySQL uploads directory:

C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\


Enable local file loading:

SET GLOBAL local_infile = 1;


Start MySQL with local-infile enabled:

mysql --local-infile=1 -u root -p


Use this template to load each CSV file
(Just change the filename for each chunk):

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


Repeat for:

fraudTest_2.csv  
fraudTest_3.csv  
fraudTest_4.csv  
fraudTest_5.csv  
fraudTest_6.csv  

📊 Analysis Performed (SQL Insights)
1. Total Transactions, Fraud Count & Fraud Rate
SELECT 
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS total_fraud,
    ROUND(SUM(is_fraud)/COUNT(*) * 100, 2) AS fraud_rate
FROM transactions;

2. Fraud by Category
SELECT category, COUNT(*) AS total_txn, SUM(is_fraud) AS fraud_txn
FROM transactions
GROUP BY category
ORDER BY fraud_txn DESC;

3. Top 10 High-Risk Merchants
SELECT merchant, COUNT(*) AS total_txn, SUM(is_fraud) AS fraud_txn
FROM transactions
GROUP BY merchant
ORDER BY fraud_txn DESC
LIMIT 10;

4. Fraud by State
SELECT state, SUM(is_fraud) AS fraud_cases
FROM transactions
GROUP BY state
ORDER BY fraud_cases DESC;

5. Fraud by Transaction Hour
SELECT HOUR(trans_date_trans_time) AS hour, SUM(is_fraud) AS fraud_cases
FROM transactions
GROUP BY hour
ORDER BY fraud_cases DESC;

📈 Key Insights

Fraud activity spikes during late-night and early-morning hours

Categories like shopping_net and misc_net show highest fraud

A small number of merchants contribute most fraud cases

Large cities show bulk of fraudulent transactions

Fraud amounts are often small, intended to bypass detection

📦 Folder Structure
Fraud-Detection-SQL-Project/
│── schema.sql
│── queries.sql
│── README.md
│── data/  # (optional folder for CSV)

🚀 How to Run This Project
Step 1 — Clone the repository
git clone https://github.com/<your-username>/fraud-detection-sql-project

Step 2 — Create the database
SOURCE schema.sql;

Step 3 — Load CSV chunks

Place them into MySQL uploads folder and run LOAD DATA INFILE.

Step 4 — Run analysis
SOURCE queries.sql;

🙋‍♂️ Author

Divya Kathare
SQL • Data Analyst • Data Science Enthusiast

GitHub: https://github.com/Divya-Kathare

LinkedIn: https://www.linkedin.com/in/divya-kathare-41323a3a0

⭐ Support the Project

If you found this helpful, please star this repository on GitHub!
