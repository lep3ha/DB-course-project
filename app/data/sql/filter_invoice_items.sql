SELECT 
    b.blank_code,
    b.name,
    b.material,
    ii.price,
    ii.quantity,
    (ii.price * ii.quantity) as total
FROM invoice_items ii
INNER JOIN blanks b ON ii.blank_id = b.id
WHERE ii.invoice_id = {{ invoice_id }}
ORDER BY b.name;