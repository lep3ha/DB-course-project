SELECT 
    s.id,
    s.name,
    s.city,
    s.contract_date,
    COUNT(i.id) as invoice_count,
    COALESCE(SUM(i.total_cost), 0) as total_invoices
FROM suppliers s
LEFT JOIN invoices i ON s.id = i.supplier_id
WHERE (s.city = '{{ city }}' OR '{{ city }}' = '')
  AND (s.contract_date >= '{{ min_date }}' OR '{{ min_date }}' = '')
  AND (s.contract_date <= '{{ max_date }}' OR '{{ max_date }}' = '')
GROUP BY s.id, s.name, s.city, s.contract_date
{% if sort_by == 'name_asc' %}
ORDER BY s.name ASC
{% elif sort_by == 'name_desc' %}
ORDER BY s.name DESC
{% elif sort_by == 'city_asc' %}
ORDER BY s.city ASC NULLS LAST
{% elif sort_by == 'city_desc' %}
ORDER BY s.city DESC NULLS LAST
{% elif sort_by == 'date_asc' %}
ORDER BY s.contract_date ASC
{% elif sort_by == 'date_desc' %}
ORDER BY s.contract_date DESC
{% elif sort_by == 'invoice_count_asc' %}
ORDER BY invoice_count ASC
{% elif sort_by == 'invoice_count_desc' %}
ORDER BY invoice_count DESC 
{% elif sort_by == 'total_invoices_asc' %}
ORDER BY total_invoices ASC
{% elif sort_by == 'total_invoices_desc' %}   
ORDER BY total_invoices DESC
{% else %}
ORDER BY s.name ASC
{% endif %};