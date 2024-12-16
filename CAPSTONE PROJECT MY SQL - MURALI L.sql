USE ecomm ;

-- Data Cleaning 
SELECT ROUND(AVG(WarehouseToHome)) AS Imputed_WarehouseToHome
FROM customer_churn
WHERE WarehouseToHome IS NOT NULL;

SELECT ROUND(AVG(HourSpendOnApp)) AS Imputed_HourSpendOnApp
FROM customer_churn
WHERE HourSpendOnApp IS NOT NULL;

SELECT ROUND(AVG(OrderAmountHikeFromLastYear)) AS Imputed_OrderAmountHikeFromLastYear
FROM customer_churn
WHERE OrderAmountHikeFromLastYear IS NOT NULL;

SELECT ROUND(AVG(DaySinceLastOrder)) AS Imputed_DaySinceLastOrder
FROM customer_churn
WHERE DaySinceLastOrder IS NOT NULL;

SELECT Tenure
FROM customer_churn
GROUP BY Tenure
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT CouponUsed
FROM customer_churn
GROUP BY CouponUsed
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT OrderCount
FROM customer_churn
GROUP BY OrderCount
ORDER BY COUNT(*) DESC
LIMIT 1;

SET SQL_SAFE_UPDATES = 0;

-- Dealing with Inconsistencies

DELETE FROM customer_churn
WHERE WarehouseToHome > 100;

SELECT * FROM customer_churn
WHERE WarehouseToHome > 100;

UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';

UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';

UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';

-- Data Transformation

ALTER TABLE customer_churn
CHANGE COLUMN PreferedOrderCat PreferredOrderCat VARCHAR(255);

ALTER TABLE customer_churn
RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;

-- Creating New Columns

ALTER TABLE customer_churn
ADD ComplaintReceived VARCHAR(3);

ALTER TABLE customer_churn
ADD ChurnStatus VARCHAR(8);

-- Column Dropping

ALTER TABLE customer_churn
DROP COLUMN Churn,
DROP COLUMN Complain;

-- Data Exploration and Analysis

SELECT Churn,
COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY Churn;

SELECT AVG(Tenure) AS AverageTenureOfChurned
FROM customer_churn
WHERE Churn = 'Yes';

SELECT SUM(CashbackAmount) AS TotalCashbackForChurned
FROM customer_churn
WHERE Churn = 'Yes';

