SELECT 
    w.id,
    w.article_number as blank_code,
    w.name,
    w.material,
    w.weight,
    wh.purchase_price as price,
    wh.quantity as quantity
FROM workpiece w
JOIN warehouse wh ON w.id = wh.workpiece_id
WHERE (w.material = '{{ material }}' OR '{{ material }}' = '')
  AND (wh.purchase_price >= {{ min_price }}::numeric OR {{ min_price }} = 0 OR wh.purchase_price IS NULL)
  AND (wh.purchase_price <= {{ max_price }}::numeric OR {{ max_price }} = 0 OR wh.purchase_price IS NULL)
{% if sort_by == 'name_asc' %}
ORDER BY w.name ASC
{% elif sort_by == 'name_desc' %}
ORDER BY w.name DESC
{% elif sort_by == 'price_asc' %}
ORDER BY wh.purchase_price ASC
{% elif sort_by == 'price_desc' %}
ORDER BY wh.purchase_price DESC
{% else %}
ORDER BY w.name ASC
{% endif %};