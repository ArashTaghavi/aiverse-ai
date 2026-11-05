/****** Object:  Sequence [dbo].[Sequence-DocumentNo]    Script Date: 11/5/2026 11:38:07 AM ******/
CREATE SEQUENCE [dbo].[Sequence-DocumentNo]
 AS [bigint]
 START WITH 10000
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE
GO

/****** Object:  Sequence [dbo].[Sequence-RequestNo]    Script Date: 11/5/2026 11:38:07 AM ******/
CREATE SEQUENCE [dbo].[Sequence-RequestNo]
 AS [int]
 START WITH 10000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE
GO
/****** Object:  Table [dbo].[address_groups]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[address_groups](
	[id] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[is_real] [bit] NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
 CONSTRAINT [PK_address_groups] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[address_kinds]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[address_kinds](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NULL,
	[address_group_id] [tinyint] NULL,
	[is_home] [bit] NOT NULL,
	[is_social_media] [bit] NOT NULL,
	[is_email] [bit] NOT NULL,
	[is_telegram] [bit] NOT NULL,
	[is_whatsapp] [bit] NOT NULL,
	[is_twitter] [bit] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_address_kinds] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[application_exceptions]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_exceptions](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[ip_address] [varchar](50) NOT NULL,
	[message] [nvarchar](max) NOT NULL,
	[trace] [nvarchar](max) NOT NULL,
	[code] [varchar](50) NOT NULL,
	[created_at] [datetime] NULL,
 CONSTRAINT [PK_application_exceptions] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[application_routes]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_routes](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[guid] [char](36) NOT NULL,
	[name] [nvarchar](500) NOT NULL,
	[uri_prefix] [nvarchar](500) NULL,
	[uri] [nvarchar](500) NOT NULL,
	[methods] [nvarchar](500) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_application_routes] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[attachment_types]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[attachment_types](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_attachment_types] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[audits]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[audits](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_type] [nvarchar](255) NULL,
	[user_id] [bigint] NULL,
	[event] [nvarchar](255) NOT NULL,
	[auditable_type] [nvarchar](255) NOT NULL,
	[auditable_id] [bigint] NOT NULL,
	[old_values] [nvarchar](max) NULL,
	[new_values] [nvarchar](max) NULL,
	[url] [nvarchar](max) NULL,
	[ip_address] [nvarchar](45) NULL,
	[user_agent] [nvarchar](1023) NULL,
	[tags] [nvarchar](255) NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cities]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cities](
	[id] [smallint] IDENTITY(6701,1) NOT NULL,
	[province_id] [smallint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[is_capital] [int] NOT NULL,
	[is_central] [int] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_cities] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[configurations]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[configurations](
	[id] [tinyint] NOT NULL,
	[title] [nvarchar](100) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[value] [nvarchar](max) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expires_at] [datetime] NULL,
 CONSTRAINT [PK_configf] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[continents]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[continents](
	[id] [tinyint] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_continents] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[countries]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[countries](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[continent_id] [tinyint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[is_home_country] [bit] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_countries] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[department_types]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[department_types](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[supervisor_grade_id] [smallint] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_department_types] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[departments]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[departments](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[department_number] [nvarchar](50) NOT NULL,
	[parent_id] [int] NULL,
	[left_id] [int] NULL,
	[right_id] [int] NULL,
	[department_type_id] [smallint] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_departments] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_addresses]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_addresses](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[document_id] [int] NOT NULL,
	[address_kind_id] [smallint] NOT NULL,
	[city_id] [smallint] NULL,
	[postal_code] [nvarchar](10) NULL,
	[address] [nvarchar](1000) NULL,
	[description] [nvarchar](1000) NULL,
	[document_phone_id] [int] NULL,
	[geo_longitude] [decimal](18, 14) NULL,
	[geo_latitude] [decimal](18, 14) NULL,
	[creator_profile_id] [smallint] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_document_addresses] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_attachments]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_attachments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[document_id] [int] NOT NULL,
	[creator_profile_id] [int] NOT NULL,
	[attachment_type_id] [smallint] NULL,
	[file_path] [nvarchar](max) NOT NULL,
	[description] [nvarchar](200) NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_document_attachments] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_images]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_images](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[document_id] [int] NOT NULL,
	[image_kind_id] [smallint] NULL,
	[image_data] [nvarchar](max) NOT NULL,
	[description] [nvarchar](200) NULL,
	[creator_profile_id] [int] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_document_images] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_import_failures]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_import_failures](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[document_import_id] [int] NOT NULL,
	[row_index] [bigint] NULL,
	[national_code] [char](10) NULL,
	[first_name] [nvarchar](200) NULL,
	[last_name] [nvarchar](200) NULL,
	[birth_date] [datetime] NULL,
	[gender_name] [nvarchar](50) NULL,
	[gender_id] [tinyint] NULL,
	[issue_no] [int] NULL,
	[father_name] [nvarchar](200) NULL,
	[mother_name] [nvarchar](200) NULL,
	[birth_place_name] [nvarchar](200) NULL,
	[birth_place_id] [smallint] NULL,
	[issue_place_name] [nvarchar](200) NULL,
	[issue_place_id] [smallint] NULL,
	[document_title] [nvarchar](500) NULL,
	[documentary_no] [int] NULL,
	[document_subject_name_01] [nvarchar](200) NULL,
	[document_subject_id_01] [smallint] NULL,
	[document_subject_name_02] [nvarchar](200) NULL,
	[document_subject_id_02] [smallint] NULL,
	[document_subject_name_03] [nvarchar](200) NULL,
	[document_subject_id_03] [smallint] NULL,
	[mobile_phone_01] [varchar](15) NULL,
	[mobile_phone_02] [varchar](15) NULL,
	[fixed_phone_01] [varchar](15) NULL,
	[fixed_phone_02] [varchar](15) NULL,
	[email] [nvarchar](100) NULL,
	[telegram_id] [nvarchar](100) NULL,
	[whatsapp_id] [nvarchar](100) NULL,
	[twitter_id] [nvarchar](100) NULL,
	[postal_code] [char](10) NULL,
	[address] [nvarchar](500) NULL,
	[address_city_name] [nvarchar](100) NULL,
	[address_city_id] [smallint] NULL,
	[validation_errors] [nvarchar](max) NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
 CONSTRAINT [PK_document_import_failures] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_imports]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_imports](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[guid] [char](36) NOT NULL,
	[creator_profile_id] [smallint] NOT NULL,
	[profile_id] [smallint] NOT NULL,
	[file_name] [nvarchar](300) NOT NULL,
	[file_size] [int] NOT NULL,
	[file_mime_type] [nvarchar](200) NOT NULL,
	[imported_file_data] [nvarchar](max) NOT NULL,
	[total_records_count] [int] NOT NULL,
	[failed_records_count] [int] NOT NULL,
	[skipped_records_count] [int] NOT NULL,
	[closed_at] [datetime] NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
 CONSTRAINT [PK_document_imports] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_ownerships]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_ownerships](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[document_id] [int] NOT NULL,
	[profile_id] [smallint] NOT NULL,
	[assignee_id] [smallint] NULL,
	[is_current] [bit] NOT NULL,
	[is_creator] [bit] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_document_ownerships] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_phones]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_phones](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[document_id] [int] NOT NULL,
	[phone_number] [nvarchar](50) NOT NULL,
	[phone_kind_id] [int] NULL,
	[description] [nvarchar](500) NULL,
	[creator_profile_id] [smallint] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_document_phones] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_reject_reasons]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_reject_reasons](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[order_no] [int] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_document_rejects] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_state_flows]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_state_flows](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[document_id] [int] NOT NULL,
	[document_state_id] [tinyint] NOT NULL,
	[document_reject_reason_id] [smallint] NULL,
	[profile_id] [smallint] NOT NULL,
	[is_current] [bit] NOT NULL,
	[is_system_flow] [bit] NOT NULL,
	[description] [nvarchar](1000) NULL,
	[seen_at] [datetime] NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_document_state_flow] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_states]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_states](
	[id] [tinyint] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[action_name] [nvarchar](100) NULL,
	[is_first] [bit] NOT NULL,
	[is_pending] [bit] NOT NULL,
	[is_archived] [bit] NOT NULL,
	[is_draft] [bit] NOT NULL,
	[is_rejected] [bit] NOT NULL,
	[is_approved] [bit] NOT NULL,
	[is_visible] [bit] NOT NULL,
	[is_selectable] [bit] NOT NULL,
	[is_searchable] [bit] NOT NULL,
	[permission_id] [tinyint] NULL,
	[order_no] [int] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expires_at] [datetime] NULL,
 CONSTRAINT [PK_document_states] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_subject]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_subject](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[document_id] [int] NOT NULL,
	[subject_id] [smallint] NOT NULL,
	[creator_profile_id] [smallint] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_document_subject_1] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_summaries]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_summaries](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[document_id] [int] NOT NULL,
	[description] [nvarchar](3000) NOT NULL,
	[creator_profile_id] [smallint] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_document_summaries] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[document_vehicles]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_vehicles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[document_id] [int] NOT NULL,
	[creator_profile_id] [smallint] NULL,
	[vehicle_color_id] [smallint] NULL,
	[vehicle_plate_type_id] [smallint] NULL,
	[vehicle_plate_row_id] [smallint] NULL,
	[vehicle_model_id] [smallint] NULL,
	[vin_no] [varchar](20) NULL,
	[plate_left_no] [char](2) NOT NULL,
	[plate_right_no] [char](3) NOT NULL,
	[plate_iran_no] [char](2) NOT NULL,
	[description] [nvarchar](1000) NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_vehicles] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[documents]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[documents](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[guid] [char](36) NULL,
	[is_public] [bit] NOT NULL,
	[is_imported] [bit] NOT NULL,
	[document_import_id] [int] NULL,
	[document_no] [int] NOT NULL,
	[documentary_no] [nvarchar](10) NULL,
	[document_title] [nvarchar](200) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_documents] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[failed_jobs]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[failed_jobs](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[uuid] [nvarchar](255) NOT NULL,
	[connection] [nvarchar](max) NOT NULL,
	[queue] [nvarchar](max) NOT NULL,
	[payload] [nvarchar](max) NOT NULL,
	[exception] [nvarchar](max) NOT NULL,
	[failed_at] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[genders]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[genders](
	[id] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[expired_at] [datetime] NULL,
	[placeholder_image] [nvarchar](255) NULL,
 CONSTRAINT [PK_genders] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[grades]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[grades](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_grades] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[helps]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[helps](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[help_name] [varchar](50) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](500) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NULL,
 CONSTRAINT [PK_helps] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[image_kinds]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[image_kinds](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_image_kinds] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[migrations]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[migrations](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[migration] [nvarchar](255) NOT NULL,
	[batch] [int] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[people]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[people](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[document_id] [int] NOT NULL,
	[gender_id] [tinyint] NULL,
	[birth_place_id] [smallint] NULL,
	[issue_place_id] [smallint] NULL,
	[first_name] [nvarchar](100) NULL,
	[last_name] [nvarchar](100) NULL,
	[alias] [nvarchar](50) NULL,
	[esm] [nvarchar](60) NULL,
	[national_code] [char](10) NULL,
	[issue_no] [nvarchar](50) NULL,
	[father_name] [nvarchar](100) NULL,
	[mother_name] [nvarchar](100) NULL,
	[birth_date] [datetime] NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
 CONSTRAINT [PK_people] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[permission_role]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permission_role](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[role_id] [smallint] NOT NULL,
	[permission_id] [tinyint] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_permission_role] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[permission_sets]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permission_sets](
	[id] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_permission_sets] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[permission_user]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permission_user](
	[id] [int] NOT NULL,
	[user_id] [smallint] NOT NULL,
	[permission_id] [tinyint] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_permission_user] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[permissions]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permissions](
	[id] [tinyint] IDENTITY(1,1) NOT NULL,
	[permission_set_id] [tinyint] NULL,
	[name] [varchar](100) NOT NULL,
	[description] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_permissions] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[phone_kinds]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[phone_kinds](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[is_phone_number] [bit] NOT NULL,
	[is_mobile] [bit] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_phone_kinds] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[phone_numbers]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[phone_numbers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](50) NULL,
	[name] [nvarchar](40) NOT NULL,
	[phone_number] [nvarchar](100) NOT NULL,
	[description] [nvarchar](500) NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[phone_type_id] [smallint] NULL,
	[c1] [char](1) NULL,
	[c2] [char](1) NULL,
	[c3] [char](1) NULL,
	[c4] [char](1) NULL,
	[c5] [char](1) NULL,
	[c6] [char](1) NULL,
	[c7] [char](1) NULL,
	[c8] [char](1) NULL,
	[c9] [char](1) NULL,
	[c10] [char](1) NULL,
	[c11] [char](1) NULL,
	[document_id] [int] NULL,
	[is_mobile] [bit] NULL,
	[parent_id] [int] NULL,
	[contact_document_id] [int] NULL,
	[phone_is_mobile] [bit] NULL,
 CONSTRAINT [PK_phone_numbers] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[phone_types]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[phone_types](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_phone_types] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[profiles]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[profiles](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[parent_id] [smallint] NULL,
	[user_id] [smallint] NOT NULL,
	[department_id] [smallint] NOT NULL,
	[grade_id] [smallint] NOT NULL,
	[is_enable] [bit] NOT NULL,
	[is_current] [bit] NOT NULL,
	[description] [nvarchar](200) NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_profiles] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provinces]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provinces](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[name] [nvarchar](200) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_provinces] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[request_reasons]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[request_reasons](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_request_reasons] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[request_reject_reasons]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[request_reject_reasons](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_request_reject_reasons] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[request_state_flows]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[request_state_flows](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[request_id] [int] NOT NULL,
	[profile_id] [smallint] NOT NULL,
	[request_state_id] [int] NOT NULL,
	[request_reject_reason_id] [smallint] NULL,
	[description] [nvarchar](500) NULL,
	[is_first] [bit] NOT NULL,
	[is_current] [bit] NOT NULL,
	[seen_at] [datetime] NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_requesr_state_flows] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[request_states]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[request_states](
	[id] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[action_name] [nvarchar](100) NULL,
	[is_first] [bit] NOT NULL,
	[is_pending] [bit] NOT NULL,
	[is_approved] [bit] NOT NULL,
	[is_rejected] [bit] NOT NULL,
	[is_selectable] [bit] NOT NULL,
	[permission_id] [tinyint] NULL,
	[order_no] [int] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_request_states] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[requests]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[requests](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[document_id] [int] NOT NULL,
	[profile_id] [smallint] NOT NULL,
	[request_reason_id] [smallint] NOT NULL,
	[request_no] [int] NOT NULL,
	[description] [nvarchar](1000) NULL,
	[started_at] [datetime] NULL,
	[finished_at] [datetime] NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_requests] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[role_user]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[role_user](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [smallint] NOT NULL,
	[role_id] [smallint] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
 CONSTRAINT [PK_role_user] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[roles]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[roles](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_roles] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sela_action_logs]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sela_action_logs](
	[id] [char](36) NOT NULL,
	[process_tag] [varchar](50) NOT NULL,
	[parent_proc] [varchar](50) NULL,
	[user_name] [nvarchar](50) NOT NULL,
	[file_name] [varchar](60) NULL,
	[timestamp] [varchar](50) NOT NULL,
 CONSTRAINT [sela_action_logs_id_primary] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sela_detail_logs]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sela_detail_logs](
	[id] [char](36) NOT NULL,
	[actionlog_id] [char](36) NOT NULL,
	[data_tag] [nvarchar](30) NOT NULL,
	[log_mime] [bit] NOT NULL,
	[value] [nvarchar](max) NOT NULL,
	[file_name] [varchar](60) NULL,
	[timestamp] [varchar](50) NOT NULL,
 CONSTRAINT [sela_detail_logs_id_primary] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sela_mime_logs]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sela_mime_logs](
	[id] [char](36) NOT NULL,
	[actionlog_id] [char](36) NOT NULL,
	[data_tag] [nvarchar](30) NOT NULL,
	[value] [nvarchar](max) NOT NULL,
	[mime] [nvarchar](100) NOT NULL,
	[file_name] [varchar](60) NULL,
	[timestamp] [varchar](50) NOT NULL,
 CONSTRAINT [sela_mime_logs_id_primary] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[social_platforms]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[social_platforms](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_social_platforms] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[social_posts]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[social_posts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NULL,
	[phone_number] [varchar](15) NULL,
	[username] [nvarchar](20) NULL,
	[post_text] [nvarchar](500) NOT NULL,
	[hashtag] [nvarchar](50) NULL,
	[display_name] [nvarchar](30) NULL,
	[social_platform_id] [smallint] NOT NULL,
	[created_at] [datetime] NOT NULL,
 CONSTRAINT [PK_social_posts] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sso_attempts]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sso_attempts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [smallint] NULL,
	[state] [char](36) NOT NULL,
	[url] [nvarchar](2000) NOT NULL,
	[ip_address] [varchar](20) NOT NULL,
	[result_code] [varchar](300) NULL,
	[username] [nvarchar](50) NULL,
	[identify_code] [nvarchar](50) NULL,
	[type] [varchar](10) NOT NULL,
	[is_successful] [bit] NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[confirmed_at] [datetime] NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_sso_attemps] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[subjects]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[subjects](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
 CONSTRAINT [PK_subjects] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_agents]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_agents](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](300) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[gender_id] [tinyint] NULL,
	[username] [nvarchar](100) NOT NULL,
	[first_name] [nvarchar](100) NOT NULL,
	[last_name] [nvarchar](100) NOT NULL,
	[employment_no] [int] NULL,
	[password] [nvarchar](200) NULL,
	[privileges_code] [nvarchar](200) NULL,
	[is_active] [bit] NOT NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[two_factor_secret] [nvarchar](max) NULL,
	[two_factor_recovery_codes] [nvarchar](max) NULL,
	[two_factor_confirmed_at] [datetime] NULL,
	[password_expired_at] [datetime] NULL,
	[last_login_at] [datetime] NULL,
	[last_access_at] [datetime] NULL,
	[blocked_at] [datetime] NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vehicle_colors]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehicle_colors](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](200) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_vehicle_colors] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vehicle_models]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehicle_models](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](200) NOT NULL,
	[vehicle_type_id] [int] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_vehicle_models] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vehicle_plate_rows]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehicle_plate_rows](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_plate_rows] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vehicle_plate_types]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehicle_plate_types](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](200) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_vehicle_types] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vehicle_types]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehicle_types](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](200) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[expired_at] [datetime] NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_vehicle_types_1] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [audits_auditable_type_auditable_id_index]    Script Date: 11/5/2026 11:38:07 AM ******/
