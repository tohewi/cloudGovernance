/****** Object:  Table [Applications].[Applications]    Script Date: 6/7/2022 7:30:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Applications].[Applications](
	[SysId] [nchar](32) NOT NULL,
	[CloudId] [int] NULL,
	[ApplicationId] [nvarchar](10) NULL,
	[OnboardingId] [int] NULL,
	[RecordStatus] [nvarchar](50) NULL,	
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nchar](256) NULL,
	[Status] [nvarchar](50) NULL,
	[ApplicationType] [nvarchar](50) NOT NULL,	
	[ReleaseProcess] [nvarchar](50) NULL, 			
	[RegulatoryRequirements] [nchar](3) NULL,
	[ITApplicationOwner] [nvarchar](50) NULL,
	[BusinessOwner] [nvarchar](50) NULL,	
	[Location] [nvarchar](50) NULL,
	[Type] [nvarchar](50) NULL,
	[dateCreated] [datetime2](7) NULL,
	[dateModified] [datetime2](7) NULL
) ON [PRIMARY]
GO

ALTER TABLE [Applications].[Applications] ADD  DEFAULT (getdate()) FOR [dateCreated]
GO

ALTER TABLE [Applications].[Applications] ADD  DEFAULT (getdate()) FOR [dateModified]
GO


/****** Object:  Table [Applications].[State]    Script Date: 6/7/2022 7:07:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Applications].[State](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nchar](100) NULL,
	[Description] [nchar](256) NULL,
	[ReleaseProcess] [nvarchar](50) NULL,
	[RegulatoryRequirements] [nchar](3) NULL,
	[ITApplicationOwnerEmail] [nchar](50) NULL,
	[BusinessOwnerEmail] [nchar](50) NULL,
	[ApplicationGuid] [nchar](32) NULL,
	[ApplicationId] [nvarchar](10) NULL,
	[OnboardingId] [int] NULL,
	[RecordStatus] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[ApplicationType] [nvarchar](50) NOT NULL,
	[dateCreated] [datetime2](7) NULL,
	[dateModified] [datetime2](7) NULL
) ON [PRIMARY]
GO

ALTER TABLE [Applications].[State] ADD  DEFAULT (getdate()) FOR [dateCreated]
GO

ALTER TABLE [Applications].[State] ADD  DEFAULT (getdate()) FOR [dateModified]
GO


/****** Object:  Trigger [Applications].[trg_Applications_UpdateOnlyIfChanged]    Script Date: 6/7/2022 3:59:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create trigger [Applications].[trg_Applications_UpdateOnlyIfChanged] on [Applications].[Applications]
instead of update
AS declare  @sysid nchar(32),
			@applicationId nvarchar(10), 
			@name nvarchar(100),
			@description nvarchar(256),
			@status nvarchar(50),			
			@ITApplicationOwner nvarchar(50),
			@BusinessOwner nvarchar(50);

select @sysId = i.SysId from inserted i;
select @applicationId = i.ApplicationId from inserted i;
select @name = i.Name from inserted i;
select @description = i.Description from inserted i;
select @status = i.Status from inserted i;
select @ITApplicationOwner = i.ITApplicationOwner from inserted i;
select @BusinessOwner = i.BusinessOwner from inserted i;

update Applications set Name = @name, ApplicationId = @applicationId, Description = @description, Status = @status, ITApplicationOwner = @ITApplicationOwner, BusinessOwner = @BusinessOwner
where Applications.SysId = @sysid and (Name != @name or ApplicationId != @applicationId or Description != @description or Status != @status or ITApplicationOwner != @ITApplicationOwner or BusinessOwner != @BusinessOwner);

GO

ALTER TABLE [Applications].[Applications] ENABLE TRIGGER [trg_Applications_UpdateOnlyIfChanged]
GO


/****** Object:  Trigger [Applications].[trg_Applications_UpdateDateModified]    Script Date: 6/7/2022 3:59:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [Applications].[trg_Applications_UpdateDateModified]
ON [Applications].[Applications]
AFTER UPDATE
AS
UPDATE [Applications].Applications
SET dateModified = CURRENT_TIMESTAMP
WHERE SysId IN (SELECT DISTINCT SysId FROM inserted);
GO

ALTER TABLE [Applications].[Applications] ENABLE TRIGGER [trg_Applications_UpdateDateModified]
GO

