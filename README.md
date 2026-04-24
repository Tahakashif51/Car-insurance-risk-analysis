>>> Project Overview
  
A full-stack data analytics portfolio project built around a real car insurance claims dataset. The goal is to replicate the kind of risk and pricing analysis a Data Analyst would produce for an insurance underwriting team.

The project answers three business questions:

1 - Which customers are most likely to make a claim — and why?
2 - Are current premiums reflecting the actual risk being underwritten?
3 - Which customer segments are profitable, and which are loss-making?


>>> Tools Used

SQL — Data cleaning, segmentation, risk scoring, pricing gap analysis
Python (Pandas, Seaborn, Matplotlib) — EDA, data cleaning, correlation analysis
Power BI — 3-page interactive dashboard for stakeholder reporting

>>> Repository Structure

car-insurance-analytics/
│
├── data/
│   ├── Car_Insurance_Claim.csv      # Raw dataset (from Kaggle)
│   └── car_insurance_clean.csv      # Cleaned dataset (output of Python script)
│
├── sql/
│   ├── 01_data_quality.sql
│   ├── 02_age_segmentation.sql
│   ├── 03_experience_claims.sql
│   ├── 04_risk_segmentation.sql
│   ├── 05_vehicle_profitability.sql
│   ├── 06_high_risk_flag.sql
│   └── 07_pricing_gap.sql
│
├── python/
│   └── car_insurance_eda.py
│
├── dashboard/
│   └── car_insurance_dashboard.pbix
│
├── visuals/
│   ├── correlation_heatmap.png
│   └── dashboard_screenshot.png
│
└── README.md

>>> Key Insights

Young drivers (16–25) with under 10 years' experience claim at 30–40%, more than twice the portfolio average of ~20%
Customers with 1+ DUI offence claim at 50%+ — 3–4x the clean-record baseline of ~14%
High Risk customers (18% of the portfolio) generate a disproportionate share of total claim costs
Sports car owners claim 8–12 percentage points more often than sedan owners
Married customers with children represent one of the lowest-risk, most profitable segments
Past accident history is the single strongest predictor of a future claim
Customers aged 36–65 with 20+ years' experience are the core profitable segment

>>> Dashboard Pages

Page 1 — Executive Overview: KPI cards, claim rate by age band, risk tier donut, experience split
Page 2 — Risk Deep Dive: Risk score scatter, violation analysis, segment matrix with conditional formatting
Page 3 — Pricing Gap: Premium vs expected loss by segment, underwriting margin table, underpriced flags

>>> Dataset

Source: Kaggle — Car Insurance Data by Sagnik1511

~10,000 records | 19 columns | Binary claim outcome (0/1)
