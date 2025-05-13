-- d)
-- Số khách mua trong 6 tháng gần nhất
WITH recent_customers AS (
    SELECT DISTINCT UserID
    FROM Orders
    WHERE CreatedAt >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
),

-- Số khách mua từ 6 đến 12 tháng trước
past_customers AS (
    SELECT DISTINCT UserID
    FROM Orders
    WHERE CreatedAt >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
      AND CreatedAt < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
)

SELECT 
    COUNT(DISTINCT pc.UserID) AS ChurnedUsers,
    ROUND(COUNT(DISTINCT pc.UserID) / NULLIF((SELECT COUNT(*) FROM past_customers), 0) * 100, 2) AS ChurnRatePercent
FROM past_customers pc
LEFT JOIN recent_customers rc ON pc.UserID = rc.UserID
WHERE rc.UserID IS NULL;
 