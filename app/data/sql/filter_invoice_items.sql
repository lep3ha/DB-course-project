SELECT 
    w.article_number as blank_code,
    w.name,
    w.material,
    di.price,
    di.quantity,
    (di.price * di.quantity) as total
FROM delivery_item di
INNER JOIN workpiece w ON di.workpiece_id = w.id
WHERE di.delivery_id = {{ invoice_id }}::integer
ORDER BY w.name;