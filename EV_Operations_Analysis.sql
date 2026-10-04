-- =======================================================================
-- Project: EV Charging Network - Operational & Business Intelligence
-- =======================================================================

-- 1. Total Network Performance Overview
SELECT 
    COUNT(DISTINCT Station_Name) AS Total_Stations,
    COUNT(Session_ID) AS Total_Sessions,
    ROUND(SUM(Energy_Consumed_kWh), 2) AS Total_Energy_Delivered_kWh,
    ROUND(SUM(Total_Cost_INR), 2) AS Total_Revenue_Generated
FROM EV_Charging_Sessions;

-- 2. Top 5 Stations by Revenue and Traffic
SELECT 
    Station_Name,
    COUNT(Session_ID) AS Total_Visits,
    ROUND(SUM(Total_Cost_INR), 2) AS Revenue_INR
FROM EV_Charging_Sessions
GROUP BY Station_Name
ORDER BY Revenue_INR DESC
LIMIT 5;

-- 3. Peak Charging Hours (Time-Series Analysis)
-- Identifies the busiest hours of the day across the network
WITH HourlyTraffic AS (
    SELECT 
        EXTRACT(HOUR FROM Start_Time) AS hour_of_day,
        COUNT(Session_ID) AS total_sessions,
        ROUND(SUM(Energy_Consumed_kWh), 2) AS total_energy
    FROM EV_Charging_Sessions
    GROUP BY EXTRACT(HOUR FROM Start_Time)
)
SELECT * FROM HourlyTraffic
ORDER BY total_sessions DESC
LIMIT 5;

-- 4. User Churn / Retention Proxy (Identifying Frequent Users)
-- Finds users who have charged their vehicles more than 15 times
SELECT 
    User_ID,
    COUNT(Session_ID) AS Charging_Frequency,
    ROUND(SUM(Total_Cost_INR), 2) AS Lifetime_Value_INR
FROM EV_Charging_Sessions
GROUP BY User_ID
HAVING COUNT(Session_ID) > 15
ORDER BY Charging_Frequency DESC;

-- 5. Station Utilization Rate & Average Session Duration
SELECT 
    Station_Name,
    ROUND(AVG(EXTRACT(EPOCH FROM (End_Time - Start_Time))/60), 2) AS Avg_Session_Minutes,
    MAX(Energy_Consumed_kWh) AS Max_Energy_Single_Session
FROM EV_Charging_Sessions
GROUP BY Station_Name
ORDER BY Avg_Session_Minutes DESC;

-- 6. Idle Time Calculation Using Window Functions (LEAD)
-- Calculates the idle time between consecutive sessions at each station
WITH SessionGaps AS (
    SELECT 
        Station_Name,
        Start_Time,
        End_Time,
        LEAD(Start_Time) OVER(PARTITION BY Station_Name ORDER BY Start_Time) AS next_session_start
    FROM EV_Charging_Sessions
)
SELECT 
    Station_Name,
    Start_Time,
    next_session_start,
    ROUND((EXTRACT(EPOCH FROM (next_session_start - End_Time))/3600), 2) AS Idle_Hours
FROM SessionGaps
WHERE next_session_start IS NOT NULL
ORDER BY Idle_Hours DESC
LIMIT 10;

-- 7. Revenue Moving Average (Trend Analysis)
-- Calculates a rolling 7-day revenue average for the network
WITH DailyRevenue AS (
    SELECT 
        DATE(Start_Time) AS Charge_Date,
        SUM(Total_Cost_INR) AS Daily_Revenue
    FROM EV_Charging_Sessions
    GROUP BY DATE(Start_Time)
)
SELECT 
    Charge_Date,
    Daily_Revenue,
    ROUND(AVG(Daily_Revenue) OVER(ORDER BY Charge_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS Rolling_7_Day_Avg
FROM DailyRevenue;
