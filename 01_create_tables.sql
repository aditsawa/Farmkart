-- ============================================================
-- FarmKart Database Management System
-- DDL: Table Creation Script
-- Version: 1.0
-- Description: Creates all tables in 3rd Normal Form (3NF)
-- ============================================================

-- Drop tables in reverse dependency order (if they exist)
DROP TABLE IF EXISTS WarehouseEmployeeDetails;
DROP TABLE IF EXISTS Warehouse;
DROP TABLE IF EXISTS VOrderItems;
DROP TABLE IF EXISTS VOrder;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS TimeTable;
DROP TABLE IF EXISTS Vehicle;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Vendor;
DROP TABLE IF EXISTS ProductCategory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Employee_Contact;
DROP TABLE IF EXISTS Employee_Address;
DROP TABLE IF EXISTS JobHistory;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Job;
DROP TABLE IF EXISTS CustomerContact;
DROP TABLE IF EXISTS CustomerAddress;
DROP TABLE IF EXISTS Customer;

-- ============================================================
-- CUSTOMER TABLES
-- ============================================================

CREATE TABLE Customer (
    CustomerID   INT          NOT NULL,
    CFirstName   VARCHAR(255) NOT NULL,
    CLastName    VARCHAR(255) NOT NULL,
    PRIMARY KEY (CustomerID)
);

CREATE TABLE CustomerAddress (
    CAddressID      INT          NOT NULL,
    CustomerID      INT          NOT NULL,
    CustomerAddress VARCHAR(255),
    City            VARCHAR(255),
    Zip             VARCHAR(10),
    State           VARCHAR(50),
    PRIMARY KEY (CAddressID),
    CONSTRAINT FK_CustAddr_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer (CustomerID)
);

CREATE TABLE CustomerContact (
    CContactID INT          NOT NULL,
    CustomerID INT          NOT NULL,
    Email      VARCHAR(255),
    Phone      VARCHAR(20),          -- Changed from INT to VARCHAR to support formatted phone numbers
    PRIMARY KEY (CContactID),
    CONSTRAINT FK_CustContact_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer (CustomerID)
);

-- ============================================================
-- JOB & EMPLOYEE TABLES
-- ============================================================

CREATE TABLE Job (
    JobID    INT          NOT NULL,
    JobDesc  VARCHAR(255),
    Salary   NUMERIC(10,2),          -- Changed from INT to NUMERIC for decimal salaries
    PRIMARY KEY (JobID)
);

CREATE TABLE Employees (
    EmployeeID INT          NOT NULL,
    EFirstName VARCHAR(255),
    ELastName  VARCHAR(255),
    ManagerID  INT,
    HireDate   DATE,
    JobID      INT,
    PRIMARY KEY (EmployeeID),
    CONSTRAINT FK_Emp_Job FOREIGN KEY (JobID)
        REFERENCES Job (JobID)
);

CREATE TABLE JobHistory (
    HistoryID  INT  NOT NULL,
    EmployeeID INT  NOT NULL,        -- Added missing EmployeeID FK (was in ERD, missing in original DDL)
    JobID      INT  NOT NULL,
    StartDate  DATE,
    EndDate    DATE,
    PRIMARY KEY (HistoryID),
    CONSTRAINT FK_JobHist_Emp FOREIGN KEY (EmployeeID)
        REFERENCES Employees (EmployeeID),
    CONSTRAINT FK_JobHist_Job FOREIGN KEY (JobID)
        REFERENCES Job (JobID)
);

CREATE TABLE Employee_Address (
    EAddress_ID      INT          NOT NULL,
    EmployeeID       INT          NOT NULL,
    Employee_Address VARCHAR(255),
    Employee_City    VARCHAR(255),
    Employee_State   VARCHAR(2),
    Employee_Country VARCHAR(100),
    Employee_ZIP     VARCHAR(10),    -- Changed from INT to VARCHAR for ZIP codes
    PRIMARY KEY (EAddress_ID),
    CONSTRAINT FK_EmpAddr_Emp FOREIGN KEY (EmployeeID)
        REFERENCES Employees (EmployeeID)
);

CREATE TABLE Employee_Contact (
    EContact_ID    INT          NOT NULL,
    EmployeeID     INT          NOT NULL,
    Employee_Email VARCHAR(255),
    Employee_Phone VARCHAR(20),      -- Changed from INT to VARCHAR for formatted phone numbers
    PRIMARY KEY (EContact_ID),
    CONSTRAINT FK_EmpContact_Emp FOREIGN KEY (EmployeeID)
        REFERENCES Employees (EmployeeID)
);

-- ============================================================
-- LOCATION, VEHICLE & PAYMENT TABLES
-- ============================================================

CREATE TABLE Location (
    LocationID   INT          NOT NULL,
    LocationDesc VARCHAR(255) NOT NULL,
    PRIMARY KEY (LocationID)
);

CREATE TABLE Vehicle (
    VehicleID          INT          NOT NULL,
    VehicleType        VARCHAR(255),
    Registration       VARCHAR(20),  -- Renamed from RegNumber; stored as VARCHAR for reg plate strings
    ServiceDue         DATE,
    LeaseStartDate     DATE,
    LeaseEndDate       DATE,
    Availability       CHAR(1),      -- 'T' or 'F' (or 'Y'/'N')
    PRIMARY KEY (VehicleID)
);

CREATE TABLE Payment (
    PaymentID   INT          NOT NULL,
    PaymentType VARCHAR(50)  NOT NULL,
    PRIMARY KEY (PaymentID)
);

