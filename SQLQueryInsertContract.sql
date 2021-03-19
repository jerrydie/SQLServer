CREATE TRIGGER Tr1 ON [dbo].[�����_���������] AFTER Insert AS Select 'Insert';
GO 
CREATE TRIGGER Tr2 ON [dbo].[�����_���������] AFTER UPDATE AS Select 'UPDATE'; 
GO

/** ��� ������ ���������� ��� ������� ���������� ��� ������� ������ ������ ������� �������� (���� �� ��� �� ���������� � �������) **/
CREATE SEQUENCE KS_Code	
AS	int
	START WITH 1
	INCREMENT BY 1
	CACHE  5
GO

CREATE VIEW KK_KA_and_KS_Code
AS SELECT [dbo].���������_�����.���_������ AS ���_������, 
			[dbo].����������_���������.���_���������� AS ���_����������, 
			[dbo].����������.��������  AS �����_���������
FROM [dbo].����������_��������� 
JOIN [dbo].���������_����� ON [dbo].����������_���������.���_���������� = [dbo].���������_�����.���_����������
JOIN [dbo].���������� ON [dbo].����������_���������.���_���������� = [dbo].����������.���_����������
GO

INSERT INTO [dbo].��������
SELECT �����_��������� + CAST(NEXT VALUE for KS_Code AS varchar(255)), ���_����������, ���_������
FROM KK_KA_and_KS_Code
GO