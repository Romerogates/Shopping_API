CREATE PROCEDURE [dbo].[SP_USER_ITEM_updateCheck]
    @ItemId UNIQUEIDENTIFIER,     -- L'article spécifique à cocher
    @IsChecked BIT,                -- Le nouvel état (true ou false)
    @UserId UNIQUEIDENTIFIER     -- L'utilisateur qui fait la demande (sécurité)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Tenter la mise à jour sécurisée
    -- Nous utilisons une jointure (JOIN) pour s'assurer que l'utilisateur
    -- (T2.UserId) possède bien la liste (T2.ListId)
    -- à laquelle l'article (T1.ItemId) appartient.
    UPDATE T1
    SET 
        T1.[IsChecked] = @IsChecked
    FROM 
        [dbo].[ShoppingListItem] AS T1
    JOIN 
        [dbo].[ShoppingList] AS T2 ON T1.[ListId] = T2.[ListId]
    WHERE 
        T1.[ItemId] = @ItemId 
        AND T2.[UserId] = @UserId;

    -- 2. Vérifier si la mise à jour a fonctionné
    -- Si @@ROWCOUNT est 0, cela signifie que l'article n'a pas été trouvé
    -- OU que l'utilisateur n'en était pas le propriétaire.
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Mise à jour impossible. Article non trouvé ou accès refusé.', 16, 1);
        RETURN -1;
    END

    RETURN 0; -- Succès
END
GO