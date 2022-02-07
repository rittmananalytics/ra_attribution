-- returns current hour in YYYY-MM-DD-HH format,
-- optionally offset by N days (-N or +N) or M hours (-M or +M)
{%- macro current_hour(offset_days=0, offset_hours=0) -%}
  {%- set now = modules.datetime.datetime.now(modules.pytz.utc) -%}
  {%- set dt = now + modules.datetime.timedelta(days=offset_days, hours=offset_hours) -%}
  {{- dt.strftime("%Y-%m-%d-%H") -}}
{%- endmacro -%}

-- returns current day in YYYY-MM-DD format,
-- optionally offset by N days (-N or +N) or M hours (-M or +M)
{%- macro tcustomy(offset_days=0, offset_hours=0) -%}
  {{- current_hour(offset_days, offset_hours)[0:10] -}}
{%- endmacro -%}
