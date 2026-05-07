-- ============================================================
-- DATA QUALITY AUDIT
-- Before any analysis, we need to know what we are working with.
-- Check for nulls, duplicates, and out-of-range values.
-- ============================================================

-- 1a. Total records and duplicate check
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ID) AS unique_policies,
    COUNT(*) - COUNT(DISTINCT ID) AS duplicate_count
FROM car_insurance;

-- 1b. Null count per key column
SELECT
    SUM(CASE WHEN AGE IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN CREDIT_SCORE IS NULL THEN 1 ELSE 0 END) AS null_credit_score,
    SUM(CASE WHEN ANNUAL_MILEAGE IS NULL THEN 1 ELSE 0 END) AS null_mileage,
    SUM(CASE WHEN OUTCOME IS NULL THEN 1 ELSE 0 END) AS null_outcome
FROM car_insurance;

-- 1c. Age sanity check — flag any records outside valid driving age
SELECT COUNT(*) AS invalid_age_records
FROM car_insurance
WHERE AGE < 17 OR AGE > 100;

-- 1d. Outcome distribution — is the dataset balanced?
SELECT
    OUTCOME,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM car_insurance
GROUP BY OUTCOME;