USE [Filmoteque]
GO
/***
Данная процедура добавляет новый кинофильм в таблицу Кинофильм,
добавляет новые записи в таблицу Кинофильм_Актер с одним главным актером,
добавляет его в таблицу Актер, если это новый актер,
добавляет новые записи в таблицу Контракт, если соответствующая киностудия
еще не заключила контракт с задействованным актером,
добавляет студию в Киностудия, если студия новая, добавлякт соответствующую
запись в таблицу Киностудия_Кинофильм.
***/
CREATE PROCEDURE ADD_NEW_FILM 
	@film_name varchar(255),
	@film_tema varchar(255), 
	@film_year Integer, 
	@studio_name varchar(255),
	@studio_city varchar(255),
	@main_actor_name varchar(255),
	@main_actor_bd DATE,
	@main_actor_city varchar(255)
AS
BEGIN
	DECLARE @film_code int = NULL
	DECLARE @actor_code int = NULL
	DECLARE @studio_code int = NULL

	WHILE @actor_code IS NULL
	BEGIN
		SELECT @actor_code = [Код_актера]
		FROM [dbo].Актер
		WHERE [ФИО] = @main_actor_name
		AND [Дата_рождения] = @main_actor_bd
		AND [Город] = @main_actor_city
		
		IF @actor_code IS NULL 
		BEGIN
			INSERT INTO [dbo].Актер
			VALUES (@main_actor_name, @main_actor_city, @main_actor_bd)
		END
	END

	WHILE @studio_code IS NULL
	BEGIN
		SELECT @studio_code = [dbo].Киностудия.Код_киностудии
		FROM [dbo].Киностудия
		WHERE [dbo].Киностудия.Название = @studio_name
		AND [dbo].Киностудия.Город = @studio_city
		
		IF @studio_code IS NULL 
		BEGIN
			INSERT INTO [dbo].Киностудия
			VALUES (@studio_name, @studio_city)
		END
	END

	WHILE @film_code IS NULL
	BEGIN
		SELECT @film_code = [dbo].Кинофильм.Код_кинофильма
		FROM [dbo].Кинофильм
		WHERE [dbo].Кинофильм.Название = @film_name
		AND [dbo].Кинофильм.Год_выхода = @film_year
		AND [dbo].Кинофильм.Тематика = @film_tema
		
		IF @film_code IS NULL 
		BEGIN
			INSERT INTO [dbo].Кинофильм
			VALUES (@film_name, @film_year, @film_tema)
		END
	END
	
	IF ((SELECT COUNT(*) FROM [dbo].Киностудия_Кинофильм
		 WHERE [dbo].Киностудия_Кинофильм.Код_киностудии = @studio_code 
		 AND [dbo].Киностудия_Кинофильм.Код_кинофильма = @film_code ) = 0)
	BEGIN
		INSERT INTO [dbo].Киностудия_Кинофильм
		VALUES (@studio_code, @film_code)
	END

	IF ((SELECT COUNT(*) FROM [dbo].Кинофильм_Актер
		 WHERE [dbo].Кинофильм_Актер.Код_актера = @actor_code 
		 AND [dbo].Кинофильм_Актер.Код_кинофильма = @film_code ) = 0)
	BEGIN
		INSERT INTO [dbo].Кинофильм_Актер
		VALUES (@film_code, @actor_code)
	END

	IF ((SELECT COUNT(*) FROM [dbo].Контракт
		 WHERE [dbo].Контракт.Код_актера = @actor_code 
		 AND [dbo].Контракт.Код_киностудии = @studio_code ) = 0)
	BEGIN
		INSERT INTO [dbo].Контракт
		VALUES (@studio_name + CAST(NEXT VALUE for KS_Code AS varchar(255)), @studio_code, @actor_code)
	END
END

GO 

SELECT * 
FROM [dbo].Кинофильм

SELECT * 
FROM [dbo].Актер

SELECT * 
FROM [dbo].Киностудия
GO

EXEC ADD_NEW_FILM 'Полночь в Париже', 'мелодрама', 1998, 'CANAL+', 'Париж', 'Абрамов Василий Николаевич', '12.01.1990', 'Одинцово'
GO

SELECT * 
FROM [dbo].Кинофильм

SELECT * 
FROM [dbo].Актер

SELECT * 
FROM [dbo].Киностудия
GO