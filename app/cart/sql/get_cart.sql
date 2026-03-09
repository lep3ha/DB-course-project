SELECT ci.id,
       ci.workpiece_id,
       wp.article_number,
       wp.name,
       ci.quantity,
       ci.price_at_add,
       w.add_value,
       (ci.price_at_add * w.add_value) AS price,
       w.quantity AS available
FROM cart_items ci
JOIN workpiece wp ON wp.id = ci.workpiece_id
JOIN warehouse w ON w.workpiece_id = ci.workpiece_id AND w.purchase_price = ci.price_at_add
WHERE ci.cart_id = %s
ORDER BY wp.name;
