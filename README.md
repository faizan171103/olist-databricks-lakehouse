Olist E-Commerce Analytics Platform

An end-to-end Analytics Engineering project transforming raw Brazilian e-commerce data into trusted, business-ready datasets for analytics and decision-making.

This project builds an analytics platform around the Olist Brazilian E-Commerce dataset, following an Analytics Engineering approach to transform raw operational data into clean, tested, documented, and reusable analytical models.

Rather than connecting a BI tool directly to raw source tables, the project establishes a transformation layer that separates raw data, cleaned data, business logic, and analytical consumption.

The result is a reusable data foundation that can answer questions around sales, customers, products, sellers, payments, logistics, and customer experience.

What This Project Demonstrates

This project focuses on the core responsibilities of an Analytics Engineer:

Designing analytical data models
Transforming raw data using SQL and dbt
Building reusable staging models
Developing fact and dimension tables
Defining business logic in centralized models
Implementing data quality tests
Managing dependencies with dbt
Building a dimensional model for BI
Working with a Lakehouse architecture
Version-controlling analytics code with Git
Delivering trusted datasets to Power BI

The overall workflow is:

Raw Operational Data
        │
        ▼
   Databricks
        │
        ▼
      Bronze
   Raw / Preserved
        │
        ▼
       dbt
        │
        ▼
      Silver
 Cleaned / Standardized
        │
        ▼
       dbt
        │
        ▼
       Gold
 Business / Analytical Models
        │
        ▼
     Power BI
        │
        ▼
 Analytics & Reporting
1. Project Context

E-commerce businesses generate data across multiple operational domains.

Orders, customers, products, sellers, payments, reviews, and logistics information are often stored separately. While each dataset may be useful individually, meaningful business analysis requires these sources to be connected through consistent definitions and analytical models.

This project addresses that problem by creating a centralized analytical layer on top of the Olist dataset.

Instead of treating the source CSV files as the final analytical data, the project transforms them into a structured model designed around business questions.

2. Business Questions

The analytical layer is designed to support questions such as:

Sales
How are sales changing over time?
Which product categories contribute the most sales?
What is the average order value?
How does order volume vary across regions?
Customers
Where are customers located?
How frequently do customers purchase?
Which customer groups contribute the most value?
Products
Which categories and products perform best?
How do product characteristics relate to sales?
What is the relationship between product price and freight cost?
Sellers
Which sellers generate the most order value?
How does seller performance vary geographically?
How does seller activity differ across regions?
Logistics
How long do orders take to reach customers?
Which orders experience delivery delays?
How does freight cost compare with product price?
Customer Experience
How are review scores distributed?
How does delivery performance relate to customer reviews?
Which areas of the marketplace show weaker customer experience?
3. Architecture

The platform follows a Medallion-style Lakehouse architecture.

                    ┌──────────────────────┐
                    │   Olist Source Data  │
                    │       CSV Files      │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │      Databricks      │
                    │     Unity Catalog    │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │       BRONZE         │
                    │   Raw Source Data    │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │         dbt          │
                    │   SQL Transformations│
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │       SILVER         │
                    │ Clean & Standardized │
                    │      Models          │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │         dbt          │
                    │   Business Logic     │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │        GOLD          │
                    │ Facts + Dimensions   │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │      Power BI        │
                    │ Semantic Model & BI  │
                    └──────────────────────┘

The architecture intentionally separates:

Raw data → Transformation → Business logic → Consumption

This makes analytical logic easier to maintain, test, understand, and reuse.

4. Technology Stack
Layer	Technology
Data Platform	Databricks
Governance	Unity Catalog
Processing	Apache Spark / PySpark
Transformation	dbt + SQL
Analytical Storage	Databricks
Data Modeling	Dimensional Modeling
BI	Power BI
Version Control	Git / GitHub
Development	VS Code
Languages	SQL / Python

The core of the project is SQL + dbt + analytical modeling, with Databricks providing the Lakehouse environment.

5. Source Data

The project uses the Olist Brazilian E-Commerce dataset.

The source consists of multiple datasets covering different parts of the marketplace:

customers
orders
order_items
payments
reviews
products
sellers
geolocation
category_translation

These sources collectively provide the information required to analyze the marketplace from several business perspectives.

6. Bronze Layer

The Bronze layer represents the source data as closely as possible.

e-commerce_olist
└── bronze_data
    ├── olist_customers_dataset
    ├── olist_geolocation_dataset
    ├── olist_order_items_dataset
    ├── olist_order_payments_dataset
    ├── olist_order_reviews_dataset
    ├── olist_orders_dataset
    ├── olist_products_dataset
    ├── olist_sellers_dataset
    └── product_category_name_translation
Design principle

The Bronze layer is not treated as the place to fix everything.

Raw information is preserved so that downstream transformations can be traced back to the original source.

This provides a useful foundation for:

Auditing
Debugging
Reprocessing
Data lineage
Investigating source-data issues

For example, malformed review records were retained in Bronze and handled during downstream transformation rather than modifying the raw source.

7. Silver Layer

The Silver layer is where the raw source becomes usable analytical data.

dbt is used to create reusable staging models:

stg_customers
stg_orders
stg_order_items
stg_order_payments
stg_order_reviews
stg_products
stg_sellers
stg_geolocation
stg_category_translation

Typical transformations include:

Data type standardization
CAST(price AS DECIMAL(12,2))

CAST(payment_value AS DECIMAL(12,2))

CAST(order_purchase_timestamp AS TIMESTAMP)

CAST(review_score AS INT)
Standardization
TRIM(customer_id)

UPPER(customer_city)

UPPER(customer_state)

LOWER(order_status)
Data validation
WHERE order_id IS NOT NULL

and business-rule validation such as:

review_score BETWEEN 1 AND 5

The objective is not simply to "clean data", but to establish consistent models that downstream analytics can depend on.

8. Gold Layer

The Gold layer represents the analytical interface of the platform.

Instead of exposing raw operational structures to BI users, business logic is organized into reusable fact and dimension models.

Dimensions
dim_customers
dim_products
dim_sellers
dim_date
Facts
fact_orders
fact_order_items
fact_payments
fact_reviews

This creates a dimensional model suitable for analytical workloads and Power BI.

9. Dimensional Model

The analytical model follows a star-schema-oriented design.

                    dim_date
                       │
                       ▼
dim_customers ───► fact_orders
                       │
                       │
                 ┌─────┴─────┐
                 ▼           ▼
          fact_payments   fact_reviews


dim_products ───► fact_order_items ◄─── dim_sellers

dbt

dbt is the central transformation framework in the project.

The transformation graph follows:

Sources
   │
   ▼
Staging Models
   │
   ▼
Business Models
   │
   ▼
Facts / Dimensions

The project uses core dbt concepts including:

source()
ref()
SQL models
Schema tests
Model dependencies
Model organization
Documentation metadata

Engineering Decisions
Preserve raw data

Bronze remains close to the source instead of being aggressively transformed.

Reason: maintain traceability and reproducibility.

Separate staging from business logic

Silver models handle standardization and preparation, while Gold models introduce analytical business logic.

Reason: avoid mixing source cleanup with business definitions.

Use dimensional modeling

Facts and dimensions provide a consistent interface for analytical workloads.

Reason: make downstream BI consumption simpler and more predictable.

Centralize transformations in dbt

Business logic is implemented as version-controlled SQL models.

Reason: improve maintainability, testing, lineage, and collaboration.

