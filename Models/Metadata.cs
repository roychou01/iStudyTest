using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace iStudyTest.Models;

public class MemberData
{
    [Display(Name = "會員編號")]
    [StringLength(6, MinimumLength = 6)]
    public string MemberID { get; set; } = null!;

    [Display(Name = "會員姓名")]
    public string Name { get; set; } = null!;

    [Display(Name = "生日")]
    [DataType(DataType.Date)]
    public DateOnly Birthday { get; set; }

    [Display(Name = "地址")]
    [DataType(DataType.MultilineText)]
    public string Address { get; set; } = null!;

    [Display(Name = "性別")]
    public string Gender { get; set; } = null!;

    [Display(Name = "電子郵件")]
    [Required(ErrorMessage = "電子郵件是必填欄位")]
    [EmailAddress(ErrorMessage = "請輸入有效的電子郵件地址")]
    public string Email { get; set; } = null!;

    [Display(Name = "手機號碼")]
    public string phone { get; set; } = null!;

    [Display(Name = "密碼", Prompt = "密碼為8-16碼")]
    [Required(ErrorMessage = "必填")]
    [StringLength(16, MinimumLength = 8, ErrorMessage = "密碼為8-16碼")]
    [MinLength(8)]
    [MaxLength(16)]
    [DataType(DataType.Password)]
    public string Password { get; set; } = null!;
}
[ModelMetadataType(typeof(MemberData))]
public partial class Member
{
    [NotMapped]  //這項要在DB first重建後再加，建View時要先註解，不然會沒有此欄位
    [Display(Name = "再填一次密碼", Prompt = "密碼為8-16碼")]
    [Required(ErrorMessage = "必填")]
    [Compare(nameof(Password), ErrorMessage = "密碼兩次輸入不相同")]
    [DataType(DataType.Password)]
    public string PasswordConfirm { get; set; } = null!;
}


public class EmployeeData
{
    [Display(Name = "員工編號")]
    [StringLength(7, MinimumLength = 7)]
    public string EmployeeID { get; set; } = null!;

    [Display(Name = "員工姓名")]
    [StringLength(27, MinimumLength = 2, ErrorMessage = "姓名最少2字、最多27個字")]
    public string Name { get; set; } = null!;

    [Display(Name = "員工性別")]
    public string Gender { get; set; } = null!;

    [Display(Name = "員工生日")]
    [DataType(DataType.Date)]
    public DateOnly Birthday { get; set; }

    [Display(Name = "員工地址")]
    [DataType(DataType.MultilineText)]
    public string Address { get; set; } = null!;

    [Display(Name = "員工電話")]
    public string? Phone { get; set; }

    [Display(Name = "員工身分證號")]
    [Required(ErrorMessage = "必填")]
    public string PersonalID { get; set; } = null!;

    [Display(Name = "員工到職日")]
    [DataType(DataType.Date)]
    public DateOnly? HireDate { get; set; }

    [Display(Name = "員工職稱")]
    public string? JobTitle { get; set; }

    [Display(Name = "員工經歷")]
    [DataType(DataType.MultilineText)]
    public string? Experience { get; set; }

    [Display(Name = "員工照片")]
    public string? EmployeePhoto { get; set; }

    [Display(Name = "員工權限碼")]
    [Required(ErrorMessage = "必填")]
    public string RoleCode { get; set; } = null!;

    [Display(Name = "員工密碼", Prompt = "密碼為8-16碼")]
    [Required(ErrorMessage = "必填")]
    [StringLength(16, MinimumLength = 8, ErrorMessage = "密碼為8-16碼")]
    [MinLength(8)]
    [MaxLength(16)]
    [DataType(DataType.Password)]
    public string Password { get; set; } = null!;

    [Display(Name = "員工離職日")]
    [DataType(DataType.Date)]
    public DateOnly? DueDate { get; set; }
}
    [ModelMetadataType(typeof(EmployeeData))]
    public partial class Employee
    {

    }

public class EmployeeRolesData
{
    [Display(Name = "員工權限碼")]
    public string RoleCode { get; set; } = null!;

    [Display(Name = "員工權限")]
    public string Role { get; set; } = null!;
}
    [ModelMetadataType(typeof(EmployeeRolesData))]
    public partial class EmployeeRoles
    {

    }


public class ProductData
{
    [Display(Name = "編號")]
    [StringLength(10, MinimumLength = 1, ErrorMessage = "編號 1~10字")]
    [Required(ErrorMessage = "必填")]
    public string ProductNumber { get; set; } = null!;

    [Display(Name = "品名")]
    [StringLength(30, MinimumLength = 1, ErrorMessage = "名稱 1~30字")]
    [Required(ErrorMessage = "必填")]
    public string ProductName { get; set; } = null!;

    [Display(Name = "上架日")]
    [DataType(DataType.Date)]
    public DateOnly LaunchDate { get; set; }

    [Display(Name = "停售日")]
    [DataType(DataType.Date)]
    public DateOnly? DiscontinuedDate { get; set; }

    [Display(Name = "期數")]
    public int? ValidityPeriod { get; set; }

    [Display(Name = "類型")]
    public string? Type { get; set; }

