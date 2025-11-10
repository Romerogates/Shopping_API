CREATE PROCEDURE [dbo].[SP_USER_LIST_getAll]
    @UserId UNIQUEIDENTIFIER -- L'utilisateur dont on veut les listes
AS
BEGIN
    SET NOCOUNT ON;

    -- Sélectionne les listes actives de cet utilisateur
    SELECT
        l.[ListId],
        l.[Name],
        l.[CreatedAt]
    FROM
        [dbo].[ShoppingList] AS l
    WHERE
        l.[UserId] = @UserId
        AND l.[DisabledAt] IS NULL
    ORDER BY
        l.[CreatedAt] DESC;
END
GO