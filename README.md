# Snow dbt

A dbt project for building a Snowflake data warehouse using a layered medallion-style architecture. The project ingests TPC-H source data from a raw database and transforms it through bronze, silver, and gold models to support analytics and reporting.

## Overview

This project is designed to demonstrate a practical dbt workflow in Snowflake with:

- Source ingestion from `RAW_DB.TPCH`
- Bronze models for raw-to-structured landing
- Silver models for cleaning, deduplication, and enrichment
- Gold marts for business-level analytics
- Incremental processing for efficient refreshes
- Custom macros and tests for reusable logic

## Project Structure

```text
.
├── analyses/
├── macros/
│   ├── calculate_revenue.sql
│   ├── calculations.sql
│   ├── derive_name.sql
│   ├── generate_schema_name.sql
│   ├── test_is_positive.sql
│   └── weekname
├── models/
│   ├── marts/
│   │   ├── DIM_CUSTOMERS.SQL
│   │   ├── fact_order_lines.sql
│   │   ├── fct_customer_orders.sql
│   │   ├── monthly_sales.sql
│   │   └── sales_by_brand.sql
│   ├── schema.yml
│   ├── silver/
│   │   ├── silver_customer.sql
│   │   ├── silver_lineitem.sql
│   │   ├── silver_orders.sql
│   │   └── silver_parts.sql
│   └── source/
│       ├── _source.yml
│       ├── bronze_customer.sql
│       ├── bronze_lineitem.sql
│       ├── bronze_orders.sql
│       └── bronze_parts.sql
├── seeds/
├── snapshots/
├── tests/
├── .gitignore
├── .user.yml
├── dbt_project.yml
├── profiles.yml
├── README.md
└── packages.yml
```

## Data Transformation Layers

### 1) Source Layer
The `models/source` directory maps raw Snowflake tables from the `TPCH` schema in `RAW_DB`.

Source tables:
- `customer`
- `orders`
- `lineitem`
- `part`

### 2) Bronze Layer
Bronze models load and standardize raw data into a raw analytical format. These models are assigned to the `bronze` schema via the project config.

### 3) Silver Layer
Silver models clean and deduplicate the data, apply business rules, and enrich raw fields. Examples include:
- `silver_orders.sql`
- `silver_customer.sql`
- `silver_lineitem.sql`
- `silver_parts.sql`

### 4) Gold Layer
Gold models expose analytics-ready facts and dimensions for reporting and dashboarding. Examples include:
- `fact_order_lines.sql`
- `fct_customer_orders.sql`
- `monthly_sales.sql`
- `sales_by_brand.sql`
- `DIM_CUSTOMERS.SQL`

## dbt Configuration

The project name is configured as `snowdbt` and uses the following schema mapping:

- `source` -> `bronze`
- `silver` -> `silver`
- `marts` -> `gold`

This is defined in `dbt_project.yml`.

## Custom Macros

The project includes reusable dbt macros for common transformation logic:

- `derive_name(column_name)`
  - normalizes values such as `Customer#0001` into `Customer-1`
- `calculate_revenue(extended_price, discount)`
  - calculates discounted revenue
- `generate_schema_name(custom_schema_name, node)`
  - controls schema naming behavior
- `test_is_positive(model, column_name)`
  - validates positive numeric values

## Testing

The project defines schema tests in `models/schema.yml` and includes validation logic such as:
- `unique`
- `not_null`
- custom `is_positive` test

Run tests with:

```bash
dbt test
```

## Prerequisites

Before running this project, make sure you have:

- Python installed
- dbt installed
- Snowflake access with a valid user, role, and warehouse
- Environment variables configured for your Snowflake connection

## Environment Variables

Set the following variables before running dbt:

```bash
export DBT_SNOWFLAKE_ACCOUNT="your_account"
export DBT_SNOWFLAKE_USER="your_user"
export DBT_SNOWFLAKE_PASSWORD="your_password"
export DBT_SNOWFLAKE_ROLE="your_role"
export DBT_SNOWFLAKE_WAREHOUSE="your_warehouse"
export DBT_SNOWFLAKE_DATABASE="your_database"
export DBT_SNOWFLAKE_SCHEMA="your_schema"
```

## Setup

1. Clone the repository
2. Install dbt dependencies
3. Configure your Snowflake connection in `profiles.yml`
4. Run dbt debug to validate the connection

Example:

```bash
dbt debug
```

## Common Commands

```bash
# Check connection

dbt debug

# Run all models

dbt run

# Run tests

dbt test

# Build models and tests together

dbt build

# Clean build artifacts

dbt clean
```

## Notes

This project is a strong example of a medallion architecture in dbt and is especially useful for:

- analytics engineering learning
- Snowflake warehouse transformations
- incremental data modeling
- business reporting layer creation

## License

This project does not currently declare a license. If you want to publish it publicly, consider adding an appropriate open-source license such as MIT or Apache 2.0.

## Author

Pavan16164

## Repository

https://github.com/Pavan16164/Snow_dbt
