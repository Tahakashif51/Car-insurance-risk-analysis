import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# ── LOAD DATA ──────────────────────────────────────────
df = pd.read_csv('/Users/taha/Desktop/Insurance risk analysis/data/Car_Insurance_Claim.csv')

# ── CLEANING ───────────────────────────────────────────
df = df.drop_duplicates()

# Standardise all text columns to uppercase
text_cols = [
    'AGE', 'GENDER', 'RACE', 'DRIVING_EXPERIENCE',
    'EDUCATION', 'INCOME', 'VEHICLE_YEAR', 'VEHICLE_TYPE'
]
for col in text_cols:
    df[col] = df[col].astype(str).str.strip().str.upper()

# Rename AGE to AGE_BAND since it contains ranges not numbers
df = df.rename(columns={'AGE': 'AGE_BAND'})

# ── NUMERIC TYPES ──────────────────────────────────────
# These become clean integers — no decimals, no nulls
int_cols = [
    'ID', 'POSTAL_CODE', 'VEHICLE_OWNERSHIP', 'MARRIED',
    'CHILDREN', 'SPEEDING_VIOLATIONS', 'DUIS', 'PAST_ACCIDENTS', 'OUTCOME'
]
for col in int_cols:
    df[col] = pd.to_numeric(df[col], errors='coerce').fillna(0).astype(int)

# These stay as decimals
df['CREDIT_SCORE'] = pd.to_numeric(df['CREDIT_SCORE'], errors='coerce')
df['ANNUAL_MILEAGE'] = pd.to_numeric(df['ANNUAL_MILEAGE'], errors='coerce')

# ── MISSING VALUES ─────────────────────────────────────
df['CREDIT_SCORE'] = df['CREDIT_SCORE'].fillna(df['CREDIT_SCORE'].median())
df['ANNUAL_MILEAGE'] = df.groupby('DRIVING_EXPERIENCE')['ANNUAL_MILEAGE'] \
                         .transform(lambda x: x.fillna(x.median()))
df['ANNUAL_MILEAGE'] = df['ANNUAL_MILEAGE'].fillna(df['ANNUAL_MILEAGE'].median())

# Round to 2 decimal places for cleanliness
df['CREDIT_SCORE'] = df['CREDIT_SCORE'].round(4)
df['ANNUAL_MILEAGE'] = df['ANNUAL_MILEAGE'].round(0).astype(int)

# ── RISK SCORE ─────────────────────────────────────────
df['RISK_SCORE'] = (
    (df['AGE_BAND'] == '16-25').astype(int) * 4 +
    (df['DRIVING_EXPERIENCE'] == '0-9Y').astype(int) * 4 +
    df['SPEEDING_VIOLATIONS'] * 2 +
    df['DUIS'] * 5 +
    df['PAST_ACCIDENTS'] * 3 +
    (df['VEHICLE_TYPE'] == 'SPORTS CAR').astype(int) * 2
).astype(int)

# ── RISK TIER ──────────────────────────────────────────
def assign_risk_tier(score):
    if score <= 3:
        return 'Low Risk'
    elif score <= 7:
        return 'Medium Risk'
    else:
        return 'High Risk'

df['RISK_TIER'] = df['RISK_SCORE'].apply(assign_risk_tier)

# ── PROXY PREMIUM ──────────────────────────────────────
def calc_premium(row):
    base = 300
    age_load = 400 if row['AGE_BAND'] == '16-25' else \
               150 if row['AGE_BAND'] == '26-39' else \
                50 if row['AGE_BAND'] == '40-64' else 30
    exp_load = 350 if row['DRIVING_EXPERIENCE'] == '0-9Y' else \
               100 if row['DRIVING_EXPERIENCE'] == '10-19Y' else 0
    vehicle_load = 250 if row['VEHICLE_TYPE'] == 'SPORTS CAR' else 0
    violation_load = (row['SPEEDING_VIOLATIONS'] * 80) + \
                     (row['DUIS'] * 200) + \
                     (row['PAST_ACCIDENTS'] * 120)
    return int(base + age_load + exp_load + vehicle_load + violation_load)

df['PROXY_PREMIUM'] = df.apply(calc_premium, axis=1).astype(int)

# ── CLAIM COST AND MARGIN ──────────────────────────────
df['ESTIMATED_CLAIM_COST'] = (df['OUTCOME'] * 3500).astype(int)
df['UNDERWRITING_MARGIN'] = (df['PROXY_PREMIUM'] - df['ESTIMATED_CLAIM_COST']).astype(int)
df['PRICING_STATUS'] = df['UNDERWRITING_MARGIN'].apply(
    lambda x: 'Underpriced' if x < 0 else 'Profitable'
)

# ── VALIDATION ─────────────────────────────────────────
print("Shape:", df.shape)
print("\nDtypes:")
print(df.dtypes)
print("\nNull counts:")
print(df.isnull().sum())
print("\nClaim rate by AGE_BAND:")
print(df.groupby('AGE_BAND')['OUTCOME'].mean().mul(100).round(1))
print("\nClaim rate by RISK_TIER:")
print(df.groupby('RISK_TIER')['OUTCOME'].mean().mul(100).round(1))
print("\nSample rows:")
print(df[['AGE_BAND', 'DRIVING_EXPERIENCE', 'RISK_SCORE',
          'RISK_TIER', 'PROXY_PREMIUM', 'ESTIMATED_CLAIM_COST',
          'UNDERWRITING_MARGIN', 'PRICING_STATUS']].head(5).to_string())

# ── CORRELATION HEATMAP ────────────────────────────────
numeric_cols = [
    'CREDIT_SCORE', 'ANNUAL_MILEAGE', 'SPEEDING_VIOLATIONS',
    'DUIS', 'PAST_ACCIDENTS', 'RISK_SCORE', 'OUTCOME'
]
corr = df[numeric_cols].corr()
plt.figure(figsize=(10, 7))
sns.heatmap(corr, annot=True, fmt='.2f', cmap='RdYlGn', center=0, linewidths=0.5)
plt.title('Correlation Matrix — Car Insurance Risk Factors', fontsize=14)
plt.tight_layout()
plt.savefig('/Users/taha/Desktop/Insurance risk analysis/visuals/correlation_heatmap.png', dpi=150)
print("\nHeatmap saved.")

# ── EXPORT ─────────────────────────────────────────────
df.to_csv(
    '/Users/taha/Desktop/Insurance risk analysis/data/car_insurance_clean.csv',
    index=False
)
print("Clean CSV exported. Ready for Snowflake.")