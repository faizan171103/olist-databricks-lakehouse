# Olist E-Commerce Analytics Platform

> **An end-to-end Analytics Engineering project transforming raw Brazilian e-commerce data into trusted, business-ready analytical models using Databricks, dbt, SQL, and Power BI.**

This project builds an analytics platform using the **Olist Brazilian E-Commerce dataset**. The goal is to transform raw operational data into reliable datasets that can be used for business analysis without requiring users to work directly with raw source tables.

The project follows a **Bronze → Silver → Gold** architecture, with **dbt** managing the transformation and modeling layer.

---

### Architecture

```text
Olist CSV Data
      │
      ▼
Databricks + Unity Catalog
      │
      ▼
   ┌─────────┐
   │ BRONZE  │  Raw source tables
   └────┬────┘
        │
        ▼
      dbt
        │
        ▼
   ┌─────────┐
   │ SILVER  │  Cleaned & standardized
   └────┬────┘
        │
        ▼
      dbt
        │
        ▼
   ┌─────────┐
   │  GOLD   │  Facts & dimensions
   └────┬────┘
        │
        ▼
    Power BI
        │
        ▼
 Business Analytics
```

The architecture separates:

**Raw Data → Transformation → Analytical Models → BI**

This keeps the data pipeline modular, testable, and reusable.

---

### Technology Stack

| Area            | Technology                |
| --------------- | ------------------------- |
| Data Platform   | Databricks                |
| Governance      | Unity Catalog             |
| Transformation  | dbt + SQL                 |
| Processing      | Spark / PySpark           |
| Data Modeling   | Dimensional / Star Schema |
| BI              | Power BI                  |
| Version Control | Git / GitHub              |
| Development     | VS Code                   |
| Languages       | SQL / Python              |

---

### Dataset

The project uses the **Olist Brazilian E-Commerce dataset**, covering multiple areas of the marketplace:

* Customers
* Orders
* Order Items
* Products
* Sellers
* Payments
* Reviews
* Geolocation
* Product Category Translation

These datasets allow the platform to connect transactional, customer, product, seller, payment, logistics, and review information into a unified analytical model.

---

### Project Context

E-commerce data is distributed across multiple operational datasets. Analyzing these datasets independently makes it difficult to establish consistent metrics and relationships.

This project creates a centralized analytical layer that transforms the source data into models designed around business questions such as:

* How are sales changing over time?
* Which product categories generate the most sales?
* Which customers and regions contribute the most value?
* How do sellers perform across different regions?
* How long do orders take to reach customers?
* Which payment methods are most commonly used?
* How are customer reviews distributed?
* How does delivery performance relate to customer experience?

---

### Bronze Layer

The Bronze layer contains the raw Olist source data loaded into Databricks and registered through Unity Catalog.

```text
e-commerce_olist
└── bronze_data
    ├── olist_customers_dataset
    ├── olist_order_items_dataset
    ├── olist_order_payments_dataset
    ├── olist_order_reviews_dataset
    ├── olist_orders_dataset
    ├── olist_products_dataset
    ├── olist_sellers_dataset
    ├── olist_geolocation_dataset
    └── product_category_name_translation
```

The Bronze layer is kept close to the original source so that raw information remains available for:

* Auditing
* Debugging
* Reprocessing
* Data lineage
* Investigating source-data issues

Source-quality issues are handled downstream rather than modifying the raw data directly.

---

### Silver Layer

The Silver layer transforms raw source tables into clean and standardized staging models using **dbt and SQL**.

```text
stg_customers
stg_orders
stg_order_items
stg_order_payments
stg_order_reviews
stg_products
stg_sellers
stg_geolocation
stg_category_translation
```

Transformations include:

* Data type standardization
* Null handling
* String normalization
* Timestamp conversion
* Data validation
* Filtering invalid records
* Preparing consistent fields for downstream models

Example:

```sql
CAST(price AS DECIMAL(12,2))
```

```sql
CAST(order_purchase_timestamp AS TIMESTAMP)
```

