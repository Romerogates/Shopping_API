CREATE PROCEDURE [dbo].[SP_USER_USER_disable]
    -- Paramètre d'entrée : L'ID de l'utilisateur à désactiver
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Vérifier si l'utilisateur existe ET s'il n'est pas déjà désactivé
    IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE [UserId] = @UserId AND [DisableAt] IS NULL)
    BEGIN
        -- 2. Mettre à jour le statut et la date de modification
        UPDATE [dbo].[User]
        SET 
            [DisableAt] = GETDATE(), -- Marque le compte comme désactivé
            [UpdatedAt] = GETDATE()  -- Met à jour la date de modification
        WHERE 
            [UserId] = @UserId;
            
        RETURN 0; -- Succès
    END
    ELSE
    BEGIN
        -- L'utilisateur n'existe pas ou est déjà désactivé
        PRINT 'Utilisateur non trouvé ou déjà désactivé.';
        RETURN -1; -- Échec (non trouvé ou action inutile)
    END
END
GO