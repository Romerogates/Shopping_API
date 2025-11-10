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
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Création de la base de données $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Impossible de modifier les paramètres de base de données. Vous devez être administrateur système pour appliquer ces paramètres.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Impossible de modifier les paramètres de base de données. Vous devez être administrateur système pour appliquer ces paramètres.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Création de Table [dbo].[Role]...';


GO
CREATE TABLE [dbo].[Role] (
    [RoleId] INT           NOT NULL,
    [Role]   NVARCHAR (20) NOT NULL,
    PRIMARY KEY CLUSTERED ([RoleId] ASC)
);


GO
PRINT N'Création de Table [dbo].[User]...';


GO
CREATE TABLE [dbo].[User] (
    [UserId]    UNIQUEIDENTIFIER NOT NULL,
    [Username]  NVARCHAR (50)    NOT NULL,
    [Email]     NVARCHAR (320)   NOT NULL,
    [Password]  VARBINARY (32)   NOT NULL,
    [Salt]      UNIQUEIDENTIFIER NOT NULL,
    [CreatedAt] DATETIME2 (7)    NOT NULL,
    [UpdatedAt] DATETIME2 (7)    NOT NULL,
    [DisableAt] DATETIME2 (7)    NULL,
    [Role]      INT              NOT NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([UserId] ASC),
    CONSTRAINT [UK_User_Email] UNIQUE NONCLUSTERED ([Email] ASC),
    CONSTRAINT [UK_User_Username] UNIQUE NONCLUSTERED ([Username] ASC)
);


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[User]...';


GO
ALTER TABLE [dbo].[User]
    ADD DEFAULT NEWID() FOR [UserId];


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[User]...';


GO
ALTER TABLE [dbo].[User]
    ADD DEFAULT NEWID() FOR [Salt];


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[User]...';


GO
ALTER TABLE [dbo].[User]
    ADD DEFAULT GETDATE() FOR [CreatedAt];


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[User]...';


GO
ALTER TABLE [dbo].[User]
    ADD DEFAULT GETDATE() FOR [UpdatedAt];


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[User]...';


GO
ALTER TABLE [dbo].[User]
    ADD DEFAULT 1 FOR [Role];


GO
PRINT N'Création de Clé étrangère [dbo].[FK_User_Role]...';


GO
ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_Role] FOREIGN KEY ([Role]) REFERENCES [dbo].[Role] ([RoleId]);


GO
PRINT N'Création de Fonction [dbo].[SF_USER_hashAndSalt]...';


GO
CREATE FUNCTION [dbo].[SF_USER_hashAndSalt]
(
    @Password NVARCHAR(255),
    @Salt UNIQUEIDENTIFIER
)
RETURNS VARBINARY(32)
AS
BEGIN
    -- Concatène le mot de passe (texte) et le sel (GUID converti en texte)
    DECLARE @SaltedPassword NVARCHAR(600)
    SET @SaltedPassword = CONCAT(@Password, @Salt)
    
    -- Retourne le hash binaire de 32 octets (256 bits)
    RETURN HASHBYTES('SHA2_256', @SaltedPassword)
END
GO
PRINT N'Création de Procédure [dbo].[SP_ADMIN_getRoles]...';


GO
CREATE PROCEDURE [dbo].[SP_ADMIN_getRoles]
    @PerformingUserId UNIQUEIDENTIFIER -- L'ID de l'admin
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. VÉRIFICATION DES PERMISSIONS
    IF NOT EXISTS (
        SELECT 1
        FROM [dbo].[User] u
        JOIN [dbo].[Role] r ON u.[Role] = r.[RoleId]
        WHERE u.[UserId] = @PerformingUserId
          AND r.[Role] = 'Admin'
          AND u.[DisableAt] IS NULL
    )
    BEGIN
        RAISERROR('Permission refusée. Seul un administrateur peut voir la liste des rôles.', 16, 1);
        RETURN -1; -- Permission refusée
    END

    -- 2. ACTION (si admin)
    SELECT [RoleId], [Role]
    FROM [dbo].[Role]
    ORDER BY [RoleId];
    
    RETURN 0; -- Succès

