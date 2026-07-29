{% macro calculate_discounted_price(extended_price, discount) %}
    ({{ extended_price }} * (1 - {{ discount }}))
{% endmacro %}

{% macro calculate_total_charged_amount(extended_price, discount, tax_rate) %}
    ({{ extended_price }} * (1 - {{ discount }})) * (1 + {{ tax_rate }})
{% endmacro %}