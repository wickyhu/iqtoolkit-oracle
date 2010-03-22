
-- this is used to create dual table in sql server 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dual](
	[DUMMY] [varchar](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DUMMY] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dual]  WITH CHECK ADD CHECK  (([DUMMY]='X'))

INSERT INTO [dual] values ('X')
GO
