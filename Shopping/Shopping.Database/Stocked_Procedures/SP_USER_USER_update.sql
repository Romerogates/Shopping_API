CREATE PROCEDURE [dbo].[SP_USER_USER_update]
    -- Paramètres d'entrée
    @UserId UNIQUEIDENTIFIER,      -- L'ID de l'utilisateur qui fait le changement
    @NewUsername NVARCHAR(50)     -- Le nouveau nom d'utilisateur souhaité
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Vérifier si l'utilisateur existe et est actif
    IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [UserId] = @UserId AND [DisableAt] IS NULL)
    BEGIN
        PRINT 'Utilisateur non trouvé ou désactivé.';
        RETURN -1; -- Échec : Non trouvé
    END

    -- 2. Vérifier si le nouveau nom d'utilisateur est déjà pris par quelqu'un d'autre
    -- (Votre contrainte UNIQUE le fera aussi, mais c'est une vérification "propre"
    -- qui évite de déclencher une erreur SQL)
    IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE [Username] = @NewUsername AND [UserId] != @UserId)
    BEGIN
        PRINT 'Ce nom d''utilisateur est déjà pris.';
        RETURN -2; -- Échec : Nom d'utilisateur pris
    END

    -- 3. Effectuer la mise à jour
    BEGIN TRY
        UPDATE [dbo].[User]
        SET 
            [Username] = @NewUsername,
            [UpdatedAt] = GETDATE()  -- Mettre à jour la date de modification
        WHERE 
            [UserId] = @UserId;
        
        RETURN 0; -- Succès
    END TRY
    BEGIN CATCH
        -- Intercepte toute autre erreur (par exemple, une "race condition"
        -- si quelqu'un a pris le pseudo à la même milliseconde)
        PRINT 'Une erreur est survenue lors de la mise à jour.';
        THROW;
        RETURN -100; -- Erreur générale
    END CATCH

END
GO