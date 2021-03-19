USE [Filmoteque]
GO
/***
������ ��������� ��������� ����� ��������� � ������� ���������,
��������� ����� ������ � ������� ���������_����� � ����� ������� �������,
��������� ��� � ������� �����, ���� ��� ����� �����,
��������� ����� ������ � ������� ��������, ���� ��������������� ����������
��� �� ��������� �������� � ��������������� �������,
��������� ������ � ����������, ���� ������ �����, ��������� ���������������
������ � ������� ����������_���������.
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
		SELECT @actor_code = [���_������]
		FROM [dbo].�����
		WHERE [���] = @main_actor_name
		AND [����_��������] = @main_actor_bd
		AND [�����] = @main_actor_city
		
		IF @actor_code IS NULL 
		BEGIN
			INSERT INTO [dbo].�����
			VALUES (@main_actor_name, @main_actor_city, @main_actor_bd)
		END
	END

	WHILE @studio_code IS NULL
	BEGIN
		SELECT @studio_code = [dbo].����������.���_����������
		FROM [dbo].����������
		WHERE [dbo].����������.�������� = @studio_name
		AND [dbo].����������.����� = @studio_city
		
		IF @studio_code IS NULL 
		BEGIN
			INSERT INTO [dbo].����������
			VALUES (@studio_name, @studio_city)
		END
	END

	WHILE @film_code IS NULL
	BEGIN
		SELECT @film_code = [dbo].���������.���_����������
		FROM [dbo].���������
		WHERE [dbo].���������.�������� = @film_name
		AND [dbo].���������.���_������ = @film_year
		AND [dbo].���������.�������� = @film_tema
		
		IF @film_code IS NULL 
		BEGIN
			INSERT INTO [dbo].���������
			VALUES (@film_name, @film_year, @film_tema)
		END
	END
	
	IF ((SELECT COUNT(*) FROM [dbo].����������_���������
		 WHERE [dbo].����������_���������.���_���������� = @studio_code 
		 AND [dbo].����������_���������.���_���������� = @film_code ) = 0)
	BEGIN
		INSERT INTO [dbo].����������_���������
		VALUES (@studio_code, @film_code)
	END

	IF ((SELECT COUNT(*) FROM [dbo].���������_�����
		 WHERE [dbo].���������_�����.���_������ = @actor_code 
		 AND [dbo].���������_�����.���_���������� = @film_code ) = 0)
	BEGIN
		INSERT INTO [dbo].���������_�����
		VALUES (@film_code, @actor_code)
	END

	IF ((SELECT COUNT(*) FROM [dbo].��������
		 WHERE [dbo].��������.���_������ = @actor_code 
		 AND [dbo].��������.���_���������� = @studio_code ) = 0)
	BEGIN
		INSERT INTO [dbo].��������
		VALUES (@studio_name + CAST(NEXT VALUE for KS_Code AS varchar(255)), @studio_code, @actor_code)
	END
END

GO 

SELECT * 
FROM [dbo].���������

SELECT * 
FROM [dbo].�����

SELECT * 
FROM [dbo].����������
GO

EXEC ADD_NEW_FILM '������� � ������', '���������', 1998, 'CANAL+', '�����', '������� ������� ����������', '12.01.1990', '��������'
GO

SELECT * 
FROM [dbo].���������

SELECT * 
FROM [dbo].�����

SELECT * 
FROM [dbo].����������
GO