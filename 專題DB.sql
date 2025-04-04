USE [master]
GO
/****** Object:  Database [iStudyTest]    Script Date: 2025/3/25 下午 01:18:42 ******/
CREATE DATABASE [iStudyTest]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'iStudyTtest', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\iStudyTtest.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'iStudyTtest_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\iStudyTtest_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [iStudyTest] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [iStudyTest].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [iStudyTest] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [iStudyTest] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [iStudyTest] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [iStudyTest] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [iStudyTest] SET ARITHABORT OFF 
GO
ALTER DATABASE [iStudyTest] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [iStudyTest] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [iStudyTest] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [iStudyTest] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [iStudyTest] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [iStudyTest] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [iStudyTest] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [iStudyTest] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [iStudyTest] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [iStudyTest] SET  ENABLE_BROKER 
GO
ALTER DATABASE [iStudyTest] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [iStudyTest] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [iStudyTest] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [iStudyTest] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [iStudyTest] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [iStudyTest] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [iStudyTest] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [iStudyTest] SET RECOVERY FULL 
GO
ALTER DATABASE [iStudyTest] SET  MULTI_USER 
GO
ALTER DATABASE [iStudyTest] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [iStudyTest] SET DB_CHAINING OFF 
GO
ALTER DATABASE [iStudyTest] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [iStudyTest] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [iStudyTest] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [iStudyTest] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'iStudyTest', N'ON'
GO
ALTER DATABASE [iStudyTest] SET QUERY_STORE = ON
GO
ALTER DATABASE [iStudyTest] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [iStudyTest]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetNewMemberID]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function[dbo].[fnGetNewMemberID] ()
    returns nchar(6)
begin
  DECLARE @newID nchar(6)
	DECLARE @numberPart int
	DECLARE @newNumberPart NVARCHAR(10)

	-- 取得最新的 MemberID
	SELECT TOP 1 @newID = MemberID
	FROM Member
	ORDER BY MemberID DESC

	-- 提取數字部分，轉換為整數
	SET @numberPart = CAST(SUBSTRING(@newID, 2, 5) AS INT)

	-- 加 1
	SET @numberPart = @numberPart + 1

	-- 將新的數字部分轉為字串，並確保補零至 5 位
	SET @newID = RIGHT('00000' + CAST(@numberPart AS NVARCHAR(5)), 5)

	-- 拼接回新的 MemberID
	return 'A' + @newID
	
