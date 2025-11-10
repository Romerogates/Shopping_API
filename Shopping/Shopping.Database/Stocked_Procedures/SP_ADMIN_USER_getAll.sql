CREATE PROCEDURE [dbo].[SP_ADMIN_USER_getAll]
AS
BEGIN
    SET NOCOUNT ON;

    -- Sélectionne les informations utiles pour un panneau d'administration
    SELECT 
        u.[UserId],
        u.[Username],
        u.[Email],
        r.[Role] AS [RoleName], -- On récupère le nom du rôle
        u.[CreatedAt],
        u.[DisableAt] -- L'admin a besoin de savoir si le compte est désactivé
    FROM 
        [dbo].[User] AS u
    JOIN 
        [dbo].[Role] AS r ON u.[Role] = r.[RoleId] -- Jointure pour avoir le nom du rôle
    ORDER BY 
        u.[Username]; -- Trier par nom d'utilisateur par défaut

END