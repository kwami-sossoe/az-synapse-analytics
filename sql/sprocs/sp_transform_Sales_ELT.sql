CREATE OR ALTER PROCEDURE dbo.sp_Transform_Sales_ELT
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Début de la transformation ELT...';

    -- Vider la table cible avant ré-insertion
    TRUNCATE TABLE dbo.FactEnrichedSales;
    PRINT 'Table dbo.FactEnrichedSales vidée.';

    -- Insérer les données transformées
    INSERT INTO dbo.FactEnrichedSales (
        SalesKey, 
        CustomerName, 
        ProductName, 
        SalesAmount
    )
    SELECT
        fs.OnlineSalesKey AS SalesKey,
        ISNULL(c.FirstName, 'Unknown') + ' ' + ISNULL(c.LastName, 'Customer') AS CustomerName,
        ISNULL(p.ProductName, 'Unknown Product') AS ProductName,
        fs.SalesAmount
    FROM
        stg.FactOnlineSales AS fs
    LEFT JOIN
        stg.DimCustomer AS c ON fs.CustomerKey = c.CustomerKey
    LEFT JOIN
        stg.DimProduct AS p ON fs.ProductKey = p.ProductKey
    WHERE
        fs.SalesAmount > 0; -- Exemple de filtre simple

    PRINT 'Transformation et chargement de dbo.FactEnrichedSales terminés.';
    PRINT 'Nombre de lignes insérées : ' + CAST(@@ROWCOUNT AS VARCHAR(20));

END;
GO