SELECT (SUM(CASE WHEN Complain = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS PercentageOfChurnedWhoComplained
FROM customer_churn
WHERE Churn = 'Yes';

SELECT Gender, COUNT(*) AS NumberOfComplaints
FROM customer_churn
WHERE Complain = 'Yes'
GROUP BY Gender;


SELECT CityTier,COUNT(*) AS NumberOfChurnedCustomers
FROM customer_churn
WHERE Churn = 1 AND PreferedOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY NumberOfChurnedCustomers DESC
LIMIT 1;

SELECT PreferredLoginDevice, COUNT(*) AS NumberOfCustomers
FROM customer_churn
WHERE DaySinceLastOrder > 10
GROUP BY PreferredLoginDevice;

SELECT COUNT(*) AS NumberOfActiveCustomers
FROM customer_churn
WHERE Churn = 0
AND HourSpendOnApp > 3;

SELECT AVG(CashbackAmount) AS AverageCashback
FROM customer_churn
WHERE HourSpendOnApp >= 2;

SELECT PreferedOrderCat,MAX(HourSpendOnApp) AS MaxHoursSpentOnApp
FROM customer_churn
GROUP BY PreferedOrderCat;

SELECT MaritalStatus, AVG(OrderAmountHikeFromlastYear) AS AverageOrderAmountHike
FROM customer_churn
GROUP BY MaritalStatus; 

SELECT SUM(OrderAmountHikeFromlastYear) AS TotalOrderAmountHike
FROM customer_churn
WHERE MaritalStatus = 'Single' AND PreferedOrderCat = 'Mobile Phone'; 

SELECT AVG(NumberOfDeviceRegistered) AS AverageNumberOfDevicesRegistered
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI'; 

SELECT CityTier,COUNT(*) AS NumberOfCustomers
FROM customer_churn
GROUP BY CityTier
ORDER BY NumberOfCustomers DESC

SELECT CityTier, COUNT(*) count
FROM customer_churn
GROUP BY CityTier
ORDER BY count DESC LIMIT 1;

SELECT MaritalStatus, MAX(NumberOfAddress) AS Highest
FROM customer_churn 
GROUP BY MaritalStatus
ORDER BY Highest DESC
LIMIT 1;

SELECT gender, COUNT(*) AS coupon_count
FROM customer_churn
GROUP BY gender
ORDER BY coupon_count DESC
LIMIT 1;

SELECT PreferredOrderCat, AVG(SatisfactionScore) AS avg_satisfaction
FROM customer_churn
GROUP BY PreferredOrderCat;

SELECT COUNT(*) AS OrderCount
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
AND SatisfactionScore = (SELECT MAX(SatisfactionScore) FROM customer_churn);

SELECT COUNT(*) AS CustomerCount
FROM customer_churn
WHERE HoursSpentOnApp = 1 AND DaySinceLastOrder > 5;

SELECT AVG(SatisfactionScore) AS AverageSatisfaction
FROM customer_churn
WHERE Complain = 1;

SELECT PreferredOrderCat, COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY PreferredOrderCat;

SELECT AVG(NumberOfDeviceRegistered) AS AverageDevicesRegistered
FROM customer_churn
WHERE PreferredLoginDevice <> 'Mobile Phone';

SELECT PreferredOrderCat
FROM customer_churn
WHERE CouponUsed > 5;

SELECT PreferredOrderCat, AVG(CashbackAmount) AS AverageCashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY AverageCashback DESC
LIMIT 3;

SELECT PreferredPaymentMode,
avg(Tenure) avg_tenure,
count(ordercount) count
FROM customer_churn
GROUP BY PreferredPaymentMode
HAVING avg_tenure > 10 AND Count > 500;

SELECT 
    CASE 
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS DistanceCategory,
    Churn,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY DistanceCategory, Churn;

SELECT CustomerID, OrderCount, PreferredOrderCat, PreferredPaymentMode, SatisfactionScore
FROM customer_churn
WHERE MaritalStatus = 'Married'
  AND CityTier = 1
  AND OrderCount > (SELECT AVG(OrderCount) FROM customer_churn);

USE ecomm;

CREATE TABLE customer_returns (
    ReturnID       INT PRIMARY KEY,
    CustomerID     INT,
    ReturnDate     DATE,
    RefundAmount   DECIMAL(10, 2)
);

INSERT INTO customer_returns (ReturnID, CustomerID, ReturnDate, RefundAmount)
VALUES 
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);


SELECT cr.ReturnID, cr.CustomerID, cr.ReturnDate, cr.RefundAmount, 
       cc.Churn, cc.Complain, cc.PreferredOrderCat, cc.SatisfactionScore
FROM customer_churn cc
JOIN customer_returns cr ON cc.CustomerID = cr.CustomerID
WHERE cc.Churn = 1 AND cc.Complain = 1;


select * from customer_churn;

select * from customer_returns;

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_churn AS cc
JOIN (
    SELECT CityTier, PreferredPaymentMode, Gender, ROUND(AVG(HoursSpentOnApp)) AS AvgHoursSpent
    FROM customer_churn
    WHERE HoursSpentOnApp IS NOT NULL
    GROUP BY CityTier, PreferredPaymentMode, Gender
) AS avg_values
ON cc.CityTier = avg_values.CityTier
   AND cc.PreferredPaymentMode = avg_values.PreferredPaymentMode
   AND cc.Gender = avg_values.Gender
SET cc.HoursSpentOnApp = avg_values.AvgHoursSpent
WHERE cc.HoursSpentOnApp IS NULL;


SELECT * FROM customer_churn WHERE HoursSpentOnApp IS NULL;

SELECT NumberOfAddress, AVG(WarehouseToHome) AS AvgDistance
FROM customer_churn
WHERE WarehouseToHome IS NOT NULL
GROUP BY NumberOfAddress;


UPDATE customer_churn AS cc
JOIN (
    SELECT NumberOfAddress, ROUND(AVG(WarehouseToHome)) AS AvgDistance
    FROM customer_churn
    WHERE WarehouseToHome IS NOT NULL
    GROUP BY NumberOfAddress
) AS avg_values
ON cc.NumberOfAddress = avg_values.NumberOfAddress
SET cc.WarehouseToHome = avg_values.AvgDistance
WHERE cc.WarehouseToHome IS NULL;
