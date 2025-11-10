CREATE PROCEDURE [dbo].[SP_USER_ITEM_update]
    @ItemId UNIQUEIDENTIFIER,
    @Name NVARCHAR(200),
    @Quantity DECIMAL(8, 2),
    @UnitId INT = NULL, -- MODIFIÉ (accepte l'ID)
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE T1
    SET 
        T1.[Name] = @Name,
        T1.[Quantity] = @Quantity,
        T1.[UnitId] = @UnitId -- MODIFIÉ
    FROM 
        [dbo].[ShoppingListItem] AS T1
    JOIN 
        [dbo].[ShoppingList] AS T2 ON T1.[ListId] = T2.[ListId]
    WHERE 
        T1.[ItemId] = @ItemId AND T2.[UserId] = @UserId;

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Mise à jour impossible. Accès refusé.', 16, 1); RETURN -1;
    END
    RETURN 0;
END
GO