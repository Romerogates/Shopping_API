CREATE TABLE [dbo].[User]
(
    [UserId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [Username] NVARCHAR(50) NOT NULL,    -- Ajouté
    [Email] NVARCHAR(320) NOT NULL,
    [Password] VARBINARY(32) NOT NULL,
    [Salt] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [DisableAt] DATETIME2 NULL, 
    [Role] INT NOT NULL DEFAULT 1, 
    
    -- Contraintes
    CONSTRAINT [PK_User] PRIMARY KEY ([UserId]),
    CONSTRAINT [FK_User_Role] FOREIGN KEY ([Role]) REFERENCES [Role]([RoleId]),
    CONSTRAINT [UK_User_Email] UNIQUE ([Email]),
    CONSTRAINT [UK_User_Username] UNIQUE ([Username]) -- Ajouté : Crucial !
)