-- Nouvelle procédure : SANS le paramètre @NewUserId
CREATE PROCEDURE [dbo].[SP_USER_USER_create]
    @Username NVARCHAR(50),
    @Email NVARCHAR(320),
    @Password NVARCHAR(255),
    @Role INT = 1 -- Le rôle est conservé, il fonctionne comme valeur par défaut
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Salt UNIQUEIDENTIFIER = NEWID();
    DECLARE @HashedPassword VARBINARY(32);

    -- 1. Hachage du mot de passe
    SET @HashedPassword = [dbo].[SF_USER_hashAndSalt](@Password, @Salt);

    -- 2. Insertion
    BEGIN TRY
        INSERT INTO [dbo].[User]
        (
            -- L'ID est généré automatiquement via DEFAULT NEWID()
            [Username],
            [Email],
            [Password],
            [Salt],
            [Role]
        )
        VALUES
        (
            @Username,
            @Email,
            @HashedPassword,
            @Salt,
            @Role
        );
        
        RETURN 0; -- Succès

    END TRY
    BEGIN CATCH
        -- Relance l'erreur pour le 409 Conflict (si violation d'unicité)
        THROW;
    END CATCH

END
GO