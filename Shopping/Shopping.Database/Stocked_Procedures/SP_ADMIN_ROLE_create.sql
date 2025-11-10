CREATE PROCEDURE [dbo].[SP_ADMIN_ROLE_create]
    @PerformingUserId UNIQUEIDENTIFIER, -- L'ID de l'admin
    @NewRoleId INT,                     -- Le nouvel ID (ex: 2)
    @NewRoleName NVARCHAR(20)           -- Le nom (ex: 'Moderator')
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. VÉRIFICATION DES PERMISSIONS
    IF NOT EXISTS (
        SELECT 1
        FROM [dbo].[User] u
        JOIN [dbo].[Role] r ON u.[Role] = r.[RoleId]
        WHERE u.[UserId] = @PerformingUserId
          AND r.[Role] = 'Admin' -- Vérifie si l'utilisateur est 'Admin'
          AND u.[DisableAt] IS NULL
    )
    BEGIN
        RAISERROR('Permission refusée. Seul un administrateur peut créer un rôle.', 16, 1);
        RETURN -1; -- Permission refusée
    END

    -- 2. VÉRIFIER SI L'ID OU LE NOM EXISTE DÉJÀ
    IF EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [RoleId] = @NewRoleId OR [Role] = @NewRoleName)
    BEGIN
        RAISERROR('Un rôle avec cet ID ou ce nom existe déjà.', 16, 1);
        RETURN -2; -- Conflit
    END

    -- 3. ACTION (si admin)
    BEGIN TRY
        INSERT INTO [dbo].[Role] ([RoleId], [Role])
        VALUES (@NewRoleId, @NewRoleName);
        RETURN 0; -- Succès
    END TRY
    BEGIN CATCH
        PRINT 'Erreur lors de la création du rôle.';
        THROW;
        RETURN -100;
    END CATCH

END
GO