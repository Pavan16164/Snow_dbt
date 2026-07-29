{% macro derive_name(column_name) %}
    regexp_replace(
        {{ column_name }},
        $$([A-Za-z]+)#0*([0-9]+)$$,   -- Dollar quotes protect your regex patterns
        $$\1-\2$$                     -- Snowflake reads \1 and \2 exactly as written
    )
{% endmacro %}
