SELECT DISTINCT city 
FROM suppliers 
WHERE city IS NOT NULL AND city != ''
ORDER BY city;