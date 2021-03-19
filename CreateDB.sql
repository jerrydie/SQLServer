CREATE DATABASE Filmoteque;
GO
USE Filmoteque;
GO

CREATE TABLE [Актер]
( 
	[Код_актера]         integer  IDENTITY(1,1),
	[ФИО]                nvarchar(255)  NOT NULL ,
	[Город]              nvarchar(255)  NOT NULL ,
	[Дата_рождения]      date  NOT NULL 
)
go

ALTER TABLE [Актер]
	ADD CONSTRAINT [XPKАктер] PRIMARY KEY  CLUSTERED ([Код_актера] ASC)
go

CREATE TABLE [Кинофильм]
( 
	[Код_кинофильма]     integer  IDENTITY(1,1) ,
	[Название]           nvarchar(255)  NOT NULL ,
	[Год_выхода]         integer  NOT NULL ,
	[Тематика]           nvarchar(255)  NOT NULL 
)
go

ALTER TABLE [Кинофильм]
	ADD CONSTRAINT [XPKКинофильм] PRIMARY KEY  CLUSTERED ([Код_кинофильма] ASC)
go


CREATE TABLE [Киностудия]
( 
	[Код_киностудии]     integer IDENTITY(1,1) ,
	[Название]           nvarchar(255)  NOT NULL ,
	[Город]              nvarchar(255)  NOT NULL 
)
go

ALTER TABLE [Киностудия]
	ADD CONSTRAINT [XPKКиностудия] PRIMARY KEY  CLUSTERED ([Код_киностудии] ASC)
go

CREATE TABLE [Киностудия_Кинофильм]
( 
	[Код_киностудии]     integer  NOT NULL ,
	[Код_кинофильма]     integer  NOT NULL 
)
go

ALTER TABLE [Киностудия_Кинофильм]
	ADD CONSTRAINT [XPKКиностудия_Кинофильм] PRIMARY KEY  CLUSTERED ([Код_кинофильма] ASC,[Код_киностудии] ASC)
go

CREATE TABLE [Кинофильм_Актер]
( 
	[Код_кинофильма]     integer  NOT NULL ,
	[Код_актера]         integer  NOT NULL 
)
go

ALTER TABLE [Кинофильм_Актер]
	ADD CONSTRAINT [XPKКинофильм_Актер] PRIMARY KEY  CLUSTERED ([Код_кинофильма] ASC,[Код_актера] ASC)
go

CREATE TABLE [Контракт]
( 
	[Код_контракта]      integer  IDENTITY(1,1) ,
	[Номер_контракта]    nvarchar(255)  NOT NULL ,
	[Код_киностудии]     integer  NOT NULL ,
	[Код_актера]         integer  NOT NULL 
)
go

ALTER TABLE [Контракт]
	ADD CONSTRAINT [XPKКонтракт] PRIMARY KEY  CLUSTERED ([Код_контракта] ASC)
go


ALTER TABLE [Киностудия_Кинофильм]
	ADD CONSTRAINT [R_1] FOREIGN KEY ([Код_киностудии]) REFERENCES [Киностудия]([Код_киностудии])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Киностудия_Кинофильм]
	ADD CONSTRAINT [R_2] FOREIGN KEY ([Код_кинофильма]) REFERENCES [Кинофильм]([Код_кинофильма])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Кинофильм_Актер]
	ADD CONSTRAINT [R_3] FOREIGN KEY ([Код_кинофильма]) REFERENCES [Кинофильм]([Код_кинофильма])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Кинофильм_Актер]
	ADD CONSTRAINT [R_4] FOREIGN KEY ([Код_актера]) REFERENCES [Актер]([Код_актера])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Контракт]
	ADD CONSTRAINT [R_5] FOREIGN KEY ([Код_киностудии]) REFERENCES [Киностудия]([Код_киностудии])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Контракт]
	ADD CONSTRAINT [R_6] FOREIGN KEY ([Код_актера]) REFERENCES [Актер]([Код_актера])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


