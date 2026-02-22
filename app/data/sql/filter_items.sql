SELECT 
    b.id,
    b.blank_code,
    b.name,
    b.material,
    b.weight,
    COALESCE(s.price, 0) as price,
    COALESCE(s.quantity, 0) as quantity
FROM blanks b
LEFT JOIN stock s ON b.id = s.blank_id
WHERE (b.material = '{{ material }}' OR '{{ material }}' = '')
  AND (COALESCE(s.price, 0) >= {{ min_price }} OR {{ min_price }} = 0)
  AND (COALESCE(s.price, 0) <= {{ max_price }} OR {{ max_price }} = 0)
{% if sort_by == 'name_asc' %}
ORDER BY b.name ASC
{% elif sort_by == 'name_desc' %}
ORDER BY b.name DESC
{% elif sort_by == 'price_asc' %}
ORDER BY COALESCE(s.price, 0) ASC
{% elif sort_by == 'price_desc' %}
ORDER BY COALESCE(s.price, 0) DESC
{% else %}
ORDER BY b.name ASC
{% endif %};