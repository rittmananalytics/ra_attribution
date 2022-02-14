# RA Attribution for dbt

This dbt package provides a multi-touch, multi-cycle marketing attribution model that helps marketers better understand the contribution each online marketing channel makes to order revenue, and the cost and return on investment from ad channel spend that led to those conversions.

## Supported Data Sources and Warehouse Target

The package assumes that orders and user registrations along with customer LTV measures and currency FX rates come from tables replicated from a customer application database, and marketing touchpoints are sourced from Snowplow. Ad Spend data comes via Fivetran from Google Ads, Facebook Ads and Snapchat Ads, as shown in the high-level data flow diagram below.

![](img/image-20220213-224936.png)

Whilst as much use as possible has been made of dbt\_utils cross-database SQL functions, the target data warehouse platform is assumed to be Snowflake and this package has not yet been tested on BigQuery or other dbt-supported warehouse platforms.

Credit is also due to Fivetran for their community-released Google Ads, Facebook Ads and Snapchat Ads dbt modules from which functionality and code has been incorporated into this package.

### Dependencies

*   dbt core 1.0.1 or higher

    *   dbt\_utils 0.8.0 or higher

    *   fivetran\_utils 0.3.2 or higher

*   Snowflake data warehouse

*   Fivetran for Google Ads, Facebook Ads and Snapchat Ads API replication

*   Snowplow

*   Orders, Order Lines, User, Currency Rates and Customer LTV table extracts from your custom app database


### How to Run this Package

1.  Configure Fivetran to replicate your Facebook Ads, Google Ads and/or Snapchat Ads data into your Snowflake Data Warehouse

2.  Configure Fivetran to replicate your Orders, Order Details, Users, Currency Conversion Rates and Customer Lifetime Value tables also into Snowflake, and map the columns in your incoming tables to the expected columns in the STG\_CUSTOM\_EVENTS\_ORDER\_EVENTS, STG\_CUSTOM\_EVENTS\_REGISTRATION\_EVENTS, STG\_CUSTOM\_LTV\_CUSTOMER\_LTV and STG\_CURRENCY\_RATES dbt models

    1.  Sample data for these models is included as seed files in the package, and the default “true” setting for the `attribution_demo_mode` configuration variable will use these seed file values by default when you run the package

3.  Set the configuration variables in `dbt_project.yml` to point to your Snowflake database and schemas

4.  Run the package using `dbt build`.


### DAG Lineage Graphs

#### Overall Package Running in Demo Mode

![](img/image-20220214-001921.png)

#### Integration and Warehouse Layers

![](img/image-20220214-002146.png)

## Supported Attribution Models

|     |     |
| --- | --- |
| **Model Name** | **Description** |
| First Click | Attributes 100% of each first order, subsequent order and account opening to the first marketing or non-marketing touchpoint over a 30-day (default) look-back window |
| Last Click | Attributes 100% of each first order, subsequent order and account opening to the last marketing or non-marketing touchpoint over a 30-day (default) look-back window |
| Last Non-Direct Click | Attributes 100% of each first order, subsequent order and account opening to the last marketing touchpoint over a 30-day (default) look-back window |
| Last Paid Click | Attributes 100% of each first order, subsequent order and account opening to the last paid marketing touchpoint over a 30-day (default) look-back window |
| Even Click | Attributes evenly a share of each first order, subsequent order and account opening to each touchpoint  over a 30-day (default) look-back window |
| Time-Decay | Attributes a percentage of the credit to all the channels on the conversion path for a time-decay period: the amount of credit for each channel is less (decaying) the further back in time the channel was interacted (0.5, 0.25, 0.125 etc) shared across all touchpoints for the day, over a 30-day (default) look-back window and 7-day (default) time-decay look-back window |
|     |     |

## Conversion Measures and Currencies

The attribution model within this package is a multi-cycle, multi-touch revenue attribution model that attributes

*   new account openings,

