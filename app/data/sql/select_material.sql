SELECT DISTINCT material 
FROM workpiece 
WHERE material IS NOT NULL AND material != ''
ORDER BY material;