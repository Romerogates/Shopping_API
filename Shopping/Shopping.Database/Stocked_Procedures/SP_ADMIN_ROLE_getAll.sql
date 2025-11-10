CREATE PROCEDURE [dbo].[SP_ADMIN_getRoles]
    @PerformingUserId UNIQUEIDENTIFIER -- L'ID de l'admin
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. VÉRIFICATION DES PERMISSIONS
    IF NOT EXISTS (
        SELECT 1
        FROM [dbo].[User] u
        JOIN [dbo].[Role] r ON u.[Role] = r.[RoleId]
        WHERE u.[UserId] = @PerformingUserId
          AND r.[Role] = 'Admin'
          AND u.[DisableAt] IS NULL
    )
    BEGIN
        RAISERROR('Permission refusée. Seul un administrateur peut voir la liste des rôles.', 16, 1);
        RETURN -1; -- Permission refusée
    END

    -- 2. ACTION (si admin)
    SELECT [RoleId], [Role]
    FROM [dbo].[Role]
    ORDER BY [RoleId];
    
    RETURN 0; -- Succès

END
GO