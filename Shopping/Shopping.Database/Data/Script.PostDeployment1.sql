    /*
Modèle de script de post-déploiement							
--------------------------------------------------------------------------------------
 Ce fichier contient des instructions SQL qui seront ajoutées au script de compilation.		
 Utilisez la syntaxe SQLCMD pour inclure un fichier dans le script de post-déploiement.			
 Exemple :      :r .\monfichier.sql								
 Utilisez la syntaxe SQLCMD pour référencer une variable dans le script de post-déploiement.		
 Exemple :      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
DECLARE @AdminRoleId INT = 0; 
DECLARE @UserRoleId INT = 1;

-----------------------------------------------------------
-- 1. AJOUT DES RÔLES (Si non existants)
-----------------------------------------------------------

-- 1a. Insérer le rôle Admin (0)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [RoleId] = @AdminRoleId)
BEGIN
    INSERT INTO [dbo].[Role] ([RoleId], [Role]) VALUES (@AdminRoleId, 'Admin');
END

-- 1b. Insérer le rôle User (1)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [RoleId] = @UserRoleId)
BEGIN
    INSERT INTO [dbo].[Role] ([RoleId], [Role]) VALUES (@UserRoleId, 'User');
END
GO

-----------------------------------------------------------
-- 2. CRÉATION DE L'UTILISATEUR ADMINISTRATEUR (Si non existant)
-----------------------------------------------------------

-- Le bloc DECLARE doit être répété ici car le GO le termine
DECLARE @AdminUsername NVARCHAR(50) = 'SuperAdmin';
DECLARE @AdminEmail NVARCHAR(320) = 'admin@admin.com';
DECLARE @AdminPassword NVARCHAR(255) = 'Ma3ds3ds';
DECLARE @AdminRoleId INT = 0; 

-- Créer l'utilisateur uniquement s'il n'existe pas déjà par email
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [Email] = @AdminEmail)
BEGIN
    
    -- Utiliser la procédure de création sécurisée
    EXEC [dbo].[SP_USER_USER_create]
        @Username = @AdminUsername,
        @Email = @AdminEmail,
        @Password = @AdminPassword,
        @Role = @AdminRoleId; -- Assigne le RoleId 0

    PRINT 'Utilisateur Admin cree: ' + @AdminUsername;
END
ELSE
BEGIN
    PRINT 'L''utilisateur Admin existe deja.';
END
GO

INSERT INTO [dbo].[Unit] ([Name])
VALUES
('Pièce(s)'),
('kg'),
('g'),
('Litre(s)'),
('ml'),
('Boîte(s)'),
('Paquet(s)');
GO