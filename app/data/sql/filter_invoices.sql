SELECT 
    i.id,
    s.name as supplier_name,
    i.delivery_date,
    i.total_cost,
    COUNT(ii.id) as item_count,
    COALESCE(SUM(ii.quantity), 0) as total_quantity
FROM invoices i
INNER JOIN suppliers s ON i.supplier_id = s.id
LEFT JOIN invoice_items ii ON i.id = ii.invoice_id
WHERE (i.supplier_id = {{ supplier_id }} OR {{ supplier_id }} = 0)
  AND (i.delivery_date >= '{{ min_date }}' OR '{{ min_date }}' = '')
  AND (i.delivery_date <= '{{ max_date }}' OR '{{ max_date }}' = '')
  AND (i.total_cost >= {{ min_total }} OR {{ min_total }} = 0)
  AND (i.total_cost <= {{ max_total }} OR {{ max_total }} = 0)
GROUP BY i.id, s.name, i.delivery_date, i.total_cost
{% if sort_by == 'date_asc' %}
ORDER BY i.delivery_date ASC
{% elif sort_by == 'date_desc' %}
ORDER BY i.delivery_date DESC
{% elif sort_by == 'cost_asc' %}
ORDER BY i.total_cost ASC
{% elif sort_by == 'cost_desc' %}
ORDER BY i.total_cost DESC
{% elif sort_by == 'supplier_asc' %}
ORDER BY s.name ASC
{% elif sort_by == 'supplier_desc' %}
ORDER BY s.name DESC
{% else %}
ORDER BY i.delivery_date DESC
{% endif %};