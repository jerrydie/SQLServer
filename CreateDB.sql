CREATE DATABASE Filmoteque;
GO
USE Filmoteque;
GO

CREATE TABLE [�����]
( 
	[���_������]         integer  IDENTITY(1,1),
	[���]                nvarchar(255)  NOT NULL ,
	[�����]              nvarchar(255)  NOT NULL ,
	[����_��������]      date  NOT NULL 
)
go

ALTER TABLE [�����]
	ADD CONSTRAINT [XPK�����] PRIMARY KEY  CLUSTERED ([���_������] ASC)
go

CREATE TABLE [���������]
( 
	[���_����������]     integer  IDENTITY(1,1) ,
	[��������]           nvarchar(255)  NOT NULL ,
	[���_������]         integer  NOT NULL ,
	[��������]           nvarchar(255)  NOT NULL 
)
go

ALTER TABLE [���������]
	ADD CONSTRAINT [XPK���������] PRIMARY KEY  CLUSTERED ([���_����������] ASC)
go


CREATE TABLE [����������]
( 
	[���_����������]     integer IDENTITY(1,1) ,
	[��������]           nvarchar(255)  NOT NULL ,
	[�����]              nvarchar(255)  NOT NULL 
)
go

ALTER TABLE [����������]
	ADD CONSTRAINT [XPK����������] PRIMARY KEY  CLUSTERED ([���_����������] ASC)
go

CREATE TABLE [����������_���������]
( 
	[���_����������]     integer  NOT NULL ,
	[���_����������]     integer  NOT NULL 
)
go

ALTER TABLE [����������_���������]
	ADD CONSTRAINT [XPK����������_���������] PRIMARY KEY  CLUSTERED ([���_����������] ASC,[���_����������] ASC)
go

CREATE TABLE [���������_�����]
( 
	[���_����������]     integer  NOT NULL ,
	[���_������]         integer  NOT NULL 
)
go

ALTER TABLE [���������_�����]
	ADD CONSTRAINT [XPK���������_�����] PRIMARY KEY  CLUSTERED ([���_����������] ASC,[���_������] ASC)
go

CREATE TABLE [��������]
( 
	[���_���������]      integer  IDENTITY(1,1) ,
	[�����_���������]    nvarchar(255)  NOT NULL ,
	[���_����������]     integer  NOT NULL ,
	[���_������]         integer  NOT NULL 
)
go

ALTER TABLE [��������]
	ADD CONSTRAINT [XPK��������] PRIMARY KEY  CLUSTERED ([���_���������] ASC)
go


ALTER TABLE [����������_���������]
	ADD CONSTRAINT [R_1] FOREIGN KEY ([���_����������]) REFERENCES [����������]([���_����������])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [����������_���������]
	ADD CONSTRAINT [R_2] FOREIGN KEY ([���_����������]) REFERENCES [���������]([���_����������])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [���������_�����]
	ADD CONSTRAINT [R_3] FOREIGN KEY ([���_����������]) REFERENCES [���������]([���_����������])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [���������_�����]
	ADD CONSTRAINT [R_4] FOREIGN KEY ([���_������]) REFERENCES [�����]([���_������])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [��������]
	ADD CONSTRAINT [R_5] FOREIGN KEY ([���_����������]) REFERENCES [����������]([���_����������])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [��������]
	ADD CONSTRAINT [R_6] FOREIGN KEY ([���_������]) REFERENCES [�����]([���_������])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