-- ============================================================
-- VENDOR TABLES
-- ============================================================

CREATE TABLE Vendor (
    VendorID      INT          NOT NULL,
    Vendor_Name   VARCHAR(255),
    Vendor_Address VARCHAR(255),
    Vendor_City   VARCHAR(255),
    Vendor_State  VARCHAR(2),
    Vendor_Country VARCHAR(100),
    Vendor_ZIP    VARCHAR(10),
    PRIMARY KEY (VendorID)
);

-- ============================================================
-- PRODUCT TABLES
-- ============================================================

CREATE TABLE ProductCategory (
    PCategoryID INT          NOT NULL,
    Category    VARCHAR(255),
    PRIMARY KEY (PCategoryID)
);

CREATE TABLE Products (
    ProductID    INT            NOT NULL,
    Description  VARCHAR(255),
    ProductCost  NUMERIC(10,2),
    PCategoryID  INT,
    PRIMARY KEY (ProductID),
    CONSTRAINT FK_Prod_Category FOREIGN KEY (PCategoryID)
        REFERENCES ProductCategory (PCategoryID)
);

-- ============================================================
-- ORDER TABLES
-- ============================================================

CREATE TABLE Orders (                -- Renamed from ORDER (reserved keyword in SQL)
    OrderID     INT            NOT NULL,
    OrderDate   DATE,
    OrderTime   TIMESTAMP,
    CustomerID  INT,
    VehicleID   INT,
    PaymentID   INT,
    LocationID  INT,
    OrderTotal  NUMERIC(10,2),
    PRIMARY KEY (OrderID),
    CONSTRAINT FK_Ord_Customer  FOREIGN KEY (CustomerID)  REFERENCES Customer (CustomerID),
    CONSTRAINT FK_Ord_Vehicle   FOREIGN KEY (VehicleID)   REFERENCES Vehicle (VehicleID),
    CONSTRAINT FK_Ord_Payment   FOREIGN KEY (PaymentID)   REFERENCES Payment (PaymentID),
    CONSTRAINT FK_Ord_Location  FOREIGN KEY (LocationID)  REFERENCES Location (LocationID)
);

CREATE TABLE OrderItems (
    OrderID       INT            NOT NULL,
    ItemID        INT            NOT NULL,
    ProductID     INT,
    Quantity      NUMERIC(10,2),
    LineItemTotal NUMERIC(10,2),
    PRIMARY KEY (OrderID, ItemID),
    CONSTRAINT FK_OrdItem_Order   FOREIGN KEY (OrderID)   REFERENCES Orders (OrderID),
    CONSTRAINT FK_OrdItem_Product FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
);

-- ============================================================
-- VENDOR ORDER TABLES
-- ============================================================

CREATE TABLE VOrder (
    VOrderID    INT            NOT NULL,
    VendorID    INT,
    VOrderDate  DATE,
    VOrderTime  TIMESTAMP,
    PaymentID   INT,
    VOrderTotal NUMERIC(10,2),
    PRIMARY KEY (VOrderID),
    CONSTRAINT FK_VOrd_Vendor  FOREIGN KEY (VendorID)  REFERENCES Vendor (VendorID),
    CONSTRAINT FK_VOrd_Payment FOREIGN KEY (PaymentID) REFERENCES Payment (PaymentID)
);

CREATE TABLE VOrderItems (
    VOrderID      INT            NOT NULL,
    VItemID       INT            NOT NULL,
    ProductID     INT,
    VQuantity     NUMERIC(10,2),
    VLineItemTotal NUMERIC(10,2),
    PRIMARY KEY (VOrderID, VItemID),
    CONSTRAINT FK_VOrdItem_VOrder  FOREIGN KEY (VOrderID)   REFERENCES VOrder (VOrderID),
    CONSTRAINT FK_VOrdItem_Product FOREIGN KEY (ProductID)  REFERENCES Products (ProductID)
);

-- ============================================================
-- WAREHOUSE TABLES
-- ============================================================

CREATE TABLE Warehouse (
    WarehouseID    INT     NOT NULL,
    ProductID      INT,
    VOrderID       INT,
    Quantity       INT,
    OutOfStock     CHAR(1),          -- 'Y' or 'N'
    PRIMARY KEY (WarehouseID),       -- NOTE: In practice this would be a composite or surrogate PK
    CONSTRAINT FK_WH_Product FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
    CONSTRAINT FK_WH_VOrder  FOREIGN KEY (VOrderID)  REFERENCES VOrder (VOrderID)
);

CREATE TABLE WarehouseEmployeeDetails (
    WEMPID      INT  NOT NULL,
    WarehouseID INT,
    EmployeeID  INT,
    StartDate   DATE,
    EndDate     DATE,
    PRIMARY KEY (WEMPID),
    CONSTRAINT FK_WHEmp_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employees (EmployeeID)
);

-- ============================================================
-- TIMETABLE (Vehicle Schedule)
-- ============================================================

CREATE TABLE TimeTable (
    TTID        INT       NOT NULL,
    VehicleID   INT,
    LocationID  INT,
    TTDate      DATE,
    TTTime      TIMESTAMP,
    EmployeeID  INT,
    PRIMARY KEY (TTID),
    CONSTRAINT FK_TT_Vehicle   FOREIGN KEY (VehicleID)  REFERENCES Vehicle (VehicleID),
    CONSTRAINT FK_TT_Location  FOREIGN KEY (LocationID) REFERENCES Location (LocationID),
    CONSTRAINT FK_TT_Employee  FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID)
);
