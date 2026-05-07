
-- ============================================================
-- VEHICLE TYPE CLAIM ANALYSIS
-- Different vehicle types carry very different risk profiles.
-- This query tells the underwriting team where losses are concentrated.
-- ============================================================

-- 5a. Claim rate by vehicle type and year
SELECT
    VEHICLE_TYPE,
    VEHICLE_YEAR,
    COUNT(*)                                            AS policy_count,
    SUM(OUTCOME)                                        AS total_claims,
    ROUND(SUM(OUTCOME) * 100.0 / COUNT(*), 2)          AS claim_rate_pct,
    ROUND(AVG(SPEEDING_VIOLATIONS), 2)                  AS avg_speeding,
    ROUND(AVG(PAST_ACCIDENTS), 2)                       AS avg_accidents,
    ROUND(AVG(ANNUAL_MILEAGE), 0)                       AS avg_mileage,
    ROUND(AVG(PROXY_PREMIUM), 0)                        AS avg_premium,
    ROUND(AVG(ESTIMATED_CLAIM_COST), 0)                 AS avg_claim_cost,
    ROUND(AVG(UNDERWRITING_MARGIN), 0)                  AS avg_margin
FROM CAR_INSURANCE
GROUP BY VEHICLE_TYPE, VEHICLE_YEAR
ORDER BY claim_rate_pct DESC;

-- 5b. Vehicle type by driving experience
-- Shows which combination is most dangerous
SELECT
    VEHICLE_TYPE,
    DRIVING_EXPERIENCE,
    COUNT(*)                                            AS policy_count,
    SUM(OUTCOME)                                        AS total_claims,
    ROUND(SUM(OUTCOME) * 100.0 / COUNT(*), 2)          AS claim_rate_pct,
    ROUND(AVG(UNDERWRITING_MARGIN), 0)                  AS avg_margin,
    SUM(CASE WHEN PRICING_STATUS = 'Underpriced'
        THEN 1 ELSE 0 END)                              AS underpriced_policies
FROM CAR_INSURANCE
GROUP BY VEHICLE_TYPE, DRIVING_EXPERIENCE
ORDER BY claim_rate_pct DESC;