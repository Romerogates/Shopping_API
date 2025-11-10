CREATE PROCEDURE [dbo].[SP_ADMIN_USER_update]
    -- Paramètre d'entrée : Qui mettre à jour ?
    @UserId UNIQUEIDENTIFIER,
    
    -- Nouveaux détails (laisser NULL si on ne veut pas changer)
    @Username NVARCHAR(50) = NULL,
    @Email NVARCHAR(320) = NULL,
    @Role INT = NULL,
    
    -- Paramètre spécial pour le statut
    -- 0 = Activer le compte, 1 = Désactiver le compte, NULL = Ne pas changer
    @DisableStatus BIT = NULL 
AS
BEGIN
    SET NOCOUNT ON;

    -- Vérifier si au moins une action est demandée
    IF @Username IS NULL AND @Email IS NULL AND @Role IS NULL AND @DisableStatus IS NULL
    BEGIN
        PRINT 'Aucune information à mettre à jour n''a été fournie.';
        RETURN -2; -- "Rien à faire"
    END

    -- Vérifier si l'utilisateur existe (contrairement aux autres,
    -- un admin peut vouloir modifier un compte déjà désactivé)
    IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [UserId] = @UserId)
    BEGIN
        PRINT 'Utilisateur non trouvé.';
        RETURN -1; -- "Non trouvé"
    END

    BEGIN TRY
        UPDATE [dbo].[User]
        SET 
            -- Logique "ISNULL" pour les champs optionnels
            [Username] = ISNULL(@Username, [Username]),
            [Email] = ISNULL(@Email, [Email]),
            [Role] = ISNULL(@Role, [Role]),

            -- Logique "CASE" pour le statut d'activation
            [DisableAt] = CASE
                WHEN @DisableStatus = 1 THEN GETDATE() -- Désactiver
                WHEN @DisableStatus = 0 THEN NULL      -- Réactiver
                ELSE [DisableAt]                     -- Ne rien changer (si @DisableStatus est NULL)
            END,

            [UpdatedAt] = GETDATE()
        WHERE 
            [UserId] = @UserId;
        
        RETURN 0; -- Succès
    END TRY
    BEGIN CATCH
        -- Gère les erreurs (ex: l'email ou username existe déjà)
        PRINT 'Erreur : Le nom d''utilisateur ou l''email est peut-être déjà pris.';
        THROW;
        RETURN -100; -- Erreur générale
    END CATCH

END
GO