-- 1. Create the database
CREATE DATABASE ApartmentManagement;
GO

USE ApartmentManagement;
GO

-- Apartments Table
CREATE TABLE Apartments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ApartmentNumber NVARCHAR(10) NOT NULL UNIQUE,
    Floor INT NOT NULL,
    Area DECIMAL(5,2) NOT NULL -- in square meters
);
GO

-- Residents Table
CREATE TABLE Residents (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    ApartmentId INT NOT NULL,
    IsOwner BIT NOT NULL DEFAULT 1,
    BirthDate DATE NULL,
    FOREIGN KEY (ApartmentId) REFERENCES Apartments(Id)
);
GO

-- Utilities Table
CREATE TABLE Utilities (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ApartmentId INT NOT NULL,
    Month INT NOT NULL CHECK (Month >= 1 AND Month <= 12),
    Year INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ApartmentId) REFERENCES Apartments(Id)
);
GO

-- Payments Table
CREATE TABLE Payments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UtilityId INT NOT NULL,
    ResidentId INT NOT NULL,
    PaymentDate DATE NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (UtilityId) REFERENCES Utilities(Id),
    FOREIGN KEY (ResidentId) REFERENCES Residents(Id)
);
GO

-- Benefits Table (e.g., children under 5)
CREATE TABLE Benefits (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ResidentId INT NOT NULL,
    Description NVARCHAR(100) NOT NULL,
    Discount DECIMAL(5,2) NOT NULL, -- percentage or amount
    FOREIGN KEY (ResidentId) REFERENCES Residents(Id)
);
GO

-- Apartments
INSERT INTO Apartments (ApartmentNumber, Floor, Area) VALUES
('101', 1, 55.5),
('102', 1, 48.0),
('201', 2, 60.0),
('202', 2, 52.5),
('301', 3, 70.0);
GO

-- Residents (owners and tenants)
INSERT INTO Residents (FirstName, LastName, ApartmentId, IsOwner, BirthDate) VALUES
('John', 'Doe', 1, 1, '1985-06-15'),
('Jane', 'Smith', 1, 0, '1990-02-20'),
('Alice', 'Brown', 2, 1, '1978-11-03'),
('Bob', 'Johnson', 3, 1, '1982-08-12'),
('Charlie', 'Davis', 4, 0, '1995-04-25'),
('Eve', 'Wilson', 5, 1, '1988-09-30');
GO

-- Utilities (charges per apartment)
INSERT INTO Utilities (ApartmentId, Month, Year, Amount) VALUES
(1, 2, 2026, 120.50),
(2, 2, 2026, 95.00),
(3, 2, 2026, 130.00),
(4, 2, 2026, 110.25),
(5, 2, 2026, 150.75);
GO

-- Payments (matching UtilityId and ResidentId)
INSERT INTO Payments (UtilityId, ResidentId, PaymentDate, AmountPaid) VALUES
(1, 1, '2026-02-05', 120.50),  -- John Doe pays Apartment 101
(2, 3, '2026-02-06', 95.00),   -- Alice Brown pays Apartment 102
(3, 4, '2026-02-07', 130.00),  -- Bob Johnson pays Apartment 201
(4, 5, '2026-02-08', 110.25),  -- Charlie Davis pays Apartment 202
(5, 6, '2026-02-09', 150.75);  -- Eve Wilson pays Apartment 301
GO

-- Benefits (example: children under 5 exempt from payment)
INSERT INTO Benefits (ResidentId, Description, Discount) VALUES
(2, 'Child under 5 - utility discount', 100.00); -- Jane Smith
GO

-- 4. Example Queries
-- 4.1 List all apartments with residents
SELECT a.ApartmentNumber, r.FirstName + ' ' + r.LastName AS Resident, r.IsOwner
FROM Apartments a
JOIN Residents r ON r.ApartmentId = a.Id
ORDER BY a.ApartmentNumber;
GO

-- 4.2 Total utility payments per apartment
SELECT a.ApartmentNumber, SUM(p.AmountPaid) AS TotalPaid
FROM Apartments a
JOIN Residents r ON r.ApartmentId = a.Id
JOIN Payments p ON p.ResidentId = r.Id
GROUP BY a.ApartmentNumber;
GO

-- 4.3 Residents with benefits
SELECT r.FirstName + ' ' + r.LastName AS Resident, b.Description, b.Discount
FROM Benefits b
JOIN Residents r ON r.Id = b.ResidentId;
GO

-- 4.4 Utilities with unpaid amounts (example: where AmountPaid < Amount)
SELECT u.Id AS UtilityId, a.ApartmentNumber, u.Amount, ISNULL(SUM(p.AmountPaid),0) AS PaidAmount,
       u.Amount - ISNULL(SUM(p.AmountPaid),0) AS Remaining
FROM Utilities u
JOIN Apartments a ON a.Id = u.ApartmentId
LEFT JOIN Payments p ON p.UtilityId = u.Id
GROUP BY u.Id, a.ApartmentNumber, u.Amount;
GO
