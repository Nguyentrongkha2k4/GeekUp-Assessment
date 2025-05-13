-- c)

SELECT 
    MONTH(O.CreatedAt) AS Month,
    ROUND(AVG(O.GrandTotal), 2) AS AverageOrderValue
FROM Orders O
WHERE YEAR(O.CreatedAt) = YEAR(CURDATE())
GROUP BY MONTH(O.CreatedAt)
ORDER BY Month;