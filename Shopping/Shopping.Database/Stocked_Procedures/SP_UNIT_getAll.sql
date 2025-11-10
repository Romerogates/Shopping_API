CREATE PROCEDURE [dbo].[SP_UNIT_getAll]
AS
BEGIN
    SET NOCOUNT ON;
    -- Renvoie l'ID (pour le <select>) et le Nom
    SELECT [UnitId], [Name] FROM [dbo].[Unit] ORDER BY [Name];
END
GO