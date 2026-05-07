# 🚗 Car Insurance Risk & Pricing Analysis

![SQL](https://img.shields.io/badge/SQL-Snowflake-blue)
![Python](https://img.shields.io/badge/Python-Pandas%20%7C%20Seaborn-green)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)
![Domain](https://img.shields.io/badge/Domain-Insurance%20Analytics-red)

---

## 📋 Project Overview

A full-stack data analytics portfolio project built around a real car 
insurance claims dataset from Kaggle. The project simulates the kind of 
risk and pricing analysis a Data Analyst or Pricing Analyst would produce 
for an insurance underwriting team.

**Business Scenario:** As a junior analyst at a fictional insurer 
(Meridian Insurance Group), claims costs have risen 12% while premiums 
grew only 4%. The CFO wants to understand who is claiming the most, 
whether premiums reflect actual risk, and which customer segments are 
unprofitable.

**Three core business questions:**
- Which customers are most likely to make a claim — and why?
- Are current premiums reflecting the actual risk being underwritten?
- Which customer segments are profitable, and which are loss-making?

---

## 🛠 Tools Used

| Tool | Purpose |
|------|---------|
| **Python (Pandas, Seaborn, Matplotlib)** | Data cleaning, feature engineering, EDA, correlation analysis |
| **SQL (Snowflake)** | Data loading, segmentation, risk scoring, pricing gap analysis |
| **Power BI** | 3-page interactive dashboard for stakeholder reporting |

---

## 📁 Repository Structure

car-insurance-risk-analysis/
│
├── data/
│   ├── Car_Insurance_Claim.csv        ← Raw dataset from Kaggle
│   └── car_insurance_clean.csv        ← Cleaned dataset from Python
│
├── sql/
│   ├── 01_data_quality.sql            ← Null checks, duplicates
│   ├── 02_age_segmentation.sql        ← Claim rate by age band
│   ├── 03_experience_claims.sql       ← Experience vs claim rate
│   ├── 04_risk_segmentation.sql       ← Composite risk scoring (CTEs)
│   ├── 05_vehicle_profitability.sql   ← Vehicle type analysis
│   ├── 06_high_risk_flag.sql          ← Window functions — top risk
│   └── 07_pricing_gap.sql             ← Premium vs expected loss
│
├── python/
│   └── car_insurance_eda.py           ← Cleaning, EDA, heatmap, export
│
├── dashboard/
│   └── car_insurance_dashboard.pbix   ← Power BI dashboard file
│
├── visuals/
│   ├── correlation_heatmap.png
│   ├── dashboard_page1_overview.png
│   ├── dashboard_page2_risk.png
│   ├── dashboard_page3_pricing.png
│   └── sql-results/
│       ├── 01_data_quality_result.png
│       ├── 04_risk_segmentation_result.png
│       └── 07_pricing_gap_result.png
│
└── README.md


## Project Workflow

Raw CSV (Kaggle)
↓
Python — cleans data, engineers risk score, proxy premium, exports clean CSV
↓
Snowflake — data loaded, SQL queries run, analytical views created
↓
Power BI — connects to clean CSV, 3-page dashboard built
↓
GitHub — full project documented with screenshots

---

## Python — What Was Done

- Loaded raw CSV and dropped duplicates
- Standardised all text columns to uppercase
- Filled 982 missing CREDIT_SCORE values with median
- Filled 957 missing ANNUAL_MILEAGE values with group median
- Engineered AGE_BAND from raw age range column
- Built composite RISK_SCORE from 6 risk factors
- Assigned RISK_TIER (Low / Medium / High) from score
- Engineered PROXY_PREMIUM using simplified actuarial logic
- Calculated ESTIMATED_CLAIM_COST and UNDERWRITING_MARGIN
- Generated correlation heatmap saved to visuals folder
- Exported clean 25-column dataset ready for Snowflake

---

## SQL — Queries Written (Snowflake)

### 01 — Data Quality Check
Checked for nulls, duplicates, and outcome distribution before 
any analysis. Confirmed zero nulls across all key columns after 
Python cleaning.

### 02 — Age Band Segmentation
Grouped customers by AGE_BAND and calculated claim rate, average 
credit score, mileage, and speeding violations per group.

### 03 — Driving Experience Analysis
Showed claim rates dropping from 62.8% for 0-9Y experience down 
to 1.9% for 30Y+ — the strongest single predictor after past accidents.

### 04 — Risk Score Validation (CTEs)
Validated the composite risk scoring model using CTEs. Confirmed 
High Risk customers claim at significantly higher rates. Also broke 
down risk tiers by age band and showed risk score distribution.

### 05 — Vehicle Profitability
Compared claim rates across SEDAN and SPORTS CAR by vehicle year. 
Calculated average premium, claim cost, and underwriting margin per 
vehicle segment.

### 06 — High Risk Customer Flag (Window Functions)
Used RANK() OVER (PARTITION BY DRIVING_EXPERIENCE) to identify the 
top 10 riskiest customers within each experience band — simulating 
a real underwriting referral list.

### 07 — Pricing Gap Analysis
Compared average proxy premium against average expected claim cost 
by segment. Flagged underpriced segments where expected losses 
exceed premium income. Calculated total portfolio underwriting margin.

---

## Power BI Dashboard

### Page 1 — Executive Overview
KPI cards (Total Policies, Claim Rate, High Risk %, Avg Risk Score), 
claim rate by age band bar chart, risk tier donut chart, claim rate 
by driving experience bar chart. Slicers for Gender, Vehicle Type, 
Vehicle Year.

### Page 2 — Risk Deep Dive
Scatter plot of Risk Score vs Claim Rate by Vehicle Type, matrix 
heat map of Experience × Vehicle Type with conditional formatting, 
clustered bar of violations split by claim outcome, high risk 
concentration card. Slicers for Income, Married, Age Band.

### Page 3 — Pricing Gap Analysis
Side-by-side bar chart of proxy premium vs expected loss by segment, 
detailed pricing table with conditional formatting on margin column, 
total portfolio margin card, underpriced policy count card. Slicers 
for Experience, Vehicle Type, Risk Tier.

---

## Dashboard Screenshots

### Page 1 — Executive Overview
![Overview](visuals/dashboard_page1_overview.png)

### Page 2 — Risk Deep Dive
![Risk](visuals/dashboard_page2_risk.png)

### Page 3 — Pricing Gap Analysis
![Pricing](visuals/dashboard_page3_pricing.png)

---

## 🔍 Key Business Insights

1. **Young drivers (16-25) claim at 71.8%** — more than double the 
   portfolio average of 31.3%

2. **Inexperienced drivers (0-9Y) claim at 62.8%** — the strongest 
   single risk signal in the dataset alongside age

3. **High Risk customers generate a disproportionate share of total 
   claims** despite being a minority of the portfolio

4. **Sports car owners claim at a higher rate than sedan owners** — 
   justifying a vehicle type surcharge in the rating model

5. **Married customers show lower claim rates** — a segment worth 
   targeting with retention pricing

6. **Past accident history is the strongest predictor of future claims** 
   — confirmed via correlation analysis in Python

7. **Several segments show negative underwriting margin** — premiums 
   are not covering expected claim costs in key risk groups

---

##  SQL Results

### Risk Segmentation (Query 04)
![Risk SQL](visuals/sql-results/04_risk_segmentation_result.png)

### Pricing Gap (Query 07)
![Pricing SQL](visuals/sql-results/07_pricing_gap_result.png)

---

## SQL Techniques Used

- `CASE WHEN` for segmentation and risk scoring
- CTEs (`WITH` clause) for multi-step logic
- Window functions: `RANK() OVER (PARTITION BY ...)`
- Aggregate functions: `COUNT`, `SUM`, `ROUND`, `AVG`
- Null handling and data quality checks
- Percentage calculations with `SUM() OVER()` for window totals

---

## Python Techniques Used

- `pandas` for data cleaning and transformation
- Group-level imputation using `.groupby().transform()`
- Feature engineering with `.apply()` for custom functions
- `seaborn` heatmap for correlation analysis
- `matplotlib` for chart export
- CSV export for downstream tools

---

## Dataset

- **Source:** [Kaggle — Car Insurance Data by Sagnik1511](https://www.kaggle.com/datasets/sagnik1511/car-insurance-data)
- **Size:** 10,000 records, 19 raw columns, 25 after engineering
- **Target variable:** `OUTCOME` (0 = no claim, 1 = claim made)
- **Key engineered columns:** AGE_BAND, RISK_SCORE, RISK_TIER, 
  PROXY_PREMIUM, ESTIMATED_CLAIM_COST, UNDERWRITING_MARGIN, 
  PRICING_STATUS

---

## 🚀 How to Reproduce

1. Download dataset from Kaggle link above → save to `/data/` OR Get the file  'data/Car_Insurance_Claim.csv'
2. Run `python/car_insurance_eda.py` to clean data and generate 
   `car_insurance_clean.csv`
3. Load `car_insurance_clean.csv` into Snowflake using the table 
   structure in `04_risk_segmentation.sql`
4. Run SQL files in `/sql/` folder in order 01 through 07
5. Open `dashboard/car_insurance_dashboard.pbix` in Power BI Desktop
6. Refresh data source to point to your local CSV

---

## 💡 Potential Extensions

- **Logistic Regression:** Train a sklearn model to predict claim 
  probability per customer
- **Streamlit App:** Deploy risk scoring logic as a live web calculator
- **Industry Benchmarking:** Compare portfolio metrics against ABI 
  published motor insurance statistics

---

*Portfolio project built for Data Analyst roles*  
*Tools: Python · SQL · Snowflake · Power BI*
