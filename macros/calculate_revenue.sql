
{% macro calculate_revenue(extended_price, discount) %}
    ({{ extended_price }} * (1 - {{ discount }}))
{% endmacro %}