end
GO
/****** Object:  UserDefinedFunction [dbo].[GetEmployeeID]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create FUNCTION [dbo].[GetEmployeeID]()

    RETURNS CHAR(11)
AS
BEGIN
    DECLARE @TodayYear VARCHAR(3);
	DECLARE @SerialNumber INT;
	DECLARE @NewEmployeeID VARCHAR(7);

--取得今天的民國年（格式: YYY, 西元年 - 1911）
    SET @TodayYear = RIGHT(CAST(YEAR(GETDATE()) - 1911 AS VARCHAR(3)), 3);

--查詢今年已有的員工數量，並計算下一個流水號
SELECT @SerialNumber = ISNULL(MAX(CAST(SUBSTRING(EmployeeID, 4, 4) AS INT)), 0) + 1
    FROM [Employee]
WHERE EmployeeID LIKE @TodayYear + '%';

--組合新的訂單編號，格式: 民國年(YYY) + 4位數流水號
SET @NewEmployeeID = @TodayYear + RIGHT('0000' + CAST(@SerialNumber AS VARCHAR(4)), 4);

RETURN @NewEmployeeID;
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetServiceID]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[GetServiceID]()

    RETURNS CHAR(11)
AS
BEGIN
    DECLARE @TodayDate VARCHAR(8);
	DECLARE @SerialNumber INT;
	DECLARE @NewServiceID VARCHAR(11);

--取得今天的日期（格式: YYYYMMDD）
    SET @TodayDate = CONVERT(VARCHAR(8), GETDATE(), 112);

--查詢今天已有的訂單數量，並計算下一個流水號
SELECT @SerialNumber = ISNULL(MAX(CAST(SUBSTRING(ServiceNumber, 9, 3) AS INT)), 0) + 1
    FROM [ServiceList]
WHERE ServiceNumber LIKE @TodayDate + '%';

--組合新的訂單編號，格式: YYYYMMDD + 4位數流水號
SET @NewServiceID = @TodayDate + RIGHT('000' + CAST(@SerialNumber AS VARCHAR(3)), 3);

RETURN @NewServiceID;
END
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeID] [char](7) NOT NULL,
	[Name] [nvarchar](27) NOT NULL,
	[Gender] [nchar](5) NOT NULL,
	[Birthday] [date] NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](15) NULL,
	[PersonalID] [char](10) NOT NULL,
	[HireDate] [date] NULL,
	[JobTitle] [nvarchar](20) NULL,
	[Experience] [nvarchar](200) NULL,
	[EmployeePhoto] [nvarchar](20) NULL,
	[RoleCode] [nchar](6) NOT NULL,
	[Password] [nvarchar](64) NOT NULL,
	[DueDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeRoles]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeRoles](
	[RoleCode] [nchar](6) NOT NULL,
	[Role] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncomeAndSpend]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncomeAndSpend](
	[SpendNumber] [nchar](20) NOT NULL,
	[MemberID] [nchar](6) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SpendNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncomeAndSpendDetail]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncomeAndSpendDetail](
	[SpendNumber] [nchar](20) NOT NULL,
	[ItemCode] [nchar](2) NOT NULL,
	[Amount] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[SpendNumber] ASC,
	[ItemCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Insurance]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Insurance](
	[PolicyNumber] [nvarchar](20) NOT NULL,
	[Insurer] [nvarchar](27) NOT NULL,
	[Insured] [nvarchar](27) NOT NULL,
	[Orderdate] [date] NOT NULL,
	[EffectiveDate] [date] NULL,
	[PaymentMethod] [nvarchar](20) NULL,
	[ExpiryDate] [date] NULL,
	[ProductNumber] [nvarchar](10) NOT NULL,
	[ServiceNumber] [char](11) NOT NULL,
	[Amount] [money] NOT NULL,
 CONSTRAINT [PK__Insuranc__46DA015609BE8987] PRIMARY KEY CLUSTERED 
(
	[PolicyNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InsuranceCompany]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InsuranceCompany](
	[CompanyID] [nvarchar](10) NOT NULL,
	[CompanyName] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Member]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Member](
	[MemberID] [nchar](6) NOT NULL,
	[Name] [nvarchar](27) NOT NULL,
	[Birthday] [date] NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[Gender] [nchar](5) NOT NULL,
	[Email] [nvarchar](20) NOT NULL,
	[phone] [nchar](15) NOT NULL,
	[Password] [nvarchar](64) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MemberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ProductNumber] [nvarchar](10) NOT NULL,
	[ProductName] [nvarchar](30) NOT NULL,
	[LaunchDate] [date] NULL,
	[DiscontinuedDate] [date] NULL,
	[ValidityPeriod] [int] NULL,
	[Type] [nvarchar](10) NULL,
	[CompanyID] [nvarchar](10) NOT NULL,
	[DM] [nvarchar](20) NULL,
	[DMType] [nvarchar](10) NULL,
	[Feature] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServiceDetail]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceDetail](
	[ServiceNumber] [char](11) NOT NULL,
	[EmployeeID] [char](7) NOT NULL,
	[ServiceDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ServiceNumber] ASC,
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServiceList]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceList](
	[ServiceNumber] [char](11) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[MemberID] [nchar](6) NOT NULL,
	[CurrentBusiness] [nchar](7) NULL,
	[StateCode] [nchar](2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ServiceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServiceState]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceState](
	[StateCode] [nchar](2) NOT NULL,
	[State] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StateCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpendItem]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpendItem](
	[ItemCode] [nchar](2) NOT NULL,
	[Item] [nvarchar](20) NOT NULL,
	[TypeCode] [nchar](3) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ItemCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpendType]    Script Date: 2025/3/25 下午 01:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpendType](
	[TypeCode] [nchar](3) NOT NULL,
	[Type] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Employee] ([EmployeeID], [Name], [Gender], [Birthday], [Address], [Phone], [PersonalID], [HireDate], [JobTitle], [Experience], [EmployeePhoto], [RoleCode], [Password], [DueDate]) VALUES (N'1130001', N'張瑪麗', N'F    ', CAST(N'1982-12-16' AS Date), N'高雄市前金區中華四路293號7樓', N'0982-113456', N'B223344556', CAST(N'2020-05-10' AS Date), N'事業部主任', N'國泰人壽2年', NULL, N'sal001', N'612dcd0d639ccfef6d930c5aacb0d2321406885ac4f1320fafde0ae397addec4', NULL)
INSERT [dbo].[Employee] ([EmployeeID], [Name], [Gender], [Birthday], [Address], [Phone], [PersonalID], [HireDate], [JobTitle], [Experience], [EmployeePhoto], [RoleCode], [Password], [DueDate]) VALUES (N'1130002', N'林傑克', N'M    ', CAST(N'1979-02-18' AS Date), N'高雄市前鎮區瑞隆路51號', N'0988-334667', N'A123456789', CAST(N'2019-09-01' AS Date), N'事業部經理', N'MDRT百萬圓桌認證', NULL, N'lea002', N'e84aad947b3e35a5d7479244878f45774b51dfa77fed01c0fca6b1e5c2305a04', NULL)
INSERT [dbo].[Employee] ([EmployeeID], [Name], [Gender], [Birthday], [Address], [Phone], [PersonalID], [HireDate], [JobTitle], [Experience], [EmployeePhoto], [RoleCode], [Password], [DueDate]) VALUES (N'1130003', N'吳強生', N'M    ', CAST(N'1995-05-10' AS Date), N'高雄市鳳山區光復二路66號', N'0932-667899', N'D101255487', CAST(N'2023-07-15' AS Date), N'業務主任', N'新進人員', NULL, N'sal001', N'efbce49affe68a9f63da093457e60474bee259ca6844ea29ff78268ae685439f', NULL)
INSERT [dbo].[Employee] ([EmployeeID], [Name], [Gender], [Birthday], [Address], [Phone], [PersonalID], [HireDate], [JobTitle], [Experience], [EmployeePhoto], [RoleCode], [Password], [DueDate]) VALUES (N'1130004', N'莊玫瑰', N'F    ', CAST(N'2000-04-04' AS Date), N'台南市永康區小東路697號4樓之2', N'0955-332616', N'S222555999', CAST(N'2021-04-02' AS Date), N'業務助理', N'細心、嚴格', NULL, N'sup003', N'23fcb8f02dab4d73392a1c58f3c9b08ee25ba009ba54a058c61aecbfb746a5eb', NULL)
INSERT [dbo].[Employee] ([EmployeeID], [Name], [Gender], [Birthday], [Address], [Phone], [PersonalID], [HireDate], [JobTitle], [Experience], [EmployeePhoto], [RoleCode], [Password], [DueDate]) VALUES (N'1130005', N'陳曉雲', N'F    ', CAST(N'1998-02-14' AS Date), N'台中市西屯區逢甲一路', N'0938-333888', N'B222688521', CAST(N'2024-09-28' AS Date), N'業務主任', N'具備：人身保險業務員證照、財產保險業務員證照
1.保單健診
2.六大保障觀念
3.各式保單相關問題解析
4.新生兒保單規劃
5.新鮮人保單規劃
6.家庭保單規劃
7.退休規劃 & 理財規劃
8.車險/寵物險/旅平險規劃', NULL, N'sal001', N'72fbbeafb6428e5e29931cca716f23bd24b76a5a7ce6786e6eab7650129227fe', NULL)
GO
INSERT [dbo].[EmployeeRoles] ([RoleCode], [Role]) VALUES (N'adm004', N'系統管理員')
INSERT [dbo].[EmployeeRoles] ([RoleCode], [Role]) VALUES (N'lea002', N'主管')
INSERT [dbo].[EmployeeRoles] ([RoleCode], [Role]) VALUES (N'sal001', N'業務員')
INSERT [dbo].[EmployeeRoles] ([RoleCode], [Role]) VALUES (N'sup003', N'業助')
GO
INSERT [dbo].[IncomeAndSpend] ([SpendNumber], [MemberID]) VALUES (N'20241224102645000001', N'A00001')
INSERT [dbo].[IncomeAndSpend] ([SpendNumber], [MemberID]) VALUES (N'20241224102645000002', N'A00002')
INSERT [dbo].[IncomeAndSpend] ([SpendNumber], [MemberID]) VALUES (N'20250209130120000001', N'A00003')
GO
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20241224102645000001', N'01', 420000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20241224102645000001', N'04', 180000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20241224102645000001', N'19', 35000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20241224102645000001', N'20', 36000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20241224102645000001', N'25', 5600.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20241224102645000001', N'26', 36000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20241224102645000001', N'28', 144000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20241224102645000002', N'01', 600000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20241224102645000002', N'18', 24000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'01', 700000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'04', 240000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'05', 18000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'06', 9600.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'08', 1080.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'09', 20000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'10', 10000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'11', 30000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'12', 140000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'13', 11000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'14', 22000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'15', 48000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'16', 3200.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'17', 10000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'21', 6000.0000)
INSERT [dbo].[IncomeAndSpendDetail] ([SpendNumber], [ItemCode], [Amount]) VALUES (N'20250209130120000001', N'22', 5988.0000)
GO
INSERT [dbo].[Insurance] ([PolicyNumber], [Insurer], [Insured], [Orderdate], [EffectiveDate], [PaymentMethod], [ExpiryDate], [ProductNumber], [ServiceNumber], [Amount]) VALUES (N'1324004501002360000', N'陳大衛', N'陳小寶', CAST(N'2024-11-30' AS Date), CAST(N'2024-12-10' AS Date), N'銀行帳戶自動扣繳', CAST(N'2044-12-10' AS Date), N'TL00000005', N'20241202002', 600000.0000)
INSERT [dbo].[Insurance] ([PolicyNumber], [Insurer], [Insured], [Orderdate], [EffectiveDate], [PaymentMethod], [ExpiryDate], [ProductNumber], [ServiceNumber], [Amount]) VALUES (N'CUTE20241210001', N'王瑪莉', N'王瑪莉', CAST(N'2024-10-25' AS Date), CAST(N'2024-10-30' AS Date), N'信用卡', CAST(N'2034-10-30' AS Date), N'VAUF000001', N'20241020001', 300000.0000)
GO
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Allianz012', N'安聯人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'America018', N'英屬百慕達商友邦人壽保險股份有限公司台灣分公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'BankTai001', N'臺銀人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Cardif021', N'法商法國巴黎人壽保險股份有限公司台灣分公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Cathay004', N'國泰人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Chubb017', N'安達國際人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Chunghw013', N'中華郵政股份有限公司壽險處')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Coface038', N'法商科法斯產物保險股份有限公司台灣分公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Far010', N'遠雄人壽保險事業股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'First014', N'第一金人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Fubon008', N'富邦人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Hontai011', N'宏泰人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'KGI005', N'凱基人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'MassMut009', N'三商美邦人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Nan006', N'南山人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'PCA003', N'保誠人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Shin007', N'新光人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Taishin016', N'台新人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Taiwan002', N'台灣人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'TCB015', N'合作金庫人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Transgl020', N'全球人壽保險股份有限公司')
INSERT [dbo].[InsuranceCompany] ([CompanyID], [CompanyName]) VALUES (N'Yuanta019', N'元大人壽保險股份有限公司')
GO
INSERT [dbo].[Member] ([MemberID], [Name], [Birthday], [Address], [Gender], [Email], [phone], [Password]) VALUES (N'A00001', N'王瑪莉', CAST(N'1997-02-10' AS Date), N'高雄市前金區五福三路21號4樓', N'F    ', N'mary@abc.com', N'0911333555     ', N'2d8210bcbd473505f2f07c84f436b1d2f2a72f4530677971dc65b1e9da5f2141')
INSERT [dbo].[Member] ([MemberID], [Name], [Birthday], [Address], [Gender], [Email], [phone], [Password]) VALUES (N'A00002', N'陳大衛', CAST(N'1982-05-17' AS Date), N'屏東縣萬丹鄉', N'M    ', N'daivid@gmail.com', N'0988258888     ', N'040ff32a5756488b394d1d92035da4e89428b6e8754ab7a10c64c1cd9069f6e4')
INSERT [dbo].[Member] ([MemberID], [Name], [Birthday], [Address], [Gender], [Email], [phone], [Password]) VALUES (N'A00003', N'張凱文', CAST(N'1999-10-02' AS Date), N'台南市永康區裕農路', N'M    ', N'kevin@yahoo.com', N'0956555666     ', N'9dc7fc6c7ce07b8da239d91b66161df2fe0757848e99bdc117502e770aa2f66e')
INSERT [dbo].[Member] ([MemberID], [Name], [Birthday], [Address], [Gender], [Email], [phone], [Password]) VALUES (N'A00004', N'金一', CAST(N'1996-07-07' AS Date), N'屏東市', N'M    ', N'gold@gmail.com', N'0911335666     ', N'ed057b5b79005c739573ff4d51f3701a2a00eaf609653b4ddf28771f19b08f06')
INSERT [dbo].[Member] ([MemberID], [Name], [Birthday], [Address], [Gender], [Email], [phone], [Password]) VALUES (N'A00005', N'毛利小五郎', CAST(N'1987-01-05' AS Date), N'東京都米花市米花町五丁目39番地', N'M    ', N'mao@gmail.com', N'0900000001     ', N'8761a2ff3cc3b4728a1a96dd1e4bb493cb7f27bc15b7a6513aeff4ccbcb32310')
INSERT [dbo].[Member] ([MemberID], [Name], [Birthday], [Address], [Gender], [Email], [phone], [Password]) VALUES (N'A00006', N'王先生', CAST(N'2016-01-01' AS Date), N'高雄市', N'M    ', N'andy@gmail.com', N'00922334556    ', N'9558d1e317d799b3833a79be3c477ce9203649dd5394610e6417ae75539c1762')
GO
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'10RPISWLB', N'金多美美元利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, 120, N'倍數型', N'Chubb017', N'10RPISWLB.jpg', N'jpg', N'1、2-9級失能豁免。
2、保險金分期給付(類信託)。
3、生命末期提前給付(指定比例)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'10TISN', N'台鑫金讚利率變動型終身保險', CAST(N'2024-11-01' AS Date), NULL, 120, N'倍數型', N'Taishin016', N'10TISN.jpg', N'jpg', N'1.高保障保單，滿足家庭對保障的需求。
2.繳費年期彈性，可靈活規劃保障。
3.自第3年起即享有高額終身保障')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'10UISE', N'美利達利率變動型美元終身保險', CAST(N'2024-11-01' AS Date), NULL, 120, N'倍數型', N'Taishin016', N'10UISE.jpg', N'jpg', N'高保障保單 滿足家庭保障需求。繳費年期彈性/靈活規劃保障。自第3年起, 即享高額終身保障。每年有機會享有增值回饋分享金。2-6級失能豁免 保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'10ULSN', N'大樂美利率變動型美元終身保險', CAST(N'2024-11-01' AS Date), NULL, 120, N'倍數型', N'Taishin016', N'10ULSN.jpg', N'jpg', N'2~6級失能豁免。身故保險金及完全失能保險金')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'20RPISWLB', N'金多美美元利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, 240, N'倍數型', N'Chubb017', N'20RPISWLB.jpg', N'jpg', N'2-9級失能豁免。
保險金分期給付(類信託)。
生命末期提前給付(指定比例)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'20TISN', N'台鑫金讚利率變動型終身保險', CAST(N'2024-11-01' AS Date), NULL, 240, N'倍數型', N'Taishin016', N'20TISN.jpg', N'jpg', N'高保障保單，滿足家庭對保障的需求。繳費年期彈性，可靈活規劃保障。自第3年起即享有高額終身保障')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'20UISE', N'美利達利率變動型美元終身保險', CAST(N'2024-11-01' AS Date), NULL, 240, N'倍數型', N'Taishin016', N'20UISE.jpg', N'jpg', N'高保障保單 滿足家庭保障需求。繳費年期彈性/靈活規劃保障。自第3年起, 即享高額終身保障。每年有機會享有增值回饋分享金。2-6級失能豁免 保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'20ULSN', N'大樂美利率變動型美元終身保險', CAST(N'2024-11-01' AS Date), NULL, 240, N'倍數型', N'Taishin016', N'20ULSN.jpg', N'jpg', N'2~6級失能豁免。身故保險金及完全失能保險金')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'6RPISWLB', N'金多美美元利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, 72, N'倍數型', N'Chubb017', N'6RPISWLB.jpg', N'jpg', N'2-9級失能豁免。保險金分期給付(類信託)。生命末期提前給付(指定比例)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'811227-4', N'新溢起愛變額萬能壽險', CAST(N'2025-03-01' AS Date), NULL, NULL, N'投資型', N'Cathay004', N'811227-4.jpg', N'image/jpeg', N'◆可搭配人生週期的規劃，彈性調整自身保障需求，並可彈性決定額外繳交保費的時間及金額
◆如按期繳交目標保險費，自第5至第9保單週年日止，可享加值給付，金額最高約當於目標保險費費用(相關給付條件請見保單條款說明)
◆第10保險費年度起免收超額保險費費用，適時加碼，退休理財及資產累積皆可再升級
◆投資標的多元，提供包含委託專業投資機構投資運用且具有穩定撥回資產之委託投資帳戶，亦有多檔以永續、ESG等訴求的共同基金供選擇
註：本保險不提供未來投資收益、撥回資產或保本之保證，另投資標的的收益或撥回資產可能由投資標的的收益或本金中支付
')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'ACLPEN32', N'金會旺終身保險(113)', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'PCA003', N'ACLPEN32.jpg', N'jpg', N'年度分紅/長青分紅/長青解約紅利。2-6級失能豁免')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'ACLPLN3', N'享利一生終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'PCA003', N'ACLPLN3.jpg', N'image/jpeg', N'享利一生終身壽險(定期給付型)只需一次繳費，就能擁有終身保障，適合讓嚮往富裕的您進行資產與保障規劃。
自屆滿第二保單年度起還有機會年年享有保單紅利。搭配選擇保險金分期給付方式，讓您的人生除了擁有完整的保障，更能展現您對後代的愛與呵護。請您把握現在，啟動傳承享利一生的最佳計劃。

註：本保險為分紅保險單，保單紅利部分非本保險單之保證給付項目，保誠人壽不保證其給付金額( 保額)。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'APKQTL', N'天天有利利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'KGI005', N'APKQTL.jpg', N'jpg', N'大眾交通意外身故金 海外意外身故金 天然災害意外身故金 身故金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'APMOPL', N'基業長鴻美元利率變動型終身保險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'KGI005', N'APMOPL.jpg', N'jpg', N'2-6級失能豁免。保險金分期給付(類信託)。生命末期提前給付最高 90%')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'APMTPL', N'鑫旺來利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'KGI005', N'APMTPL.jpg', N'jpg', N'高保費折扣：躉繳：60萬-0.8%、120萬-1.8%；2年期：30萬-0.8%、60萬-1.8%')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'APNCPL', N'大富人生利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'KGI005', N'APNCPL.jpg', N'jpg', N'2-6級失能豁免 保額增額權 保險金分期給付(類信託) 提前給付保險金')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'ARLPLN10', N'福安滿利終身壽險(113)', CAST(N'2024-11-01' AS Date), NULL, NULL, N'分紅險', N'PCA003', N'ARLPLN10.jpg', N'jpg', N'增額分紅、額外分紅')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'BD1', N'傳富萬客隆美元利率變動型終身壽險', CAST(N'2024-09-10' AS Date), NULL, NULL, N'倍數型', N'Far010', N'BD1.jpg', N'image/jpeg', N'一.保障萬一：美元利變、終身保障。
二.自在客選：躉繳/二年繳、自由規劃。
三.呵護隆情：保險金分期，守護更恆久。
四.傳富勝典：指定受益、預留稅源，成就傳承心意。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'BRLPLN8', N'金世代終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'分紅險', N'PCA003', N'BRLPLN8.jpg', N'jpg', N'身故金分期給付(類信託)、增額分紅、額外分紅')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'DSVA000003', N'三商美邦人壽金世紀多利變額年金保險(DSVA)', CAST(N'2023-03-05' AS Date), CAST(N'2024-12-20' AS Date), 120, N'退休年金', N'MassMut009', N'DSVA000003.jpg', N'jpg', N'繳費方式多元，可選擇定期繳費或彈性繳費。逾百檔多元投資標的，可自行操作或委由專家代為投資操作，滿足不同投資需求。運用約定轉換及停利機制，讓投資更輕鬆。可搭配意外及醫療附約，享有年金、意外及醫療的三方保障。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'FBW', N'豪神六六利率變動型美元終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Transgl020', N'FBW.jpg', N'jpg', N'2-6級失能豁免 保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'FDW', N'88美傳承利率變動型美元終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Transgl020', N'FDW.jpg', N'jpg', N'2-6級失能豁免。保險金分期給付(類信託)癌症提前給付')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'FFS', N'美富66利率變動型美元終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Transgl020', N'FFS.jpg', N'jpg', N'2-6級失能豁免 保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'FMW', N'豪旺世代利率變動型美元終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Transgl020', N'FMW.jpg', N'jpg', N'可轉投保年金保險 保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'FVI1', N'富貴美美美元利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'First014', N'FVI1.jpg', N'jpg', N'2-6級失能豁免 保額增額權 保險金分期給付(類信託) 提前給付保險金')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'FVM', N'美樂悠美元利率變動型還本終身保險', CAST(N'2024-12-01' AS Date), NULL, 240, N'退休年金', N'First014', N'FVM.jpg', N'jpg', N'完全失能保險金。生存保險金。祝壽保險金。提前給付保險金')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'IAT2', N'新吉好利利率變動型增額終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'Fubon008', N'IAT2.jpg', N'jpg', N'2~6級失能豁免 身故金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'ICD', N'豐盛年年利率變動型終身保險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'Fubon008', N'ICD.jpg', N'jpg', N'豐盛退休! 屆滿第1保單年度起年年領取生存保險金。增值回饋! 有機會享有增值回饋分享金轉增購保額。意外加給! 提供大眾運輸交通工具意外身故保障')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'ILL1', N'金盈寶利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'First014', N'ILL1.jpg', N'jpg', N'2-6級失能豁免 保額增額權 保險金分期給付(類信託) 提前給付保險金')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'JF', N'元滿鑽多利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'Yuanta019', NULL, NULL, N'')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'JY', N'真億達利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Yuanta019', N'JY.jpg', N'jpg', N'提供保額增加權 八大醫材購置補助 意外傷害失能補償')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'JZA', N'美鑽傳家外幣利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Shin007', NULL, NULL, N'保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'KY', N'承億達美元利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Yuanta019', N'KY.jpg', N'jpg', N'2-6級失能豁免。保險金分期給付(類信託)。結婚、生子、配偶身故、滿5周年可增額 20%')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'LP0', N'尚好佳利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'Shin007', NULL, NULL, N'高保費折扣：90萬-0.5%、180萬-1%、280萬-2%')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'MXA', N'豐利旺終身還本保險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'Shin007', NULL, NULL, N'2-6級失能豁免')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'NTIW2101', N'金多利利率變動型增額終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'Taiwan002', N'NTIW2101.jpg', N'jpg', N'高保費折扣：躉：60萬-0.2%、120萬-1.4%、150萬-1.7%；2年期：30萬-0.2%、60萬-1.4%、75萬-1.7%')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'NUIW6601', N'美鑫美利美元利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Taiwan002', N'NUIW6601.jpg', N'jpg', N'1~9級失能豁免。60歲前第5.10.15週年，結婚、生子可增額 20%。生命末期提前給付 50%或100萬美元較小為限。保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'NUIW7101', N'旺美勝美元利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Taiwan002', N'NUIW7101.jpg', N'jpg', N'保險金分期給付(類信託) 60歲前享增額選擇權')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'NUIW7301', N'臻美滿美元利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Taiwan002', N'NUIW7301.jpg', N'jpg', N'增值回饋分享金、身故保險金或喪葬費用保險金、保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'NWLS', N'鴻利優沛利率變動型還本終身保險', CAST(N'2024-10-01' AS Date), NULL, 240, N'退休年金', N'America018', N'NWLS.jpg', N'jpg', N'完全失能保險金。生存保險金。祝壽保險金')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'P3UISA', N'吉美傳家利率變動型美元終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Taishin016', N'P3UISA.jpg', N'jpg', N'繳費3年，保障終身。每年有機會享有增值回饋分享金。高倍數壽險保障保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'P6TISN', N'台鑫金讚利率變動型終身保險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Taishin016', N'P6TISN.jpg', N'jpg', N'高保障保單，滿足家庭對保障的需求。繳費年期彈性，可靈活規劃保障。自第3年起即享有高額終身保障')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'P6UIDC', N'多美傳家利率變動型美元終身保險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Taishin016', NULL, NULL, N'繳費6年或7年，保障終身。有機會享有增值回饋分享金。高資產保障傳承。2~6級失能豁免保費')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'P6ULSN', N'大樂美利率變動型美元終身保險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Taishin016', N'P6ULSN.jpg', N'jpg', N'2~6級失能豁免。身故保險金及完全失能保險金')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'PAC', N'紅旺年年分紅終身保險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'Fubon008', N'PAC.jpg', N'jpg', N'壽險保障!6年繳費，終身壽險保障。雙重金流!年年可領生存保險金，有機會再享保單紅利。保單分紅!具有區隔帳戶機制')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'PAG', N'紅運多多分紅終身保險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'Fubon008', N'PAG.jpg', N'jpg', N'2重金流！年年可領生存保險金，有機會再享保單紅利加分退休人生。3年繳費！ 3年繳費輕鬆規劃，保障終身守護家人。2重紅利！ 有機會享年度保單紅利及終期保單紅利')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'PRT01A01', N'鴻運旺旺來終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'分紅險', N'Cardif021', N'PRT01A01.jpg', N'jpg', N'身故金分期給付(類信託)、增額分紅、額外分紅')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'QDW', N'88鑫傳承利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Transgl020', N'QDW.jpg', N'jpg', N'2~6級失能豁免 老年重度癌症提前給付 重大燒燙傷保險金 生命末期提前給付最高100% 老年照護住院醫療 保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'QE', N'樂享元元美元利率變動型還本終身保險', CAST(N'2024-12-01' AS Date), NULL, 240, N'退休年金', N'Yuanta019', N'QE.jpg', N'jpg', N'增加保額選擇權、生存金終身給付，樂活退休無煩惱')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'QFD', N'有GO鑽利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'Transgl020', N'QFD.jpg', N'jpg', N'高保額保費折扣：90萬-0.8%、150萬-1.2%')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'QJW', N'代代緻富利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Transgl020', N'QJW.jpg', N'jpg', N'重大燒燙傷/老年照護住院醫療提前給付 可轉投保年金保險 保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'QM', N'美旺達美元利率變動型增額終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Yuanta019', NULL, NULL, N'2-6級失能豁免 保額增額權 保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'QPS', N'鑫利旺盛利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'Transgl020', N'QPS.jpg', N'jpg', N'可附加1~8級失能豁免 特定傷病及2~6級失能豁免 重大燒燙傷、提前給付、老年照護醫療 特定傷病金 身故金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'QTW', N'88鑫傳富利率變動型終身壽險', CAST(N'2024-12-01' AS Date), NULL, 240, N'退休年金', N'Transgl020', N'QTW.jpg', N'jpg', N'2~6級失能豁免。重大燒燙傷保險金。生命末期提前給付最高 100%。老年照護住院醫療。保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'SP1', N'傳富聚匯美元利率變動型終身壽險', CAST(N'2024-01-01' AS Date), NULL, NULL, N'倍數型', N'Far010', N'SP1.jpg', N'image/jpeg', N'一.終身保障：責任承諾與資產傳承兼具。
二.美元利變：有機會享宣告回饋。
三.守護升級：涵蓋5項特定疾病。
四.豁免機制：2-6級失能豁免保障不中斷。
五.保險金分期：呵護所愛最佳利益。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'THA', N'美鑽傳富外幣利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'Shin007', NULL, NULL, N'保險金分期給付(類信託)')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'TL00000005', N'台灣人壽新金采100變額萬能壽險', CAST(N'2024-06-28' AS Date), NULL, 240, N'投資型', N'Taiwan002', N'TL00000005.jpg', N'jpg', N'身故保險金或喪葬費用保險金與保單帳戶價值之返還、完全失能保險')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'TSVU000004', N'三商美邦人壽金世紀經典變額萬能終身壽險(TSVUL)', CAST(N'2023-06-20' AS Date), CAST(N'2025-12-25' AS Date), NULL, N'投資型', N'MassMut009', N'TSVU000004.jpg', N'jpg', N'適合計劃長期投資者，基本壽險保障與投資雙管齊下。二至六級失能豁免目標保險費，讓保障更全面。享有保單持續特別紅利+保單管理費符合標準者減免。可搭配意外及醫療附約，享有壽險、意外及醫療的三方保障。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'UA0081', N'華利滿載變額萬能壽險', CAST(N'2024-10-03' AS Date), NULL, NULL, N'投資型', N'Cardif021', N'UA0081.jpg', N'image/jpeg', N'1.第6年起：帳戶價值+0.45%加值給付金。 
2.第6回合生命表 
3. 保額300萬以上有VIP機場接送服務')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'UA0082', N'金采年華變額萬能壽險', CAST(N'2024-12-01' AS Date), NULL, NULL, N'投資型', N'Cardif021', N'UA0082.jpg', N'jpg', N'第6回合生命表
300萬以上有VIP機場接送服務')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'UFISWL', N'金創富人生美元利率變動型終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'倍數型', N'America018', N'UFISWL.jpg', N'jpg', N'2-6級失能豁免 保險金分期給付(類信託) 保單每5年可增額，每次最多25%累計最高100% 生命末期提前給付')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'UWLV', N'富利豐沛美元利率變動型還本終身保險', CAST(N'2024-11-01' AS Date), NULL, 240, N'退休年金', N'America018', N'UWLV.jpg', N'jpg', N'全保額免體檢。身故保障高')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'VA118TW2', N'新天生贏家Plus變額萬能壽險', CAST(N'2025-01-01' AS Date), NULL, NULL, N'投資型', N'Chubb017', N'VA118TW2.jpg', N'jpg', N'身故保險金或喪葬費用保險金的給付與保單帳戶價值之返還、
完全失能保險金的給付、
祝壽保險金的給付、
65歲以下附加重大燒燙傷與1-6級失能豁免')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'VA171TW', N'富貴大贏家變額萬能壽險', CAST(N'2024-10-01' AS Date), NULL, NULL, N'投資型', N'Chubb017', N'VA171TW.jpg', N'jpg', N'自動停利鎖利，
投資管家主動通知、
標的多元、
附加重大燒燙傷保障')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'VABY1', N'吉利發發變額萬能壽險', CAST(N'2024-10-01' AS Date), NULL, NULL, N'投資型', N'Allianz012', N'VABY1.jpg', N'jpg', N'◆加值給付金回饋
  自第六保單年度起即啟動投資標的價值之加值給付金回饋(註)。
◆標的選擇多元化
  涵括多種產業、區域的投資標的，可自由配置與規劃。
註：

本契約於有效期間內，自第六保單年度起，每保單週 年日按前一保單年度共同基金（不含貨幣型基金）及指數型股票基金所屬之投資 標的價值每月平均值之千分之二點五計算加值給付金，加值給付金於該保單週年 日後第一個資產評價日，扣除各投資標的申購手續費後投入指定之投資標的，若 無指定者依各投資標的之價值比例再投入各投資標的，但要保人指定之投資標的 以一檔為限。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'VACW10', N'10來旺變額萬能壽險(112)', CAST(N'2025-01-01' AS Date), NULL, NULL, N'投資型', N'Allianz012', N'VACW10.jpg', N'jpg', N'創新給付已收取之保費費用。
精選標的，掌握投資趨勢。
完整保障，符合需求。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'VAMPZ', N'新六六大順變額萬能壽險(112)', CAST(N'2024-10-01' AS Date), NULL, NULL, N'投資型', N'Allianz012', N'VAMPZ.jpg', N'jpg', N'給付項目：
身故保險金或喪葬費用保險金或返還保單帳戶價值、
完全失能保險金、祝壽保險金。
本保險為不分紅保單，不參加紅利分配，並無紅利給付項目。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'VAUF000001', N'外幣計價富利人生變額年金保險(V1)', CAST(N'2002-01-01' AS Date), CAST(N'2025-12-30' AS Date), 240, N'退休年金', N'Fubon008', N'VAUF000001.jpg', N'jpg', N'身故保證!附保證最低身故保險金機制之連結類全委帳戶保障。 專家代操!與施羅德投信、富邦投信及富達投信合作，為您規劃投資組合配置。 年金平台!開放40~64歲投保，年金平台讓您安享生活。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'VCBT000002', N'真吉利變額年金保險', CAST(N'2024-05-01' AS Date), NULL, 180, N'退休年金', N'Fubon008', N'VCBT000002.jpg', N'jpg', N'精選多檔標的：精選不同區域及主題型基金，讓您的投資與全球市場脈動。年金平台：活愈久領愈多，年金給付有保障，滿足退休養老需求。資金靈活運用：每年6次免費投資標轉換，及時反應市場變化，可選擇部分提領及標的轉換')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'WE1', N'美滿金享優利率變動型增額終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'Far010', N'WE1.jpg', N'image/jpeg', N'一.台幣計價，無匯兌風險。
二.加值享利，有機會享回饋分享金。
三.布局彈性，繳費6/12/20年期。
四.投保年齡廣，最高可投保至75歲。
五.分期給付，呵護所愛恆長久。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'WF1', N'美滿雄福利利率變動型增額終身壽險', CAST(N'2023-09-28' AS Date), NULL, NULL, N'還本型', N'Far010', N'WF1.jpg', N'image/jpeg', N'一.雄材布局：躉繳/2年繳，輕鬆自由選。
二.福擁回饋：利變終身，有機會享回饋分享金。
三.利澤八方：保險金分期，留愛無礙。
四.保障加值：特定意外身故保障。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'WH1', N'傳富聚鑫利率變動型終身壽險', CAST(N'2024-01-12' AS Date), NULL, NULL, N'倍數型', N'Far010', N'WH1.jpg', N'image/jpeg', N'一.台幣利變：繳費年期多元(6/7/12/20)。
二.多重守護：大眾運輸意外與重大燒燙傷保障升值。
三.貼心豁免：內含2~6級失能豁免保費。
四.分期給付：照顧最愛與資產傳承。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'WI1', N'富貴喜相逢利率變動型終身還本保險', CAST(N'2024-01-12' AS Date), NULL, NULL, N'還本型', N'Far010', N'WI1.jpg', N'image/jpeg', N'一.台幣利變：有機會享回饋分享金。
二.年年還本：創造穩定現金流。
三.保障加值：大眾運輸意外保障升級。
四.分期給付：呵護所愛更長久。')
INSERT [dbo].[Product] ([ProductNumber], [ProductName], [LaunchDate], [DiscontinuedDate], [ValidityPeriod], [Type], [CompanyID], [DM], [DMType], [Feature]) VALUES (N'WN1', N'美滿雄go利利率變動型增額終身壽險', CAST(N'2024-11-01' AS Date), NULL, NULL, N'還本型', N'Far010', N'WN1.jpg', N'image/jpeg', N'一.雄厚資產：躉繳利變，保障與財富穩健累積。
二.go建未來：保險金分期給付，呵護更到位。
三.利益升級：0-85歲可投保，特定意外保障加值給付。')
GO
INSERT [dbo].[ServiceDetail] ([ServiceNumber], [EmployeeID], [ServiceDate]) VALUES (N'20241020001', N'1130001', CAST(N'2024-10-20T00:00:00.000' AS DateTime))
INSERT [dbo].[ServiceDetail] ([ServiceNumber], [EmployeeID], [ServiceDate]) VALUES (N'20241202002', N'1130002', CAST(N'2024-12-02T00:00:00.000' AS DateTime))
INSERT [dbo].[ServiceDetail] ([ServiceNumber], [EmployeeID], [ServiceDate]) VALUES (N'20241202002', N'1130003', CAST(N'2024-12-06T00:00:00.000' AS DateTime))
INSERT [dbo].[ServiceDetail] ([ServiceNumber], [EmployeeID], [ServiceDate]) VALUES (N'20250105001', N'1130004', CAST(N'2024-01-06T00:00:00.000' AS DateTime))
INSERT [dbo].[ServiceDetail] ([ServiceNumber], [EmployeeID], [ServiceDate]) VALUES (N'20250105002', N'1130002', CAST(N'2025-01-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ServiceList] ([ServiceNumber], [CreateDate], [MemberID], [CurrentBusiness], [StateCode]) VALUES (N'20241020001', CAST(N'2024-10-20T00:00:00.000' AS DateTime), N'A00001', N'1130001', N'ED')
INSERT [dbo].[ServiceList] ([ServiceNumber], [CreateDate], [MemberID], [CurrentBusiness], [StateCode]) VALUES (N'20241202002', CAST(N'2024-12-02T00:00:00.000' AS DateTime), N'A00002', N'1130002', N'B2')
INSERT [dbo].[ServiceList] ([ServiceNumber], [CreateDate], [MemberID], [CurrentBusiness], [StateCode]) VALUES (N'20250105001', CAST(N'2025-01-05T00:00:00.000' AS DateTime), N'A00003', N'1130003', N'A1')
INSERT [dbo].[ServiceList] ([ServiceNumber], [CreateDate], [MemberID], [CurrentBusiness], [StateCode]) VALUES (N'20250105002', CAST(N'2025-01-05T00:00:00.000' AS DateTime), N'A00001', N'1130002', N'A3')
INSERT [dbo].[ServiceList] ([ServiceNumber], [CreateDate], [MemberID], [CurrentBusiness], [StateCode]) VALUES (N'20250317001', CAST(N'2025-03-17T10:13:49.040' AS DateTime), N'A00004', N'       ', N'01')
INSERT [dbo].[ServiceList] ([ServiceNumber], [CreateDate], [MemberID], [CurrentBusiness], [StateCode]) VALUES (N'20250317002', CAST(N'2025-03-17T14:16:58.000' AS DateTime), N'A00005', N'1130002', N'A2')
INSERT [dbo].[ServiceList] ([ServiceNumber], [CreateDate], [MemberID], [CurrentBusiness], [StateCode]) VALUES (N'20250324001', CAST(N'2025-03-24T13:39:00.000' AS DateTime), N'A00006', N'1130001', N'A1')
GO
INSERT [dbo].[ServiceState] ([StateCode], [State]) VALUES (N'01', N'待業務聯繫')
INSERT [dbo].[ServiceState] ([StateCode], [State]) VALUES (N'02', N'持續追蹤')
INSERT [dbo].[ServiceState] ([StateCode], [State]) VALUES (N'A1', N'接洽中10%')
INSERT [dbo].[ServiceState] ([StateCode], [State]) VALUES (N'A2', N'接洽中25%')
INSERT [dbo].[ServiceState] ([StateCode], [State]) VALUES (N'A3', N'接洽中50%')
INSERT [dbo].[ServiceState] ([StateCode], [State]) VALUES (N'B1', N'收單進件')
INSERT [dbo].[ServiceState] ([StateCode], [State]) VALUES (N'B2', N'審核完成')
INSERT [dbo].[ServiceState] ([StateCode], [State]) VALUES (N'B3', N'補件中')
INSERT [dbo].[ServiceState] ([StateCode], [State]) VALUES (N'B4', N'審核不通過')
INSERT [dbo].[ServiceState] ([StateCode], [State]) VALUES (N'ED', N'核保通過')
GO
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'01', N'主要收入', N'I01')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'02', N'次要收入', N'I01')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'03', N'其他收入', N'I01')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'04', N'房貸', N'L02')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'05', N'房地稅', N'L02')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'06', N'水電瓦斯費', N'L02')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'07', N'管理費', N'L02')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'08', N'電信費', N'L02')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'09', N'水電維修', N'L02')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'10', N'家電廚具', N'L02')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'11', N'小家電', N'L02')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'12', N'車價攤提', N'T03')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'13', N'車輛牌照燃料稅', N'T03')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'14', N'車險費', N'T03')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'15', N'油資', N'T03')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'16', N'停車過路費', N'T03')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'17', N'保養費', N'T03')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'18', N'交通車資', N'T03')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'19', N'生活用品', N'E04')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'20', N'外食', N'E04')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'21', N'3C設備', N'E04')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'22', N'通訊費', N'E04')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'23', N'旅行', N'E04')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'24', N'藝文活動', N'E04')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'25', N'學雜餐費', N'C05')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'26', N'安親補習費', N'C05')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'27', N'才藝社團費', N'C05')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'28', N'餐費', N'C05')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'29', N'衣鞋文具費', N'C05')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'30', N'人身保險', N'S06')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'31', N'退休儲蓄金', N'S06')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'32', N'零用金', N'E07')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'33', N'備用金', N'E07')
INSERT [dbo].[SpendItem] ([ItemCode], [Item], [TypeCode]) VALUES (N'34', N'房租', N'L02')
GO
INSERT [dbo].[SpendType] ([TypeCode], [Type]) VALUES (N'C05', N'子女養育')
INSERT [dbo].[SpendType] ([TypeCode], [Type]) VALUES (N'E04', N'生活娛樂')
INSERT [dbo].[SpendType] ([TypeCode], [Type]) VALUES (N'E07', N'備用')
INSERT [dbo].[SpendType] ([TypeCode], [Type]) VALUES (N'I01', N'收入')
INSERT [dbo].[SpendType] ([TypeCode], [Type]) VALUES (N'L02', N'居住維持')
INSERT [dbo].[SpendType] ([TypeCode], [Type]) VALUES (N'S06', N'儲蓄保險')
INSERT [dbo].[SpendType] ([TypeCode], [Type]) VALUES (N'T03', N'交通費')
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Employee__28343712ABECF4C6]    Script Date: 2025/3/25 下午 01:18:42 ******/
ALTER TABLE [dbo].[Employee] ADD UNIQUE NONCLUSTERED 
(
	[PersonalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Member__A9D105346D013126]    Script Date: 2025/3/25 下午 01:18:42 ******/
ALTER TABLE [dbo].[Member] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_EmployeeID]  DEFAULT ([dbo].[GetEmployeeID]()) FOR [EmployeeID]
GO
ALTER TABLE [dbo].[IncomeAndSpendDetail] ADD  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_MemberID]  DEFAULT ([dbo].[fnGetNewMemberID]()) FOR [MemberID]
GO
ALTER TABLE [dbo].[ServiceDetail] ADD  DEFAULT (getdate()) FOR [ServiceDate]
GO
ALTER TABLE [dbo].[ServiceList] ADD  CONSTRAINT [DF_ServiceList_ServiceNumber]  DEFAULT ([dbo].[GetServiceID]()) FOR [ServiceNumber]
GO
ALTER TABLE [dbo].[ServiceList] ADD  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([RoleCode])
REFERENCES [dbo].[EmployeeRoles] ([RoleCode])
GO
ALTER TABLE [dbo].[IncomeAndSpend]  WITH CHECK ADD FOREIGN KEY([MemberID])
REFERENCES [dbo].[Member] ([MemberID])
GO
ALTER TABLE [dbo].[IncomeAndSpendDetail]  WITH CHECK ADD FOREIGN KEY([ItemCode])
REFERENCES [dbo].[SpendItem] ([ItemCode])
GO
ALTER TABLE [dbo].[IncomeAndSpendDetail]  WITH CHECK ADD FOREIGN KEY([SpendNumber])
REFERENCES [dbo].[IncomeAndSpend] ([SpendNumber])
GO
ALTER TABLE [dbo].[Insurance]  WITH CHECK ADD  CONSTRAINT [FK__Insurance__Produ__628FA481] FOREIGN KEY([ProductNumber])
REFERENCES [dbo].[Product] ([ProductNumber])
GO
ALTER TABLE [dbo].[Insurance] CHECK CONSTRAINT [FK__Insurance__Produ__628FA481]
GO
ALTER TABLE [dbo].[Insurance]  WITH CHECK ADD  CONSTRAINT [FK__Insurance__Servi__6383C8BA] FOREIGN KEY([ServiceNumber])
REFERENCES [dbo].[ServiceList] ([ServiceNumber])
GO
ALTER TABLE [dbo].[Insurance] CHECK CONSTRAINT [FK__Insurance__Servi__6383C8BA]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD FOREIGN KEY([CompanyID])
REFERENCES [dbo].[InsuranceCompany] ([CompanyID])
GO
ALTER TABLE [dbo].[ServiceDetail]  WITH CHECK ADD FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([EmployeeID])
GO
ALTER TABLE [dbo].[ServiceDetail]  WITH CHECK ADD FOREIGN KEY([ServiceNumber])
REFERENCES [dbo].[ServiceList] ([ServiceNumber])
GO
ALTER TABLE [dbo].[ServiceList]  WITH CHECK ADD FOREIGN KEY([MemberID])
REFERENCES [dbo].[Member] ([MemberID])
GO
ALTER TABLE [dbo].[ServiceList]  WITH CHECK ADD FOREIGN KEY([StateCode])
REFERENCES [dbo].[ServiceState] ([StateCode])
GO
ALTER TABLE [dbo].[SpendItem]  WITH CHECK ADD FOREIGN KEY([TypeCode])
REFERENCES [dbo].[SpendType] ([TypeCode])
GO
USE [master]
GO
ALTER DATABASE [iStudyTest] SET  READ_WRITE 
GO