CREATE NONCLUSTERED INDEX [audits_auditable_type_auditable_id_index] ON [dbo].[audits]
(
	[auditable_type] ASC,
	[auditable_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [audits_user_id_user_type_index]    Script Date: 11/5/2026 11:38:07 AM ******/
CREATE NONCLUSTERED INDEX [audits_user_id_user_type_index] ON [dbo].[audits]
(
	[user_id] ASC,
	[user_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [failed_jobs_uuid_unique]    Script Date: 11/5/2026 11:38:07 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [failed_jobs_uuid_unique] ON [dbo].[failed_jobs]
(
	[uuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_phone_is_mobile]    Script Date: 11/5/2026 11:38:07 AM ******/
CREATE NONCLUSTERED INDEX [idx_phone_is_mobile] ON [dbo].[phone_numbers]
(
	[phone_is_mobile] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_phone_numbers_code]    Script Date: 11/5/2026 11:38:07 AM ******/
CREATE NONCLUSTERED INDEX [idx_phone_numbers_code] ON [dbo].[phone_numbers]
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_phone_numbers_phone_number]    Script Date: 11/5/2026 11:38:07 AM ******/
CREATE NONCLUSTERED INDEX [idx_phone_numbers_phone_number] ON [dbo].[phone_numbers]
(
	[phone_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_phone_numbers_phone_type_id]    Script Date: 11/5/2026 11:38:07 AM ******/
CREATE NONCLUSTERED INDEX [idx_phone_numbers_phone_type_id] ON [dbo].[phone_numbers]
(
	[phone_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_sso_attemps]    Script Date: 11/5/2026 11:38:07 AM ******/
CREATE NONCLUSTERED INDEX [IX_sso_attemps] ON [dbo].[sso_attempts]
(
	[state] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_user_agents_name]    Script Date: 11/5/2026 11:38:07 AM ******/
CREATE NONCLUSTERED INDEX [idx_user_agents_name] ON [dbo].[user_agents]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[address_kinds] ADD  CONSTRAINT [DF_address_kinds_is_home]  DEFAULT ((0)) FOR [is_home]
GO
ALTER TABLE [dbo].[address_kinds] ADD  CONSTRAINT [DF_address_kinds_is_social_media]  DEFAULT ((0)) FOR [is_social_media]
GO
ALTER TABLE [dbo].[address_kinds] ADD  CONSTRAINT [DF_address_kinds_is_email]  DEFAULT ((0)) FOR [is_email]
GO
ALTER TABLE [dbo].[address_kinds] ADD  CONSTRAINT [DF_address_kinds_is_telegram]  DEFAULT ((0)) FOR [is_telegram]
GO
ALTER TABLE [dbo].[address_kinds] ADD  CONSTRAINT [DF_address_kinds_is_whatsapp]  DEFAULT ((0)) FOR [is_whatsapp]
GO
ALTER TABLE [dbo].[address_kinds] ADD  CONSTRAINT [DF_address_kinds_is_twitter]  DEFAULT ((0)) FOR [is_twitter]
GO
ALTER TABLE [dbo].[cities] ADD  CONSTRAINT [DF__cities__is_capit__746F28F1]  DEFAULT ((0)) FOR [is_capital]
GO
ALTER TABLE [dbo].[cities] ADD  CONSTRAINT [DF__cities__is_centr__75634D2A]  DEFAULT ((0)) FOR [is_central]
GO
ALTER TABLE [dbo].[countries] ADD  CONSTRAINT [DF_countries_is_home_country]  DEFAULT ((0)) FOR [is_home_country]
GO
ALTER TABLE [dbo].[document_imports] ADD  CONSTRAINT [DF_document_imports_total_records_count]  DEFAULT ((0)) FOR [total_records_count]
GO
ALTER TABLE [dbo].[document_imports] ADD  CONSTRAINT [DF_document_imports_failed_imports_count]  DEFAULT ((0)) FOR [failed_records_count]
GO
ALTER TABLE [dbo].[document_imports] ADD  CONSTRAINT [DF_document_imports_skiped_imports_count]  DEFAULT ((0)) FOR [skipped_records_count]
GO
ALTER TABLE [dbo].[document_ownerships] ADD  CONSTRAINT [DF_document_ownerships_is_current]  DEFAULT ((0)) FOR [is_current]
GO
ALTER TABLE [dbo].[document_ownerships] ADD  CONSTRAINT [DF_document_ownerships_is_creator]  DEFAULT ((0)) FOR [is_creator]
GO
ALTER TABLE [dbo].[document_reject_reasons] ADD  CONSTRAINT [DF_document_reject_reasons_order_no]  DEFAULT ((0)) FOR [order_no]
GO
ALTER TABLE [dbo].[document_state_flows] ADD  CONSTRAINT [DF_document_state_flow_is_current]  DEFAULT ((1)) FOR [is_current]
GO
ALTER TABLE [dbo].[document_state_flows] ADD  CONSTRAINT [DF_document_state_flows_is_system_flow]  DEFAULT ((0)) FOR [is_system_flow]
GO
ALTER TABLE [dbo].[document_states] ADD  CONSTRAINT [DF_document_states_is_first]  DEFAULT ((0)) FOR [is_first]
GO
ALTER TABLE [dbo].[document_states] ADD  CONSTRAINT [DF_document_states_is_pending]  DEFAULT ((0)) FOR [is_pending]
GO
ALTER TABLE [dbo].[document_states] ADD  CONSTRAINT [DF_document_states_is_archived]  DEFAULT ((0)) FOR [is_archived]
GO
ALTER TABLE [dbo].[document_states] ADD  CONSTRAINT [DF_document_states_is_draft]  DEFAULT ((0)) FOR [is_draft]
GO
ALTER TABLE [dbo].[document_states] ADD  CONSTRAINT [DF_document_states_is_rejected]  DEFAULT ((0)) FOR [is_rejected]
GO
ALTER TABLE [dbo].[document_states] ADD  CONSTRAINT [DF_document_states_is_approved]  DEFAULT ((0)) FOR [is_approved]
GO
ALTER TABLE [dbo].[document_states] ADD  CONSTRAINT [DF_document_states_is_visible]  DEFAULT ((0)) FOR [is_visible]
GO
ALTER TABLE [dbo].[document_states] ADD  CONSTRAINT [DF_document_states_is_selectable]  DEFAULT ((0)) FOR [is_selectable]
GO
ALTER TABLE [dbo].[document_states] ADD  CONSTRAINT [DF_document_states_is_searchable]  DEFAULT ((0)) FOR [is_searchable]
GO
ALTER TABLE [dbo].[document_states] ADD  CONSTRAINT [DF_document_states_order_no]  DEFAULT ((0)) FOR [order_no]
GO
ALTER TABLE [dbo].[documents] ADD  CONSTRAINT [DF_documents_is_public]  DEFAULT ((0)) FOR [is_public]
GO
ALTER TABLE [dbo].[documents] ADD  CONSTRAINT [DF_documents_is_imported]  DEFAULT ((0)) FOR [is_imported]
GO
ALTER TABLE [dbo].[documents] ADD  CONSTRAINT [DF_documents_document_no]  DEFAULT (NEXT VALUE FOR [dbo].[Sequence-DocumentNo]) FOR [document_no]
GO
ALTER TABLE [dbo].[failed_jobs] ADD  DEFAULT (getdate()) FOR [failed_at]
GO
ALTER TABLE [dbo].[phone_kinds] ADD  CONSTRAINT [DF_phone_kinds_is_phone_number]  DEFAULT ((0)) FOR [is_phone_number]
GO
ALTER TABLE [dbo].[phone_kinds] ADD  CONSTRAINT [DF_phone_kinds_is_mobile]  DEFAULT ((0)) FOR [is_mobile]
GO
ALTER TABLE [dbo].[profiles] ADD  CONSTRAINT [DF_profiles_is_enable]  DEFAULT ((0)) FOR [is_enable]
GO
ALTER TABLE [dbo].[profiles] ADD  CONSTRAINT [DF_profiles_is_current]  DEFAULT ((0)) FOR [is_current]
GO
ALTER TABLE [dbo].[request_state_flows] ADD  CONSTRAINT [DF_requesr_state_flows_is_first]  DEFAULT ((0)) FOR [is_first]
GO
ALTER TABLE [dbo].[request_state_flows] ADD  CONSTRAINT [DF_requesr_state_flows_is_current]  DEFAULT ((1)) FOR [is_current]
GO
ALTER TABLE [dbo].[request_states] ADD  CONSTRAINT [DF_request_states_is_first]  DEFAULT ((0)) FOR [is_first]
GO
ALTER TABLE [dbo].[request_states] ADD  CONSTRAINT [DF_request_states_is_pending]  DEFAULT ((0)) FOR [is_pending]
GO
ALTER TABLE [dbo].[request_states] ADD  CONSTRAINT [DF_request_states_is_approved]  DEFAULT ((0)) FOR [is_approved]
GO
ALTER TABLE [dbo].[request_states] ADD  CONSTRAINT [DF_request_states_is_rejected]  DEFAULT ((0)) FOR [is_rejected]
GO
ALTER TABLE [dbo].[request_states] ADD  CONSTRAINT [DF_request_states_is_selectable]  DEFAULT ((0)) FOR [is_selectable]
GO
ALTER TABLE [dbo].[request_states] ADD  CONSTRAINT [DF_request_states_order_no]  DEFAULT ((0)) FOR [order_no]
GO
ALTER TABLE [dbo].[requests] ADD  CONSTRAINT [DF_requests_request_no]  DEFAULT (NEXT VALUE FOR [dbo].[Sequence-RequestNo]) FOR [request_no]
GO
ALTER TABLE [dbo].[sela_detail_logs] ADD  CONSTRAINT [DF_sela_detail_logs_log_mime]  DEFAULT ((0)) FOR [log_mime]
GO
ALTER TABLE [dbo].[social_posts] ADD  CONSTRAINT [DF_social_posts_created_at]  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[user_agents] ADD  DEFAULT ('2023-11-06 13:43:56') FOR [created_at]
GO
ALTER TABLE [dbo].[user_agents] ADD  DEFAULT ('2023-11-06 13:43:56') FOR [updated_at]
GO
ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_is_active]  DEFAULT ((0)) FOR [is_active]
GO
ALTER TABLE [dbo].[address_kinds]  WITH CHECK ADD  CONSTRAINT [FK_address_kinds_address_groups] FOREIGN KEY([address_group_id])
REFERENCES [dbo].[address_groups] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[address_kinds] CHECK CONSTRAINT [FK_address_kinds_address_groups]
GO
ALTER TABLE [dbo].[cities]  WITH CHECK ADD  CONSTRAINT [FK_cities_provinces] FOREIGN KEY([province_id])
REFERENCES [dbo].[provinces] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cities] CHECK CONSTRAINT [FK_cities_provinces]
GO
ALTER TABLE [dbo].[countries]  WITH CHECK ADD  CONSTRAINT [FK_countries_continents] FOREIGN KEY([continent_id])
REFERENCES [dbo].[continents] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[countries] CHECK CONSTRAINT [FK_countries_continents]
GO
ALTER TABLE [dbo].[department_types]  WITH CHECK ADD  CONSTRAINT [FK_department_types_grades] FOREIGN KEY([supervisor_grade_id])
REFERENCES [dbo].[grades] ([id])
GO
ALTER TABLE [dbo].[department_types] CHECK CONSTRAINT [FK_department_types_grades]
GO
ALTER TABLE [dbo].[departments]  WITH CHECK ADD  CONSTRAINT [FK_departments_department_types] FOREIGN KEY([department_type_id])
REFERENCES [dbo].[department_types] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[departments] CHECK CONSTRAINT [FK_departments_department_types]
GO
ALTER TABLE [dbo].[document_addresses]  WITH CHECK ADD  CONSTRAINT [FK_document_addresses_address_kinds] FOREIGN KEY([address_kind_id])
REFERENCES [dbo].[address_kinds] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_addresses] CHECK CONSTRAINT [FK_document_addresses_address_kinds]
GO
ALTER TABLE [dbo].[document_addresses]  WITH CHECK ADD  CONSTRAINT [FK_document_addresses_cities] FOREIGN KEY([city_id])
REFERENCES [dbo].[cities] ([id])
ON UPDATE SET NULL
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[document_addresses] CHECK CONSTRAINT [FK_document_addresses_cities]
GO
ALTER TABLE [dbo].[document_addresses]  WITH CHECK ADD  CONSTRAINT [FK_document_addresses_document_phones] FOREIGN KEY([document_phone_id])
REFERENCES [dbo].[document_phones] ([id])
GO
ALTER TABLE [dbo].[document_addresses] CHECK CONSTRAINT [FK_document_addresses_document_phones]
GO
ALTER TABLE [dbo].[document_addresses]  WITH CHECK ADD  CONSTRAINT [FK_document_addresses_documents] FOREIGN KEY([document_id])
REFERENCES [dbo].[documents] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_addresses] CHECK CONSTRAINT [FK_document_addresses_documents]
GO
ALTER TABLE [dbo].[document_addresses]  WITH CHECK ADD  CONSTRAINT [FK_document_addresses_profiles] FOREIGN KEY([creator_profile_id])
REFERENCES [dbo].[profiles] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_addresses] CHECK CONSTRAINT [FK_document_addresses_profiles]
GO
ALTER TABLE [dbo].[document_images]  WITH CHECK ADD  CONSTRAINT [FK_document_images_documents] FOREIGN KEY([document_id])
REFERENCES [dbo].[documents] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_images] CHECK CONSTRAINT [FK_document_images_documents]
GO
ALTER TABLE [dbo].[document_images]  WITH CHECK ADD  CONSTRAINT [FK_document_images_image_kinds] FOREIGN KEY([image_kind_id])
REFERENCES [dbo].[image_kinds] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_images] CHECK CONSTRAINT [FK_document_images_image_kinds]
GO
ALTER TABLE [dbo].[document_import_failures]  WITH CHECK ADD  CONSTRAINT [FK_document_import_failures_cities] FOREIGN KEY([birth_place_id])
REFERENCES [dbo].[cities] ([id])
GO
ALTER TABLE [dbo].[document_import_failures] CHECK CONSTRAINT [FK_document_import_failures_cities]
GO
ALTER TABLE [dbo].[document_import_failures]  WITH CHECK ADD  CONSTRAINT [FK_document_import_failures_cities1] FOREIGN KEY([issue_place_id])
REFERENCES [dbo].[cities] ([id])
GO
ALTER TABLE [dbo].[document_import_failures] CHECK CONSTRAINT [FK_document_import_failures_cities1]
GO
ALTER TABLE [dbo].[document_import_failures]  WITH CHECK ADD  CONSTRAINT [FK_document_import_failures_cities2] FOREIGN KEY([address_city_id])
REFERENCES [dbo].[cities] ([id])
GO
ALTER TABLE [dbo].[document_import_failures] CHECK CONSTRAINT [FK_document_import_failures_cities2]
GO
ALTER TABLE [dbo].[document_import_failures]  WITH CHECK ADD  CONSTRAINT [FK_document_import_failures_document_imports] FOREIGN KEY([document_import_id])
REFERENCES [dbo].[document_imports] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_import_failures] CHECK CONSTRAINT [FK_document_import_failures_document_imports]
GO
ALTER TABLE [dbo].[document_import_failures]  WITH CHECK ADD  CONSTRAINT [FK_document_import_failures_genders] FOREIGN KEY([gender_id])
REFERENCES [dbo].[genders] ([id])
GO
ALTER TABLE [dbo].[document_import_failures] CHECK CONSTRAINT [FK_document_import_failures_genders]
GO
ALTER TABLE [dbo].[document_import_failures]  WITH CHECK ADD  CONSTRAINT [FK_document_import_failures_subjects] FOREIGN KEY([document_subject_id_01])
REFERENCES [dbo].[subjects] ([id])
GO
ALTER TABLE [dbo].[document_import_failures] CHECK CONSTRAINT [FK_document_import_failures_subjects]
GO
ALTER TABLE [dbo].[document_import_failures]  WITH CHECK ADD  CONSTRAINT [FK_document_import_failures_subjects1] FOREIGN KEY([document_subject_id_02])
REFERENCES [dbo].[subjects] ([id])
GO
ALTER TABLE [dbo].[document_import_failures] CHECK CONSTRAINT [FK_document_import_failures_subjects1]
GO
ALTER TABLE [dbo].[document_import_failures]  WITH CHECK ADD  CONSTRAINT [FK_document_import_failures_subjects2] FOREIGN KEY([document_subject_id_03])
REFERENCES [dbo].[subjects] ([id])
GO
ALTER TABLE [dbo].[document_import_failures] CHECK CONSTRAINT [FK_document_import_failures_subjects2]
GO
ALTER TABLE [dbo].[document_imports]  WITH CHECK ADD  CONSTRAINT [FK_document_imports_profiles] FOREIGN KEY([profile_id])
REFERENCES [dbo].[profiles] ([id])
GO
ALTER TABLE [dbo].[document_imports] CHECK CONSTRAINT [FK_document_imports_profiles]
GO
ALTER TABLE [dbo].[document_imports]  WITH CHECK ADD  CONSTRAINT [FK_document_imports_profiles1] FOREIGN KEY([creator_profile_id])
REFERENCES [dbo].[profiles] ([id])
GO
ALTER TABLE [dbo].[document_imports] CHECK CONSTRAINT [FK_document_imports_profiles1]
GO
ALTER TABLE [dbo].[document_ownerships]  WITH CHECK ADD  CONSTRAINT [FK_document_ownerships_documents] FOREIGN KEY([document_id])
REFERENCES [dbo].[documents] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_ownerships] CHECK CONSTRAINT [FK_document_ownerships_documents]
GO
ALTER TABLE [dbo].[document_ownerships]  WITH CHECK ADD  CONSTRAINT [FK_document_ownerships_profiles] FOREIGN KEY([profile_id])
REFERENCES [dbo].[profiles] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_ownerships] CHECK CONSTRAINT [FK_document_ownerships_profiles]
GO
ALTER TABLE [dbo].[document_phones]  WITH CHECK ADD  CONSTRAINT [FK_document_phones_documents] FOREIGN KEY([document_id])
REFERENCES [dbo].[documents] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_phones] CHECK CONSTRAINT [FK_document_phones_documents]
GO
ALTER TABLE [dbo].[document_phones]  WITH CHECK ADD  CONSTRAINT [FK_document_phones_phone_kinds] FOREIGN KEY([phone_kind_id])
REFERENCES [dbo].[phone_kinds] ([id])
ON UPDATE SET NULL
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[document_phones] CHECK CONSTRAINT [FK_document_phones_phone_kinds]
GO
ALTER TABLE [dbo].[document_phones]  WITH CHECK ADD  CONSTRAINT [FK_document_phones_profiles] FOREIGN KEY([creator_profile_id])
REFERENCES [dbo].[profiles] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_phones] CHECK CONSTRAINT [FK_document_phones_profiles]
GO
ALTER TABLE [dbo].[document_state_flows]  WITH CHECK ADD  CONSTRAINT [FK_document_state_flows_document_reject_reasons] FOREIGN KEY([document_reject_reason_id])
REFERENCES [dbo].[document_reject_reasons] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_state_flows] CHECK CONSTRAINT [FK_document_state_flows_document_reject_reasons]
GO
ALTER TABLE [dbo].[document_state_flows]  WITH CHECK ADD  CONSTRAINT [FK_document_state_flows_document_states] FOREIGN KEY([document_state_id])
REFERENCES [dbo].[document_states] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_state_flows] CHECK CONSTRAINT [FK_document_state_flows_document_states]
GO
ALTER TABLE [dbo].[document_state_flows]  WITH CHECK ADD  CONSTRAINT [FK_document_state_flows_documents] FOREIGN KEY([document_id])
REFERENCES [dbo].[documents] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_state_flows] CHECK CONSTRAINT [FK_document_state_flows_documents]
GO
ALTER TABLE [dbo].[document_state_flows]  WITH CHECK ADD  CONSTRAINT [FK_document_state_flows_profiles] FOREIGN KEY([profile_id])
REFERENCES [dbo].[profiles] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_state_flows] CHECK CONSTRAINT [FK_document_state_flows_profiles]
GO
ALTER TABLE [dbo].[document_state_flows]  WITH CHECK ADD  CONSTRAINT [FK_document_state_flows_request_reject_reasons] FOREIGN KEY([document_reject_reason_id])
REFERENCES [dbo].[request_reject_reasons] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_state_flows] CHECK CONSTRAINT [FK_document_state_flows_request_reject_reasons]
GO
ALTER TABLE [dbo].[document_states]  WITH CHECK ADD  CONSTRAINT [FK_document_states_permissions] FOREIGN KEY([permission_id])
REFERENCES [dbo].[permissions] ([id])
GO
ALTER TABLE [dbo].[document_states] CHECK CONSTRAINT [FK_document_states_permissions]
GO
ALTER TABLE [dbo].[document_subject]  WITH CHECK ADD  CONSTRAINT [FK_document_subject_documents] FOREIGN KEY([document_id])
REFERENCES [dbo].[documents] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_subject] CHECK CONSTRAINT [FK_document_subject_documents]
GO
ALTER TABLE [dbo].[document_subject]  WITH CHECK ADD  CONSTRAINT [FK_document_subject_profiles] FOREIGN KEY([creator_profile_id])
REFERENCES [dbo].[profiles] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_subject] CHECK CONSTRAINT [FK_document_subject_profiles]
GO
ALTER TABLE [dbo].[document_subject]  WITH CHECK ADD  CONSTRAINT [FK_document_subject_subjects] FOREIGN KEY([subject_id])
REFERENCES [dbo].[subjects] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_subject] CHECK CONSTRAINT [FK_document_subject_subjects]
GO
ALTER TABLE [dbo].[document_summaries]  WITH CHECK ADD  CONSTRAINT [FK_document_summaries_documents] FOREIGN KEY([document_id])
REFERENCES [dbo].[documents] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_summaries] CHECK CONSTRAINT [FK_document_summaries_documents]
GO
ALTER TABLE [dbo].[document_summaries]  WITH CHECK ADD  CONSTRAINT [FK_document_summaries_profiles] FOREIGN KEY([creator_profile_id])
REFERENCES [dbo].[profiles] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_summaries] CHECK CONSTRAINT [FK_document_summaries_profiles]
GO
ALTER TABLE [dbo].[document_vehicles]  WITH CHECK ADD  CONSTRAINT [FK_document_vehicles_document_vehicles] FOREIGN KEY([vehicle_model_id])
REFERENCES [dbo].[vehicle_models] ([id])
GO
ALTER TABLE [dbo].[document_vehicles] CHECK CONSTRAINT [FK_document_vehicles_document_vehicles]
GO
ALTER TABLE [dbo].[document_vehicles]  WITH CHECK ADD  CONSTRAINT [FK_document_vehicles_documents] FOREIGN KEY([document_id])
REFERENCES [dbo].[documents] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[document_vehicles] CHECK CONSTRAINT [FK_document_vehicles_documents]
GO
ALTER TABLE [dbo].[document_vehicles]  WITH CHECK ADD  CONSTRAINT [FK_document_vehicles_vehicle_colors] FOREIGN KEY([vehicle_color_id])
REFERENCES [dbo].[vehicle_colors] ([id])
GO
ALTER TABLE [dbo].[document_vehicles] CHECK CONSTRAINT [FK_document_vehicles_vehicle_colors]
GO
ALTER TABLE [dbo].[document_vehicles]  WITH CHECK ADD  CONSTRAINT [FK_document_vehicles_vehicle_plate_rows] FOREIGN KEY([vehicle_plate_row_id])
REFERENCES [dbo].[vehicle_plate_rows] ([id])
GO
ALTER TABLE [dbo].[document_vehicles] CHECK CONSTRAINT [FK_document_vehicles_vehicle_plate_rows]
GO
ALTER TABLE [dbo].[document_vehicles]  WITH CHECK ADD  CONSTRAINT [FK_document_vehicles_vehicle_plate_types] FOREIGN KEY([vehicle_plate_type_id])
REFERENCES [dbo].[vehicle_plate_types] ([id])
GO
ALTER TABLE [dbo].[document_vehicles] CHECK CONSTRAINT [FK_document_vehicles_vehicle_plate_types]
GO
ALTER TABLE [dbo].[documents]  WITH CHECK ADD  CONSTRAINT [FK_documents_document_imports] FOREIGN KEY([document_import_id])
REFERENCES [dbo].[document_imports] ([id])
GO
ALTER TABLE [dbo].[documents] CHECK CONSTRAINT [FK_documents_document_imports]
GO
ALTER TABLE [dbo].[people]  WITH CHECK ADD  CONSTRAINT [FK_people_cities_birth_place] FOREIGN KEY([birth_place_id])
REFERENCES [dbo].[cities] ([id])
GO
ALTER TABLE [dbo].[people] CHECK CONSTRAINT [FK_people_cities_birth_place]
GO
ALTER TABLE [dbo].[people]  WITH CHECK ADD  CONSTRAINT [FK_people_cities_issue_place] FOREIGN KEY([issue_place_id])
REFERENCES [dbo].[cities] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[people] CHECK CONSTRAINT [FK_people_cities_issue_place]
GO
ALTER TABLE [dbo].[people]  WITH CHECK ADD  CONSTRAINT [FK_people_documents] FOREIGN KEY([document_id])
REFERENCES [dbo].[documents] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[people] CHECK CONSTRAINT [FK_people_documents]
GO
ALTER TABLE [dbo].[people]  WITH CHECK ADD  CONSTRAINT [FK_people_genders] FOREIGN KEY([gender_id])
REFERENCES [dbo].[genders] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[people] CHECK CONSTRAINT [FK_people_genders]
GO
ALTER TABLE [dbo].[permission_role]  WITH CHECK ADD  CONSTRAINT [FK_permission_role_permissions] FOREIGN KEY([permission_id])
REFERENCES [dbo].[permissions] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[permission_role] CHECK CONSTRAINT [FK_permission_role_permissions]
GO
ALTER TABLE [dbo].[permission_role]  WITH CHECK ADD  CONSTRAINT [FK_permission_role_roles] FOREIGN KEY([role_id])
REFERENCES [dbo].[roles] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[permission_role] CHECK CONSTRAINT [FK_permission_role_roles]
GO
ALTER TABLE [dbo].[permission_user]  WITH CHECK ADD  CONSTRAINT [FK_permission_user_permissions] FOREIGN KEY([permission_id])
REFERENCES [dbo].[permissions] ([id])
GO
ALTER TABLE [dbo].[permission_user] CHECK CONSTRAINT [FK_permission_user_permissions]
GO
ALTER TABLE [dbo].[permission_user]  WITH CHECK ADD  CONSTRAINT [FK_permission_user_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[permission_user] CHECK CONSTRAINT [FK_permission_user_users]
GO
ALTER TABLE [dbo].[permissions]  WITH CHECK ADD  CONSTRAINT [FK_permissions_permission_sets] FOREIGN KEY([permission_set_id])
REFERENCES [dbo].[permission_sets] ([id])
GO
ALTER TABLE [dbo].[permissions] CHECK CONSTRAINT [FK_permissions_permission_sets]
GO
ALTER TABLE [dbo].[phone_numbers]  WITH CHECK ADD FOREIGN KEY([phone_type_id])
REFERENCES [dbo].[phone_types] ([id])
GO
ALTER TABLE [dbo].[profiles]  WITH CHECK ADD  CONSTRAINT [FK_profiles_departments] FOREIGN KEY([department_id])
REFERENCES [dbo].[departments] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[profiles] CHECK CONSTRAINT [FK_profiles_departments]
GO
ALTER TABLE [dbo].[profiles]  WITH CHECK ADD  CONSTRAINT [FK_profiles_grades] FOREIGN KEY([grade_id])
REFERENCES [dbo].[grades] ([id])
GO
ALTER TABLE [dbo].[profiles] CHECK CONSTRAINT [FK_profiles_grades]
GO
ALTER TABLE [dbo].[profiles]  WITH CHECK ADD  CONSTRAINT [FK_profiles_profiles] FOREIGN KEY([parent_id])
REFERENCES [dbo].[profiles] ([id])
GO
ALTER TABLE [dbo].[profiles] CHECK CONSTRAINT [FK_profiles_profiles]
GO
ALTER TABLE [dbo].[profiles]  WITH CHECK ADD  CONSTRAINT [FK_profiles_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[profiles] CHECK CONSTRAINT [FK_profiles_users]
GO
ALTER TABLE [dbo].[provinces]  WITH CHECK ADD  CONSTRAINT [FK_provinces_countries] FOREIGN KEY([country_id])
REFERENCES [dbo].[countries] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[provinces] CHECK CONSTRAINT [FK_provinces_countries]
GO
ALTER TABLE [dbo].[request_state_flows]  WITH CHECK ADD  CONSTRAINT [FK_request_state_flows_profiles] FOREIGN KEY([profile_id])
REFERENCES [dbo].[profiles] ([id])
GO
ALTER TABLE [dbo].[request_state_flows] CHECK CONSTRAINT [FK_request_state_flows_profiles]
GO
ALTER TABLE [dbo].[request_state_flows]  WITH CHECK ADD  CONSTRAINT [FK_request_state_flows_request_reject_reasons] FOREIGN KEY([request_reject_reason_id])
REFERENCES [dbo].[request_reject_reasons] ([id])
GO
ALTER TABLE [dbo].[request_state_flows] CHECK CONSTRAINT [FK_request_state_flows_request_reject_reasons]
GO
ALTER TABLE [dbo].[request_state_flows]  WITH CHECK ADD  CONSTRAINT [FK_request_state_flows_request_states] FOREIGN KEY([request_state_id])
REFERENCES [dbo].[request_states] ([id])
GO
ALTER TABLE [dbo].[request_state_flows] CHECK CONSTRAINT [FK_request_state_flows_request_states]
GO
ALTER TABLE [dbo].[request_state_flows]  WITH CHECK ADD  CONSTRAINT [FK_request_state_flows_requests] FOREIGN KEY([request_id])
REFERENCES [dbo].[requests] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[request_state_flows] CHECK CONSTRAINT [FK_request_state_flows_requests]
GO
ALTER TABLE [dbo].[request_states]  WITH CHECK ADD  CONSTRAINT [FK_request_states_permissions] FOREIGN KEY([permission_id])
REFERENCES [dbo].[permissions] ([id])
GO
ALTER TABLE [dbo].[request_states] CHECK CONSTRAINT [FK_request_states_permissions]
GO
ALTER TABLE [dbo].[requests]  WITH CHECK ADD  CONSTRAINT [FK_requests_documents] FOREIGN KEY([document_id])
REFERENCES [dbo].[documents] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[requests] CHECK CONSTRAINT [FK_requests_documents]
GO
ALTER TABLE [dbo].[requests]  WITH CHECK ADD  CONSTRAINT [FK_requests_profiles] FOREIGN KEY([profile_id])
REFERENCES [dbo].[profiles] ([id])
GO
ALTER TABLE [dbo].[requests] CHECK CONSTRAINT [FK_requests_profiles]
GO
ALTER TABLE [dbo].[requests]  WITH CHECK ADD  CONSTRAINT [FK_requests_request_reasons] FOREIGN KEY([request_reason_id])
REFERENCES [dbo].[request_reasons] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[requests] CHECK CONSTRAINT [FK_requests_request_reasons]
GO
ALTER TABLE [dbo].[role_user]  WITH CHECK ADD  CONSTRAINT [FK_role_user_roles] FOREIGN KEY([role_id])
REFERENCES [dbo].[roles] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[role_user] CHECK CONSTRAINT [FK_role_user_roles]
GO
ALTER TABLE [dbo].[role_user]  WITH CHECK ADD  CONSTRAINT [FK_role_user_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[role_user] CHECK CONSTRAINT [FK_role_user_users]
GO
ALTER TABLE [dbo].[sela_detail_logs]  WITH CHECK ADD  CONSTRAINT [sela_detail_logs_actionlog_id_foreign] FOREIGN KEY([actionlog_id])
REFERENCES [dbo].[sela_action_logs] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[sela_detail_logs] CHECK CONSTRAINT [sela_detail_logs_actionlog_id_foreign]
GO
ALTER TABLE [dbo].[sela_mime_logs]  WITH CHECK ADD  CONSTRAINT [sela_mime_logs_actionlog_id_foreign] FOREIGN KEY([actionlog_id])
REFERENCES [dbo].[sela_action_logs] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[sela_mime_logs] CHECK CONSTRAINT [sela_mime_logs_actionlog_id_foreign]
GO
ALTER TABLE [dbo].[social_posts]  WITH CHECK ADD  CONSTRAINT [FK_social_posts_social_platforms] FOREIGN KEY([social_platform_id])
REFERENCES [dbo].[social_platforms] ([id])
GO
ALTER TABLE [dbo].[social_posts] CHECK CONSTRAINT [FK_social_posts_social_platforms]
GO
ALTER TABLE [dbo].[sso_attempts]  WITH CHECK ADD  CONSTRAINT [FK_sso_attempts_sso_attempts] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[sso_attempts] CHECK CONSTRAINT [FK_sso_attempts_sso_attempts]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_genders] FOREIGN KEY([gender_id])
REFERENCES [dbo].[genders] ([id])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [FK_users_genders]
GO
ALTER TABLE [dbo].[vehicle_models]  WITH CHECK ADD  CONSTRAINT [FK_vehicle_models_vehicle_types] FOREIGN KEY([vehicle_type_id])
REFERENCES [dbo].[vehicle_types] ([id])
GO
ALTER TABLE [dbo].[vehicle_models] CHECK CONSTRAINT [FK_vehicle_models_vehicle_types]
GO
/****** Object:  StoredProcedure [dbo].[BulkInsertSample]    Script Date: 11/5/2026 11:38:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BulkInsertSample]
    @Xml XML
AS
BEGIN
	DECLARE @sql nvarchar(max)


	CREATE TABLE #phone_numbers (
		[id] [int] IDENTITY(1,1) NOT NULL,
		[code] [nvarchar](50) NULL,
		[name] [nvarchar](100) NOT NULL,
		[phone_number] [nvarchar](100) NOT NULL,
		[description] [nvarchar](500) NULL,
		[created_at] [datetime] NOT NULL,
		[updated_at] [datetime] NOT NULL
	)



	/*Method 1*/ /*****  This method is faster  */

	;WITH Casted AS
	(
		SELECT
			Tbl.Col.value('(./@Code)[1]', 'NVARCHAR(50)') as code,
			Tbl.Col.value('(./@Name)[1]', 'NVARCHAR(100)') as name,
			Tbl.Col.value('(./@PhoneNumber)[1]', 'NVARCHAR(100)') as phone,
			Tbl.Col.value('(./@CreatedAt)[1]', 'DATETIME') as created,
			Tbl.Col.value('(./@UpdatedAt)[1]', 'DATETIME') as updated
		FROM @Xml.nodes('/Root/Row') Tbl(Col)
	)
	INSERT INTO #phone_numbers ([code], [name], [phone_number], [description], created_at, updated_at)
	SELECT code, name, phone, null, created, updated FROM Casted


	INSERT INTO phone_numbers ([code], [name], [phone_number], [description], created_at, updated_at)
	SELECT [code], [name], [phone_number], [description], created_at, updated_at FROM #phone_numbers

	drop table #phone_numbers

	/*Method 2*/

	/*SET @sql = 'INSERT INTO phone_numbers([code], [name], [phone_number], [description], created_at, updated_at) Values ';

	WITH Casted AS
	(
		SELECT
			Tbl.Col.value('(./@Code)[1]', 'NVARCHAR(50)') as code,
			Tbl.Col.value('(./@Name)[1]', 'NVARCHAR(100)') as name,
			Tbl.Col.value('(./@PhoneNumber)[1]', 'NVARCHAR(100)') as phone,
			Tbl.Col.value('(./@Description)[1]', 'NVARCHAR(500)') as descrip,
			Tbl.Col.value('(./@CreatedAt)[1]', 'DATETIME') as created,
			Tbl.Col.value('(./@UpdatedAt)[1]', 'DATETIME') as updated
		FROM @Xml.nodes('/Root/Row') Tbl(Col)
	)
	SELECT @sql += CONCAT('(', Casted.code, ',N''', Casted.name, ''',''', Casted.phone, ''',N''', Casted.descrip, ''',''', Casted.created, ''',''', Casted.updated, '''),')
	FROM Casted;

	SET @sql = LEFT(@sql, LEN(@sql) - 1)

	exec (@sql);*/
END
GO
USE [master]
GO
