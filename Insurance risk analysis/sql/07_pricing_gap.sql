
-- ============================================================
-- PRICING GAP ANALYSIS
-- Premium and claim cost columns were engineered in Python
-- and loaded into Snowflake. This query uses them directly
-- to identify underpriced segments — the key business output.
-- ============================================================

-- 7a. Pricing gap by experience and vehicle type
SELECT
    DRIVING_EXPERIENCE,
    VEHICLE_TYPE,
    COUNT(*)                                            AS policies,
    ROUND(AVG(PROXY_PREMIUM), 0)                        AS avg_proxy_premium,
    ROUND(AVG(ESTIMATED_CLAIM_COST), 0)                 AS avg_expected_loss,
    ROUND(AVG(UNDERWRITING_MARGIN), 0)                  AS avg_margin,
    SUM(CASE WHEN PRICING_STATUS = 'Underpriced'
        THEN 1 ELSE 0 END)                              AS underpriced_count,
    SUM(CASE WHEN PRICING_STATUS = 'Profitable'
        THEN 1 ELSE 0 END)                              AS profitable_count,
    CASE
        WHEN AVG(UNDERWRITING_MARGIN) < 0
        THEN '⚠ UNDERPRICED'
        ELSE '✓ PROFITABLE'
    END                                                 AS segment_status
FROM CAR_INSURANCE
GROUP BY DRIVING_EXPERIENCE, VEHICLE_TYPE
ORDER BY avg_margin ASC;

-- 7b. Pricing gap by age band and risk tier
-- Shows which customer profiles are losing money
SELECT
    AGE_BAND,
    RISK_TIER,
    COUNT(*)                                            AS policies,
    ROUND(AVG(PROXY_PREMIUM), 0)                        AS avg_proxy_premium,
    ROUND(AVG(ESTIMATED_CLAIM_COST), 0)                 AS avg_expected_loss,
    ROUND(AVG(UNDERWRITING_MARGIN), 0)                  AS avg_margin,
    ROUND(SUM(OUTCOME) * 100.0 / COUNT(*), 1)          AS claim_rate_pct,
    CASE
        WHEN AVG(UNDERWRITING_MARGIN) < 0
        THEN '⚠ UNDERPRICED'
        ELSE '✓ PROFITABLE'
    END                                                 AS segment_status
FROM CAR_INSURANCE
GROUP BY AGE_BAND, RISK_TIER
ORDER BY avg_margin ASC;

-- 7c. Overall portfolio margin summary
SELECT
    COUNT(*)                                            AS total_policies,
    SUM(PROXY_PREMIUM)                                  AS total_premium_income,
    SUM(ESTIMATED_CLAIM_COST)                           AS total_claim_cost,
    SUM(UNDERWRITING_MARGIN)                            AS total_margin,
    ROUND(SUM(UNDERWRITING_MARGIN) * 100.0
        / SUM(PROXY_PREMIUM), 2)                        AS margin_pct,
    COUNT(CASE WHEN PRICING_STATUS = 'Underpriced'
        THEN 1 END)                                     AS underpriced_policies,
    COUNT(CASE WHEN PRICING_STATUS = 'Profitable'
        THEN 1 END)                                     AS profitable_policies
FROM CAR_INSURANCE;