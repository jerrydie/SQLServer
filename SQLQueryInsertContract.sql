CREATE TRIGGER Tr1 ON [dbo].[Актер_Кинофильм] AFTER Insert AS Select 'Insert';
GO 
CREATE TRIGGER Tr2 ON [dbo].[Актер_Кинофильм] AFTER UPDATE AS Select 'UPDATE'; 
GO

/** Для каждой киностудии для каждого кинофильма для каждого нового актера создать контракт (если он еще не существует в таблице) **/
CREATE SEQUENCE KS_Code	
AS	int
	START WITH 1
	INCREMENT BY 1
	CACHE  5
GO

CREATE VIEW KK_KA_and_KS_Code
AS SELECT [dbo].Кинофильм_Актер.Код_актера AS Код_актера, 
			[dbo].Киностудия_Кинофильм.Код_киностудии AS Код_киностудии, 
			[dbo].Киностудия.Название  AS Номер_контракта
FROM [dbo].Киностудия_Кинофильм 
JOIN [dbo].Кинофильм_Актер ON [dbo].Киностудия_Кинофильм.Код_кинофильма = [dbo].Кинофильм_Актер.Код_кинофильма
JOIN [dbo].Киностудия ON [dbo].Киностудия_Кинофильм.Код_киностудии = [dbo].Киностудия.Код_киностудии
GO

INSERT INTO [dbo].Контракт
SELECT Номер_контракта + CAST(NEXT VALUE for KS_Code AS varchar(255)), Код_киностудии, Код_актера
FROM KK_KA_and_KS_Code
GO