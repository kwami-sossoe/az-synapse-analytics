-- Création d'un schéma de staging si non existant
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'stg')
BEGIN
    EXEC('CREATE SCHEMA stg');
END
GO

-- 1. Table de Staging pour les ventes (destination du pipeline de copie)
DROP TABLE IF EXISTS stg.FactOnlineSales;

CREATE TABLE stg.FactOnlineSales
(
    OnlineSalesKey int,
    DateKey date,
    StoreKey int,
    ProductKey int,
    CustomerKey int,
    SalesAmount float,
    TotalCost float
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    HEAP
);
GO

-- 2. Table de Staging/Dimension pour les clients
DROP TABLE IF EXISTS stg.DimCustomer;

CREATE TABLE stg.DimCustomer
(
    CustomerKey int,
    GeographyKey int,
    FirstName nvarchar(100),
    LastName nvarchar(100)
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    HEAP
);
GO

-- 3. Table de Staging/Dimension pour les produits
DROP TABLE IF EXISTS stg.DimProduct;

CREATE TABLE stg.DimProduct
(
    ProductKey int,
    ProductName nvarchar(200),
    BrandName nvarchar(50)
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    HEAP
);
GO


-- 4. Table Cible "Propre" (table de faits enrichie)
DROP TABLE IF EXISTS dbo.FactEnrichedSales;

CREATE TABLE dbo.FactEnrichedSales
(
    SalesKey int NOT NULL,
    CustomerName nvarchar(200),
    ProductName nvarchar(200),
    SalesAmount float
)
WITH
(
    DISTRIBUTION = HASH(SalesKey),
    CLUSTERED COLUMNSTORE INDEX
);
GO
