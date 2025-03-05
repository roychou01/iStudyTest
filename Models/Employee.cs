using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class Employee
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
    public DateTime Birthday { get; set; }

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
    public DateTime? HireDate { get; set; }

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

    [Display(Name = "員工密碼")]
    public string Password { get; set; } = null!;

    [Display(Name = "員工離職日")]
    [DataType(DataType.Date)]
    public DateTime? DueDate { get; set; }

    public virtual EmployeeRoles RoleCodeNavigation { get; set; } = null!;

    public virtual ICollection<ServiceDetail> ServiceDetail { get; set; } = new List<ServiceDetail>();

    public virtual ICollection<ServiceList> ServiceList { get; set; } = new List<ServiceList>();
}
