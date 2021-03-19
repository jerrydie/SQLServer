CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SQLmaster@1';
GO

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
GO

USE Filmoteque;
GO
CREATE CERTIFICATE Certificate_Contract WITH SUBJECT = 'Protect Contract Number';
GO

SELECT name CertName, 
    certificate_id CertID, 
    pvt_key_encryption_type_desc EncryptType, 
    issuer_name Issuer
FROM sys.certificates;
GO

CREATE SYMMETRIC KEY SymKey_Contract WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE Certificate_Contract;
GO

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
GO


USE [Filmoteque]

ALTER TABLE [dbo].[Контракт]
ADD [Номер_контракта_шифр] varbinary(MAX)

GO

OPEN SYMMETRIC KEY SymKey_Contract
DECRYPTION BY CERTIFICATE Certificate_Contract
GO

UPDATE [dbo].[Контракт]
	SET [Номер_контракта_шифр] = EncryptByKey (Key_GUID('SymKey_Contract'), [Номер_контракта])
	FROM [dbo].[Контракт];
GO


CLOSE SYMMETRIC KEY SymKey_Contract;
GO

SELECT *
FROM [dbo].Контракт
GO

ALTER TABLE [dbo].Контракт DROP COLUMN Номер_контракта;
GO

SELECT *
FROM [dbo].Контракт
GO

CREATE VIEW Contract_open_view
WITH ENCRYPTION
AS 
	SELECT [dbo].Контракт.Код_контракта, [dbo].Контракт.Код_киностудии, [dbo].Контракт.Код_актера, 
		CONVERT(nvarchar(255), DECRYPTBYKEY([dbo].Контракт.Номер_контракта_шифр)) As [Номер_контракта]
	FROM [dbo].Контракт

GO

/*** The way to see Contract number ***/
OPEN SYMMETRIC KEY SymKey_Contract
DECRYPTION BY CERTIFICATE Certificate_Contract
GO

SELECT *
FROM Contract_open_view
GO

CLOSE SYMMETRIC KEY SymKey_Contract;
GO

/*** In general it will be seen like this ***/
SELECT *
FROM [dbo].Контракт
GO