```sql
WHERE order_id IS NOT NULL
```

The Silver layer provides a consistent foundation for the analytical models.

---

### Gold Layer

The Gold layer contains the business-ready analytical models used by downstream analytics and Power BI.

#### Dimensions

```text
dim_customers
dim_products
dim_sellers
dim_date
```

#### Facts

```text
fact_orders
fact_order_items
fact_payments
fact_reviews
```

These models follow a dimensional modeling approach and provide a structured interface for analytical queries and reporting.

---

### Dimensional Model

```text
                     dim_date
                        │
                        ▼
dim_customers ────► fact_orders
                        │
                 ┌──────┴──────┐
                 ▼             ▼
          fact_payments   fact_reviews


dim_products ──► fact_order_items ◄── dim_sellers
```

The model separates descriptive dimensions from measurable business events, creating a structure suitable for analytical workloads and Power BI.

---

### Data Quality

Data quality is incorporated into the dbt transformation workflow.

Tests cover areas such as:

* Unique identifiers
* Required fields
* Accepted values
* Source validation
* Model relationships

Examples include validation of:

```text
customer_id
order_id
product_id
seller_id
```

and fields such as:

```text
order_status
review_score
```

Raw source issues are handled in downstream models while keeping the original Bronze data available for investigation and lineage.

---

### dbt

dbt acts as the core transformation layer of the project.

```text
Bronze Sources
      │
      ▼
Silver Staging Models
      │
      ▼
Gold Analytical Models
      │
      ▼
Power BI
```

The project uses core dbt functionality including:

* `source()`
* `ref()`
* SQL models
* Schema tests
* Model dependencies
* Reusable transformations
* Documentation metadata

Example source reference:

```sql
FROM {{ source('olist_bronze', 'olist_orders_dataset') }}
```

Example model dependency:

```sql
FROM {{ ref('stg_orders') }}
```

Using `ref()` allows dbt to understand relationships between models and construct the transformation workflow.

---

### Power BI

Power BI consumes the **Gold analytical layer** rather than the raw source data.

```text
Gold Models
     │
     ▼
Power BI Semantic Model
     │
     ▼
DAX Measures
     │
     ▼
Dashboards & Reports
```

The analytical model supports reporting across:

* Sales performance
* Customer behavior
* Product performance
* Seller performance
* Payment methods
* Delivery performance
* Freight costs
* Customer reviews

---

### Key Engineering Decisions

**Preserve raw data**

Bronze remains close to the source to maintain traceability and reproducibility.

**Separate staging and analytical models**

Silver focuses on cleaning and standardization, while Gold provides business-ready analytical structures.

**Use dimensional modeling**

Facts and dimensions provide a consistent structure for analytical queries and BI consumption.

**Centralize transformations in dbt**

SQL transformations, dependencies, and data-quality tests are maintained within the dbt project.

---

### Running the Project

Clone the repository:

```bash
git clone https://github.com/faizan171103/olist-databricks-lakehouse.git
```

Navigate to the project:

```bash
cd olist-databricks-lakehouse
```

Configure the local Databricks connection and then validate the dbt environment:

```bash
dbt debug
```

Build the models:

```bash
dbt build
```

Run the data-quality tests:

```bash
dbt test
```

---

### Project Outcome

The final platform creates a complete path from raw operational data to business analytics:

```text
Raw Olist Data
      │
      ▼
  Databricks
      │
      ▼
    Bronze
      │
      ▼
     dbt
      │
      ▼
    Silver
      │
      ▼
     dbt
      │
      ▼
     Gold
      │
      ▼
Dimensional Model
      │
      ▼
   Power BI
      │
      ▼
Business Analytics
```

The project demonstrates practical Analytics Engineering across:

**SQL · dbt · Data Modeling · Data Quality · Databricks · Lakehouse Architecture · Git · Power BI**

---

### Author

**Mohd Faizanul Haque**

Data Analytics / Analytics Engineering Portfolio

[GitHub — @faizan171103](https://github.com/faizan171103)


