
-- ============================================================
-- DRIVING EXPERIENCE ANALYSIS
-- Experience is one of the strongest pricing factors in car insurance.
-- This query shows exactly how claim rates drop as experience increases.
-- ============================================================

SELECT
    DRIVING_EXPERIENCE,
    COUNT(*)                                            AS policy_count,
    SUM(OUTCOME)                                        AS total_claims,
    ROUND(SUM(OUTCOME) * 100.0 / COUNT(*), 2)          AS claim_rate_pct,
    ROUND(AVG(PAST_ACCIDENTS), 2)                       AS avg_past_accidents,
    ROUND(AVG(SPEEDING_VIOLATIONS), 2)                  AS avg_speed_violations,
    ROUND(AVG(DUIS), 2)                                 AS avg_duis,
    ROUND(AVG(RISK_SCORE), 2)                           AS avg_risk_score,
    ROUND(AVG(PROXY_PREMIUM), 0)                        AS avg_proxy_premium,
    ROUND(AVG(ANNUAL_MILEAGE), 0)                       AS avg_annual_mileage,
    -- Show how much more risky vs most experienced drivers
    ROUND(
        SUM(OUTCOME) * 100.0 / COUNT(*) -
        MIN(SUM(OUTCOME) * 100.0 / COUNT(*)) OVER(),
        2
    )                                                   AS pct_above_safest_band
FROM CAR_INSURANCE
GROUP BY DRIVING_EXPERIENCE
ORDER BY claim_rate_pct DESC;