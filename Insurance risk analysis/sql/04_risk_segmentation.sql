
-- ============================================================
-- RISK SCORE VALIDATION
-- The risk score was already calculated in Python and loaded
-- into Snowflake. This query validates it works correctly by
-- confirming claim rates increase with risk tier.
-- ============================================================

-- 4a. Validate risk tier claim rates
SELECT
    RISK_TIER,
    COUNT(*)                                            AS policy_count,
    SUM(OUTCOME)                                        AS actual_claims,
    ROUND(SUM(OUTCOME) * 100.0 / COUNT(*), 2)          AS claim_rate_pct,
    ROUND(AVG(RISK_SCORE), 2)                           AS avg_risk_score,
    ROUND(AVG(PROXY_PREMIUM), 0)                        AS avg_proxy_premium,
    ROUND(AVG(SPEEDING_VIOLATIONS), 2)                  AS avg_speeding,
    ROUND(AVG(DUIS), 2)                                 AS avg_duis,
    ROUND(AVG(PAST_ACCIDENTS), 2)                       AS avg_past_accidents
FROM CAR_INSURANCE
GROUP BY RISK_TIER
ORDER BY claim_rate_pct DESC;

-- 4b. Risk tier breakdown by age band
-- Shows which age groups dominate each risk tier
SELECT
    RISK_TIER,
    AGE_BAND,
    COUNT(*)                                            AS policy_count,
    SUM(OUTCOME)                                        AS claims,
    ROUND(SUM(OUTCOME) * 100.0 / COUNT(*), 2)          AS claim_rate_pct
FROM CAR_INSURANCE
GROUP BY RISK_TIER, AGE_BAND
ORDER BY RISK_TIER, claim_rate_pct DESC;

-- 4c. Risk score distribution
-- Shows how many customers fall into each score band

SELECT
    RISK_SCORE,
    COUNT(*)                                AS policy_count,
    SUM(OUTCOME)                            AS claims,
    ROUND(SUM(OUTCOME) * 100.0 / COUNT(*), 2) AS claim_rate_pct
FROM CAR_INSURANCE
GROUP BY RISK_SCORE
ORDER BY RISK_SCORE ASC;