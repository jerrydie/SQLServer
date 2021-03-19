/****** Custom constraints  ******/
USE Filmoteque;
GO

GO
CREATE FUNCTION dbo.SignupYearsDif()
RETURNS int
AS BEGIN RETURN (
    SELECT MIN([dbo].[Кинофильм].Год_выхода - YEAR([dbo].[Актер].[Дата_рождения])) AS min_dif
    FROM [dbo].Кинофильм_Актер
    JOIN [dbo].Актер ON [dbo].Актер.Код_актера = [dbo].Кинофильм_Актер.Код_актера
	JOIN [dbo].Кинофильм ON [dbo].Кинофильм_Актер.Код_кинофильма = [dbo].Кинофильм.Код_кинофильма
) END
GO

ALTER TABLE [dbo].Актер ADD 
	CONSTRAINT Actor_can_be_alive CHECK (YEAR(GETDATE()) - YEAR([Дата_рождения]) <= 123 )
GO

/****** To check the constraint
INSERT INTO [dbo].Актер VALUES('TEST Actor', 'New York', '12.01.1800');
GO
******/

ALTER TABLE [dbo].Кинофильм_Актер ADD
	CONSTRAINT Actor_is_born_before_film CHECK (dbo.SignupYearsDif() > 0)
GO

ALTER TABLE [dbo].Кинофильм ADD
	CONSTRAINT Film_is_done CHECK ( Год_выхода <= YEAR(GETDATE()) )
GO

/****** To check the constraint
INSERT INTO [dbo].Кинофильм VALUES('TEST Film', 2022, 'horror');
GO
******/