END
GO
PRINT N'Création de Procédure [dbo].[SP_ADMIN_ROLE_create]...';


GO
CREATE PROCEDURE [dbo].[SP_ADMIN_ROLE_create]
    @PerformingUserId UNIQUEIDENTIFIER, -- L'ID de l'admin
    @NewRoleId INT,                     -- Le nouvel ID (ex: 2)
    @NewRoleName NVARCHAR(20)           -- Le nom (ex: 'Moderator')
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. VÉRIFICATION DES PERMISSIONS
    IF NOT EXISTS (
        SELECT 1
        FROM [dbo].[User] u
        JOIN [dbo].[Role] r ON u.[Role] = r.[RoleId]
        WHERE u.[UserId] = @PerformingUserId
          AND r.[Role] = 'Admin' -- Vérifie si l'utilisateur est 'Admin'
          AND u.[DisableAt] IS NULL
    )
    BEGIN
        RAISERROR('Permission refusée. Seul un administrateur peut créer un rôle.', 16, 1);
        RETURN -1; -- Permission refusée
    END

    -- 2. VÉRIFIER SI L'ID OU LE NOM EXISTE DÉJÀ
    IF EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [RoleId] = @NewRoleId OR [Role] = @NewRoleName)
    BEGIN
        RAISERROR('Un rôle avec cet ID ou ce nom existe déjà.', 16, 1);
        RETURN -2; -- Conflit
    END

    -- 3. ACTION (si admin)
    BEGIN TRY
        INSERT INTO [dbo].[Role] ([RoleId], [Role])
        VALUES (@NewRoleId, @NewRoleName);
        RETURN 0; -- Succès
    END TRY
    BEGIN CATCH
        PRINT 'Erreur lors de la création du rôle.';
        THROW;
        RETURN -100;
    END CATCH

END
GO
PRINT N'Création de Procédure [dbo].[SP_ADMIN_ROLE_delete]...';


GO
CREATE PROCEDURE [dbo].[SP_ADMIN_ROLE_delete]
    @PerformingUserId UNIQUEIDENTIFIER, -- L'ID de l'admin
    @RoleIdToDelete INT                 -- L'ID du rôle à supprimer
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. VÉRIFICATION DES PERMISSIONS
    IF NOT EXISTS (
        SELECT 1
        FROM [dbo].[User] u
        JOIN [dbo].[Role] r ON u.[Role] = r.[RoleId]
        WHERE u.[UserId] = @PerformingUserId
          AND r.[Role] = 'Admin'
          AND u.[DisableAt] IS NULL
    )
    BEGIN
        RAISERROR('Permission refusée. Seul un administrateur peut supprimer un rôle.', 16, 1);
        RETURN -1; -- Permission refusée
    END
    
    -- 2. NE JAMAIS SUPPRIMER LE RÔLE ADMIN LUI-MÊME (ou le rôle par défaut 1)
    IF @RoleIdToDelete = 1 OR (SELECT [Role] FROM [dbo].[Role] WHERE [RoleId] = @RoleIdToDelete) = 'Admin'
    BEGIN
        RAISERROR('Ce rôle ne peut pas être supprimé.', 16, 1);
        RETURN -2; -- Règle métier
    END

    -- 3. VÉRIFIER SI LE RÔLE EST UTILISÉ
    IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE [Role] = @RoleIdToDelete)
    BEGIN
        RAISERROR('Impossible de supprimer ce rôle car il est assigné à un ou plusieurs utilisateurs.', 16, 1);
        RETURN -3; -- Conflit (Clé étrangère)
    END

    -- 4. ACTION (si admin et rôle non utilisé)
    BEGIN TRY
        DELETE FROM [dbo].[Role]
        WHERE [RoleId] = @RoleIdToDelete;
        
        IF @@ROWCOUNT = 0
        BEGIN
             RAISERROR('Le rôle n''a pas été trouvé.', 16, 1);
             RETURN -4; -- Non trouvé
        END
        
        RETURN 0; -- Succès
    END TRY
    BEGIN CATCH
        PRINT 'Erreur lors de la suppression du rôle.';
        THROW;
        RETURN -100;
    END CATCH

