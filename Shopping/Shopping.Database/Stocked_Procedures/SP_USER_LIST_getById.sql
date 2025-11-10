CREATE PROCEDURE [dbo].[SP_USER_LIST_getById]
    @ListId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM [dbo].[ShoppingList] WHERE [ListId] = @ListId AND [UserId] = @UserId AND [DisabledAt] IS NULL)
    BEGIN
        RAISERROR('Liste non trouvée ou accès non autorisé.', 16, 1); RETURN -1;
    END

    SELECT
        i.[ItemId],
        i.[Name],
        i.[Quantity],
        i.[IsChecked],
        i.[UnitId],      -- Renvoyer l'ID de l'unité
        u.[Name] AS [UnitName] -- Renvoyer le Nom de l'unité
    FROM
        [dbo].[ShoppingListItem] AS i
    LEFT JOIN 
        [dbo].[Unit] AS u ON i.[UnitId] = u.[UnitId] -- Jointure pour le nom
    WHERE
        i.[ListId] = @ListId
    ORDER BY
        i.[Name];
END
GO