CREATE TRIGGER tD_Актер ON Актер FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Актер */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Актер  Кинофильм_Актер on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002fc50", PARENT_OWNER="", PARENT_TABLE="Актер"
    CHILD_OWNER="", CHILD_TABLE="Кинофильм_Актер"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="Код_актера" */
    IF EXISTS (
      SELECT * FROM deleted,Кинофильм_Актер
      WHERE
        /*  %JoinFKPK(Кинофильм_Актер,deleted," = "," AND") */
        Кинофильм_Актер.Код_актера = deleted.Код_актера
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Актер because Кинофильм_Актер exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    /* Актер  Контракт on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Актер"
    CHILD_OWNER="", CHILD_TABLE="Контракт"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Код_актера" */
    IF EXISTS (
      SELECT * FROM deleted,Контракт
      WHERE
        /*  %JoinFKPK(Контракт,deleted," = "," AND") */
        Контракт.Код_актера = deleted.Код_актера
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Актер because Контракт exists.'
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


CREATE TRIGGER tU_Актер ON Актер FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Актер */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insКод_актера integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Актер  Кинофильм_Актер on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00035f4e", PARENT_OWNER="", PARENT_TABLE="Актер"
    CHILD_OWNER="", CHILD_TABLE="Кинофильм_Актер"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="Код_актера" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Код_актера)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Кинофильм_Актер
      WHERE
        /*  %JoinFKPK(Кинофильм_Актер,deleted," = "," AND") */
        Кинофильм_Актер.Код_актера = deleted.Код_актера
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Актер because Кинофильм_Актер exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  /* Актер  Контракт on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Актер"
    CHILD_OWNER="", CHILD_TABLE="Контракт"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Код_актера" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Код_актера)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Контракт
      WHERE
        /*  %JoinFKPK(Контракт,deleted," = "," AND") */
        Контракт.Код_актера = deleted.Код_актера
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Актер because Контракт exists.'
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




CREATE TRIGGER tD_Киностудия ON Киностудия FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Киностудия */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Киностудия  Киностудия_Кинофильм on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00032fcf", PARENT_OWNER="", PARENT_TABLE="Киностудия"
    CHILD_OWNER="", CHILD_TABLE="Киностудия_Кинофильм"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="Код_киностудии" */
    IF EXISTS (
      SELECT * FROM deleted,Киностудия_Кинофильм
      WHERE
        /*  %JoinFKPK(Киностудия_Кинофильм,deleted," = "," AND") */
        Киностудия_Кинофильм.Код_киностудии = deleted.Код_киностудии
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Киностудия because Киностудия_Кинофильм exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Киностудия  Контракт on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Киностудия"
    CHILD_OWNER="", CHILD_TABLE="Контракт"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Код_киностудии" */
    IF EXISTS (
      SELECT * FROM deleted,Контракт
      WHERE
        /*  %JoinFKPK(Контракт,deleted," = "," AND") */
        Контракт.Код_киностудии = deleted.Код_киностудии
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Киностудия because Контракт exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Киностудия  Киностудия_Кинофильм on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Киностудия"
    CHILD_OWNER="", CHILD_TABLE="Киностудия_Кинофильм"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="Код_киностудии" */
    IF EXISTS (
      SELECT * FROM deleted,Киностудия_Кинофильм
      WHERE
        /*  %JoinFKPK(Киностудия_Кинофильм,deleted," = "," AND") */
        Киностудия_Кинофильм.Код_киностудии = deleted.Код_киностудии
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Киностудия because Киностудия_Кинофильм exists.'
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


CREATE TRIGGER tU_Киностудия ON Киностудия FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Киностудия */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insКод_киностудии integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Киностудия  Киностудия_Кинофильм on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00038efb", PARENT_OWNER="", PARENT_TABLE="Киностудия"
    CHILD_OWNER="", CHILD_TABLE="Киностудия_Кинофильм"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="Код_киностудии" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Код_киностудии)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Киностудия_Кинофильм
      WHERE
        /*  %JoinFKPK(Киностудия_Кинофильм,deleted," = "," AND") */
        Киностудия_Кинофильм.Код_киностудии = deleted.Код_киностудии
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Киностудия because Киностудия_Кинофильм exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Киностудия  Контракт on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Киностудия"
    CHILD_OWNER="", CHILD_TABLE="Контракт"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Код_киностудии" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Код_киностудии)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Контракт
      WHERE
        /*  %JoinFKPK(Контракт,deleted," = "," AND") */
        Контракт.Код_киностудии = deleted.Код_киностудии
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Киностудия because Контракт exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Киностудия  Киностудия_Кинофильм on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Киностудия"
    CHILD_OWNER="", CHILD_TABLE="Киностудия_Кинофильм"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="Код_киностудии" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Код_киностудии)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Киностудия_Кинофильм
      WHERE
        /*  %JoinFKPK(Киностудия_Кинофильм,deleted," = "," AND") */
        Киностудия_Кинофильм.Код_киностудии = deleted.Код_киностудии
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Киностудия because Киностудия_Кинофильм exists.'
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




CREATE TRIGGER tD_Киностудия_Кинофильм ON Киностудия_Кинофильм FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Киностудия_Кинофильм */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Кинофильм  Киностудия_Кинофильм on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002d719", PARENT_OWNER="", PARENT_TABLE="Кинофильм"
    CHILD_OWNER="", CHILD_TABLE="Киностудия_Кинофильм"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Код_кинофильма" */
    IF EXISTS (SELECT * FROM deleted,Кинофильм
      WHERE
        /* %JoinFKPK(deleted,Кинофильм," = "," AND") */
        deleted.Код_кинофильма = Кинофильм.Код_кинофильма AND
        NOT EXISTS (
          SELECT * FROM Киностудия_Кинофильм
          WHERE
            /* %JoinFKPK(Киностудия_Кинофильм,Кинофильм," = "," AND") */
            Киностудия_Кинофильм.Код_кинофильма = Кинофильм.Код_кинофильма
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Киностудия_Кинофильм because Кинофильм exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Киностудия  Киностудия_Кинофильм on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Киностудия"
    CHILD_OWNER="", CHILD_TABLE="Киностудия_Кинофильм"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="Код_киностудии" */
    IF EXISTS (SELECT * FROM deleted,Киностудия
      WHERE
        /* %JoinFKPK(deleted,Киностудия," = "," AND") */
        deleted.Код_киностудии = Киностудия.Код_киностудии AND
        NOT EXISTS (
          SELECT * FROM Киностудия_Кинофильм
          WHERE
            /* %JoinFKPK(Киностудия_Кинофильм,Киностудия," = "," AND") */
            Киностудия_Кинофильм.Код_киностудии = Киностудия.Код_киностудии
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Киностудия_Кинофильм because Киностудия exists.'
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


CREATE TRIGGER tU_Киностудия_Кинофильм ON Киностудия_Кинофильм FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Киностудия_Кинофильм */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insКод_киностудии integer, 
           @insКод_кинофильма integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Кинофильм  Киностудия_Кинофильм on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002dcc4", PARENT_OWNER="", PARENT_TABLE="Кинофильм"
    CHILD_OWNER="", CHILD_TABLE="Киностудия_Кинофильм"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Код_кинофильма" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Код_кинофильма)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Кинофильм
        WHERE
          /* %JoinFKPK(inserted,Кинофильм) */
          inserted.Код_кинофильма = Кинофильм.Код_кинофильма
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Киностудия_Кинофильм because Кинофильм does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Киностудия  Киностудия_Кинофильм on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Киностудия"
    CHILD_OWNER="", CHILD_TABLE="Киностудия_Кинофильм"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="Код_киностудии" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Код_киностудии)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Киностудия
        WHERE
          /* %JoinFKPK(inserted,Киностудия) */
          inserted.Код_киностудии = Киностудия.Код_киностудии
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Киностудия_Кинофильм because Киностудия does not exist.'
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



CREATE TRIGGER tD_Кинофильм ON Кинофильм FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Кинофильм */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Кинофильм  Кинофильм_Актер on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000451cc", PARENT_OWNER="", PARENT_TABLE="Кинофильм"
    CHILD_OWNER="", CHILD_TABLE="Кинофильм_Актер"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Код_кинофильма" */
    IF EXISTS (
      SELECT * FROM deleted,Кинофильм_Актер
      WHERE
        /*  %JoinFKPK(Кинофильм_Актер,deleted," = "," AND") */
        Кинофильм_Актер.Код_кинофильма = deleted.Код_кинофильма
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Кинофильм because Кинофильм_Актер exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Кинофильм  Киностудия_Кинофильм on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Кинофильм"
    CHILD_OWNER="", CHILD_TABLE="Киностудия_Кинофильм"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="Код_кинофильма" */
    IF EXISTS (
      SELECT * FROM deleted,Киностудия_Кинофильм
      WHERE
        /*  %JoinFKPK(Киностудия_Кинофильм,deleted," = "," AND") */
        Киностудия_Кинофильм.Код_кинофильма = deleted.Код_кинофильма
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Кинофильм because Киностудия_Кинофильм exists.'
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


CREATE TRIGGER tU_Кинофильм ON Кинофильм FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Кинофильм */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insКод_кинофильма integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Кинофильм  Кинофильм_Актер on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0004c958", PARENT_OWNER="", PARENT_TABLE="Кинофильм"
    CHILD_OWNER="", CHILD_TABLE="Кинофильм_Актер"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Код_кинофильма" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Код_кинофильма)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Кинофильм_Актер
      WHERE
        /*  %JoinFKPK(Кинофильм_Актер,deleted," = "," AND") */
        Кинофильм_Актер.Код_кинофильма = deleted.Код_кинофильма
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Кинофильм because Кинофильм_Актер exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Кинофильм  Киностудия_Кинофильм on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Кинофильм"
    CHILD_OWNER="", CHILD_TABLE="Киностудия_Кинофильм"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="Код_кинофильма" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Код_кинофильма)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Киностудия_Кинофильм
      WHERE
        /*  %JoinFKPK(Киностудия_Кинофильм,deleted," = "," AND") */
        Киностудия_Кинофильм.Код_кинофильма = deleted.Код_кинофильма
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Кинофильм because Киностудия_Кинофильм exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  /* Кинофильм  Киностудия_Кинофильм on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Кинофильм"
    CHILD_OWNER="", CHILD_TABLE="Киностудия_Кинофильм"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Код_кинофильма" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Код_кинофильма)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Киностудия_Кинофильм
      WHERE
        /*  %JoinFKPK(Киностудия_Кинофильм,deleted," = "," AND") */
        Киностудия_Кинофильм.Код_кинофильма = deleted.Код_кинофильма
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Кинофильм because Киностудия_Кинофильм exists.'
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




CREATE TRIGGER tD_Кинофильм_Актер ON Кинофильм_Актер FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Кинофильм_Актер */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

    /* erwin Builtin Trigger */
    /* Кинофильм  Кинофильм_Актер on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Кинофильм"
    CHILD_OWNER="", CHILD_TABLE="Кинофильм_Актер"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Код_кинофильма" */
    IF EXISTS (SELECT * FROM deleted,Кинофильм
      WHERE
        /* %JoinFKPK(deleted,Кинофильм," = "," AND") */
        deleted.Код_кинофильма = Кинофильм.Код_кинофильма AND
        NOT EXISTS (
          SELECT * FROM Кинофильм_Актер
          WHERE
            /* %JoinFKPK(Кинофильм_Актер,Кинофильм," = "," AND") */
            Кинофильм_Актер.Код_кинофильма = Кинофильм.Код_кинофильма
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Кинофильм_Актер because Кинофильм exists.'
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


CREATE TRIGGER tU_Кинофильм_Актер ON Кинофильм_Актер FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Кинофильм_Актер */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insКод_кинофильма integer, 
           @insКод_актера integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Актер  Кинофильм_Актер on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002c9d1", PARENT_OWNER="", PARENT_TABLE="Актер"
    CHILD_OWNER="", CHILD_TABLE="Кинофильм_Актер"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="Код_актера" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Код_актера)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Актер
        WHERE
          /* %JoinFKPK(inserted,Актер) */
          inserted.Код_актера = Актер.Код_актера
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Кинофильм_Актер because Актер does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Кинофильм  Кинофильм_Актер on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Кинофильм"
    CHILD_OWNER="", CHILD_TABLE="Кинофильм_Актер"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Код_кинофильма" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Код_кинофильма)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Кинофильм
        WHERE
          /* %JoinFKPK(inserted,Кинофильм) */
          inserted.Код_кинофильма = Кинофильм.Код_кинофильма
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Кинофильм_Актер because Кинофильм does not exist.'
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



CREATE TRIGGER tU_Контракт ON Контракт FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Контракт */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insКод_контракта integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Актер  Контракт on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002b529", PARENT_OWNER="", PARENT_TABLE="Актер"
    CHILD_OWNER="", CHILD_TABLE="Контракт"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Код_актера" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Код_актера)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Актер
        WHERE
          /* %JoinFKPK(inserted,Актер) */
          inserted.Код_актера = Актер.Код_актера
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Контракт because Актер does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Киностудия  Контракт on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Киностудия"
    CHILD_OWNER="", CHILD_TABLE="Контракт"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Код_киностудии" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Код_киностудии)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Киностудия
        WHERE
          /* %JoinFKPK(inserted,Киностудия) */
          inserted.Код_киностудии = Киностудия.Код_киностудии
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Контракт because Киностудия does not exist.'
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


