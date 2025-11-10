CREATE PROCEDURE [dbo].[SP_USER_USER_login]
    -- Ce paramètre accepte soit l'email, soit le pseudo
    @LoginIdentifier NVARCHAR(320), 
    @Password NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId UNIQUEIDENTIFIER;
    DECLARE @StoredSalt UNIQUEIDENTIFIER;
    DECLARE @StoredHash VARBINARY(32);
    DECLARE @CalculatedHash VARBINARY(32);

    BEGIN TRY
        -- 1. Récupérer l'utilisateur par email OU par pseudo (s'il est actif)
        SELECT 
            @UserId = u.UserId,
            @StoredSalt = u.Salt,
            @StoredHash = u.[Password]
        FROM 
            [dbo].[User] AS u
        WHERE 
            (u.[Email] = @LoginIdentifier OR u.[Username] = @LoginIdentifier) 
            AND u.[DisableAt] IS NULL;

        -- 2. Vérifier si l'utilisateur a été trouvé
        IF @UserId IS NOT NULL
        BEGIN
            -- 3. Calculer le hash du mot de passe fourni avec le sel stocké
            SET @CalculatedHash = [dbo].[SF_USER_hashAndSalt](@Password, @StoredSalt);

            -- 4. Comparer les hashs
            IF @CalculatedHash = @StoredHash
            BEGIN
                -- SUCCÈS !
                -- Mettre à jour la date de dernière activité/connexion
                UPDATE [dbo].[User] SET UpdatedAt = GETDATE() WHERE UserId = @UserId;

                -- Renvoyer les informations de l'utilisateur (y compris le nom du rôle)
                SELECT 
                    u.[UserId], 
                    u.[Username], 
                    u.[Email], 
                    r.[Role] AS [RoleName] -- Jointure pour le nom du rôle
                FROM [dbo].[User] AS u
                JOIN [dbo].[Role] AS r ON u.[Role] = r.[RoleId]
                WHERE u.UserId = @UserId;
                
                RETURN 0; -- Succès
            END
            ELSE
            BEGIN
                -- Échec : Mauvais mot de passe
                RETURN -1;
            END
        END
        ELSE
        BEGIN
            -- Échec : Utilisateur non trouvé ou désactivé
            RETURN -1;
        END

    END TRY
    BEGIN CATCH
        PRINT 'Erreur lors de la tentative de connexion.';
        THROW;
        RETURN -100; -- Erreur générale
    END CATCH

END
GO