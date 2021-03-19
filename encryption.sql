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

ALTER TABLE [dbo].[��������]
ADD [�����_���������_����] varbinary(MAX)

GO

OPEN SYMMETRIC KEY SymKey_Contract
DECRYPTION BY CERTIFICATE Certificate_Contract
GO

UPDATE [dbo].[��������]
	SET [�����_���������_����] = EncryptByKey (Key_GUID('SymKey_Contract'), [�����_���������])
	FROM [dbo].[��������];
GO


CLOSE SYMMETRIC KEY SymKey_Contract;
GO

SELECT *
FROM [dbo].��������
GO

ALTER TABLE [dbo].�������� DROP COLUMN �����_���������;
GO

SELECT *
FROM [dbo].��������
GO

CREATE VIEW Contract_open_view
WITH ENCRYPTION
AS 
	SELECT [dbo].��������.���_���������, [dbo].��������.���_����������, [dbo].��������.���_������, 
		CONVERT(nvarchar(255), DECRYPTBYKEY([dbo].��������.�����_���������_����)) As [�����_���������]
	FROM [dbo].��������

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
FROM [dbo].��������
GO

