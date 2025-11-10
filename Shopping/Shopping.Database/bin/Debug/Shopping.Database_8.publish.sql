/*
Script de déploiement pour Shopping.Database

Ce code a été généré par un outil.
La modification de ce fichier peut provoquer un comportement incorrect et sera perdue si
le code est régénéré.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Shopping.Database"
:setvar DefaultFilePrefix "Shopping.Database"
:setvar DefaultDataPath "C:\Users\Antho\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\Shopping\"
:setvar DefaultLogPath "C:\Users\Antho\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\Shopping\"

GO
:on error exit
GO
/*
Détectez le mode SQLCMD et désactivez l'exécution du script si le mode SQLCMD n'est pas pris en charge.
Pour réactiver le script une fois le mode SQLCMD activé, exécutez ce qui suit :
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Le mode SQLCMD doit être activé de manière à pouvoir exécuter ce script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Création de Table [dbo].[Unit]...';


GO
CREATE TABLE [dbo].[Unit] (
    [UnitId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]   NVARCHAR (20) NOT NULL,
    PRIMARY KEY CLUSTERED ([UnitId] ASC),
    CONSTRAINT [UK_Unit_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
PRINT N'Création de Procédure [dbo].[SP_UNIT_getAll]...';


GO
CREATE PROCEDURE [dbo].[SP_UNIT_getAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [Name] FROM [dbo].[Unit] ORDER BY [Name];
END
GO
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

GO
PRINT N'Mise à jour terminée.';


GO
