CREATE PROCEDURE [dbo].[SP_USER_ITEM_delete]
    @ItemId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER -- Sécurité
AS
BEGIN
    SET NOCOUNT ON;

    DELETE T1
    FROM 
        [dbo].[ShoppingListItem] AS T1
    JOIN 
        [dbo].[ShoppingList] AS T2 ON T1.[ListId] = T2.[ListId]
    WHERE 
        T1.[ItemId] = @ItemId 
        AND T2.[UserId] = @UserId; -- Sécurité

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Suppression impossible. Article non trouvé ou accès refusé.', 16, 1);
        RETURN -1;
    END

    RETURN 0; -- Succès
END
GO