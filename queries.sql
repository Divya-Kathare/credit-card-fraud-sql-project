USE Fraud_Detection;

-- Fraud rate
SELECT COUNT(*) AS total,
       SUM(is_fraud) AS frauds,
       ROUND(100 * SUM(is_fraud)/COUNT(*), 4) AS fraud_rate
FROM transactions;

-- Fraud by category
SELECT category,
       COUNT(*) AS total,
       SUM(is_fraud) AS frauds,
       ROUND(100 * SUM(is_fraud)/COUNT(*), 3) AS fraud_rate
FROM transactions
GROUP BY category
ORDER BY fraud_rate DESC;

-- Fraud by merchant
SELECT merchant,
       COUNT(*) AS total,
       SUM(is_fraud) AS frauds,
       ROUND(100 * SUM(is_fraud)/COUNT(*), 2) AS fraud_rate
FROM transactions
GROUP BY merchant
HAVING COUNT(*) >= 100
ORDER BY frauds DESC;

-- Fraud by hour
SELECT HOUR(trans_date_trans_time) AS hr,
       COUNT(*) AS total,
       SUM(is_fraud) AS frauds,
       ROUND(100 * SUM(is_fraud)/COUNT(*), 3) AS fraud_rate
FROM transactions
GROUP BY hr
ORDER BY hr;

-- Age group analysis
SELECT
    CASE
        WHEN TIMESTAMPDIFF(YEAR, dob, trans_date_trans_time) < 25 THEN '<25'
        WHEN TIMESTAMPDIFF(YEAR, dob, trans_date_trans_time) BETWEEN 25 AND 34 THEN '25-34'
        WHEN TIMESTAMPDIFF(YEAR, dob, trans_date_trans_time) BETWEEN 35 AND 44 THEN '35-44'
        WHEN TIMESTAMPDIFF(YEAR, dob, trans_date_trans_time) BETWEEN 45 AND 54 THEN '45-54'
        WHEN TIMESTAMPDIFF(YEAR, dob, trans_date_trans_time) BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    COUNT(*) AS total,
    SUM(is_fraud) AS frauds,
    ROUND(100 * SUM(is_fraud)/COUNT(*), 3) AS fraud_rate
FROM transactions
GROUP BY age_group;

-- Geospatial anomaly detection
SELECT
    sr_no,
    merchant,
    city,
    amt,
    is_fraud,
    6371 * 2 * ASIN(
        SQRT(
            POWER(SIN(RADIANS(latitude - merch_lat) / 2), 2) +
            COS(RADIANS(latitude)) *
            COS(RADIANS(merch_lat)) *
            POWER(SIN(RADIANS(longitude - merch_long) / 2), 2)
        )
    ) AS distance_km
FROM transactions
WHERE is_fraud = 1
ORDER BY distance_km DESC
LIMIT 50;
