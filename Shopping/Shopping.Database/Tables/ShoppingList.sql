CREATE TABLE [dbo].[ShoppingList]
(
    [ListId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [UserId] UNIQUEIDENTIFIER NOT NULL, -- Propriétaire
    [Name] NVARCHAR(100) NOT NULL,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [DisabledAt] DATETIME2 NULL, 

    CONSTRAINT [PK_ShoppingList] PRIMARY KEY ([ListId]),
    
    -- Relation avec l'utilisateur
    CONSTRAINT [FK_ShoppingList_User] FOREIGN KEY ([UserId]) 
        REFERENCES [dbo].[User]([UserId])
)
GO