CREATE TRIGGER tD_����� ON ����� FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on ����� */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* �����  ���������_����� on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002fc50", PARENT_OWNER="", PARENT_TABLE="�����"
    CHILD_OWNER="", CHILD_TABLE="���������_�����"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="���_������" */
    IF EXISTS (
      SELECT * FROM deleted,���������_�����
      WHERE
        /*  %JoinFKPK(���������_�����,deleted," = "," AND") */
        ���������_�����.���_������ = deleted.���_������
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ����� because ���������_����� exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    /* �����  �������� on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="�����"
    CHILD_OWNER="", CHILD_TABLE="��������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="���_������" */
    IF EXISTS (
      SELECT * FROM deleted,��������
      WHERE
        /*  %JoinFKPK(��������,deleted," = "," AND") */
        ��������.���_������ = deleted.���_������
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ����� because �������� exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_����� ON ����� FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on ����� */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @ins���_������ integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* �����  ���������_����� on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00035f4e", PARENT_OWNER="", PARENT_TABLE="�����"
    CHILD_OWNER="", CHILD_TABLE="���������_�����"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="���_������" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(���_������)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,���������_�����
      WHERE
        /*  %JoinFKPK(���������_�����,deleted," = "," AND") */
        ���������_�����.���_������ = deleted.���_������
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ����� because ���������_����� exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  /* �����  �������� on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="�����"
    CHILD_OWNER="", CHILD_TABLE="��������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="���_������" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(���_������)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,��������
      WHERE
        /*  %JoinFKPK(��������,deleted," = "," AND") */
        ��������.���_������ = deleted.���_������
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ����� because �������� exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_���������� ON ���������� FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on ���������� */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* ����������  ����������_��������� on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00032fcf", PARENT_OWNER="", PARENT_TABLE="����������"
    CHILD_OWNER="", CHILD_TABLE="����������_���������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="���_����������" */
    IF EXISTS (
      SELECT * FROM deleted,����������_���������
      WHERE
        /*  %JoinFKPK(����������_���������,deleted," = "," AND") */
        ����������_���������.���_���������� = deleted.���_����������
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ���������� because ����������_��������� exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* ����������  �������� on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="����������"
    CHILD_OWNER="", CHILD_TABLE="��������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="���_����������" */
    IF EXISTS (
      SELECT * FROM deleted,��������
      WHERE
        /*  %JoinFKPK(��������,deleted," = "," AND") */
        ��������.���_���������� = deleted.���_����������
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ���������� because �������� exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* ����������  ����������_��������� on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="����������"
    CHILD_OWNER="", CHILD_TABLE="����������_���������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="���_����������" */
    IF EXISTS (
      SELECT * FROM deleted,����������_���������
      WHERE
        /*  %JoinFKPK(����������_���������,deleted," = "," AND") */
        ����������_���������.���_���������� = deleted.���_����������
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ���������� because ����������_��������� exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_���������� ON ���������� FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on ���������� */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @ins���_���������� integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* ����������  ����������_��������� on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00038efb", PARENT_OWNER="", PARENT_TABLE="����������"
    CHILD_OWNER="", CHILD_TABLE="����������_���������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="���_����������" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(���_����������)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,����������_���������
      WHERE
        /*  %JoinFKPK(����������_���������,deleted," = "," AND") */
        ����������_���������.���_���������� = deleted.���_����������
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ���������� because ����������_��������� exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* ����������  �������� on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="����������"
    CHILD_OWNER="", CHILD_TABLE="��������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="���_����������" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(���_����������)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,��������
      WHERE
        /*  %JoinFKPK(��������,deleted," = "," AND") */
        ��������.���_���������� = deleted.���_����������
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ���������� because �������� exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* ����������  ����������_��������� on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="����������"
    CHILD_OWNER="", CHILD_TABLE="����������_���������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="���_����������" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(���_����������)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,����������_���������
      WHERE
        /*  %JoinFKPK(����������_���������,deleted," = "," AND") */
        ����������_���������.���_���������� = deleted.���_����������
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ���������� because ����������_��������� exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_����������_��������� ON ����������_��������� FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on ����������_��������� */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* ���������  ����������_��������� on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002d719", PARENT_OWNER="", PARENT_TABLE="���������"
    CHILD_OWNER="", CHILD_TABLE="����������_���������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="���_����������" */
    IF EXISTS (SELECT * FROM deleted,���������
      WHERE
        /* %JoinFKPK(deleted,���������," = "," AND") */
        deleted.���_���������� = ���������.���_���������� AND
        NOT EXISTS (
          SELECT * FROM ����������_���������
          WHERE
            /* %JoinFKPK(����������_���������,���������," = "," AND") */
            ����������_���������.���_���������� = ���������.���_����������
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ����������_��������� because ��������� exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* ����������  ����������_��������� on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="����������"
    CHILD_OWNER="", CHILD_TABLE="����������_���������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="���_����������" */
    IF EXISTS (SELECT * FROM deleted,����������
      WHERE
        /* %JoinFKPK(deleted,����������," = "," AND") */
        deleted.���_���������� = ����������.���_���������� AND
        NOT EXISTS (
          SELECT * FROM ����������_���������
          WHERE
            /* %JoinFKPK(����������_���������,����������," = "," AND") */
            ����������_���������.���_���������� = ����������.���_����������
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ����������_��������� because ���������� exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_����������_��������� ON ����������_��������� FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on ����������_��������� */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @ins���_���������� integer, 
           @ins���_���������� integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* ���������  ����������_��������� on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002dcc4", PARENT_OWNER="", PARENT_TABLE="���������"
    CHILD_OWNER="", CHILD_TABLE="����������_���������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="���_����������" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(���_����������)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,���������
        WHERE
          /* %JoinFKPK(inserted,���������) */
          inserted.���_���������� = ���������.���_����������
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ����������_��������� because ��������� does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* ����������  ����������_��������� on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="����������"
    CHILD_OWNER="", CHILD_TABLE="����������_���������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="���_����������" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(���_����������)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,����������
        WHERE
          /* %JoinFKPK(inserted,����������) */
          inserted.���_���������� = ����������.���_����������
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ����������_��������� because ���������� does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go



CREATE TRIGGER tD_��������� ON ��������� FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on ��������� */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* ���������  ���������_����� on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000451cc", PARENT_OWNER="", PARENT_TABLE="���������"
    CHILD_OWNER="", CHILD_TABLE="���������_�����"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="���_����������" */
    IF EXISTS (
      SELECT * FROM deleted,���������_�����
      WHERE
        /*  %JoinFKPK(���������_�����,deleted," = "," AND") */
        ���������_�����.���_���������� = deleted.���_����������
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ��������� because ���������_����� exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* ���������  ����������_��������� on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="���������"
    CHILD_OWNER="", CHILD_TABLE="����������_���������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="���_����������" */
    IF EXISTS (
      SELECT * FROM deleted,����������_���������
      WHERE
        /*  %JoinFKPK(����������_���������,deleted," = "," AND") */
        ����������_���������.���_���������� = deleted.���_����������
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ��������� because ����������_��������� exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_��������� ON ��������� FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on ��������� */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @ins���_���������� integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* ���������  ���������_����� on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0004c958", PARENT_OWNER="", PARENT_TABLE="���������"
    CHILD_OWNER="", CHILD_TABLE="���������_�����"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="���_����������" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(���_����������)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,���������_�����
      WHERE
        /*  %JoinFKPK(���������_�����,deleted," = "," AND") */
        ���������_�����.���_���������� = deleted.���_����������
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ��������� because ���������_����� exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* ���������  ����������_��������� on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="���������"
    CHILD_OWNER="", CHILD_TABLE="����������_���������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="���_����������" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(���_����������)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,����������_���������
      WHERE
        /*  %JoinFKPK(����������_���������,deleted," = "," AND") */
        ����������_���������.���_���������� = deleted.���_����������
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ��������� because ����������_��������� exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  /* ���������  ����������_��������� on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="���������"
    CHILD_OWNER="", CHILD_TABLE="����������_���������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="���_����������" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(���_����������)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,����������_���������
      WHERE
        /*  %JoinFKPK(����������_���������,deleted," = "," AND") */
        ����������_���������.���_���������� = deleted.���_����������
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ��������� because ����������_��������� exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_���������_����� ON ���������_����� FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on ���������_����� */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

    /* erwin Builtin Trigger */
    /* ���������  ���������_����� on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="���������"
    CHILD_OWNER="", CHILD_TABLE="���������_�����"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="���_����������" */
    IF EXISTS (SELECT * FROM deleted,���������
      WHERE
        /* %JoinFKPK(deleted,���������," = "," AND") */
        deleted.���_���������� = ���������.���_���������� AND
        NOT EXISTS (
          SELECT * FROM ���������_�����
          WHERE
            /* %JoinFKPK(���������_�����,���������," = "," AND") */
            ���������_�����.���_���������� = ���������.���_����������
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ���������_����� because ��������� exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_���������_����� ON ���������_����� FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on ���������_����� */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @ins���_���������� integer, 
           @ins���_������ integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* �����  ���������_����� on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002c9d1", PARENT_OWNER="", PARENT_TABLE="�����"
    CHILD_OWNER="", CHILD_TABLE="���������_�����"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="���_������" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(���_������)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,�����
        WHERE
          /* %JoinFKPK(inserted,�����) */
          inserted.���_������ = �����.���_������
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ���������_����� because ����� does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* ���������  ���������_����� on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="���������"
    CHILD_OWNER="", CHILD_TABLE="���������_�����"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="���_����������" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(���_����������)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,���������
        WHERE
          /* %JoinFKPK(inserted,���������) */
          inserted.���_���������� = ���������.���_����������
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ���������_����� because ��������� does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go



CREATE TRIGGER tU_�������� ON �������� FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on �������� */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @ins���_��������� integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* �����  �������� on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002b529", PARENT_OWNER="", PARENT_TABLE="�����"
    CHILD_OWNER="", CHILD_TABLE="��������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="���_������" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(���_������)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,�����
        WHERE
          /* %JoinFKPK(inserted,�����) */
          inserted.���_������ = �����.���_������
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update �������� because ����� does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* ����������  �������� on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="����������"
    CHILD_OWNER="", CHILD_TABLE="��������"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="���_����������" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(���_����������)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,����������
        WHERE
          /* %JoinFKPK(inserted,����������) */
          inserted.���_���������� = ����������.���_����������
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update �������� because ���������� does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


