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
PRINT N'Création de Table [dbo].[ShoppingList]...';


GO
CREATE TABLE [dbo].[ShoppingList] (
    [ListId]     UNIQUEIDENTIFIER NOT NULL,
    [UserId]     UNIQUEIDENTIFIER NOT NULL,
    [Name]       NVARCHAR (100)   NOT NULL,
    [CreatedAt]  DATETIME2 (7)    NOT NULL,
    [DisabledAt] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_ShoppingList] PRIMARY KEY CLUSTERED ([ListId] ASC)
);


GO
PRINT N'Création de Table [dbo].[ShoppingListItem]...';


GO
CREATE TABLE [dbo].[ShoppingListItem] (
    [ItemId]    UNIQUEIDENTIFIER NOT NULL,
    [ListId]    UNIQUEIDENTIFIER NOT NULL,
    [Name]      NVARCHAR (200)   NOT NULL,
    [Quantity]  DECIMAL (8, 2)   NOT NULL,
    [Unit]      NVARCHAR (20)    NULL,
    [IsChecked] BIT              NOT NULL,
    [CreatedAt] DATETIME2 (7)    NOT NULL,
    CONSTRAINT [PK_ShoppingListItem] PRIMARY KEY CLUSTERED ([ItemId] ASC)
);


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[ShoppingList]...';


GO
ALTER TABLE [dbo].[ShoppingList]
    ADD DEFAULT NEWID() FOR [ListId];


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[ShoppingList]...';


GO
ALTER TABLE [dbo].[ShoppingList]
    ADD DEFAULT GETDATE() FOR [CreatedAt];


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[ShoppingListItem]...';


GO
ALTER TABLE [dbo].[ShoppingListItem]
    ADD DEFAULT NEWID() FOR [ItemId];


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[ShoppingListItem]...';


GO
ALTER TABLE [dbo].[ShoppingListItem]
    ADD DEFAULT 1 FOR [Quantity];


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[ShoppingListItem]...';


GO
ALTER TABLE [dbo].[ShoppingListItem]
    ADD DEFAULT 0 FOR [IsChecked];


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[ShoppingListItem]...';


GO
ALTER TABLE [dbo].[ShoppingListItem]
    ADD DEFAULT GETDATE() FOR [CreatedAt];


GO
PRINT N'Création de Clé étrangère [dbo].[FK_ShoppingList_User]...';


GO
ALTER TABLE [dbo].[ShoppingList] WITH NOCHECK
    ADD CONSTRAINT [FK_ShoppingList_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([UserId]);


GO
PRINT N'Création de Clé étrangère [dbo].[FK_ShoppingListItem_List]...';


GO
ALTER TABLE [dbo].[ShoppingListItem] WITH NOCHECK
    ADD CONSTRAINT [FK_ShoppingListItem_List] FOREIGN KEY ([ListId]) REFERENCES [dbo].[ShoppingList] ([ListId]) ON DELETE CASCADE;


GO
PRINT N'Modification de Procédure [dbo].[SP_USER_USER_create]...';


GO
ALTER PROCEDURE [dbo].[SP_USER_USER_create]
    @Username NVARCHAR(50),     
    @Email NVARCHAR(320),
    @Password NVARCHAR(255),
    @Role INT = 1,
    @NewUserId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Salt UNIQUEIDENTIFIER = NEWID();
    DECLARE @HashedPassword VARBINARY(32);
    SET @NewUserId = NEWID();

    SET @HashedPassword = [dbo].[SF_USER_hashAndSalt](@Password, @Salt);

    BEGIN TRY
        INSERT INTO [dbo].[User]
        (
            [UserId],
            [Username],         
            [Email],
            [Password],
            [Salt],
            [Role]
        )
        VALUES
        (
            @NewUserId,
            @Username,         
            @Email,
            @HashedPassword,
            @Salt,
            @Role
        );
        
        RETURN 0; 

    END TRY
    BEGIN CATCH
        PRINT 'Erreur : L''email ou le nom d''utilisateur existe peut-être déjà.';
        THROW;
        RETURN -1;
    END CATCH

END
GO
PRINT N'Création de Procédure [dbo].[SP_USER_LIST_create]...';


GO
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
PRINT N'Création de Procédure [dbo].[SP_USER_LIST_getAll]...';


GO
CREATE PROCEDURE [dbo].[SP_USER_LIST_getAll]
    @UserId UNIQUEIDENTIFIER -- L'utilisateur dont on veut les listes
AS
BEGIN
    SET NOCOUNT ON;

    -- Sélectionne les listes actives de cet utilisateur
    SELECT
        l.[ListId],
        l.[Name],
        l.[CreatedAt]
    FROM
        [dbo].[ShoppingList] AS l
    WHERE
        l.[UserId] = @UserId
        AND l.[DisabledAt] IS NULL
    ORDER BY
        l.[CreatedAt] DESC;
END
GO
PRINT N'Création de Procédure [dbo].[SP_USER_LIST_getById]...';


GO
CREATE PROCEDURE [dbo].[SP_USER_LIST_getById]
    @ListId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER -- Sécurité : s'assurer que la liste appartient bien à l'utilisateur
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Vérification de la propriété et de l'état de la liste
    IF NOT EXISTS (
        SELECT 1 
        FROM [dbo].[ShoppingList] 
        WHERE [ListId] = @ListId AND [UserId] = @UserId AND [DisabledAt] IS NULL
    )
    BEGIN
        -- Optionnel : lever une erreur si la liste n'existe pas ou n'appartient pas à l'utilisateur
        RAISERROR('Liste non trouvée ou accès non autorisé.', 16, 1);
        RETURN -1;
    END

    -- 2. Récupérer les articles
    SELECT
        [ItemId],
        [Name],
        [Quantity],
        [Unit],
        [IsChecked]
    FROM
        [dbo].[ShoppingListItem]
    WHERE
        [ListId] = @ListId
    ORDER BY
        [Name];
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



GO

GO
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[ShoppingList] WITH CHECK CHECK CONSTRAINT [FK_ShoppingList_User];

ALTER TABLE [dbo].[ShoppingListItem] WITH CHECK CHECK CONSTRAINT [FK_ShoppingListItem_List];


GO
PRINT N'Mise à jour terminée.';


GO
