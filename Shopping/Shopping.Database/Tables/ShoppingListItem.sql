CREATE TABLE [dbo].[ShoppingListItem]
(
    [ItemId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [ListId] UNIQUEIDENTIFIER NOT NULL, 
    [Name] NVARCHAR(200) NOT NULL,
    [Quantity] DECIMAL(8, 2) NOT NULL DEFAULT 1,
    
    -- MODIFIÉ : Utilise la clé étrangère
    [UnitId] INT NULL, 
    
    [IsChecked] BIT NOT NULL DEFAULT 0, 
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT [PK_ShoppingListItem] PRIMARY KEY ([ItemId]),
    
    -- Relation vers la ShoppingList (supprime les articles si la liste est supprimée)
    CONSTRAINT [FK_ShoppingListItem_List] FOREIGN KEY ([ListId]) 
        REFERENCES [dbo].[ShoppingList]([ListId]) ON DELETE CASCADE,
    
    -- NOUVELLE Relation vers la table Unit
    CONSTRAINT [FK_ShoppingListItem_Unit] FOREIGN KEY ([UnitId])
        REFERENCES [dbo].[Unit]([UnitId])
)
GO