CREATE PROCEDURE [dbo].[SP_ADMIN_USER_getById]
    -- Paramètre d'entrée : L'ID de l'utilisateur que l'admin recherche
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    -- Sélectionne les informations "sûres" et utiles pour un admin
    SELECT 
        u.[UserId],
        u.[Username],
        u.[Email],
        r.[Role] AS [RoleName], -- Récupère le nom du rôle
        u.[CreatedAt],
        u.[DisableAt] -- L'admin peut voir le statut d'activation
    FROM 
        [dbo].[User] AS u
    JOIN 
        [dbo].[Role] AS r ON u.[Role] = r.[RoleId] -- Jointure pour le nom du rôle
    WHERE 
        u.[UserId] = @UserId; -- Filtre sur l'ID fourni

END
GO