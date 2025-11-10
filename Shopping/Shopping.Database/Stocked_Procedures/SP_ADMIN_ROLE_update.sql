CREATE PROCEDURE [dbo].[SP_ADMIN_ROLE_update]
    @PerformingUserId UNIQUEIDENTIFIER, -- L'ID de l'admin
    @RoleIdToUpdate INT,                -- L'ID du rôle à changer
    @NewRoleName NVARCHAR(20)           -- Le nouveau nom
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
        RAISERROR('Permission refusée. Seul un administrateur peut modifier un rôle.', 16, 1);
        RETURN -1; -- Permission refusée
    END

    -- 2. VÉRIFIER SI LE RÔLE EXISTE
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [RoleId] = @RoleIdToUpdate)
    BEGIN
        RAISERROR('Le rôle que vous essayez de modifier n''existe pas.', 16, 1);
        RETURN -2; -- Non trouvé
    END
    
    -- 3. VÉRIFIER SI LE NOUVEAU NOM EST DÉJÀ PRIS
    IF EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [Role] = @NewRoleName AND [RoleId] != @RoleIdToUpdate)
    BEGIN
        RAISERROR('Ce nom de rôle est déjà utilisé.', 16, 1);
        RETURN -3; -- Conflit
    END

    -- 4. ACTION (si admin)
    BEGIN TRY
        UPDATE [dbo].[Role]
        SET [Role] = @NewRoleName
        WHERE [RoleId] = @RoleIdToUpdate;
        RETURN 0; -- Succès
    END TRY
    BEGIN CATCH
        PRINT 'Erreur lors de la mise à jour du rôle.';
        THROW;
        RETURN -100;
    END CATCH

END
GO