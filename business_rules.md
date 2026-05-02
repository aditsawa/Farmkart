# FarmKart — Business Rules Reference

> This document captures all 34 business rules that govern the FarmKart database design.

---

## 4.1 Customer Rules

| # | Rule |
|---|---|
| 1 | A given customer can have **one or many** addresses. |
| 2 | A given customer's address can belong to **many customers**. |
| 3 | A given customer can have **one or many** contacts. |
| 4 | A given customer's contact can belong to **only one** customer at a given point of time. |

**Cardinalities:** Customer ↔ CustomerAddress (1:M), Customer ↔ CustomerContact (1:M)

---

## 4.2 Employee Rules

| # | Rule |
|---|---|
| 5 | A given employee can have **one or many** addresses. |
| 6 | A given employee's address can belong to **many employees**. |
| 7 | A given employee can have **one or many** contacts. |
| 8 | A given employee's contact can belong to **only one** employee at a given point of time. |

**Cardinalities:** Employee ↔ Employee_Address (1:M), Employee ↔ Employee_Contact (1:M)

---

## 4.3 Order–Payment Rules

| # | Rule |
|---|---|
| 9  | A given order can be paid by **only one** payment type. |
| 10 | A payment type can have **multiple** associated orders. |
| 11 | A given customer can have **one or many** orders. |
| 12 | An order can be placed by **only one** customer. |

**Cardinalities:** Order ↔ Payment (M:1), Customer ↔ Order (1:M)

---

## 4.4 Order–Product Rules

| # | Rule |
|---|---|
| 13 | A given order can have **one or many** products. |
| 14 | A given product can belong to **multiple** orders. |

**Cardinalities:** Order ↔ Product (M:M via OrderItems)

---

## 4.5 Order–Vehicle Rules

| # | Rule |
|---|---|
| 15 | A given order can be picked from **one vehicle**. |
| 16 | A vehicle can have **multiple** orders. |

**Cardinalities:** Order ↔ Vehicle (M:1)

---

## 4.6 Order–Location Rules

| # | Rule |
|---|---|
| 17 | A given order can be picked from **only one** location. |
| 18 | A location can have **one or many** orders. |

**Cardinalities:** Order ↔ Location (M:1)

---

## 4.7 Order–Vendor Rules

| # | Rule |
|---|---|
| 19 | A given vendor can have **one or many** vendor orders. |
| 20 | A vendor order can belong to **one or multiple** vendors. |
| 21 | A Vendor Order can be paid by **only one** payment type. |
| 22 | A payment type can have **multiple** associated vendor orders. |

**Cardinalities:** Vendor ↔ VOrder (1:M), VOrder ↔ Payment (M:1)

---

## 4.8 Vehicle Rules

| # | Rule |
|---|---|
| 23 | A given employee can only drive **one vehicle** at a given point of time. |
| 24 | A given vehicle can be driven by **one employee**. |

**Cardinalities:** Employee ↔ Vehicle (1:1 at any point in time)

---

## 4.9 Vehicle–Location Rules

| # | Rule |
|---|---|
| 25 | A vehicle can go to **one or multiple** locations. |
| 26 | A given location can have **exactly one** vehicle. |

**Cardinalities:** Vehicle ↔ Location (1:M via TimeTable)

---

## 4.10 Warehouse Rules

| # | Rule |
|---|---|
| 27 | A warehouse can hold **one or multiple** products. |
| 28 | A product can be in **one or multiple** warehouses. |
| 29 | A vendor order will go to **exactly one** warehouse. |
| 30 | A warehouse can have **multiple** vendor orders. |
| 31 | A warehouse can have **multiple** employees. |
| 32 | An employee can work in **exactly one** warehouse at a given point of time. |

**Cardinalities:** Warehouse ↔ Product (M:M), Warehouse ↔ VOrder (1:M), Warehouse ↔ Employee (M:M via WarehouseEmployeeDetails)

---

## 4.11 Product Category Rules

| # | Rule |
|---|---|
| 33 | A given product category can have **one or more** products. |
| 34 | A product can have **only one** product category. |

**Cardinalities:** ProductCategory ↔ Product (1:M)

---

## Scope Constraints

| Constraint | Detail |
|---|---|
| Geography | User demographics restricted to Buffalo region (scalable) |
| Data parameters | ≤ 20 parameters per Consumer, Employee, or Vendor entity |
| Schedule frequency | Biweekly (twice per week) per neighbourhood |
| Vehicle types | Trucks and buses only |
| Payment methods | Cash, Credit Card, Debit Card, Online Payment |
| Product categories | Fruits, Vegetables, Dairy (and extensions: Grains, Beverages, Eggs, Meat, Fish) |
| POS data | Stored in real-time |
| Compliance | Time log maintained for vehicle and employee compliance |