    [Display(Name = "保險公司代號")]
    public string CompanyID { get; set; } = null!;

    [Display(Name = "產品圖")]
    public string? DM { get; set; }

    [Display(Name = "檔案類型")]
    public string? DMType { get; set; }

    [Display(Name = "產品特色")]
    [DataType(DataType.MultilineText)]  //顯示多行文字方塊
    public string? Feature { get; set; }
}
    [ModelMetadataType(typeof(ProductData))]
    public partial class Product
    {
    }


public class InsuranceCompanyData
{
    [Display(Name = "保險公司代號")]
    public string CompanyID { get; set; } = null!;

    [Display(Name = "保險公司")]
    public string? CompanyName { get; set; }
}

    [ModelMetadataType(typeof(InsuranceCompanyData))]
    public partial class InsuranceCompany
    {

    }

public class IncomeAndSpendData
{
    [Display(Name = "收支簿編號")]
    public string SpendNumber { get; set; } = null!;

    [Display(Name = "會員編號")]
    public string MemberID { get; set; } = null!;
}
    [ModelMetadataType(typeof(InsuranceCompanyData))]
    public partial class IncomeAndSpend
    {
    }


public  class IncomeAndSpendDetailData
{
    [Display(Name = "收支簿編號")]
    public string SpendNumber { get; set; } = null!;

    [Display(Name = "項目代碼")]
    public string ItemCode { get; set; } = null!;

    [Display(Name = "金額")]
    [DisplayFormat(DataFormatString = "{0:C0}", ApplyFormatInEditMode = true)]
    public decimal? Amount { get; set; }
}

    [ModelMetadataType(typeof(IncomeAndSpendDetailData))]
    public partial class IncomeAndSpendDetail
    {
    }


public class InsuranceData
{
    [Display(Name = "保單編號")]
    public string PolicyNumber { get; set; } = null!;

    [Display(Name = "投保人")]
    public string Insurer { get; set; } = null!;

    [Display(Name = "被保險人")]
    public string Insured { get; set; } = null!;

    [Display(Name = "要保日")]
    [DataType(DataType.Date)]
    public DateTime Orderdate { get; set; }

    [Display(Name = "生效日")]
    [DataType(DataType.Date)]
    public DateTime? EffectiveDate { get; set; }

    [Display(Name = "付款方式")]
    public string? PaymentMethod { get; set; }

    [Display(Name = "有效期限")]
    [DataType(DataType.Date)]
    public DateTime? ExpiryDate { get; set; }

    [Display(Name = "產品編號")]
    public string ProductNumber { get; set; } = null!;

    [Display(Name = "服務單號")]
    public string ServiceNumber { get; set; } = null!;

    [Display(Name = "保單金額")]
    [DisplayFormat(DataFormatString = "{0:C0}", ApplyFormatInEditMode = true)]
    public decimal Amount { get; set; }
}

    [ModelMetadataType(typeof(InsuranceData))]
    public partial class Insurance
    {
    }

public class ServiceDetailData
{
    [Display(Name = "服務單號")]
    public string ServiceNumber { get; set; } = null!;

    [Display(Name = "服務人員工號")]
    public string EmployeeID { get; set; } = null!;

    [Display(Name = "服務日期")]
    [DisplayFormat(DataFormatString = "{0:yyyy/MM/dd}", ApplyFormatInEditMode = true)]
    public DateTime? ServiceDate { get; set; }
}
    [ModelMetadataType(typeof(ServiceDetailData))]
    public partial class ServiceDetail
    {
    }


public class ServiceListData
{
    [Display(Name = "服務單號")]
    public string ServiceNumber { get; set; } = null!;

    [Display(Name = "建立日期")]
    [DisplayFormat(DataFormatString = "{0:yyyy/MM/dd}", ApplyFormatInEditMode = true)]
    public DateTime CreateDate { get; set; }

    [Display(Name = "會員編號")]
    public string MemberID { get; set; } = null!;

    [Display(Name = "業務歸屬")]
    public string? CurrentBusiness { get; set; }

    [Display(Name = "狀態碼")]
    public string StateCode { get; set; } = null!;
}
    [ModelMetadataType(typeof(ServiceListData))]
    public partial class ServiceList
    {
    }

public class ServiceStateData
{
    [Display(Name = "狀態碼")]
    public string StateCode { get; set; } = null!;

    [Display(Name = "狀態")]
    public string State { get; set; } = null!;
}
[ModelMetadataType(typeof(ServiceState))]
public partial class ServiceState
{
}


public class SpendItemData
{
    [Display(Name = "收支項目代碼")]
    public string ItemCode { get; set; } = null!;

    [Display(Name = "收支項目名稱")]
    public string Item { get; set; } = null!;

    [Display(Name = "類別代碼")]
    public string TypeCode { get; set; } = null!;
}
[ModelMetadataType(typeof(SpendItemData))]
public partial class SpendItem
{
}

public class SpendTypeData
{
    public string TypeCode { get; set; } = null!;

    [Display(Name = "收支類別")]
    public string Type { get; set; } = null!;
}
[ModelMetadataType(typeof(SpendTypeData))]
public partial class SpendType
{
}
