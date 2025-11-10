CREATE PROCEDURE [dbo].[SP_USER_ITEM_create]
    @ListId UNIQUEIDENTIFIER,
    @Name NVARCHAR(200),
    @Quantity DECIMAL(8, 2) = 1,
    @UnitId INT = NULL, -- MODIFIÉ (accepte l'ID)
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NewItemId UNIQUEIDENTIFIER = NEWID();
    IF NOT EXISTS (SELECT 1 FROM [dbo].[ShoppingList] WHERE [ListId] = @ListId AND [UserId] = @UserId AND [DisabledAt] IS NULL)
    BEGIN
        RAISERROR('Ajout impossible. Accès refusé.', 16, 1); RETURN -1;
    END
    
    INSERT INTO [dbo].[ShoppingListItem] 
        ([ItemId], [ListId], [Name], [Quantity], [UnitId]) -- MODIFIÉ
    VALUES 
        (@NewItemId, @ListId, @Name, @Quantity, @UnitId); -- MODIFIÉ

    SELECT @NewItemId AS ItemId;
    RETURN 0;
END
GO