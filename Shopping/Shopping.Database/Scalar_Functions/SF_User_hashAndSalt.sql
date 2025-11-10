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