*   count and local/global currency value of first and repeat orders

*   customer LTV value (30, 60, 90, 180 and 365 days spend since first order) on first order conversion


## Account Opening, First and Repeat Order Conversion Cycles

Each conversion has its own conversion cycle with the assumption that account openings and first orders occur once at most for each customer, and repeat orders occur zero or more times.

![](img/image-20220208-212618.png)

## Package Configuration Variables

All configuration variables are contained with the `dbt_project.yml` dbt configuration file, along with configuration options for the Fivetran Google Ads, Facebook Ads and Snapchat Ads included modules.

|     |     |     |     |
| --- | --- | --- | --- |
| Category | Variable | Defaults | Purpose |
| Data Sources | stg\_custom\_events\_schema | CUSTOM\_DB\_EXTRACT | Custom event table schema |
| Data Sources | stg\_custom\_events\_database | RA\_DATA\_WAREHOUSE\_DEV | Custom event table database |
| Data Sources | stg\_custom\_ltv\_schema | CUSTOM\_DB\_EXTRACT | Custom ltv table schema |
| Data Sources | stg\_custom\_ltv\_database | RA\_DATA\_WAREHOUSE\_DEV | Custom ltv table database |
| Data Sources | stg\_custom\_currency\_schema | CUSTOM\_DB\_EXTRACT | Custom Currency FX table schema |
| Data Sources | stg\_custom\_currency\_database | RA\_DATA\_WAREHOUSE\_DEV | Custom Currency FX table database |
| Enabled Sources | attribution\_warehouse\_ad\_campaign\_sources | \['facebook\_ads','google\_ads'\] | sources, from facebook\_ads, google\_ads and snapchat\_ads that are in-scope for ad spend attribution |
| Enabled Sources | attribution\_warehouse\_ad\_group\_sources | \['facebook\_ads','google\_ads'\] | sources, from facebook\_ads, google\_ads and snapchat\_ads that are in-scope for ad spend attribution |
| Enabled Sources | attribution\_warehouse\_ad\_sources | \['facebook\_ads','google\_ads'\] | sources, from facebook\_ads, google\_ads and snapchat\_ads that are in-scope for ad spend attribution |
| Enabled Sources | attribution\_warehouse\_click\_id\_sources | \['google\_ads'\] | sources that provide click IDs for matching to Snowplow clicks |
| Enabled Sources | attribution\_warehouse\_currency\_rate\_sources | \['custom\_currency\_rates'\] | source of currency rates |
| Enabled Sources | attribution\_warehouse\_event\_sources | \['custom\_events\_order','custom\_events\_registration','snowplow\_events\_all'\] | event sources for revenue attribution |
| Enabled Sources | attribution\_warehouse\_ltv\_sources | \['custom\_ltv\_customer'\] | ltv sources for ltv measures |
| Model Parameters | attribution\_create\_account\_event\_type | user\_registration | event name for registration events |
| Model Parameters | attribution\_conversion\_event\_type | confirmed\_order | event name for order events |
| Model Parameters | attribution\_global\_currency | USD' | currency code for global amounts |
| Model Parameters | attribution\_lookback\_days\_window | 30  | how far back sessions can go to be eligable for attribution |
| Model Parameters | attribution\_time\_decay\_days\_window | 7   | over how many days do we decay the value of conversions for time-decay model |
| Model Parameters | attribution\_include\_conversion\_session | TRUE | whether the session containing the conversion event is within scope for attribution |
| Model Parameters | attribution\_match\_offline\_conversions\_to\_sessions | TRUE | whether orders and registrations are matched to Snowplow sessions or not |
| Model Parameters | attribution\_max\_session\_hours | 24  | maximum length of a session in hours to be considered for matching purposes |
| Model Parameters | attribution\_demo\_mode | TRUE | set to 'true' to source events |
| Measures | attribution\_models | _see dbt\_project.yml_ | list of model names to be appended to measures |
| Measures | attribution\_input\_measures | _see dbt\_project.yml_ | list of attribution input measures |
| Measures | attribution\_output\_conversion\_measures | _see dbt\_project.yml_ | list of attribution output conversion measures |
| Measures | attribution\_output\_revenue\_measures | _see dbt\_project.yml_ | list of attribution output revenue measures |

