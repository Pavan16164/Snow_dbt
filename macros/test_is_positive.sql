{% test is_positive(model, column_name) %}

    -- This will fail if the column value is less than 0
    select *
    from {{ model }}
    where {{ column_name }} <= 0

{% endtest %}