# 🥕 FarmKart — Database Management System

> **"Freshness to your doorstep"** — A locally grown produce delivery service for the Buffalo, NY community.

![Version](https://img.shields.io/badge/version-1.0-blue)
![SQL](https://img.shields.io/badge/SQL-PostgreSQL%20%2F%20Standard%20SQL-336791)
![Normal Form](https://img.shields.io/badge/Normal%20Form-3NF-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

---

## 📌 Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Repository Structure](#repository-structure)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Database Tables](#database-tables)
- [Business Rules](#business-rules)
- [Getting Started](#getting-started)
- [Sample Queries](#sample-queries)
- [Bug Fixes & Improvements](#bug-fixes--improvements)
- [Team](#team)

---

## Project Overview

FarmKart is a **Farmer's Market on Wheels** — a biweekly delivery service that connects local Buffalo-area farms (vendors) to community customers through a fleet of vehicles and a network of neighbourhood pickup locations.

This repository contains the complete relational database design for FarmKart, including:

| Artefact | Description |
|---|---|
| DDL scripts | Table creation (3NF), data types, constraints, foreign keys |
| DML scripts | Sample seed data for all 21 tables |
| Business queries | 12 analytical SQL queries for operations & reporting |
| ERD diagram | Full entity-relationship / schema diagram (SVG) |

---

## Architecture

```
                ┌─────────────┐
                │  Web / App  │  (Customer-facing)
                └──────┬──────┘
                       │ bi-directional data flow
          ┌────────────▼────────────┐
          │    FarmKart Database    │
          │     (PostgreSQL / SQL)  │
          └────────────┬────────────┘
         ┌─────────────┼──────────────┐
    ┌────▼────┐   ┌────▼────┐   ┌────▼────┐
    │ Orders  │   │Logistics│   │Reporting│
    │ & POS   │   │& Ops    │   │& Analytics│
    └─────────┘   └─────────┘   └──────────┘
```

**Key design decisions:**
- All tables normalised to **3rd Normal Form (3NF)**
- Every table includes audit columns (`Create_Date`, `Update_Date`, `User_ID`) in production
- Database is **scalable** — designed for Buffalo but supports nation-wide expansion
- Schedules run **biweekly** (twice per week) per neighbourhood

---

## Repository Structure

```
farmkart-dbms/
│
├── sql/
│   ├── ddl/
│   │   └── 01_create_tables.sql     ← CREATE TABLE statements (run first)
│   ├── dml/
│   │   └── 02_seed_data.sql         ← INSERT sample data (run second)
│   └── queries/
│       └── 03_business_queries.sql  ← Analytics & reporting queries
│
├── diagrams/
│   └── erd_schema.svg               ← Entity Relationship Diagram
│
├── docs/
│   └── business_rules.md            ← Full business rules reference
│
└── README.md
```

---

## Entity Relationship Diagram

![ERD](diagrams/erd_schema.svg)

> Open `diagrams/erd_schema.svg` in any browser for a full-resolution view.

---

## Database Tables

| # | Table | Description |
|---|---|---|
| 1 | `Customer` | Customer master record |
| 2 | `CustomerAddress` | One-to-many customer addresses |
| 3 | `CustomerContact` | Customer email & phone contacts |
| 4 | `Job` | Job roles with salary bands |
| 5 | `Employees` | Employee master with manager hierarchy |
| 6 | `JobHistory` | Employee job history (role changes) |
| 7 | `Employee_Address` | Employee address(es) |
| 8 | `Employee_Contact` | Employee email & phone |
| 9 | `Location` | Neighbourhood pickup locations |
| 10 | `Vehicle` | Fleet vehicles (vans & buses) |
| 11 | `Payment` | Supported payment methods |
| 12 | `Vendor` | Farm/supplier master records |
| 13 | `ProductCategory` | Product categories (Fruits, Veg, Dairy…) |
| 14 | `Products` | Product catalogue with pricing |
| 15 | `TimeTable` | Vehicle-location-employee schedule |
| 16 | `Orders` | Customer order header |
| 17 | `OrderItems` | Customer order line items |
| 18 | `VOrder` | Vendor (supply) order header |
| 19 | `VOrderItems` | Vendor order line items |
| 20 | `Warehouse` | Warehouse inventory by product & vendor order |
| 21 | `WarehouseEmployeeDetails` | Employee warehouse assignment history |

---

## Business Rules

### Customer
- A customer can have **one or many** addresses; an address can belong to **many customers**
- A customer can have **one or many** contacts; a contact belongs to **only one** customer

### Employee
- An employee can have one or many addresses/contacts
- An employee can drive **only one vehicle** at a given time
- An employee works in **exactly one warehouse** at a given time

### Orders
- An order is placed by **only one customer** and paid via **one payment type**
- An order is picked up at **one location** from **one vehicle**
- An order can contain **one or many products**

### Vendor Orders
- A vendor can have **one or many** vendor orders
- A vendor order goes to **exactly one warehouse**
- A vendor order is paid via **one payment type**

### Warehouse
- A warehouse can hold **multiple products** from **multiple vendor orders**
- A warehouse can employ **multiple employees** over time

### Product
- A product belongs to **exactly one** product category
- A product can appear in **multiple orders** and **multiple warehouses**

---

## Getting Started

### Prerequisites
- PostgreSQL 13+ (or any ANSI SQL-compatible RDBMS)
- `psql` CLI or any SQL client (DBeaver, TablePlus, etc.)

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/your-org/farmkart-dbms.git
cd farmkart-dbms

# 2. Create the database
psql -U postgres -c "CREATE DATABASE farmkart;"

# 3. Run DDL — create all tables
psql -U postgres -d farmkart -f sql/ddl/01_create_tables.sql

# 4. Run DML — insert seed data
psql -U postgres -d farmkart -f sql/dml/02_seed_data.sql

# 5. (Optional) Run business queries
psql -U postgres -d farmkart -f sql/queries/03_business_queries.sql
```

---

## Sample Queries

### Average order value per product
```sql
SELECT
    p.Description          AS product_name,
    ROUND(AVG(oi.LineItemTotal), 2) AS avg_order_value
FROM OrderItems oi
LEFT JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY p.Description
ORDER BY avg_order_value DESC;
```

### Top 10 customers by spend
```sql
SELECT
    c.CFirstName || ' ' || c.CLastName AS customer_name,
    SUM(o.OrderTotal)                  AS total_spent,
    DENSE_RANK() OVER (ORDER BY SUM(o.OrderTotal) DESC) AS rank
FROM Orders o
INNER JOIN Customer c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CFirstName, c.CLastName
ORDER BY rank
LIMIT 10;
```

### Revenue by product category
```sql
SELECT
    pc.Category,
    SUM(oi.LineItemTotal) AS total_revenue
FROM OrderItems oi
JOIN Products p         ON oi.ProductID   = p.ProductID
JOIN ProductCategory pc ON p.PCategoryID  = pc.PCategoryID
GROUP BY pc.Category
ORDER BY total_revenue DESC;
```

> See `sql/queries/03_business_queries.sql` for all 12 analytical queries.

---

## Bug Fixes & Improvements

The following issues from the original document were corrected in this repository:

| # | Issue | Fix Applied |
|---|---|---|
| 1 | `ORDER` used as table name (reserved SQL keyword) | Renamed to `Orders` |
| 2 | `Phone` stored as `INT` — loses leading zeros & formatting | Changed to `VARCHAR(20)` |
| 3 | `Employee_ZIP` stored as `INT` | Changed to `VARCHAR(10)` |
| 4 | `Salary` stored as `INT` — no decimal support | Changed to `NUMERIC(10,2)` |
| 5 | `JobHistory` was missing the `EmployeeID` foreign key | Added `FK EmployeeID → Employees` |
| 6 | `varchar2()` used (Oracle-only syntax) | Replaced with standard `VARCHAR(n)` |
| 7 | Dates in INSERT statements were inconsistent formats (`3/1/21`, `2020-10-12`) | Standardised to ISO 8601 (`YYYY-MM-DD`) |
| 8 | `Order_Total(D)` invalid column syntax | Renamed to `OrderTotal NUMERIC(10,2)` |
| 9 | Business query Q4 had `WHERE` after `GROUP BY` (invalid SQL) | Moved filter to outer query using `LIMIT` |
| 10 | `WarehouseEmployees` had typo `PRIMARYKEY` (missing space) | Corrected to `PRIMARY KEY` |
| 11 | `varchar2()` with no length (Oracle-only) | Replaced with `VARCHAR(255)` |
| 12 | `Employee_Contact` / `Employee_Address` used `varchar2()` | Standardised to `VARCHAR` |

---

## Product Categories

| ID | Category |
|---|---|
| 1 | Fruits |
| 2 | Vegetables |
| 3 | Foodgrains |
| 4 | Dairy |
| 5 | Beverages |
| 6 | Eggs |
| 7 | Meat |
| 8 | Fish |

---

## Payment Methods Supported

`Credit Card` · `Debit Card` · `Apple Pay` · `Google Pay` · `Samsung Pay` · `PayPal` · `Zelle` · `Venmo`

---

## Team

| Name |
|---|
| Nandita Raghuvanshi |
| Kunjesh Saad |
| Aditya Sawant |
| Uma Prakash Radhakrishnan Ruckmani |

**Institution:** University at Buffalo — School of Management  
**Version:** 1.0 · **Date:** April 26, 2021

---

## License

This project is for academic and educational purposes. All rights reserved by the original authors.