## Matching Orders and User Registrations to Snowplow Sessions

In order to use first and repeat orders + user registrations as the conversion events that we then attribute across sessions, we create our own “confirmed order” events from the transactions and “user registration” events from customer records in the custom application database tables extract.

### Matching Orders and User Registration Events to Snowplow Sessions

As these confirmed\_order and user\_registration events will not have Snowplow domain\_session\_ids, we attempt to match these events to existing Snowplow-derived sessions using the following rules:

1.  We first aggregate all of the Snowplow events that contain a domain\_session\_id value to give us the starting timestamp, ending timestamp and domain\_session\_id for each Snowplow session

2.  We then add up to 30 minutes to the end of each of those Snowplow-derived sessions, up to the timestamp of the next session for the same user

3.  Then we attempt to match each order and user registration event to one of the Snowplow-derived sessions, with the additional (up to) 30 minutes allowing for the fact that the user may have visited a checkout page but not completed the checkout until up to 30 minutes later (the generally accepted length of a user session)

    1.  Each session has its length in hours calculated, and only sessions that are <=24 hours in length are considered for matching orders and accounts openings to; as before, any orders/new accounts not so matched will be assigned their own session

    2.  Two variables in the dbt\_project.yml file control the matching of orders/new accounts to Snowplow sessions:

        `attribution_match_offline_conversions_to_sessions` (default value - true) controls whether new accounts/orders are matched with existing Snowplow sessions; if this variable is set to false then no matching takes place whatsoever

        `attribution_max_session_hours` (default value: 24) determines the maximum length in hours that a session can run for in order to be eligible for matching to order or new account events

4.  If we find a match, the session\_id and session\_type (“Snowplow”) of the matching Snowplow session is used for those values for the order or user registration event

5.  If we don’t find a match, then we use `md5(concat(event_id, user_id)))` for the session\_id for the `confirmed_order` or `user_registration event`, and set the session\_type to "dbt Generated"


## Glossary

|     |     |     |
| --- | --- | --- |
| **Name** | **Example** | **Marketing Channel Data Source** |
| Conversion Session | Session in which one or more conversion events happened, for example a first or repeat order, or a new customer registration | UTM Source, Medium, Campaign etc for the landing page view (first page view in session)<br><br>Note that the attribution model can be configured to include or exclude conversion sessions from the scope of those over which conversions can be attributed.<br><br>This option is set via the `attribution_include_conversion_session` variable in the dbt\_project.yml configuration file, set to true by default i.e. conversion sessions are within scope for attribution of conversions.<br><br>Rationale for providing this option is that conversion sessions |
| Marketing Touchpoint Session | Session in which the landing website page or first mobile app interaction can be attributed to the Direct channel |     |
| Account Opening | Conversion event, one only over the lifetime of a user, containing the user’s registration event; may also contain marketing and non-marketing touchpoints, and a first order | UTM Source, Medium, Campaign etc for the landing page view (first page view in session), or none if the event did not happen within 30 minutes of a web or mobile app session |
| First Order Conversion, First Order Revenue | Conversion event, one only over the lifetime of a user, containing the first confirmed order for a user | UTM Source, Medium, Campaign etc for the landing page view (first page view in session), or none if the event did not happen within 30 minutes of a web or mobile app session |
| Repeat Order Conversion, Repeat Order Revenue | Conversion event, for which there may be none, one or more than one over the lifetime of a user, containing one or more confirmed orders for a user that are not the first confirmed order for that user | UTM Source, Medium, Campaign etc for the landing page view (first page view in session), or none if the event did not happen within 30 minutes of a web or mobile app session |
