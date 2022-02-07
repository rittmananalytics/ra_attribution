{% if var('attribution_warehouse_click_id_sources') %}
{{config(materialized="table")}}

with t_click_id_merge_list as
  (
    {% for source in var('attribution_warehouse_click_id_sources') %}
      {% set relation_source = 'stg_' + source + '_click_ids' %}

      select
        '{{source}}' as source,
        *
        from {{ ref(relation_source) }}

        {% if not loop.last %}union all{% endif %}
      {% endfor %}
  )
select * from t_click_id_merge_list

{% else %}

{{config(enabled=false)}}

{% endif %}
