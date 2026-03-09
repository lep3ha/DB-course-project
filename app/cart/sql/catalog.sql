-- List available warehouse items (only rows with quantity > 0)
SELECT w.workpiece_id AS id,
       wp.article_number,
       wp.name,
       wp.material,
       wp.weight,
       w.purchase_price,
       w.add_value,
       w.quantity,
       (w.purchase_price * w.add_value) AS price
FROM warehouse w
JOIN workpiece wp ON wp.id = w.workpiece_id
WHERE w.quantity > 0
ORDER BY wp.name;
