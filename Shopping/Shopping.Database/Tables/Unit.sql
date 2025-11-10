CREATE TABLE [dbo].[Unit]
(
    [UnitId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(20) NOT NULL,
    
    CONSTRAINT [UK_Unit_Name] UNIQUE ([Name])
)
GO