SELECT DISTINCT material 
FROM blanks 
WHERE material IS NOT NULL AND material != ''
ORDER BY material;