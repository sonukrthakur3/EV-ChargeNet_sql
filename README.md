# ⚡ EV Charging Network - SQL Operations Intelligence

## 📌 Project Overview
This project focuses on the operational analytics of an Electric Vehicle (EV) charging network. Using a simulated dataset of over 5,000 charging sessions based on real-world EV station locations in Delhi, I performed advanced SQL analysis to extract actionable business insights regarding station utilization, revenue generation, and user behavior.

## 🛠️ Tech Stack & Skills
- **Database Engine:** PostgreSQL (Syntax compatible)
- **Data Generation:** Python (Pandas, Numpy) for simulating time-series transactional data.
- **SQL Skills Applied:** Window Functions (`LEAD`, `OVER`, `PARTITION BY`), Common Table Expressions (CTEs), Time-Series Analysis (`EXTRACT`), Aggregations, and Data Ranking.

## 🗄️ Database Schema (Mock)
- `Session_ID` (INT) - Primary Key
- `Station_Name` (VARCHAR) - Location of the charger
- `User_ID` (INT) - Unique identifier for the EV owner
- `Start_Time` (TIMESTAMP) - Session start
- `End_Time` (TIMESTAMP) - Session end
- `Energy_Consumed_kWh` (FLOAT) - Power delivered
- `Total_Cost_INR` (FLOAT) - Billed amount

## 📊 Key Business Questions Solved
1. **Network Utilization:** What are the peak charging hours across the network?
2. **Revenue Optimization:** Which stations generate the highest revenue and traffic?
3. **Operational Efficiency:** What is the average idle time (downtime) between charging sessions at high-demand stations?
4. **Customer Retention:** Who are the high-frequency users (power users) driving consistent revenue?
5. **Trend Analysis:** What is the 7-day rolling average for network revenue?

## 💡 Key Insights Generated
- Identified the top 5 bottleneck stations requiring capacity expansion due to near-zero idle time.
- Extracted peak traffic hours to recommend dynamic pricing models (e.g., higher rates during 6 PM - 9 PM).
- Mapped user retention by identifying 'Power Users' with >15 sessions, highlighting the need for a subscription or loyalty program.

---
*Note: The foundational station data was sourced from an earlier geographical allocation project, while the transactional session data was generated via Python to demonstrate advanced backend SQL capabilities.*
