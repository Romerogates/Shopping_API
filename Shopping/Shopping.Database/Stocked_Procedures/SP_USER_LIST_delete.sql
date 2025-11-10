CREATE PROCEDURE [dbo].[SP_USER_LIST_delete]
    @ListId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER -- Sécurité
AS
BEGIN
    SET NOCOUNT ON;

    -- Tente de supprimer la liste
    -- La clause WHERE garantit que l'utilisateur est bien le propriétaire
    DELETE FROM [dbo].[ShoppingList]
    WHERE 
        [ListId] = @ListId 
        AND [UserId] = @UserId;

    -- Si @@ROWCOUNT est 0, c'est que la liste n'a pas été trouvée
    -- OU que l'utilisateur n'en était pas le propriétaire.
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Suppression impossible. Liste non trouvée ou accès refusé.', 16, 1);
        RETURN -1;
    END

    -- (ON DELETE CASCADE s'occupe de supprimer les ShoppingListItems)

    RETURN 0; -- Succès
END
GO