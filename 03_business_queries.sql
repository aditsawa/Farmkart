-- ============================================================
-- FarmKart Database Management System
-- Business Queries / Analytics
-- Version: 1.0
-- Run AFTER: 01_create_tables.sql AND 02_seed_data.sql
-- ============================================================

-- ============================================================
-- Q1. Average order value by product sold
-- ============================================================
SELECT
    p.Description                          AS product_name,
    ROUND(AVG(oi.LineItemTotal), 2)        AS avg_order_value
FROM OrderItems oi
LEFT JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY p.Description
ORDER BY avg_order_value DESC;

-- ============================================================
-- Q2. Products sold the most by total quantity
-- ============================================================
SELECT
    p.Description                     AS product_name,
    SUM(oi.Quantity)                  AS total_qty_sold
FROM OrderItems oi
LEFT JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY p.Description
ORDER BY total_qty_sold DESC;

-- ============================================================
-- Q3. Most preferred payment type (combined customer + vendor orders)
-- ============================================================
SELECT
    pay.PaymentType,
    COUNT(*)            AS total_usage
FROM Payment pay
LEFT JOIN Orders    o ON pay.PaymentID = o.PaymentID
LEFT JOIN VOrder    v ON pay.PaymentID = v.PaymentID
GROUP BY pay.PaymentType
ORDER BY total_usage DESC;

-- ============================================================
-- Q4. Top 10 customers by total order amount
-- ============================================================
SELECT
    c.CFirstName || ' ' || c.CLastName    AS customer_name,
    SUM(o.OrderTotal)                     AS total_spent,
    DENSE_RANK() OVER (ORDER BY SUM(o.OrderTotal) DESC) AS rank
FROM Orders o
INNER JOIN Customer c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CFirstName, c.CLastName
ORDER BY rank
LIMIT 10;

-- ============================================================
-- Q5. Revenue by product category
-- ============================================================
SELECT
    pc.Category                             AS category,
    COUNT(DISTINCT oi.OrderID)              AS num_orders,
    SUM(oi.Quantity)                        AS total_qty,
    ROUND(SUM(oi.LineItemTotal), 2)         AS total_revenue
FROM OrderItems oi
JOIN Products p         ON oi.ProductID    = p.ProductID
JOIN ProductCategory pc ON p.PCategoryID  = pc.PCategoryID
GROUP BY pc.Category
ORDER BY total_revenue DESC;

-- ============================================================
-- Q6. Vehicle utilisation - number of orders per vehicle
-- ============================================================
SELECT
    v.VehicleID,
    v.VehicleType,
    v.Registration,
    COUNT(o.OrderID)   AS total_orders
FROM Vehicle v
LEFT JOIN Orders o ON v.VehicleID = o.VehicleID
GROUP BY v.VehicleID, v.VehicleType, v.Registration
ORDER BY total_orders DESC;

-- ============================================================
-- Q7. Total vendor spend per vendor
-- ============================================================
SELECT
    vn.Vendor_Name,
    COUNT(vo.VOrderID)              AS num_vendor_orders,
    SUM(vo.VOrderTotal)             AS total_spend
FROM Vendor vn
LEFT JOIN VOrder vo ON vn.VendorID = vo.VendorID
GROUP BY vn.Vendor_Name
ORDER BY total_spend DESC;

-- ============================================================
-- Q8. Order count & revenue per delivery location
-- ============================================================
SELECT
    l.LocationDesc,
    COUNT(o.OrderID)            AS total_orders,
    ROUND(SUM(o.OrderTotal), 2) AS total_revenue
FROM Location l
LEFT JOIN Orders o ON l.LocationID = o.LocationID
GROUP BY l.LocationDesc
ORDER BY total_revenue DESC;

-- ============================================================
-- Q9. Warehouse out-of-stock summary by warehouse
-- ============================================================
SELECT
    WarehouseID,
    COUNT(*)                                        AS total_records,
    SUM(CASE WHEN OutOfStock = 'Y' THEN 1 ELSE 0 END) AS out_of_stock_count,
    SUM(CASE WHEN OutOfStock = 'N' THEN 1 ELSE 0 END) AS in_stock_count
FROM Warehouse
GROUP BY WarehouseID
ORDER BY WarehouseID;

-- ============================================================
-- Q10. Employee headcount per warehouse (current assignments)
-- ============================================================
SELECT
    we.WarehouseID,
    COUNT(we.EmployeeID)    AS employee_count
FROM WarehouseEmployeeDetails we
WHERE we.EndDate IS NULL          -- currently active
GROUP BY we.WarehouseID
ORDER BY employee_count DESC;

-- ============================================================
-- Q11. Daily sales trend
-- ============================================================
SELECT
    o.OrderDate,
    COUNT(o.OrderID)            AS num_orders,
    ROUND(SUM(o.OrderTotal), 2) AS daily_revenue
FROM Orders o
GROUP BY o.OrderDate
ORDER BY o.OrderDate;

-- ============================================================
-- Q12. Employees by job role
-- ============================================================
SELECT
    j.JobDesc,
    COUNT(e.EmployeeID) AS employee_count,
    MIN(j.Salary)       AS salary
FROM Job j
LEFT JOIN Employees e ON j.JobID = e.JobID
GROUP BY j.JobDesc, j.Salary
ORDER BY j.Salary DESC;
