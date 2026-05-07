

-- ============================================================
-- AGE BAND SEGMENTATION
-- AGE is stored as bands in this dataset (16-25, 26-39, 40-64, 65+)
-- Compare claim rates across age groups to identify risk tiers.
-- ============================================================

SELECT
    AGE_BAND,
    COUNT(*)                                                AS policy_count,
    SUM(OUTCOME)                                           AS total_claims,
    ROUND(SUM(OUTCOME) * 100.0 / COUNT(*), 2)             AS claim_rate_pct,
    ROUND(AVG(CREDIT_SCORE), 3)                           AS avg_credit_score,
    ROUND(AVG(ANNUAL_MILEAGE), 0)                         AS avg_annual_mileage,
    ROUND(AVG(SPEEDING_VIOLATIONS), 2)                    AS avg_speeding_violations,
    ROUND(AVG(RISK_SCORE), 2)                             AS avg_risk_score,
    ROUND(AVG(PROXY_PREMIUM), 0)                          AS avg_proxy_premium
FROM CAR_INSURANCE
GROUP BY AGE_BAND
ORDER BY claim_rate_pct DESC;