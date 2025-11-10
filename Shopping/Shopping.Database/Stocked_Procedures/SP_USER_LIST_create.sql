CREATE PROCEDURE [dbo].[SP_USER_LIST_create]
    @UserId UNIQUEIDENTIFIER, -- L'utilisateur qui fait l'action (pris du jeton)
    @Name NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @NewListId UNIQUEIDENTIFIER = NEWID();

    BEGIN TRY
        INSERT INTO [dbo].[ShoppingList] ([ListId], [UserId], [Name])
        VALUES (@NewListId, @UserId, @Name);

        -- Retourner le nouvel ID pour l'API (pour la redirection)
        SELECT @NewListId AS ListId;
        
        RETURN 0;
    END TRY
    BEGIN CATCH
        THROW;
        RETURN -1;
    END CATCH
END
GO