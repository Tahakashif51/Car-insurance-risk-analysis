

-- ============================================================
-- HIGH RISK CUSTOMER IDENTIFICATION
-- Use window functions to rank customers within each
-- experience band. Simulates an underwriting referral list.
-- AGE_BAND replaces AGE as it is stored as ranges in this dataset.
-- ============================================================

WITH ranked_risk AS (
    SELECT
        ID,
        AGE_BAND,
        DRIVING_EXPERIENCE,
        VEHICLE_TYPE,
        RISK_TIER,
        SPEEDING_VIOLATIONS,
        DUIS,
        PAST_ACCIDENTS,
        OUTCOME,
        PROXY_PREMIUM,

        -- Violation score from raw factors
        (SPEEDING_VIOLATIONS * 2) +
        (DUIS * 5) +
        (PAST_ACCIDENTS * 3)                            AS violation_score,

        -- Rank within driving experience band — worst first
        RANK() OVER (
            PARTITION BY DRIVING_EXPERIENCE
            ORDER BY RISK_SCORE DESC
        )                                               AS risk_rank_in_band,

        -- Average claim rate within experience band
        ROUND(AVG(OUTCOME) OVER (
            PARTITION BY DRIVING_EXPERIENCE
        ) * 100, 2)                                     AS band_avg_claim_rate_pct,

        -- Average claim rate within age band
        ROUND(AVG(OUTCOME) OVER (
            PARTITION BY AGE_BAND
        ) * 100, 2)                                     AS age_band_claim_rate_pct

    FROM CAR_INSURANCE
)

SELECT
    ID,
    AGE_BAND,
    DRIVING_EXPERIENCE,
    VEHICLE_TYPE,
    RISK_TIER,
    SPEEDING_VIOLATIONS,
    DUIS,
    PAST_ACCIDENTS,
    violation_score,
    risk_rank_in_band,
    band_avg_claim_rate_pct,
    age_band_claim_rate_pct,
    PROXY_PREMIUM,
    OUTCOME
FROM ranked_risk
WHERE risk_rank_in_band <= 10
ORDER BY DRIVING_EXPERIENCE, risk_rank_in_band;