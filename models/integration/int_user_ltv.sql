{% if var('attribution_warehouse_ltv_sources') %}
{{config(materialized="table")}}

with t_users_ltv_merge_list as
  (
    {% for source in var('attribution_warehouse_ltv_sources') %}
      {% set relation_source = 'stg_' + source + '_ltv' %}

      select
        '{{source}}' as source,
        *
        from {{ ref(relation_source) }}

        {% if not loop.last %}union all{% endif %}
      {% endfor %}
  )
select * from t_users_ltv_merge_list

{% else %}

{{config(enabled=false)}}

{% endif %}
