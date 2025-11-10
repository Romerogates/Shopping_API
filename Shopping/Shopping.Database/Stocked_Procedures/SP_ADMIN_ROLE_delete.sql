CREATE PROCEDURE [dbo].[SP_ADMIN_ROLE_delete]
    @PerformingUserId UNIQUEIDENTIFIER, -- L'ID de l'admin
    @RoleIdToDelete INT                 -- L'ID du rôle à supprimer
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
        RAISERROR('Permission refusée. Seul un administrateur peut supprimer un rôle.', 16, 1);
        RETURN -1; -- Permission refusée
    END
    
    -- 2. NE JAMAIS SUPPRIMER LE RÔLE ADMIN LUI-MÊME (ou le rôle par défaut 1)
    IF @RoleIdToDelete = 1 OR (SELECT [Role] FROM [dbo].[Role] WHERE [RoleId] = @RoleIdToDelete) = 'Admin'
    BEGIN
        RAISERROR('Ce rôle ne peut pas être supprimé.', 16, 1);
        RETURN -2; -- Règle métier
    END

    -- 3. VÉRIFIER SI LE RÔLE EST UTILISÉ
    IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE [Role] = @RoleIdToDelete)
    BEGIN
        RAISERROR('Impossible de supprimer ce rôle car il est assigné à un ou plusieurs utilisateurs.', 16, 1);
        RETURN -3; -- Conflit (Clé étrangère)
    END

    -- 4. ACTION (si admin et rôle non utilisé)
    BEGIN TRY
        DELETE FROM [dbo].[Role]
        WHERE [RoleId] = @RoleIdToDelete;
        
        IF @@ROWCOUNT = 0
        BEGIN
             RAISERROR('Le rôle n''a pas été trouvé.', 16, 1);
             RETURN -4; -- Non trouvé
        END
        
        RETURN 0; -- Succès
    END TRY
    BEGIN CATCH
        PRINT 'Erreur lors de la suppression du rôle.';
        THROW;
        RETURN -100;
    END CATCH

END
GO