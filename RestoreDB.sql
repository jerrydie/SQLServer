
USE [master]
RESTORE DATABASE [Filmoteque]
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Filmoteque.bak'
	WITH NORECOVERY;  
GO 