{% macro first_order(amount, currency_code, currency_rate) %}
    case when
        upper({{currency_code}})= '{{ var('attribution_global_currency') }}' or {{currency_rate}} is null
    then {{amount}}
        else round({{amount}} * {{currency_rate}} ,2)
    end
{% endmacro %}