END
GO
PRINT N'Création de Procédure [dbo].[SP_ADMIN_ROLE_update]...';


GO
CREATE PROCEDURE [dbo].[SP_ADMIN_ROLE_update]
    @PerformingUserId UNIQUEIDENTIFIER, -- L'ID de l'admin
    @RoleIdToUpdate INT,                -- L'ID du rôle à changer
    @NewRoleName NVARCHAR(20)           -- Le nouveau nom
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. VÉRIFICATION DES PERMISSIONS
    IF NOT EXISTS (
        SELECT 1
        FROM [dbo].[User] u
        JOIN [dbo].[Role] r ON u.[Role] = r.[RoleId]
        WHERE u.[UserId] = @PerformingUserId
          AND r.[Role] = 'Admin'
          AND u.[DisableAt] IS NULL
    )
    BEGIN
        RAISERROR('Permission refusée. Seul un administrateur peut modifier un rôle.', 16, 1);
        RETURN -1; -- Permission refusée
    END

    -- 2. VÉRIFIER SI LE RÔLE EXISTE
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [RoleId] = @RoleIdToUpdate)
    BEGIN
        RAISERROR('Le rôle que vous essayez de modifier n''existe pas.', 16, 1);
        RETURN -2; -- Non trouvé
    END
    
    -- 3. VÉRIFIER SI LE NOUVEAU NOM EST DÉJÀ PRIS
    IF EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [Role] = @NewRoleName AND [RoleId] != @RoleIdToUpdate)
    BEGIN
        RAISERROR('Ce nom de rôle est déjà utilisé.', 16, 1);
        RETURN -3; -- Conflit
    END

    -- 4. ACTION (si admin)
    BEGIN TRY
        UPDATE [dbo].[Role]
        SET [Role] = @NewRoleName
        WHERE [RoleId] = @RoleIdToUpdate;
        RETURN 0; -- Succès
    END TRY
    BEGIN CATCH
        PRINT 'Erreur lors de la mise à jour du rôle.';
        THROW;
        RETURN -100;
    END CATCH

END
GO
PRINT N'Création de Procédure [dbo].[SP_ADMIN_USER_getAll]...';


GO
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
GO
PRINT N'Création de Procédure [dbo].[SP_ADMIN_USER_getById]...';


GO
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
PRINT N'Création de Procédure [dbo].[SP_ADMIN_USER_update]...';


GO
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
PRINT N'Création de Procédure [dbo].[SP_USER_USER_create]...';


GO
CREATE PROCEDURE [dbo].[SP_USER_USER_create]
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
PRINT N'Création de Procédure [dbo].[SP_USER_USER_disable]...';


GO
CREATE PROCEDURE [dbo].[SP_USER_USER_disable]
    -- Paramètre d'entrée : L'ID de l'utilisateur à désactiver
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Vérifier si l'utilisateur existe ET s'il n'est pas déjà désactivé
    IF EXISTS (SELECT 1 FROM [dbo].[User] WHERE [UserId] = @UserId AND [DisableAt] IS NULL)
    BEGIN
        -- 2. Mettre à jour le statut et la date de modification
        UPDATE [dbo].[User]
        SET 
            [DisableAt] = GETDATE(), -- Marque le compte comme désactivé
            [UpdatedAt] = GETDATE()  -- Met à jour la date de modification
        WHERE 
            [UserId] = @UserId;
            
        RETURN 0; -- Succès
    END
    ELSE
    BEGIN
        -- L'utilisateur n'existe pas ou est déjà désactivé
        PRINT 'Utilisateur non trouvé ou déjà désactivé.';
        RETURN -1; -- Échec (non trouvé ou action inutile)
    END
END
GO
PRINT N'Création de Procédure [dbo].[SP_USER_USER_login]...';


GO
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
PRINT N'Création de Procédure [dbo].[SP_USER_USER_update]...';


GO
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
-- Étape de refactorisation pour mettre à jour le serveur cible avec des journaux de transactions déployés

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '6bcec36a-48d4-4b2b-8259-2ec1f1012d52')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('6bcec36a-48d4-4b2b-8259-2ec1f1012d52')

GO

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
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Mise à jour terminée.';


GO
